"""Design Review: a local app for the owner to look through every CV design.

It indexes the magazine-editor's concepts (design-concepts/) and, on this
machine only, the client renders under private/ (CV revisions and Text
Drafts). It shows page previews, keeps the owner's review state (reviewed,
verdict, star, notes) in .local/design-review/state.json, and opens a PDF in
the operating system's default program. It binds to 127.0.0.1 and never
sends anything anywhere.

    python scripts/design_review/server.py            # opens the browser (needs pymupdf, jsonschema)
    python scripts/design_review/server.py --port 8766 --no-browser
"""

import argparse
import hashlib
import json
import os
import subprocess
import sys
import threading
import webbrowser
from datetime import datetime
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlparse

import pymupdf

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / 'packages/cv-workflow'))
from cv_workflow import outputs  # noqa: E402

HERE = Path(__file__).resolve().parent
DENSITIES = ['condensed', 'spacious']
TIERS = ['safe', 'stylish', 'creative']
LOCK = threading.Lock()


# ---- index --------------------------------------------------------------------
# The app reads Meta Files only (Output Contract, docs/proposals/output-contract.md):
# a PDF without a valid, current one is listed as unindexed with the reason.

def _rel(repo, path):
    return Path(path).resolve().relative_to(Path(repo).resolve()).as_posix()


def _item(repo, pdf, meta):
    rel = _rel(repo, pdf)
    parts = rel.split('/')
    kind = meta['kind']
    item = {k: meta.get(k) for k in ('kind', 'domain', 'candidate', 'alias', 'rank', 'style', 'idea', 'density',
                                      'tier', 'lang', 'pages', 'date', 'status', 'title')}
    item.update(id=rel, sortTime=meta['date'], mtime=Path(pdf).stat().st_mtime_ns, brief=None)
    if kind in ('concept', 'text-draft'):
        run = parts[1]
        folder = Path(repo) / 'design-concepts' / run
        item['group'] = 'run:' + run[:10] + (':text-draft' if kind == 'text-draft' else '')
        item['groupLabel'] = run[:10] + (' · Text Draft directions' if kind == 'text-draft' else ' · design run')
        item['brief'] = _rel(repo, folder / 'brief.md') if (folder / 'brief.md').is_file() else None
        item['row'] = meta['style']
        item['variant'] = meta.get('variant')
    elif kind == 'example':
        item['group'] = 'release:' + meta['domain']
        item['groupLabel'] = 'Release · ' + meta['domain'].title()
        item['row'] = meta.get('style') or 'Examples'
        item['style'] = item['row']
        item['variant'] = ' · '.join(x for x in [meta.get('rank'), meta.get('variant')] if x)
        item['brief'] = meta.get('source')
    else:
        env = Path(repo) / 'private' / parts[1]
        item['group'] = 'client:' + parts[1]
        item['groupLabel'] = 'Client · ' + meta['candidate']
        item['style'] = meta['candidate']
        item['brief'] = _rel(repo, env / 'README.md') if (env / 'README.md').is_file() else None
        if kind == 'client-draft':
            item['row'], item['variant'] = 'Text Drafts', meta.get('variant')
        elif parts[-1] == 'reference.pdf':
            item['row'], item['variant'] = 'Delivered', meta.get('title') or 'reference'
        else:
            item['row'] = 'CV revisions'
            item['variant'] = ' · '.join(x for x in [meta.get('variant', '')[:15], meta.get('lang')] if x)
    item['col'] = f"{item['density']}/{item['tier']}" if item['density'] else (item['variant'] or item['title'] or parts[-1])
    return item


def build_index(repo, include_private=True):
    """([items], [unindexed]) from the Meta Files under `repo`."""
    indexed, problems = outputs.scan(repo, include_private)
    items = [_item(repo, pdf, meta) for pdf, meta in indexed]
    ids = {i['id'] for i in items}
    for item in items:
        twin = None
        if item['density']:
            other = 'spacious' if item['density'] == 'condensed' else 'condensed'
            twin = item['id'].replace(f"/{item['density']}/", f'/{other}/').replace(
                f"{item['density']}-{item['tier']}", f"{other}-{item['tier']}")
        item['twin'] = twin if twin in ids else None
    unindexed = [{'path': _rel(repo, pdf), 'reason': reason} for pdf, reason in problems]
    return items, unindexed


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
        self.unindexed = []

    def items(self):
        self._items, self.unindexed = build_index(self.repo, self.include_private)
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
                    return self._send(200, {'items': app.items(), 'unindexed': app.unindexed, 'state': state, 'stateError': error})
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
