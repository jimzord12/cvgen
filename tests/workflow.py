"""End-to-end and failure checks for packages/cv-workflow, run through the real scripts/cv.py."""
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

from verify import ROOT, FLAGSHIP, verify

sys.path.insert(0, str(ROOT / 'packages/cv-workflow'))
from cv_workflow import sha256_file  # noqa: E402

ENTRY = '''#import "/packages/cv-engine/lib.typ": flagship
#import "/packages/cv-engine/templates/flagship/themes/golden-blue.typ": theme
#import "/packages/cv-engine/templates/flagship/artwork/engineer.typ": artwork
#import "/packages/cv-engine/templates/flagship/layouts/flagship-v11.typ": layout
#let candidate = json("candidate.json")
#show: flagship.with(candidate: candidate, theme: theme, artwork: artwork, layout: layout, show-vessel-durations: true)
'''


def run_workflow(out, typst):
    """A fresh fictional workspace under the suite output; returns the list of passed checks."""
    base = out / 'workflow'
    workspace = base / 'fictional-engineer'
    workspace.mkdir(parents=True, exist_ok=False)
    (workspace / 'cv.typ').write_text(ENTRY, encoding='utf-8')
    shutil.copyfile(ROOT / 'examples/candidates/fictional-engineer.png', workspace / 'portrait.png')
    record = json.loads((ROOT / 'examples/candidates/engineer-example.json').read_text(encoding='utf-8'))
    record['identity']['portrait'] = 'portrait.png'
    (workspace / 'candidate.json').write_text(json.dumps(record, indent=2), encoding='utf-8')
    log = (base / 'commands.log').open('w', encoding='utf-8')
    passed = []

    def cv(*args, expect=0, env=None):
        command = [sys.executable, str(ROOT / 'scripts/cv.py'), *[str(a) for a in args]]
        result = subprocess.run(command, capture_output=True, text=True, cwd=ROOT, env=env)
        log.write(f'$ {" ".join(command[2:])}\n{result.stdout}{result.stderr}[exit {result.returncode}]\n\n')
        assert result.returncode == expect, (args, expect, result.returncode, result.stdout, result.stderr)
        return json.loads(result.stdout) if result.returncode != 2 else result.stderr

    def revision(rid):
        return workspace / 'revisions' / rid

    # 1. Render: snapshot, records, checks bound to the bytes, PDF identical to the frozen v11 reference.
    first = cv('render', workspace, '--typst', typst)
    rid = first['revision']
    assert first['status'] == 'success' and first['checks_passed'] and first['engine_uncommitted_changes'] is False, first
    folder = revision(rid)
    for name in ['inputs/cv.typ', 'inputs/candidate.json', 'inputs/assets/portrait.png', 'render.log', 'render.json', 'checks.json', 'cv.pdf']:
        assert (folder / name).is_file(), name
    render = json.loads((folder / 'render.json').read_text(encoding='utf-8'))
    checks = json.loads((folder / 'checks.json').read_text(encoding='utf-8'))
    sha = sha256_file(folder / 'cv.pdf')
    assert render['pdf']['sha256'] == sha == first['sha256'] == checks['pdf_sha256'] and checks['passed']
    assert render['compiler']['version'].startswith('typst 0.15.1') and render['engine']['commit']
    assert render['inputs']['entry']['imports'][0] == '/packages/cv-engine/lib.typ'
    snapshot = json.loads((folder / 'inputs/candidate.json').read_text(encoding='utf-8'))
    assert snapshot['identity']['portrait'] == '/' + (folder / 'inputs/assets/portrait.png').relative_to(ROOT).as_posix()
    assert sha256_file(folder / 'inputs/assets/portrait.png') == sha256_file(ROOT / 'examples/candidates/fictional-engineer.png')
    assert (folder / 'inputs/cv.typ').read_text(encoding='utf-8') == ENTRY
    exact = verify(folder / 'cv.pdf', ROOT / FLAGSHIP / 'tests/approved/Marine-Engineer-CV-v11.pdf', output=base / 'exact')
    assert exact['passed'], exact
    passed.append('render-snapshot-and-records')

    # 2. Approval needs the reviewed hash, a name, and refuses test-only approvals under private/.
    assert 'does not match' in cv('approve', workspace, rid, '--approver', 'suite', '--sha256', 'deadbeefdeadbeef', '--test-only', expect=2)
    assert 'twelve' in cv('approve', workspace, rid, '--approver', 'suite', '--sha256', sha[:8], '--test-only', expect=2)
    assert 'private/' in cv('approve', ROOT / 'private/zz-fictional-never-created', rid, '--approver', 'suite',
                            '--sha256', sha, '--test-only', expect=2)
    assert not (ROOT / 'private/zz-fictional-never-created').exists()
    assert not (folder / 'cv.approval.json').exists()
    approved = cv('approve', workspace, rid, '--approver', 'suite (fictional fixture)', '--sha256', sha[:12], '--test-only')
    approval = json.loads((folder / 'cv.approval.json').read_text(encoding='utf-8'))
    assert approval == approved['approval'] and approval['scope'] == 'test-only' and approval['sha256'] == sha and approval['revision'] == rid
    receipt_bytes = (folder / 'cv.approval.json').read_bytes()
    assert cv('approve', workspace, rid, '--approver', 'someone else', '--sha256', sha, '--test-only')['already_approved']
    assert (folder / 'cv.approval.json').read_bytes() == receipt_bytes
    passed.append('approve-explicit-and-bound')

    # 3. Export copies the bytes without a compiler on PATH, verifies them, and repeats without touching the bundle.
    no_typst = {**os.environ, 'PATH': str(base)}
    assert shutil.which('typst', path=no_typst['PATH']) is None
    exported = cv('export', workspace, rid, env=no_typst)
    bundle = workspace / 'exports' / rid
    assert not exported['existing'] and Path(exported['export']) == bundle
    assert sha256_file(bundle / 'cv.pdf') == sha and (bundle / 'cv.approval.json').read_bytes() == receipt_bytes
    before = {p.name: p.stat().st_mtime_ns for p in bundle.iterdir()}
    assert cv('export', workspace, rid, env=no_typst)['existing']
    assert {p.name: p.stat().st_mtime_ns for p in bundle.iterdir()} == before
    assert [r['state'] for r in cv('status', workspace)['revisions']] == ['exported']
    passed.append('export-verified-no-rerender-repeatable')

    # 4. Editing the record starts a new revision that inherits no approval; a copied receipt does not count.
    record['identity']['rank'] = 'SECOND ENGINEER (REVISED)'
    (workspace / 'candidate.json').write_text(json.dumps(record, indent=2), encoding='utf-8')
    second = cv('render', workspace, '--typst', typst)
    rid2 = second['revision']
    assert rid2 != rid and second['sha256'] != sha and not (revision(rid2) / 'cv.approval.json').exists()
    assert 'not approved' in cv('export', workspace, rid2, expect=2)
    shutil.copyfile(folder / 'cv.approval.json', revision(rid2) / 'cv.approval.json')
    assert 'belongs to revision' in cv('export', workspace, rid2, expect=2)
    os.remove(revision(rid2) / 'cv.approval.json')
    passed.append('later-revision-inherits-nothing')

    # 5. Bytes changed after approval: export refuses; a mismatched receipt is refused before any copy.
    cv('approve', workspace, rid2, '--approver', 'suite', '--sha256', second['sha256'], '--test-only')
    with (revision(rid2) / 'cv.pdf').open('ab') as handle:
        handle.write(b'\n%tampered')
    assert 'bytes changed' in cv('export', workspace, rid2, expect=2)
    assert not (workspace / 'exports' / rid2).exists()
    assert 'bytes changed' in cv('approve', workspace, rid2, '--approver', 'suite', '--sha256', second['sha256'], '--test-only', expect=2)
    passed.append('changed-bytes-refused')

    # 6. Failing checks (wrong expected page count) keep the revision but block approval.
    failing = cv('render', workspace, '--typst', typst, '--pages', '3', expect=1)
    assert failing['status'] == 'success' and not failing['checks_passed'] and 'Expected 3 pages' in failing['errors'][0]
    assert 'checks failed' in cv('approve', workspace, failing['revision'], '--approver', 'suite', '--sha256', failing['sha256'], '--test-only', expect=2)
    passed.append('failing-checks-block-approval')

    # 7. Stale check evidence is refused; a compile failure is retained with its log.
    third = cv('render', workspace, '--typst', typst)
    rid3 = third['revision']
    checks_path = revision(rid3) / 'checks.json'
    original = checks_path.read_text(encoding='utf-8')
    stale = json.loads(original)
    stale['pdf_sha256'] = '0' * 64
    checks_path.write_text(json.dumps(stale), encoding='utf-8')
    assert 'stale' in cv('approve', workspace, rid3, '--approver', 'suite', '--sha256', third['sha256'], '--test-only', expect=2)
    checks_path.write_text('{not json', encoding='utf-8')
    assert 'not valid JSON' in cv('approve', workspace, rid3, '--approver', 'suite', '--sha256', third['sha256'], '--test-only', expect=2)
    assert [r['state'] for r in cv('status', workspace)['revisions'] if r['revision'] == rid3] == ['corrupt']
    checks_path.write_text(original, encoding='utf-8')
    (workspace / 'cv.typ').write_text(ENTRY.replace('flagship.with', 'flagship.wit'), encoding='utf-8')
    broken = cv('render', workspace, '--typst', typst, expect=1)
    assert broken['status'] == 'failed' and 'error' in (revision(broken['revision']) / 'render.log').read_text(encoding='utf-8')
    assert json.loads((revision(broken['revision']) / 'render.json').read_text(encoding='utf-8'))['pdf'] is None
    assert 'did not render' in cv('approve', workspace, broken['revision'], '--approver', 'suite', '--sha256', sha, '--test-only', expect=2)
    (workspace / 'cv.typ').write_text(ENTRY, encoding='utf-8')
    # A data error naming a Greek company must reach render.log intact whatever the console codec.
    greek = json.loads(json.dumps(record))
    greek['companies'][0]['name'] = 'Ναυτιλιακή Δοκιμή'
    greek['companies'][0]['groups'][0]['ships'][0]['months'] = None
    (workspace / 'candidate.json').write_text(json.dumps(greek, ensure_ascii=False, indent=2), encoding='utf-8')
    data_error = cv('render', workspace, '--typst', typst, expect=1)
    assert data_error['status'] == 'failed' and 'Ναυτιλιακή Δοκιμή' in data_error['errors'][0]
    assert 'Ναυτιλιακή Δοκιμή' in (revision(data_error['revision']) / 'render.log').read_text(encoding='utf-8')
    passed.append('stale-checks-and-failed-render')

    # Refusals before the compiler runs leave no revision behind: bad JSON, missing portrait.
    count = len(list((workspace / 'revisions').iterdir()))
    (workspace / 'candidate.json').write_text('{"identity": ', encoding='utf-8')
    assert 'not valid JSON' in cv('render', workspace, '--typst', typst, expect=2)
    missing = json.loads(json.dumps(record))
    missing['identity']['portrait'] = 'nobody.png'
    (workspace / 'candidate.json').write_text(json.dumps(missing), encoding='utf-8')
    assert 'does not exist' in cv('render', workspace, '--typst', typst, expect=2)
    assert len(list((workspace / 'revisions').iterdir())) == count
    (workspace / 'candidate.json').write_text(json.dumps(record, indent=2), encoding='utf-8')
    passed.append('refused-render-leaves-nothing')

    # 8. Interrupted operations: a revision without render.json, a leftover partial export, a conflicting destination.
    ghost = revision('20000101-000000-ghost0')
    ghost.mkdir()
    shutil.copyfile(folder / 'cv.pdf', ghost / 'cv.pdf')
    assert 'incomplete' in cv('approve', workspace, ghost.name, '--approver', 'suite', '--sha256', sha, '--test-only', expect=2)
    assert 'incomplete' in cv('export', workspace, ghost.name, expect=2)
    assert 'approver name is required' in cv('approve', workspace, rid3, '--approver', ' ', '--sha256', third['sha256'], '--test-only', expect=2)
    cv('approve', workspace, rid3, '--approver', 'suite', '--sha256', third['sha256'], '--test-only')
    receipt3 = revision(rid3) / 'cv.approval.json'
    genuine = receipt3.read_text(encoding='utf-8')
    forged = json.loads(genuine)
    forged['sha256'] = sha  # a receipt for this revision but other bytes
    receipt3.write_text(json.dumps(forged), encoding='utf-8')
    assert 'other PDF bytes' in cv('export', workspace, rid3, expect=2)
    assert 'for other bytes' in cv('approve', workspace, rid3, '--approver', 'suite', '--sha256', third['sha256'], '--test-only', expect=2)
    receipt3.write_text(genuine, encoding='utf-8')
    partial = workspace / 'exports' / f'.partial-{rid3}-000000'
    partial.mkdir()
    (partial / 'cv.pdf').write_bytes(b'half written')
    conflict = workspace / 'exports' / rid3
    conflict.mkdir()
    (conflict / 'cv.pdf').write_bytes(b'someone else\'s file')
    assert 'not a complete bundle' in cv('export', workspace, rid3, expect=2)
    shutil.copyfile(revision(rid3) / 'cv.approval.json', conflict / 'cv.approval.json')
    assert 'different cv.pdf' in cv('export', workspace, rid3, expect=2)
    assert (conflict / 'cv.pdf').read_bytes() == b'someone else\'s file'
    shutil.copyfile(revision(rid3) / 'cv.pdf', conflict / 'cv.pdf')
    (conflict / 'cv.approval.json').write_text(json.dumps({**json.loads(genuine), 'approver': 'not the suite'}), encoding='utf-8')
    assert 'different approval receipt' in cv('export', workspace, rid3, expect=2)
    status = cv('status', workspace)
    assert status['partial_exports'] == [partial.name]
    assert dict((r['revision'], r['state']) for r in status['revisions']) == {
        rid: 'exported', rid2: 'changed', failing['revision']: 'checks-failed', broken['revision']: 'failed',
        data_error['revision']: 'failed', rid3: 'export-conflict', ghost.name: 'incomplete'}
    assert {r['revision']: r['sha256'] for r in status['revisions']}[rid3] == third['sha256'][:12]
    shutil.rmtree(conflict)
    exported3 = cv('export', workspace, rid3, env=no_typst)
    assert not exported3['existing'] and sha256_file(conflict / 'cv.pdf') == third['sha256']
    assert cv('status', workspace)['partial_exports'] == [partial.name]  # left for inspection, never used
    passed.append('interrupted-and-conflicting-refused')

    log.close()
    (base / 'report.json').write_text(json.dumps({'passed': passed, 'workspace': str(workspace)}, indent=2), encoding='utf-8')
    return passed
