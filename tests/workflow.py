"""End-to-end and failure checks for packages/cv-workflow, run through the real scripts/cv.py."""
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

from verify import ROOT, FLAGSHIP, verify

sys.path.insert(0, str(ROOT / 'packages/cv-workflow'))
from cv_workflow import WorkflowError, outputs, sha256_file  # noqa: E402
from cv_workflow.render import STRICT_FONTS  # noqa: E402


def system_font_family(typst):
    """A font family this machine has but the bundled fonts do not, or None (task-46).

    With --ignore-system-fonts Typst must call it unknown; without the flag it would find it and stay
    silent, so a case naming it fails only while the runners pass the flag. Chosen at run time, so the
    case proves the flag on any machine that has a system font; CI installs one (verify.yml), and there
    tests/run.py fails rather than skips when none is found.
    The probe spells the flag out instead of using STRICT_FONTS: emptying that constant must make the
    cases fail, not make every system font look bundled and the cases skip.
    """
    def families(*flags):
        listed = subprocess.run([typst, 'fonts', *flags], capture_output=True, text=True, encoding='utf-8',
                                errors='replace', check=True).stdout
        return {line.strip() for line in listed.splitlines() if line.strip()}
    bundled = {f.lower() for f in families('--ignore-system-fonts', '--font-path', str(ROOT / 'packages/cv-framework/fonts'))}
    # Plain names only, so the family is safe inside a Typst string and in the warning Typst prints.
    found = sorted(f for f in families() if f.lower() not in bundled and f.replace(' ', '').isalnum() and f.isascii())
    return found[0] if found else None

ENTRY = '''#import "/packages/domains/marine/lib.typ": flagship
#import "/packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "/packages/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "/packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
#let candidate = json("../candidate.json")
#show: flagship.with(candidate: candidate, theme: theme, artwork: artwork, layout: layout, show-vessel-durations: true)
'''

# A one-off design for a field with no domain yet: the Framework only, plus files beside typst/cv.typ
# and one from another Envelope folder (images/), read by a path relative to cv.typ.
ONE_OFF = '''#import "/packages/cv-framework/lib.typ": normalize-common
#import "parts/helper.typ": note
// A commented read such as json("missing.json") is not a file the page needs.
#let d = normalize-common(json("../candidate.json"))
#let p = json("presentation.json")
#set text(font: "Source Sans 3")
= #d.identity.name
#p.headline
#image("../images/badge.png", width: 1cm)

#note

Signature tours include "Athens by Night" and more.
#link("https://example.org/ada")[#read("parts/link.txt")]
'''


def run_workflow(out, typst, system_family=None):
    """A fresh fictional workspace under the suite output; returns the list of passed checks.

    `system_family` (from system_font_family) adds the system-font case; None leaves it out, and the
    caller reports it as skipped."""
    base = out / 'workflow'
    workspace = base / 'fictional-engineer'
    (workspace / 'typst').mkdir(parents=True, exist_ok=False)
    (workspace / 'images/portrait').mkdir(parents=True)
    entry = workspace / 'typst/cv.typ'           # the Envelope layout (TASK-32)
    entry.write_text(ENTRY, encoding='utf-8')
    shutil.copyfile(ROOT / 'examples/candidates/fictional-engineer.png', workspace / 'images/portrait/portrait.png')
    record = json.loads((ROOT / 'examples/candidates/engineer-example.json').read_text(encoding='utf-8'))
    record['identity']['portrait'] = 'images/portrait/portrait.png'
    (workspace / 'candidate.json').write_text(json.dumps(record, indent=2), encoding='utf-8')
    envelope = {'alias': 'client-2030-01-01', 'domain': 'marine', 'candidate': 'Alex Morgan', 'rank': 'Second Engineer'}
    log = (base / 'commands.log').open('w', encoding='utf-8')
    passed = []

    def cv(*args, expect=0, env=None):
        command = [sys.executable, str(ROOT / 'scripts/cv.py'), *[str(a) for a in args]]
        result = subprocess.run(command, capture_output=True, text=True, cwd=ROOT, env=env)
        cv.stderr = result.stderr
        log.write(f'$ {" ".join(command[2:])}\n{result.stdout}{result.stderr}[exit {result.returncode}]\n\n')
        assert result.returncode == expect, (args, expect, result.returncode, result.stdout, result.stderr)
        return json.loads(result.stdout) if result.returncode != 2 else result.stderr

    def revision(rid):
        return workspace / 'revisions' / rid

    # 0. Output Contract: no envelope.json, no render, and nothing is left behind.
    assert 'envelope.json is missing' in cv('render', workspace, '--typst', typst, expect=2)
    (workspace / 'envelope.json').write_text(json.dumps(dict(envelope, domain='Marine')), encoding='utf-8')
    assert "domain='Marine'" in cv('render', workspace, '--typst', typst, expect=2)
    assert not (workspace / 'revisions').exists()
    (workspace / 'envelope.json').write_text(json.dumps(envelope), encoding='utf-8')

    # 1. Render: snapshot, records, checks bound to the bytes, PDF identical to the frozen v11 reference.
    first = cv('render', workspace, '--typst', typst, '--input', 'lang=EN')
    rid = first['revision']
    assert first['schema'] == '/packages/domains/marine/templates/flagship/schema/flagship-input.schema.json', first
    assert first['status'] == 'success' and first['checks_passed'] and first['engine_uncommitted_changes'] is False, first
    folder = revision(rid)
    for name in ['inputs/typst/cv.typ', 'inputs/candidate.json', 'inputs/assets/portrait.png', 'render.log', 'render.json', 'checks.json', 'cv.pdf']:
        assert (folder / name).is_file(), name
    assert not (folder / 'inputs/cv.typ').exists()   # the snapshot mirrors the Envelope layout
    render = json.loads((folder / 'render.json').read_text(encoding='utf-8'))
    checks = json.loads((folder / 'checks.json').read_text(encoding='utf-8'))
    sha = sha256_file(folder / 'cv.pdf')
    assert render['pdf']['sha256'] == sha == first['sha256'] == checks['pdf_sha256'] and checks['passed']
    assert render['compiler']['version'].startswith('typst 0.15.1') and render['engine']['commit']
    assert render['inputs']['entry']['imports'][0] == '/packages/domains/marine/lib.typ'
    assert render['inputs']['entry']['path'] == 'inputs/typst/cv.typ' and render['compiler']['command'][-2].endswith('cv.typ')
    assert render['inputs']['candidate']['schema'].endswith('/templates/flagship/schema/flagship-input.schema.json')
    snapshot = json.loads((folder / 'inputs/candidate.json').read_text(encoding='utf-8'))
    assert snapshot['identity']['portrait'] == '/' + (folder / 'inputs/assets/portrait.png').relative_to(ROOT).as_posix()
    assert sha256_file(folder / 'inputs/assets/portrait.png') == sha256_file(ROOT / 'examples/candidates/fictional-engineer.png')
    assert (folder / 'inputs/typst/cv.typ').read_text(encoding='utf-8') == ENTRY
    exact = verify(folder / 'cv.pdf', ROOT / FLAGSHIP / 'tests/approved/Marine-Engineer-CV-v11.pdf', output=base / 'exact')
    assert exact['passed'], exact
    meta = json.loads((folder / 'cv.meta.json').read_text(encoding='utf-8'))
    assert meta['sha256'] == sha and meta['status'] == 'render' and meta['kind'] == 'client-cv' and meta['pages'] == 2
    assert {k: meta[k] for k in envelope} == envelope and meta['variant'] == rid and meta['lang'] == 'en', meta
    assert meta['source'] == 'typst/cv.typ', meta
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
    stamped = json.loads((folder / 'cv.meta.json').read_text(encoding='utf-8'))
    assert stamped['status'] == 'approved' and stamped['date'] == meta['date'] and stamped['sha256'] == sha
    receipt_bytes = (folder / 'cv.approval.json').read_bytes()
    meta_file = folder / 'cv.meta.json'
    meta_file.write_text(json.dumps(dict(stamped, status='render')), encoding='utf-8')     # a missed stamp
    assert cv('approve', workspace, rid, '--approver', 'someone else', '--sha256', sha, '--test-only')['already_approved']
    assert (folder / 'cv.approval.json').read_bytes() == receipt_bytes
    assert json.loads(meta_file.read_text(encoding='utf-8'))['status'] == 'approved'       # healed
    meta_file.write_text(json.dumps(dict(stamped, status='delivered')), encoding='utf-8')
    cv('approve', workspace, rid, '--approver', 'suite', '--sha256', sha, '--test-only')
    assert json.loads(meta_file.read_text(encoding='utf-8'))['status'] == 'delivered'      # never downgraded
    meta_file.write_text(json.dumps(stamped), encoding='utf-8')
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
    (workspace / 'envelope.json').write_text(json.dumps(dict(envelope, alias='client-2030-1-1')), encoding='utf-8')
    assert "alias='client-2030-1-1'" in cv('approve', workspace, rid2, '--approver', 'suite', '--sha256', second['sha256'],
                                           '--test-only', expect=2)
    assert not (revision(rid2) / 'cv.approval.json').exists()    # refused before the receipt
    (workspace / 'envelope.json').write_text(json.dumps(envelope), encoding='utf-8')
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
    # Valid JSON of the wrong shape is 'corrupt' too, and never a traceback (review note N4 on pdf-workflow).
    render_path = revision(rid3) / 'render.json'
    original_render = render_path.read_text(encoding='utf-8')
    for wrong in ('[]', '{"status": "success"}', '{"status": "success", "pdf": null}'):
        render_path.write_text(wrong, encoding='utf-8')
        assert [r['state'] for r in cv('status', workspace)['revisions'] if r['revision'] == rid3] == ['corrupt'], wrong
    render_path.write_text('[]', encoding='utf-8')
    assert 'must hold a JSON object' in cv('approve', workspace, rid3, '--approver', 'suite', '--sha256', third['sha256'], '--test-only', expect=2)
    render_path.write_text(original_render, encoding='utf-8')
    entry.write_text(ENTRY.replace('flagship.with', 'flagship.wit'), encoding='utf-8')
    broken = cv('render', workspace, '--typst', typst, expect=1)
    assert broken['status'] == 'failed' and 'error' in (revision(broken['revision']) / 'render.log').read_text(encoding='utf-8')
    assert json.loads((revision(broken['revision']) / 'render.json').read_text(encoding='utf-8'))['pdf'] is None
    assert 'did not render' in cv('approve', workspace, broken['revision'], '--approver', 'suite', '--sha256', sha, '--test-only', expect=2)
    entry.write_text(ENTRY, encoding='utf-8')
    # A data error naming a Greek company must reach render.log intact whatever the console codec.
    # A wrong company total passes the schema (it cannot add up months) and fails in the engine.
    greek = json.loads(json.dumps(record))
    greek['companies'][0]['name'] = 'Ναυτιλιακή Δοκιμή'
    greek['companies'][0]['service-months'] = 1
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

    # A record that breaks the Flagship contract is refused before anything is written, naming each field.
    typo = json.loads(json.dumps(record))
    typo['educaton_entries'] = typo.pop('education_entries')
    typo['companies'][0]['groups'][0]['ships'][0]['months'] = 'eight'
    typo['companies'][0]['groups'][0]['ships'][1]['months'] = None
    del typo['identity']['rank']
    typo['certificates'] = [{'title': 'A', 'scope': 'B', 'issued': 'C', 'reviw': 'D'},
                            {'title': 'A', 'scope': 'B', 'issued': 2021, 'review': 'D'}]
    (workspace / 'candidate.json').write_text(json.dumps(typo), encoding='utf-8')
    refused = cv('render', workspace, '--typst', typst, expect=2)
    assert 'flagship-input.schema.json' in refused and "'educaton_entries' was unexpected" in refused, refused
    assert 'companies/0/groups/0/ships/0/months' in refused and "'rank' is a required property" in refused, refused
    assert 'companies/0/groups/0/ships/1/months: is null; give a value, or leave the key out if it is optional' in refused, refused
    assert "certificates/1/issued: 2021 is not of type 'string'" in refused, refused
    assert "certificates/0: 'review' is a required property" in refused and "'reviw' was unexpected" in refused, refused
    assert "'title': 'A'" not in refused, refused
    assert len(list((workspace / 'revisions').iterdir())) == count
    (workspace / 'candidate.json').write_text(json.dumps(record, indent=2), encoding='utf-8')
    passed.append('schema-refuses-invalid-record')

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

    # 9. Certificate dates warn loudly and never block (owner, 2026-09-25), measured against a fixed day so
    # the suite never ages. Both certificate shapes; the 180-day edge; free text and a non-date are counted.
    dated = json.loads(json.dumps(record))
    dated['certificates'] = [
        ['Expired medical', 'ENG1', '01 Jun 2024', '31 May 2026'],
        {'title': 'Near CoC', 'scope': 'III/2', 'issued': '15 Jul 2021', 'review': '10 Jan 2027'},
        ['Edge of window', 'Record', '01 Jan 2024', '26 Mar 2027'],
        ['Beyond window', 'Record', '01 Jan 2024', '27 Mar 2027'],
        ['Free text', 'Record', '01 Jan 2024', 'As required'],
        ['Not a date', 'Record', '01 Jan 2024', '31 Feb 2029'],
    ]
    (workspace / 'candidate.json').write_text(json.dumps(dated, indent=2), encoding='utf-8')
    warned = cv('render', workspace, '--typst', typst, '--reference-date', '2026-09-27')
    assert warned['status'] == 'success' and warned['checks_passed'], warned
    assert len(warned['warnings']) == 3, warned['warnings']
    assert warned['warnings'][0].startswith('Certificate "Expired medical" EXPIRED on 31 May 2026 (119 days'), warned['warnings']
    assert warned['warnings'][1].startswith('Certificate "Near CoC" expires on 10 Jan 2027, in 105 days'), warned['warnings']
    assert warned['warnings'][2].startswith('Certificate "Edge of window" expires on 26 Mar 2027, in 180 days'), warned['warnings']
    assert cv.stderr.count('WARNING: Certificate') == 3, cv.stderr
    # The unchecked count reaches the output too, so silence is never read as a pass.
    assert warned['certificate_dates'] == {'reference_date': '2026-09-27', 'date_checked': 4, 'not_date_checked': 2}, warned
    assert 'NOTE: 2 certificate date(s) not checked' in cv.stderr, cv.stderr
    recorded = json.loads((revision(warned['revision']) / 'checks.json').read_text(encoding='utf-8'))
    assert recorded['passed'] and recorded['certificates'] == {
        'reference_date': '2026-09-27', 'window_days': 180, 'date_checked': 4, 'not_date_checked': 2,
        'warnings': warned['warnings']}, recorded
    listed = {r['revision']: r['warnings'] for r in cv('status', workspace)['revisions']}
    assert listed[warned['revision']] == warned['warnings']
    assert cv.stderr.count(f'WARNING [{warned["revision"]}]: Certificate') == 3, cv.stderr
    assert {r['revision']: r['certificate_dates'] for r in cv('status', workspace)['revisions']}[warned['revision']] == warned['certificate_dates']
    cv('approve', workspace, warned['revision'], '--approver', 'suite', '--sha256', warned['sha256'], '--test-only')
    # A hand-broken certificate block never makes status a traceback: no warnings, no counts, same state.
    warned_checks = revision(warned['revision']) / 'checks.json'
    kept = warned_checks.read_text(encoding='utf-8')
    for broken_block in ['x', ['x'], {'warnings': None}, {'warnings': [1]}]:
        warned_checks.write_text(json.dumps({**json.loads(kept), 'certificates': broken_block}), encoding='utf-8')
        row = [r for r in cv('status', workspace)['revisions'] if r['revision'] == warned['revision']][0]
        assert row['warnings'] == [] and row['certificate_dates'] is None and row['state'] == 'approved', (broken_block, row)
    warned_checks.write_text(kept, encoding='utf-8')
    (workspace / 'candidate.json').write_text(json.dumps(record, indent=2), encoding='utf-8')
    passed.append('certificate-dates-warn-only')

    # 10. A one-off design (no domain yet) imports only the Framework, reads sibling files and a local helper;
    # the revision snapshots them all, and compiles from the snapshot alone (card revision-snapshot).
    oneoff = base / 'fictional-tour-guide'
    typst_dir = oneoff / 'typst'
    (typst_dir / 'parts').mkdir(parents=True)
    (oneoff / 'images').mkdir()
    badge = (ROOT / 'examples/candidates/fictional-engineer.png').read_bytes()
    (oneoff / 'images/badge.png').write_bytes(badge)
    (oneoff / 'envelope.json').write_text(json.dumps(dict(envelope, domain='travel', rank='Tour Guide')), encoding='utf-8')
    (typst_dir / 'cv.typ').write_text(ONE_OFF, encoding='utf-8')
    (typst_dir / 'parts/helper.typ').write_text('#let note = read("note.txt")\n', encoding='utf-8')
    (typst_dir / 'parts/note.txt').write_text('Licensed guide, fictional record', encoding='utf-8')
    (typst_dir / 'parts/link.txt').write_text('Read after a URL', encoding='utf-8')
    (typst_dir / 'presentation.json').write_text(json.dumps({'headline': 'Walks through old Athens'}), encoding='utf-8')
    (oneoff / 'candidate.json').write_text(json.dumps({'identity': {'name': 'Ada Example', 'rank': 'Tour guide'}}), encoding='utf-8')
    guide = cv('render', oneoff, '--typst', typst, '--pages', '1')
    assert guide['status'] == 'success' and guide['checks_passed'] and guide['schema'] is None, guide
    snap = oneoff / 'revisions' / guide['revision']
    files = json.loads((snap / 'render.json').read_text(encoding='utf-8'))['inputs']['files']
    # The read after a URL is found (a // in a string is not a comment); the word "include" in prose is not a read.
    assert sorted(f['path'] for f in files) == ['inputs/images/badge.png', 'inputs/typst/parts/helper.typ',
                                                'inputs/typst/parts/link.txt', 'inputs/typst/parts/note.txt',
                                                'inputs/typst/presentation.json'], files
    assert all(f['sha256'] == sha256_file(snap / f['path']) for f in files), files
    import pymupdf as fitz
    with fitz.open(snap / 'cv.pdf') as doc:
        assert all(t in doc[0].get_text() for t in ['Walks through old Athens', 'Licensed guide', 'Read after a URL'])
    # Change and then remove the live files: the snapshot still compiles, with what was rendered.
    (typst_dir / 'presentation.json').write_text(json.dumps({'headline': 'Changed after the render'}), encoding='utf-8')
    for name in ['typst/presentation.json', 'typst/parts/helper.typ', 'typst/parts/note.txt', 'typst/parts/link.txt',
                 'images/badge.png']:
        os.remove(oneoff / name)
    again = base / 'oneoff-from-snapshot.pdf'
    subprocess.run([typst, 'compile', '--root', str(ROOT), *STRICT_FONTS, '--font-path', str(ROOT / 'packages/cv-framework/fonts'),
                    str(snap / 'inputs/typst/cv.typ'), str(again)], check=True, capture_output=True)
    with fitz.open(again) as doc:
        assert 'Walks through old Athens' in doc[0].get_text() and 'Licensed guide' in doc[0].get_text()
    # Reads the snapshot cannot hold are refused before anything is written, naming the file.
    count = len(list((oneoff / 'revisions').iterdir()))
    without_helper = ONE_OFF.replace('#import "parts/helper.typ": note\n', '').replace('#note\n', '')
    (oneoff / 'images/badge.png').write_bytes(badge)
    refused = [('/private/zz-fictional/presentation.json', 'root-absolute path'),
               ('/' + (typst_dir / 'presentation.json').relative_to(ROOT).as_posix(), 'root-absolute path'),
               ('../../outside.json', 'outside the workspace'), ('presentation.json', 'does not exist')]
    if os.name == 'nt':  # only a case-insensitive filesystem makes Private/ the same folder as private/
        refused.append(('/./Private/zz-fictional/presentation.json', 'root-absolute path'))
    for read, message in refused:
        (typst_dir / 'cv.typ').write_text(without_helper.replace('presentation.json', read), encoding='utf-8')
        refusal = cv('render', oneoff, '--typst', typst, '--pages', '1', expect=2)
        assert message in refusal and read in refusal, refusal
    # A workspace file that would land on the portrait's place in the snapshot is refused too.
    (typst_dir / 'parts/link.txt').write_text('Read after a URL', encoding='utf-8')
    (oneoff / 'portrait.png').write_bytes((ROOT / 'examples/candidates/fictional-engineer.png').read_bytes())
    (oneoff / 'assets').mkdir()
    (oneoff / 'assets/portrait.png').write_bytes(b'not the portrait')
    (oneoff / 'candidate.json').write_text(json.dumps({'identity': {'name': 'Ada Example', 'rank': 'Tour guide',
                                                                    'portrait': 'portrait.png'}}), encoding='utf-8')
    (typst_dir / 'cv.typ').write_text(without_helper.replace('json("presentation.json")', '(headline: read("../assets/portrait.png"))'),
                                      encoding='utf-8')
    assert 'would take its place' in cv('render', oneoff, '--typst', typst, '--pages', '1', expect=2)
    assert len(list((oneoff / 'revisions').iterdir())) == count
    # A computed path the scan cannot see still cannot make a live read approvable: Typst's dependency list
    # names the live file, the checks fail and approval is refused.
    (oneoff / 'candidate.json').write_text(json.dumps({'identity': {'name': 'Ada Example', 'rank': 'Tour guide'}}), encoding='utf-8')
    (typst_dir / 'presentation.json').write_text(json.dumps({'headline': 'Live, not snapshotted'}), encoding='utf-8')
    live_path = (typst_dir / 'presentation.json').relative_to(ROOT).as_posix()
    (typst_dir / 'cv.typ').write_text(without_helper.replace('json("presentation.json")', f'json("/" + "{live_path}")'), encoding='utf-8')
    live = cv('render', oneoff, '--typst', typst, '--pages', '1', expect=1)
    assert live['status'] == 'success' and not live['checks_passed'], live
    assert any('live file outside the revision snapshot' in e and 'presentation.json' in e for e in live['errors']), live
    assert 'checks failed' in cv('approve', oneoff, live['revision'], '--approver', 'suite', '--sha256', live['sha256'],
                                 '--test-only', expect=2)
    passed.append('snapshot-holds-sibling-files')

    # 11. Fonts strict (task-46): a family that is not bundled, whether it exists nowhere or only among the
    # machine's fonts, compiles in another font; the checks fail naming it.
    fonts = [('missing-font-fails-checks', 'CVgen Missing Family')]
    if system_family:
        fonts.append(('system-font-fails-checks', system_family))
    for check, family in fonts:
        (typst_dir / 'cv.typ').write_text(without_helper.replace('font: "Source Sans 3"', f'font: "{family}"'), encoding='utf-8')
        fallback = cv('render', oneoff, '--typst', typst, '--pages', '1', expect=1)
        assert fallback['status'] == 'success' and not fallback['checks_passed'], fallback
        assert any(f'Font family "{family.lower()}" is not in packages/cv-framework/fonts' in e for e in fallback['errors']), fallback
        assert 'checks failed' in cv('approve', oneoff, fallback['revision'], '--approver', 'suite', '--sha256', fallback['sha256'],
                                     '--test-only', expect=2)
        passed.append(check)

    # 11b. The old flat layout (cv.typ at the Envelope root, TASK-32) is refused by every command before anything
    # is written, and the message says how to migrate; a stray root cv.typ beside typst/cv.typ is refused too.
    flat = base / 'fictional-flat'
    flat.mkdir()
    (flat / 'envelope.json').write_text(json.dumps(envelope), encoding='utf-8')
    (flat / 'candidate.json').write_text(json.dumps(record, indent=2), encoding='utf-8')
    (flat / 'cv.typ').write_text(ENTRY.replace('../candidate.json', 'candidate.json'), encoding='utf-8')
    for args in (('render', flat, '--typst', typst), ('approve', flat, rid, '--approver', 'suite', '--sha256', sha, '--test-only'),
                 ('export', flat, rid), ('status', flat)):
        refusal = cv(*args, expect=2)
        assert 'old flat layout' in refusal and 'typst/cv.typ' in refusal and '../candidate.json' in refusal, (args, refusal)
        assert 'images/portrait/' in refusal and 'identity.portrait' in refusal, (args, refusal)
    assert sorted(p.name for p in flat.iterdir()) == ['candidate.json', 'cv.typ', 'envelope.json']
    (flat / 'typst').mkdir()
    (flat / 'typst/cv.typ').write_text(ENTRY, encoding='utf-8')
    assert 'old flat layout' in cv('render', flat, '--typst', typst, expect=2)
    (flat / 'cv.typ').unlink()
    (flat / 'typst/cv.typ').unlink()
    assert 'has no typst/cv.typ' in cv('status', flat, expect=2)
    passed.append('flat-layout-refused')

    # 12. Stamp guards (decision #8, docs/proposals/workflow-model.md): a status that records an owner's act is
    # refused without its proof on disk, and the refusal leaves the Meta File as it was.
    def refused_stamp(pdf, fields, message):
        meta_before = outputs.meta_path(pdf).read_bytes() if outputs.meta_path(pdf).is_file() else None
        try:
            outputs.stamp(pdf, fields, envelope_dir=workspace)
        except WorkflowError as error:
            assert message in str(error), (pdf.name, fields, str(error))
        else:
            raise AssertionError(f'{pdf} was stamped {fields} without its proof')
        after = outputs.meta_path(pdf).read_bytes() if outputs.meta_path(pdf).is_file() else None
        assert after == meta_before, pdf

    unapproved = revision(failing['revision']) / 'cv.pdf'
    refused_stamp(unapproved, {'status': 'approved'}, 'no cv.approval.json')
    refused_stamp(unapproved, {'status': 'delivered'}, 'no cv.approval.json')
    refused_stamp(revision(rid2) / 'cv.pdf', {'status': 'approved'}, 'not this PDF')    # receipt for other bytes
    approved_only = revision(warned['revision']) / 'cv.pdf'                              # approved, never exported
    assert outputs.stamp(approved_only, {'status': 'approved'}, envelope_dir=workspace)['status'] == 'approved'
    own_receipt = approved_only.with_name('cv.approval.json')
    kept_receipt = own_receipt.read_text(encoding='utf-8')
    own_receipt.write_text(json.dumps({**json.loads(kept_receipt), 'revision': rid}), encoding='utf-8')  # right bytes, other revision
    refused_stamp(approved_only, {'status': 'approved'}, 'not this PDF')
    own_receipt.write_text(kept_receipt, encoding='utf-8')
    stray_reference = workspace / 'reference.pdf'          # the delivered-before-cv.py exemption holds in its home only
    shutil.copyfile(approved_only, stray_reference)
    refused_stamp(stray_reference, {'kind': 'client-cv', 'status': 'delivered'}, 'no cv.approval.json')
    stray_reference.unlink()
    refused_stamp(approved_only, {'status': 'delivered'}, 'no Export')
    (workspace / 'exports' / warned['revision']).mkdir()                               # an empty folder is no Export
    refused_stamp(approved_only, {'status': 'delivered'}, 'not a complete bundle')
    shutil.rmtree(workspace / 'exports' / warned['revision'])
    assert outputs.stamp(folder / 'cv.pdf', {'status': 'delivered'}, envelope_dir=workspace)['status'] == 'delivered'
    draft = workspace / 'draft' / 'draft-01.pdf'
    draft.parent.mkdir()
    shutil.copyfile(folder / 'cv.pdf', draft)
    assert outputs.stamp(draft, {'kind': 'client-draft', 'status': 'ready'}, envelope_dir=workspace)['status'] == 'ready'
    assert outputs.stamp(draft, {'status': 'sent'}, envelope_dir=workspace)['status'] == 'sent'
    refused_stamp(draft, {'status': 'signed-off'}, 'sign-off-01.png is not beside it')
    (draft.parent / 'sign-off-02.png').write_bytes(b'another draft\'s OK')                # the OK must answer this number
    refused_stamp(draft, {'status': 'signed-off'}, 'sign-off-01.png is not beside it')
    (draft.parent / 'sign-off-01.png').write_bytes(b'fictional screenshot')
    assert outputs.stamp(draft, {'status': 'signed-off'}, envelope_dir=workspace)['status'] == 'signed-off'
    passed.append('stamp-guards')

    log.close()
    (base / 'report.json').write_text(json.dumps({'passed': passed, 'workspace': str(workspace)}, indent=2), encoding='utf-8')
    return passed


def run_reality(folder, bun_run):
    """Level 3 of the Workflow Model (TASK-42), through the workflow tool's `reality` run (tools/workflow/src/reality.ts).

    A fictional client runs the model in a new folder under `folder`: every `cmd` step on its path runs the real
    script, the other steps are labelled stand-ins, and every declared output must exist and validate. Then two
    model copies that disagree with the scripts must fail naming the step: an output the script writes under
    another name, an export the model no longer makes wait for the owner's approval (cv.py refuses it), and a
    stamp that leaves its Meta File unchanged.
    `bun_run(log, *command)` runs Bun in tools/workflow and keeps its output in `folder/<log>`."""
    passed = []
    happy = bun_run('reality.log', 'run', 'reality', '--out', str(folder / 'reality'))
    assert happy.returncode == 0 and 'level 3 passes' in happy.stdout, ('workflow-reality', happy.stdout + happy.stderr)
    passed.append('reality')

    def broken(name, old, new, stage='06-deliver'):
        model = folder / f'model-{name}'
        shutil.copytree(ROOT / 'docs/workflow', model)
        stage = model / stage / 'stage.yaml'
        text = stage.read_text(encoding='utf-8')
        assert text.count(old) == 1, (name, old)
        stage.write_text(text.replace(old, new), encoding='utf-8')
        return bun_run(f'reality-{name}.log', 'run', 'reality', str(model), '--out', str(folder / f'reality-{name}'))

    # cv.py render writes render.json; a model that says render-record.json fails at the step that writes it.
    renamed = broken('renamed-output', 'revisions/<revision>/render.json', 'revisions/<revision>/render-record.json')
    assert renamed.returncode == 1, ('renamed-output', renamed.stdout + renamed.stderr)
    assert 'FAIL deliver.render: art.render-json: private/<envelope>/revisions/<revision>/render-record.json is not there' \
        in renamed.stdout, renamed.stdout
    assert 'FAILED level 3 at deliver.render' in renamed.stdout, renamed.stdout
    passed.append('reality-renamed-output')

    # Export without the approval among its inputs passes levels 1 and 2 (TASK-38's review); level 3 runs it as soon as
    # the render is there, before the owner's approval, and the real cv.py export refuses it.
    order = broken('export-before-approval', 'inputs: [art.approval-json, art.cv-pdf,', 'inputs: [art.cv-pdf,')
    assert order.returncode == 1, ('export-before-approval', order.stdout + order.stderr)
    assert 'FAILED level 3 at deliver.export' in order.stdout and 'not approved' in order.stdout, order.stdout
    assert 'OK   deliver.approve' not in order.stdout and 'OK   deliver.render' in order.stdout, order.stdout
    assert not list((folder / 'reality-export-before-approval').glob('repo/private/*/exports/*')), 'an export was written'
    passed.append('reality-export-waits-for-approval')

    # A restamp that leaves the Meta File as it was did not do its step: the sent stamp turned into a second
    # ready stamp rewrites draft-01.meta.json byte for byte, and the run fails there.
    noop = broken('no-op-stamp', 'draft-NN.pdf status=sent', 'draft-NN.pdf status=ready', stage='04-text-draft')
    assert noop.returncode == 1, ('no-op-stamp', noop.stdout + noop.stderr)
    assert 'FAIL text-draft.draft-sent: art.draft-meta:' in noop.stdout and 'byte for byte unchanged' in noop.stdout, noop.stdout
    passed.append('reality-unchanged-output-fails')
    return passed
