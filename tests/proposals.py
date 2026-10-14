"""scripts/proposals.py through its real command line: fixture folders written under the run's evidence folder
(valid ones and each kind of refusal), then the real docs/proposals/. Run by tests/run.py."""
from datetime import date
import json
import subprocess
import sys

from verify import ROOT

SCRIPT = ROOT / 'scripts' / 'proposals.py'


def proposal(pid, status, created, revision=1, title='A proposal', kind='proposal'):
    block = [f'id: {pid}' if pid else None, f'kind: {kind}', f'status: {status}' if status else None,
             f'revision: {revision}', f'created: {created}' if created else None]
    body = '\n'.join(l for l in block if l)
    # An example block in the body must never be read as the metadata.
    return f'---\n{body}\n---\n\n# {title}\n\n```yaml\n---\nid: P-9999\nstatus: nonsense\n---\n```\n'

def write(folder, files):
    for rel, text in files.items():
        (folder / rel).parent.mkdir(parents=True, exist_ok=True)
        (folder / rel).write_text(text, encoding='utf-8', newline='\n')
    return folder


def run(*args):
    result = subprocess.run([sys.executable, str(SCRIPT), *map(str, args)], capture_output=True, text=True, encoding='utf-8')
    return result.returncode, result.stdout, result.stderr


VALID = {
    'README.md': '---\nid: P-0001\nkind: reference\n---\n\n# Proposal tracking\n',
    'old-idea.md': proposal('P-0002', 'pending', '2026-10-01', title='Old idea'),
    'fresh-idea.md': proposal('P-0003', 'pending', '2026-10-10', revision=2, title='Fresh idea'),
    'week-old.md': proposal('P-0004', 'pending', '2026-10-07'),  # exactly 7 days: not yet "older than 7"
    'older-idea.md': proposal('P-0005', 'pending', '2026-09-30'),
    'oldest-idea.md': proposal('P-0006', 'pending', '2026-09-29'),
}
# Every count in the summary differs (1 trial, 2 approved, 3 stale, 4 deferred, 5 pending, 6 applied,
# 7 rejected), so a mixed-up slot fails the exact line.
_next = 7
for _status, _count in [('trial', 1), ('approved', 2), ('deferred', 4), ('applied', 6), ('rejected', 7)]:
    for _n in range(_count):
        _folder = 'rejected/' if _status == 'rejected' else ''
        _pid = 'P-0030' if (_status, _n) == ('rejected', _count - 1) else f'P-{_next:04d}'  # a gap: next_id is max + 1
        VALID[f'{_folder}{_status}-{_n + 1}.md'] = proposal(_pid, _status, '2026-09-20')
        _next += 1
# One bad file each, beside a valid one: the whole run is refused and the message names the file and the fault.
BROKEN = {
    'missing-id': ({'no-id.md': proposal(None, 'pending', '2026-10-01')}, "no-id.md: id None is missing or not P-NNNN"),
    'invalid-status': ({'odd.md': proposal('P-0002', 'open', '2026-10-01')}, "odd.md: status 'open' is not one of"),
    'missing-status': ({'bare.md': proposal('P-0002', None, '2026-10-01')}, "bare.md: status None is not one of"),
    'duplicate-id': ({'twin.md': proposal('P-0001', 'pending', '2026-10-01')}, 'twin.md: id P-0001 is already used by'),
    'rejected-in-place': ({'nope.md': proposal('P-0002', 'rejected', '2026-10-01')}, 'nope.md: a rejected proposal lives in rejected/'),
    'pending-in-rejected': ({'rejected/back.md': proposal('P-0002', 'pending', '2026-10-01')},
                            'rejected/back.md: a rejected proposal lives in rejected/, and only a rejected one does'),
    'reference-with-status': ({'ref.md': '---\nid: P-0002\nkind: reference\nstatus: pending\n---\n\n# Notes\n'},
                              "ref.md: a reference carries no status (found 'pending')"),
    'unknown-kind': ({'idea.md': proposal('P-0002', 'pending', '2026-10-01', kind='idea')},
                     "idea.md: kind 'idea' is neither proposal nor reference"),
    'invalid-revision': ({'rev.md': proposal('P-0002', 'pending', '2026-10-01', revision='two')},
                         "rev.md: revision 'two' is not a whole number"),
    'missing-created': ({'undated.md': proposal('P-0002', 'pending', None)}, "undated.md: created None is not a YYYY-MM-DD date"),
    'invalid-created': ({'bad-date.md': proposal('P-0002', 'pending', '2026-13-01')},
                        "bad-date.md: created '2026-13-01' is not a YYYY-MM-DD date"),
    'future-created': ({'ahead.md': proposal('P-0002', 'pending', '2026-10-15')}, 'ahead.md: created 2026-10-15 is after today (2026-10-14)'),
    'no-block': ({'loose.md': '# Loose notes\n\nkind: proposal\n'}, 'loose.md: no opening metadata block'),
}


def run_proposals(out):
    """The passed check names; an AssertionError names the first failure."""
    base, checks = out / 'proposals', []
    base.mkdir(exist_ok=False)
    valid = write(base / 'valid', VALID)
    code, stdout, stderr = run('--proposals', valid, '--today', '2026-10-14')
    assert code == 0, stderr
    assert stdout.strip() == ('25 proposals: 5 pending (3 older than 7 days), 1 trial, 2 approved-not-applied, '
                              '4 deferred, 6 applied, 7 rejected'), stdout
    checks.append('summary line on a fixture folder')

    snap = base / 'valid-snapshot'
    code, stdout, stderr = run('--proposals', valid, '--today', '2026-10-14', '--json', '--output', snap)
    assert code == 0, stderr
    data = json.loads((snap / 'snapshot.json').read_text(encoding='utf-8'))
    by_id = {i['id']: i for i in data['items']}
    assert sorted(by_id) == [f'P-{n:04d}' for n in [*range(1, 26), 30]], sorted(by_id)
    assert by_id['P-0003'] == {'id': 'P-0003', 'kind': 'proposal', 'title': 'Fresh idea', 'status': 'pending', 'revision': 2,
                               'created': '2026-10-10', 'age_days': 4, 'path': 'fresh-idea.md'}, by_id['P-0003']
    assert by_id['P-0030']['path'] == 'rejected/rejected-7.md' and by_id['P-0001']['status'] is None
    assert data['next_id'] == 'P-0031' and data['summary'] == stdout.splitlines()[0], data
    checks.append('JSON snapshot: id, title, status, revision, age, path')

    before = (snap / 'snapshot.json').read_bytes()
    code, stdout, stderr = run('--proposals', valid, '--json', '--output', snap)
    assert code == 2 and 'already exists' in stderr and not stdout, (code, stdout, stderr)
    assert (snap / 'snapshot.json').read_bytes() == before
    checks.append('snapshot refuses an existing folder')

    for case, (files, message) in BROKEN.items():
        folder = write(base / case, {'good.md': proposal('P-0001', 'pending', '2026-10-01'), **files})
        target = base / (case + '-snapshot')
        code, stdout, stderr = run('--proposals', folder, '--today', '2026-10-14', '--json', '--output', target)
        assert code == 2 and message in stderr and not stdout and not target.exists(), (case, code, stdout, stderr)
        checks.append('refuses ' + case)

    code, stdout, stderr = run()
    assert code == 0, stderr
    # Counted independently of the script: 'kind: proposal' inside the opening block, not in a later example.
    def opening(path):
        lines = path.read_text(encoding='utf-8').splitlines()[1:]
        return lines[:lines.index('---')]
    blocks = [opening(p) for p in (ROOT / 'docs/proposals').rglob('*.md')]
    statuses = [next(l[len('status: '):] for l in b if l.startswith('status: ')) for b in blocks if 'kind: proposal' in b]
    stale = sum(1 for b in blocks if 'status: pending' in b and (date.today() - date.fromisoformat(
        next(l[len('created: '):] for l in b if l.startswith('created: ')))).days > 7)
    assert len(statuses) >= 10, statuses
    n = {s: statuses.count(s) for s in ('pending', 'trial', 'approved', 'deferred', 'applied', 'rejected')}
    assert stdout.strip() == (f'{len(statuses)} proposals: {n["pending"]} pending ({stale} older than 7 days), {n["trial"]} trial, '
                              f'{n["approved"]} approved-not-applied, {n["deferred"]} deferred, {n["applied"]} applied, '
                              f'{n["rejected"]} rejected'), stdout
    (base / 'docs-proposals.txt').write_text(stdout, encoding='utf-8')
    checks.append('docs/proposals/ is valid')
    return checks
