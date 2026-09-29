"""The Design Review app, end to end: a fictional repository tree, the real
server on a free port, real HTTP calls. Only the operating system's "open this
file" is replaced, so the suite never launches a PDF viewer."""

import json
import sys
import threading
import urllib.error
import urllib.request
from pathlib import Path

import pymupdf

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts' / 'design_review'))
import server  # noqa: E402

README = '''# Design concepts

| Concept | Idea | Date | Status | PDF |
|---|---|---|---|---|
| Harbour Lights | Test style | 2030-01-02 | proposed | [safe](2030-01-02-harbour-lights/condensed/safe/condensed-safe.pdf) |
| Old Draft | `Text Draft` direction (not a CV template): test | 2030-01-01 | not picked (owner chose another, 2030-01-02); kept | [2 pages](2030-01-01-old-draft/concept.pdf) |
'''


def _pdf(path, pages):
    path.parent.mkdir(parents=True, exist_ok=True)
    doc = pymupdf.open()
    for n in range(pages):
        doc.new_page(width=595, height=842).insert_text((72, 72), f'page {n + 1}')
    doc.save(path)


def _tree(repo):
    concepts = repo / 'design-concepts'
    style = concepts / '2030-01-02-harbour-lights'
    for tier in ('safe', 'stylish', 'creative'):
        _pdf(style / 'condensed' / tier / f'condensed-{tier}.pdf', 1)
    for tier in ('safe', 'stylish'):
        _pdf(style / 'spacious' / tier / f'spacious-{tier}.pdf', 2)
    (style / 'brief.md').write_text('# Harbour Lights\n\nThree words: *lights on water*.\n\n'
                                    'Idea run. `Domain` Travel & Tourism; specialty test.\n', encoding='utf-8')
    (style / 'sample.json').write_text(json.dumps({'name': {'el': 'Δοκιμή Παράδειγμα', 'en': 'Test Example'}}), encoding='utf-8')
    _pdf(concepts / '2030-01-01-old-draft' / 'concept.pdf', 2)
    (concepts / 'README.md').write_text(README, encoding='utf-8')
    env = repo / 'private' / 'fictional-client'
    (env / 'candidate.json').parent.mkdir(parents=True)
    (env / 'candidate.json').write_text(json.dumps({'identity': {'name': 'Fictional Client'}}), encoding='utf-8')
    rev = env / 'revisions' / '20300103-101010-abcdef'
    _pdf(rev / 'cv.pdf', 2)
    (rev / 'render.json').write_text(json.dumps({'created_at': '2030-01-03T10:10:10Z', 'compiler': {
        'command': ['typst', 'compile', '--input', 'lang=el', 'cv.typ']}}), encoding='utf-8')
    _pdf(env / 'draft' / 'draft-01.pdf', 1)
    _pdf(env / 'stray.pdf', 1)          # exists, but is not a revision or a draft


def _call(base, path, body=None, headers=None):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(base + path, data=data, headers=dict({'Content-Type': 'application/json'}, **(headers or {})))
    try:
        with urllib.request.urlopen(req, timeout=60) as r:
            return r.status, r.headers.get('Content-Type'), r.read()
    except urllib.error.HTTPError as e:
        return e.code, e.headers.get('Content-Type'), e.read()


def run_design_review(out):
    repo = out / 'design-review' / 'repo'
    repo.mkdir(parents=True, exist_ok=False)
    _tree(repo)
    opened = []
    app = server.App(repo, opener=lambda path, reveal=False: opened.append((path, reveal)))
    httpd = server.serve(app, 0)
    threading.Thread(target=httpd.serve_forever, daemon=True).start()
    base = f'http://127.0.0.1:{httpd.server_address[1]}'
    passed = []
    try:
        code, ctype, body = _call(base, '/')
        assert code == 200 and 'text/html' in ctype and b'Design Review' in body
        passed.append('page')

        code, _, body = _call(base, '/api/items')
        items = {i['id']: i for i in json.loads(body)['items']}
        cs = 'design-concepts/2030-01-02-harbour-lights/condensed/safe/condensed-safe.pdf'
        ss = 'design-concepts/2030-01-02-harbour-lights/spacious/safe/spacious-safe.pdf'
        cc = 'design-concepts/2030-01-02-harbour-lights/condensed/creative/condensed-creative.pdf'
        assert len(items) == 8, sorted(items)
        assert items[cs]['style'] == 'Harbour Lights' and items[cs]['idea'] == 'lights on water'
        assert items[cs]['domain'] == 'Travel & Tourism' and items[cs]['candidate'] == 'Δοκιμή Παράδειγμα'
        assert (items[cs]['density'], items[cs]['tier'], items[cs]['pages']) == ('condensed', 'safe', 1)
        assert items[ss]['pages'] == 2 and items[cs]['twin'] == ss and items[ss]['twin'] == cs
        assert items[cc]['twin'] is None  # no spacious creative was drawn
        old = items['design-concepts/2030-01-01-old-draft/concept.pdf']
        assert old['kind'] == 'text-draft' and old['status'] == 'not picked' and old['density'] is None
        rev = items['private/fictional-client/revisions/20300103-101010-abcdef/cv.pdf']
        assert rev['kind'] == 'client-cv' and rev['candidate'] == 'Fictional Client' and rev['variant'].endswith('· el')
        assert items['private/fictional-client/draft/draft-01.pdf']['kind'] == 'client-draft'
        passed.append('index')

        code, ctype, png = _call(base, f'/api/page?id={ss}&page=2&w=300')
        assert code == 200 and ctype == 'image/png' and png[:8] == b'\x89PNG\r\n\x1a\n'
        assert pymupdf.Pixmap(png).width == 300
        assert _call(base, f'/api/page?id={ss}&page=3&w=300')[0] == 404
        assert _call(base, '/api/page?id=private/fictional-client/stray.pdf&page=1')[0] == 404
        assert _call(base, '/api/items', headers={'Host': 'evil.example:80'})[0] == 403
        assert _call(base, '/api/state', {'id': ss, 'patch': {'star': True}}, {'Content-Type': 'text/plain'})[0] == 415
        passed.append('page-images')

        code, _, body = _call(base, '/api/state', {'id': ss, 'patch': {'verdict': 'keep', 'reviewed': True, 'notes': 'Καλό'}})
        assert code == 200 and json.loads(body)['verdict'] == 'keep'
        _call(base, '/api/state', {'id': ss, 'patch': {'star': True}})
        assert _call(base, '/api/state', {'id': ss, 'patch': {'verdict': 'love'}})[0] == 400
        assert _call(base, '/api/state', {'id': ss, 'patch': {'owner': 'x'}})[0] == 400
        assert _call(base, '/api/state', {'id': 'nope.pdf', 'patch': {'star': True}})[0] == 404
        saved = json.loads((repo / '.local/design-review/state.json').read_text(encoding='utf-8'))
        assert saved[ss]['verdict'] == 'keep' and saved[ss]['star'] is True and saved[ss]['notes'] == 'Καλό'
        assert json.loads(_call(base, '/api/items')[2])['state'][ss]['star'] is True
        state_file = repo / '.local/design-review/state.json'
        good = state_file.read_text(encoding='utf-8')
        state_file.write_text(good, encoding='utf-8-sig')      # a BOM (PowerShell 5, Notepad) still reads
        assert json.loads(_call(base, '/api/items')[2])['state'][ss]['verdict'] == 'keep'
        state_file.write_text(good.rstrip()[:-1] + ',}', encoding='utf-8')   # a hand edit gone wrong
        broken = state_file.read_bytes()
        code, _, body = _call(base, '/api/items')
        assert code == 200 and json.loads(body)['stateError'] and json.loads(body)['state'] == {}
        assert _call(base, '/api/state', {'id': cs, 'patch': {'star': True}})[0] == 409
        assert state_file.read_bytes() == broken      # never overwritten
        state_file.write_text(good, encoding='utf-8')
        passed.append('state')

        assert _call(base, '/api/open', {'id': ss, 'what': 'pdf'})[0] == 200
        assert _call(base, '/api/open', {'id': ss, 'what': 'folder'})[0] == 200
        assert _call(base, '/api/open', {'id': cs, 'what': 'brief'})[0] == 200
        assert _call(base, '/api/open', {'id': 'C:/Windows/notepad.exe'})[0] == 404
        style = repo / 'design-concepts/2030-01-02-harbour-lights'
        assert opened == [(repo / ss, False), (repo / ss, True), (style / 'brief.md', False)], opened
        passed.append('open')

        (repo / cc).unlink()       # a reviewed design that moved away still reaches the export
        _call(base, '/api/items')
        saved = json.loads(state_file.read_text(encoding='utf-8'))
        saved[cc] = {'verdict': 'reject', 'notes': 'gone'}
        state_file.write_text(json.dumps(saved), encoding='utf-8')
        code, _, body = _call(base, '/api/export', {})
        text = Path(json.loads(body)['path']).read_text(encoding='utf-8')
        assert '**Harbour Lights** (spacious · safe): Keep, starred, reviewed.' in text and '  Καλό' in text
        assert '## Not in this index (moved, deleted, unreadable or left out)' in text and 'condensed-creative.pdf' in text
        passed.append('export')

        code, _, body = _call(base, '/api/plain')
        pages = json.loads(body)['pages']
        assert code == 200 and len(pages) == 12, body
        assert _call(base, '/api/plain/' + pages[0])[1] == 'image/png'
        assert _call(base, '/api/plain/..%2Fstate.json')[0] == 404
        passed.append('plain-cvs')
    finally:
        httpd.shutdown()
    return passed


if __name__ == '__main__':
    import tempfile
    print(run_design_review(Path(tempfile.mkdtemp())))
