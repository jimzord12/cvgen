"""The Design Review app, end to end: a fictional repository tree, the real
server on a free port, real HTTP calls. Only the operating system's "open this
file" is replaced, so the suite never launches a PDF viewer."""

import json
from datetime import date
import sys
import threading
import urllib.error
import urllib.request
from pathlib import Path

import pymupdf

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts' / 'design_review'))
sys.path.insert(0, str(ROOT / 'packages' / 'cv-workflow'))
import server  # noqa: E402
from cv_workflow import outputs  # noqa: E402

def _pdf(path, pages):
    path.parent.mkdir(parents=True, exist_ok=True)
    doc = pymupdf.open()
    for n in range(pages):
        doc.new_page(width=595, height=842).insert_text((72, 72), f'page {n + 1}')
    doc.save(path)


def _tree(repo):
    """A fictional tree in every home, stamped the way the writers stamp, plus the drift the app must show."""
    style = repo / 'design-concepts' / '2030-01-02-harbour-lights'
    common = {'domain': 'travel', 'candidate': 'Δοκιμή Παράδειγμα', 'style': 'Harbour Lights', 'idea': 'lights on water',
              'status': 'proposed', 'producedBy': 'magazine-editor'}
    for density, tiers, pages in (('condensed', ('safe', 'stylish', 'creative'), 1), ('spacious', ('safe', 'stylish'), 2)):
        for tier in tiers:
            pdf = style / density / tier / f'{density}-{tier}.pdf'
            _pdf(pdf, pages)
            outputs.stamp(pdf, common, root=repo)
    (style / 'brief.md').write_text('# Harbour Lights\n', encoding='utf-8')
    old = repo / 'design-concepts' / '2030-01-01-old-draft' / 'concept.pdf'
    _pdf(old, 2)
    outputs.stamp(old, dict(common, kind='text-draft', style='Old Draft', status='parked'), root=repo)
    entry = repo / 'examples' / 'marine' / 'flagship' / 'cadet.typ'
    entry.parent.mkdir(parents=True)
    (repo / 'examples' / 'candidates').mkdir()
    (repo / 'examples' / 'candidates' / 'cadet.json').write_text(json.dumps({'identity': {'name': 'NIKOS TEST', 'rank': 'DECK CADET'}}), encoding='utf-8')
    entry.write_text('#let candidate = json("../../candidates/cadet.json")\n', encoding='utf-8')
    _pdf(entry.with_suffix('.pdf'), 1)
    outputs.stamp(entry.with_suffix('.pdf'), {'status': 'release', 'style': 'Flagship', 'variant': 'Golden Blue, one page'}, root=repo)
    env = repo / 'private' / 'fictional-client'
    env.mkdir(parents=True)
    (env / 'envelope.json').write_text(json.dumps({'alias': 'client-2030-01-03', 'domain': 'marine',
                                                   'candidate': 'Fictional Client', 'rank': 'Chief Officer'}), encoding='utf-8')
    rev = env / 'revisions' / '20300103-101010-abcdef' / 'cv.pdf'
    _pdf(rev, 2)
    outputs.stamp(rev, {'status': 'render', 'lang': 'el'}, root=repo)
    _pdf(env / 'draft' / 'draft-01.pdf', 1)
    outputs.stamp(env / 'draft' / 'draft-01.pdf', {'status': 'signed-off'}, root=repo)
    _pdf(env / 'reference.pdf', 2)
    outputs.stamp(env / 'reference.pdf', {'status': 'delivered', 'title': 'Delivered CV'}, root=repo)
    _pdf(env / 'stray.pdf', 1)                                  # exists, but not in a home: never shown
    _pdf(style / 'condensed' / 'safe' / 'draft-notes.pdf', 1)   # drift: outside a home
    _pdf(repo / 'exports' / 'Old-CV.pdf', 1)                    # drift: the retired root exports/
    fresh = repo / 'design-concepts' / '2030-01-02-nomad' / 'condensed' / 'safe' / 'condensed-safe.pdf'
    _pdf(fresh, 1)                                              # drift: never stamped


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

        cs = 'design-concepts/2030-01-02-harbour-lights/condensed/safe/condensed-safe.pdf'
        ss = 'design-concepts/2030-01-02-harbour-lights/spacious/safe/spacious-safe.pdf'
        cc = 'design-concepts/2030-01-02-harbour-lights/condensed/creative/condensed-creative.pdf'
        (repo / cs).write_bytes((repo / cs).read_bytes() + b'\n')   # drift: re-rendered after stamping
        code, _, body = _call(base, '/api/items')
        payload = json.loads(body)
        items = {i['id']: i for i in payload['items']}
        unindexed = {u['path']: u['reason'] for u in payload['unindexed']}
        assert len(items) == 9, sorted(items)
        assert 'stale' in unindexed.pop(cs)
        assert 'not in a home' in unindexed.pop('design-concepts/2030-01-02-harbour-lights/condensed/safe/draft-notes.pdf')
        assert 'retired' in unindexed.pop('exports/Old-CV.pdf')
        assert 'no Meta File' in unindexed.pop('design-concepts/2030-01-02-nomad/condensed/safe/condensed-safe.pdf')
        assert not unindexed, unindexed
        outputs.stamp(repo / cs, {'date': '2030-01-05'}, root=repo)
        assert outputs.stamp(repo / cs, {}, root=repo)['date'] == '2030-01-05'      # same bytes: date kept
        (repo / cs).write_bytes((repo / cs).read_bytes() + b'\n')
        assert outputs.stamp(repo / cs, {}, root=repo)['date'] == date.today().isoformat()  # new bytes: today
        wrong = outputs.meta_path(repo / cc)
        good_meta = wrong.read_text(encoding='utf-8')
        wrong.write_text(good_meta.replace('"creative"', '"safe"'), encoding='utf-8')
        mismatch = {u['path']: u['reason'] for u in json.loads(_call(base, '/api/items')[2])['unindexed']}
        assert "tier='safe' but its place says 'creative'" in mismatch[cc], mismatch
        wrong.write_text(good_meta, encoding='utf-8')
        assert outputs.home_of(repo / 'design-concepts/2030-01-01-old-draft/old-render.pdf', repo) is None
        items = {i['id']: i for i in json.loads(_call(base, '/api/items')[2])['items']}
        assert items[cs]['style'] == 'Harbour Lights' and items[cs]['idea'] == 'lights on water'
        assert items[cs]['domain'] == 'travel' and items[cs]['candidate'] == 'Δοκιμή Παράδειγμα'
        assert (items[cs]['density'], items[cs]['tier'], items[cs]['pages']) == ('condensed', 'safe', 1)
        assert items[ss]['pages'] == 2 and items[cs]['twin'] == ss and items[ss]['twin'] == cs
        assert items[cc]['twin'] is None  # no spacious creative was drawn
        old = items['design-concepts/2030-01-01-old-draft/concept.pdf']
        assert old['kind'] == 'text-draft' and old['status'] == 'parked' and old['density'] is None
        cadet = items['examples/marine/flagship/cadet.pdf']
        assert (cadet['kind'], cadet['domain'], cadet['candidate'], cadet['rank']) == ('example', 'marine', 'Nikos Test', 'Deck Cadet')
        rev = items['private/fictional-client/revisions/20300103-101010-abcdef/cv.pdf']
        assert rev['kind'] == 'client-cv' and rev['candidate'] == 'Fictional Client' and rev['variant'].endswith('· el')
        assert rev['domain'] == 'marine' and rev['alias'] == 'client-2030-01-03'
        assert items['private/fictional-client/draft/draft-01.pdf']['kind'] == 'client-draft'
        assert items['private/fictional-client/reference.pdf']['status'] == 'delivered'
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
        outputs.meta_path(repo / cc).unlink()
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
