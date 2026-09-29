"""Design Review: a local app for the owner to look through every CV design.

It indexes the magazine-editor's concepts (design-concepts/) and, on this
machine only, the client renders under private/ (CV revisions and Text
Drafts). It shows page previews, keeps the owner's review state (reviewed,
verdict, star, notes) in .local/design-review/state.json, and opens a PDF in
the operating system's default program. It binds to 127.0.0.1 and never
sends anything anywhere.

    python scripts/design_review/server.py            # opens the browser
    python scripts/design_review/server.py --port 8766 --no-browser
"""

import argparse
import hashlib
import json
import os
import re
import subprocess
import sys
import threading
import webbrowser
from datetime import datetime
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlparse

import pymupdf

HERE = Path(__file__).resolve().parent
DENSITIES = ['condensed', 'spacious']
TIERS = ['safe', 'stylish', 'creative']
LOCK = threading.Lock()


# ---- index --------------------------------------------------------------------

def _read(path):
    try:
        return path.read_text(encoding='utf-8')
    except OSError:
        return ''


def _page_count(pdf, cache={}):
    key = (str(pdf), pdf.stat().st_mtime_ns)
    if key not in cache:
        with pymupdf.open(pdf) as doc:
            cache[key] = len(doc)
    return cache[key]


def _readme_rows(repo):
    """Concept folder -> (name, idea, status) from design-concepts/README.md."""
    rows = {}
    for line in _read(repo / 'design-concepts' / 'README.md').splitlines():
        cells = [c.strip() for c in line.strip().strip('|').split('|')]
        if len(cells) < 5 or cells[0] in ('Concept', '---') or set(cells[0]) <= {'-'}:
            continue
        for folder in set(re.findall(r'\]\((\d{4}-\d{2}-\d{2}-[a-z0-9-]+)/', line)):
            status = cells[3].split(' (')[0].split(';')[0].strip()
            rows[folder] = {'name': cells[0], 'idea': cells[1], 'status': status, 'statusNote': cells[3]}
    return rows


def _brief(folder):
    text = _read(folder / 'brief.md')
    title = re.search(r'^#\s+(.+)$', text, re.M)
    words = re.search(r'Three words:\s*\*([^*]+)\*', text)
    domain = re.search(r'`Domain`\s+([^;.\n]+)', text)
    return {
        'name': title.group(1).strip() if title else None,
        'words': words.group(1).strip() if words else None,
        'domain': domain.group(1).strip() if domain else None,
    }


def _sample_name(folder):
    try:
        data = json.loads(_read(folder / 'sample.json') or 'null')
    except ValueError:
        return None
    name = data.get('name') if isinstance(data, dict) else None
    if isinstance(name, dict):
        name = next((v for v in name.values() if isinstance(v, str)), None)
    return name


def _concepts(repo):
    root = repo / 'design-concepts'
    readme = _readme_rows(repo)
    items = []
    for folder in sorted(root.glob('[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-*')):
        if not folder.is_dir():
            continue
        date, slug = folder.name[:10], folder.name[11:]
        row = readme.get(folder.name, {})
        brief = _brief(folder)
        text_draft = '`Text Draft` direction' in row.get('idea', '')
        base = {
            'group': 'run:' + date,
            'groupLabel': date + (' · Text Draft directions' if text_draft else ' · design run'),
            'kind': 'text-draft' if text_draft else 'concept',
            'date': date,
            'sortTime': date + 'T00:00:00',
            'style': row.get('name') or brief['name'] or slug.replace('-', ' ').title(),
            'row': slug,
            'idea': brief['words'] or row.get('idea', ''),
            'domain': brief['domain'] or ('Text Draft' if text_draft else None),
            'candidate': _sample_name(folder),
            'status': row.get('status') or 'proposed',
            'statusNote': row.get('statusNote'),
            'brief': _rel(repo, folder / 'brief.md') if (folder / 'brief.md').exists() else None,
        }
        found = False
        for density in DENSITIES:
            for tier in TIERS:
                pdf = folder / density / tier / f'{density}-{tier}.pdf'
                if pdf.exists():
                    found = True
                    items.append(dict(base, density=density, tier=tier, variant=None,
                                      col=f'{density}/{tier}', pdf=pdf))
        if not found:
            for pdf in sorted(folder.glob('*.pdf')):
                variant = pdf.stem.replace('concept', '').strip('-') or None
                items.append(dict(base, density=None, tier=None, variant=variant,
                                  col=variant or 'concept', pdf=pdf))
    return items


def _clients(repo):
    items = []
    for env in sorted((repo / 'private').glob('*/')):
        try:
            identity = json.loads(_read(env / 'candidate.json') or '{}').get('identity', {})
        except ValueError:
            identity = {}
        name = identity.get('name') if isinstance(identity.get('name'), str) else env.name
        base = {'group': 'client:' + env.name, 'groupLabel': 'Client · ' + name,
                'candidate': name, 'style': name, 'idea': env.name, 'domain': None,
                'density': None, 'tier': None, 'status': None, 'statusNote': None,
                'brief': _rel(repo, env / 'README.md') if (env / 'README.md').exists() else None}
        for rev in sorted((env / 'revisions').glob('*/')):
            pdf = rev / 'cv.pdf'
            if not pdf.exists():
                continue
            try:
                render = json.loads(_read(rev / 'render.json') or '{}')
            except ValueError:
                render = {}
            created = render.get('created_at') or ''
            command = ' '.join((render.get('compiler') or {}).get('command') or [])
            lang = re.search(r'\blang=(\w+)', command)
            lang = lang.group(1) if lang else None
            label = rev.name[:15] + (f' · {lang}' if lang else '')
            items.append(dict(base, kind='client-cv', row='CV revisions', col=label, variant=label,
                              date=(created[:10] or _date_from(rev.name)),
                              sortTime=created or _date_from(rev.name), pdf=pdf))
        for pdf in sorted((env / 'draft').glob('*.pdf')):
            stamp = datetime.fromtimestamp(pdf.stat().st_mtime).isoformat(timespec='seconds')
            items.append(dict(base, kind='client-draft', row='Text Drafts', col=pdf.stem, variant=pdf.stem,
                              date=stamp[:10], sortTime=stamp, pdf=pdf))
    return items


def _date_from(name):
    m = re.match(r'(\d{4})(\d{2})(\d{2})', name)
    return f'{m.group(1)}-{m.group(2)}-{m.group(3)}' if m else ''


def _rel(repo, path):
    return path.relative_to(repo).as_posix()


def build_index(repo, include_private=True):
    items = _concepts(repo) + (_clients(repo) if include_private else [])
    out = []
    for item in items:
        pdf = item.pop('pdf')
        item['id'] = _rel(repo, pdf)
        try:
            item['pages'] = _page_count(pdf)
        except Exception:  # half-written by a running compile: skip it until the next rescan
            continue
        item['mtime'] = pdf.stat().st_mtime_ns
        out.append(item)
    for item in out:
        if item['density']:
            other = 'spacious' if item['density'] == 'condensed' else 'condensed'
            twin = item['id'].replace(f"/{item['density']}/", f'/{other}/').replace(
                f"{item['density']}-{item['tier']}", f"{other}-{item['tier']}")
            item['twin'] = twin if any(o['id'] == twin for o in out) else None
        else:
            item['twin'] = None
    return out


# ---- state --------------------------------------------------------------------

class StateError(Exception):
    pass


class Store:
    FIELDS = {'reviewed': bool, 'verdict': (str, type(None)), 'star': bool, 'notes': str}
    VERDICTS = {None, 'keep', 'maybe', 'reject'}

    def __init__(self, path):
        self.path = path

    def load(self):
        if not self.path.exists():
            return {}
        try:
            state = json.loads(self.path.read_text(encoding='utf-8-sig'))
        except (OSError, ValueError) as exc:
            raise StateError(f'{self.path} cannot be read ({exc}); fix or move it, nothing was saved') from exc
        if not isinstance(state, dict):
            raise StateError(f'{self.path} is not a JSON object; fix or move it, nothing was saved')
        return state

    def update(self, item_id, patch):
        for key, value in patch.items():
            if key not in self.FIELDS or not isinstance(value, self.FIELDS[key]):
                raise ValueError(f'bad field {key!r}')
        if 'verdict' in patch and patch['verdict'] not in self.VERDICTS:
            raise ValueError('bad verdict')
        with LOCK:
            state = self.load()
            entry = state.get(item_id, {})
            entry.update(patch)
            entry['updated'] = datetime.now().isoformat(timespec='seconds')
            state[item_id] = entry
            self.path.parent.mkdir(parents=True, exist_ok=True)
            tmp = self.path.with_suffix('.tmp')
            tmp.write_text(json.dumps(state, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
            os.replace(tmp, self.path)
            return entry


def export_markdown(items, state, folder):
    stamp = datetime.now()
    lines = [f'# Design review, {stamp:%Y-%m-%d %H:%M}', '',
             'Written by the Design Review app from .local/design-review/state.json.', '']
    labels = {'keep': 'Keep', 'maybe': 'Maybe', 'reject': 'Reject'}
    groups = {}
    for item in items:
        if item['id'] in state:
            groups.setdefault(item['groupLabel'], []).append(item)
    known = {item['id'] for item in items}
    for gone in sorted(set(state) - known):
        groups.setdefault('Not in this index (moved, deleted, unreadable or left out)', []).append(
            {'id': gone, 'style': gone.rsplit('/', 1)[-1], 'density': None, 'tier': None, 'variant': None})
    for label, group in groups.items():
        lines += [f'## {label}', '']
        for item in group:
            s = state[item['id']]
            where = ' · '.join(x for x in [item['density'], item['tier'], item['variant']] if x)
            marks = ', '.join(x for x in [
                labels.get(s.get('verdict')), 'starred' if s.get('star') else None,
                'reviewed' if s.get('reviewed') else 'not reviewed'] if x)
            lines.append(f"- **{item['style']}**{' (' + where + ')' if where else ''}: {marks}. `{item['id']}`")
            if s.get('notes', '').strip():
                lines += ['  ' + n for n in s['notes'].strip().splitlines()]
        lines.append('')
    folder.mkdir(parents=True, exist_ok=True)
    path = folder / f'review-{stamp:%Y%m%d-%H%M%S}.md'
    path.write_text('\n'.join(lines), encoding='utf-8')
    return path


# ---- page images ----------------------------------------------------------------

def render_page(pdf, page, width, cache_dir):
    key = hashlib.sha1(f'{pdf}|{pdf.stat().st_mtime_ns}|{page}|{width}'.encode()).hexdigest()
    target = cache_dir / f'{key}.png'
    if not target.exists():
        with pymupdf.open(pdf) as doc:
            p = doc[page - 1]
            zoom = width / p.rect.width
            pix = p.get_pixmap(matrix=pymupdf.Matrix(zoom, zoom), alpha=False)
            cache_dir.mkdir(parents=True, exist_ok=True)
            tmp = target.with_suffix('.tmp')
            tmp.write_bytes(pix.tobytes('png'))
            os.replace(tmp, target)
    return target.read_bytes()


def plain_pages(local):
    """Render plain-cvs.typ once: generic market CVs for the batch view (this checkout's fonts)."""
    with LOCK:
        return _plain_pages(local)


def _plain_pages(local):
    repo = HERE.parents[1]
    source = HERE / 'plain-cvs.typ'
    digest = hashlib.sha1(source.read_bytes()).hexdigest()[:12]
    folder = local / 'plain' / digest
    if not folder.exists() or not any(folder.glob('*.png')):
        folder.mkdir(parents=True, exist_ok=True)
        pdf = folder / 'plain.pdf'
        subprocess.run(['typst', 'compile', '--root', str(repo), '--ignore-system-fonts',
                        '--font-path', str(repo / 'packages/cv-framework/fonts'),
                        str(source), str(pdf)], check=True, capture_output=True)
        with pymupdf.open(pdf) as doc:
            for n, p in enumerate(doc, 1):
                zoom = 360 / p.rect.width
                p.get_pixmap(matrix=pymupdf.Matrix(zoom, zoom), alpha=False).save(folder / f'plain-{n:02d}.png')
    return sorted(folder.glob('*.png'))


# ---- opening files --------------------------------------------------------------

def open_path(path, reveal=False):
    if sys.platform == 'win32':
        if reveal:
            subprocess.Popen(['explorer', '/select,', str(path)])
        else:
            os.startfile(str(path))
    elif sys.platform == 'darwin':
        subprocess.Popen(['open', '-R', str(path)] if reveal else ['open', str(path)])
    else:
        subprocess.Popen(['xdg-open', str(path.parent if reveal else path)])


# ---- server ---------------------------------------------------------------------

class App:
    def __init__(self, repo, include_private=True, opener=open_path):
        self.repo = repo
        self.local = repo / '.local' / 'design-review'
        self.store = Store(self.local / 'state.json')
        self.include_private = include_private
        self.opener = opener
        self._items = []

    def items(self):
        self._items = build_index(self.repo, self.include_private)
        return self._items

    def find(self, item_id):
        for item in self._items or self.items():
            if item['id'] == item_id:
                return item
        for item in self.items():
            if item['id'] == item_id:
                return item
        return None


def make_handler(app):
    class Handler(BaseHTTPRequestHandler):
        def log_message(self, *args):
            pass

        def _send(self, code, body, ctype='application/json; charset=utf-8', cache=False):
            if not isinstance(body, bytes):
                body = json.dumps(body, ensure_ascii=False).encode('utf-8')
            self.send_response(code)
            self.send_header('Content-Type', ctype)
            self.send_header('Content-Length', str(len(body)))
            self.send_header('Cache-Control', 'max-age=31536000, immutable' if cache else 'no-store')
            self.end_headers()
            self.wfile.write(body)

        def _foreign(self):
            port = self.server.server_address[1]
            if self.headers.get('Host') not in (f'127.0.0.1:{port}', f'localhost:{port}'):
                self._send(403, {'error': 'wrong host'})
                return True
            return False

        def do_GET(self):
            if self._foreign():
                return
            url = urlparse(self.path)
            q = {k: v[0] for k, v in parse_qs(url.query).items()}
            try:
                if url.path == '/':
                    return self._send(200, (HERE / 'index.html').read_bytes(), 'text/html; charset=utf-8')
                if url.path == '/api/items':
                    try:
                        state, error = app.store.load(), None
                    except StateError as exc:
                        state, error = {}, str(exc)
                    return self._send(200, {'items': app.items(), 'state': state, 'stateError': error})
                if url.path == '/api/page':
                    item = app.find(q.get('id', ''))
                    page, width = int(q.get('page', 1)), min(int(q.get('w', 400)), 2400)
                    if not item or not 1 <= page <= item['pages']:
                        return self._send(404, {'error': 'no such page'})
                    png = render_page(app.repo / item['id'], page, width, app.local / 'cache')
                    return self._send(200, png, 'image/png', cache=True)
                if url.path == '/api/plain':
                    pages = plain_pages(app.local)
                    return self._send(200, {'pages': [p.name for p in pages]})
                if url.path.startswith('/api/plain/'):
                    name = url.path.rsplit('/', 1)[1]
                    match = [p for p in plain_pages(app.local) if p.name == name]
                    if not match:
                        return self._send(404, {'error': 'no such page'})
                    return self._send(200, match[0].read_bytes(), 'image/png', cache=True)
                return self._send(404, {'error': 'not found'})
            except Exception as exc:  # the page shows the message; the server keeps running
                return self._send(500, {'error': str(exc)})

        def do_POST(self):
            raw = self.rfile.read(int(self.headers.get('Content-Length') or 0))  # drain before any reply
            if self._foreign():
                return
            if not (self.headers.get('Content-Type') or '').startswith('application/json'):
                return self._send(415, {'error': 'JSON only'})
            url = urlparse(self.path)
            try:
                body = json.loads(raw or b'{}')
                if url.path == '/api/state':
                    if not app.find(body.get('id', '')):
                        return self._send(404, {'error': 'unknown design'})
                    return self._send(200, app.store.update(body['id'], body.get('patch', {})))
                if url.path == '/api/open':
                    item = app.find(body.get('id', ''))
                    if not item:
                        return self._send(404, {'error': 'unknown design'})
                    what = body.get('what', 'pdf')
                    if what == 'brief':
                        if not item['brief']:
                            return self._send(404, {'error': 'no brief'})
                        app.opener(app.repo / item['brief'])
                    else:
                        app.opener(app.repo / item['id'], reveal=(what == 'folder'))
                    return self._send(200, {'ok': True})
                if url.path == '/api/export':
                    path = export_markdown(app.items(), app.store.load(), app.local / 'exports')
                    return self._send(200, {'path': str(path)})
                return self._send(404, {'error': 'not found'})
            except StateError as exc:
                return self._send(409, {'error': str(exc)})
            except ValueError as exc:
                return self._send(400, {'error': str(exc)})
            except Exception as exc:
                return self._send(500, {'error': str(exc)})

    return Handler


def serve(app, port):
    server = ThreadingHTTPServer(('127.0.0.1', port), make_handler(app))
    return server


def main():
    parser = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    parser.add_argument('--repo', type=Path, default=HERE.parents[1],
                        help='repository root to index (default: this checkout)')
    parser.add_argument('--port', type=int, default=8765)
    parser.add_argument('--no-browser', action='store_true')
    parser.add_argument('--no-private', action='store_true', help='leave out client renders under private/')
    args = parser.parse_args()
    app = App(args.repo.resolve(), include_private=not args.no_private)
    server = serve(app, args.port)
    url = f'http://127.0.0.1:{args.port}/'
    print(f'Design Review on {url} (indexing {app.repo}). Ctrl+C to stop.')
    if not args.no_browser:
        threading.Timer(0.5, webbrowser.open, [url]).start()
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
