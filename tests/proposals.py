"""scripts/proposals.py through its real command line: fixture folders written under the run's evidence folder
(valid ones and each kind of refusal), then the real docs/proposals/. Run by tests/run.py."""
import json
from pathlib import Path
import re
import subprocess
import sys

from verify import ROOT

SCRIPT = ROOT / 'scripts' / 'proposals.py'


def proposal(pid, status, created, revision=1, title='A proposal', kind='proposal'):
    block = [f'id: {pid}' if pid else None, f'kind: {kind}', f'status: {status}' if status else None,
             f'revision: {revision}', f'created: {created}']
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
    'agreed.md': proposal('P-0005', 'approved', '2026-09-20'),
    'trying.md': proposal('P-0006', 'trial', '2026-09-21'),
    'later.md': proposal('P-0007', 'deferred', '2026-09-22'),
    'done.md': proposal('P-0008', 'applied', '2026-09-23'),
    'rejected/declined.md': proposal('P-0010', 'rejected', '2026-09-24'),
}
# One bad file each, beside a valid one: the whole run is refused and the message names the file and the fault.
BROKEN = {
    'missing-id': ({'no-id.md': proposal(None, 'pending', '2026-10-01')}, "no-id.md: id None is missing or not P-NNNN"),
    'invalid-status': ({'odd.md': proposal('P-0002', 'open', '2026-10-01')}, "odd.md: status 'open' is not one of"),
    'missing-status': ({'bare.md': proposal('P-0002', None, '2026-10-01')}, "bare.md: status None is not one of"),
    'duplicate-id': ({'twin.md': proposal('P-0001', 'pending', '2026-10-01')}, 'twin.md: id P-0001 is already used by'),
    'rejected-in-place': ({'nope.md': proposal('P-0002', 'rejected', '2026-10-01')}, 'nope.md: a rejected proposal lives in rejected/'),
    'no-block': ({'loose.md': '# Loose notes\n\nkind: proposal\n'}, 'loose.md: no opening metadata block'),
}


def run_proposals(out):
    """The passed check names; an AssertionError names the first failure."""
    base, checks = out / 'proposals', []
    base.mkdir(exist_ok=False)
    valid = write(base / 'valid', VALID)
    code, stdout, stderr = run('--proposals', valid, '--today', '2026-10-14')
    assert code == 0, stderr
    assert stdout.strip() == ('8 proposals: 3 pending (1 older than 7 days), 1 trial, 1 approved-not-applied, '
                              '1 deferred, 1 applied, 1 rejected'), stdout
    checks.append('summary line on a fixture folder')

    snap = base / 'valid-snapshot'
    code, stdout, stderr = run('--proposals', valid, '--today', '2026-10-14', '--json', '--output', snap)
    assert code == 0, stderr
    data = json.loads((snap / 'snapshot.json').read_text(encoding='utf-8'))
    by_id = {i['id']: i for i in data['items']}
    assert sorted(by_id) == [f'P-{n:04d}' for n in (1, 2, 3, 4, 5, 6, 7, 8, 10)], sorted(by_id)
    assert by_id['P-0003'] == {'id': 'P-0003', 'kind': 'proposal', 'title': 'Fresh idea', 'status': 'pending', 'revision': 2,
                               'created': '2026-10-10', 'age_days': 4, 'path': 'fresh-idea.md'}, by_id['P-0003']
    assert by_id['P-0010']['path'] == 'rejected/declined.md' and by_id['P-0001']['status'] is None
    assert data['next_id'] == 'P-0011' and data['summary'] == stdout.splitlines()[0], data
    checks.append('JSON snapshot: id, title, status, revision, age, path')

    before = (snap / 'snapshot.json').read_bytes()
    code, stdout, stderr = run('--proposals', valid, '--json', '--output', snap)
    assert code == 2 and 'already exists' in stderr and not stdout, (code, stdout, stderr)
    assert (snap / 'snapshot.json').read_bytes() == before
    checks.append('snapshot refuses an existing folder')

    for case, (files, message) in BROKEN.items():
        folder = write(base / case, {'good.md': proposal('P-0001', 'pending', '2026-10-01'), **files})
        target = base / (case + '-snapshot')
        code, stdout, stderr = run('--proposals', folder, '--json', '--output', target)
        assert code == 2 and message in stderr and not stdout and not target.exists(), (case, code, stdout, stderr)
        checks.append('refuses ' + case)

    code, stdout, stderr = run()
    assert code == 0, stderr
    # Counted independently of the script: 'kind: proposal' inside the opening block, not in a later example.
    def opening(path):
        lines = path.read_text(encoding='utf-8').splitlines()[1:]
        return lines[:lines.index('---')]
    proposals = sum('kind: proposal' in opening(p) for p in (ROOT / 'docs/proposals').rglob('*.md'))
    assert proposals >= 10, proposals
    assert re.fullmatch(rf'{proposals} proposals: \d+ pending \(\d+ older than 7 days\), \d+ trial, '
                        r'\d+ approved-not-applied, \d+ deferred, \d+ applied, \d+ rejected', stdout.strip()), stdout
    (base / 'docs-proposals.txt').write_text(stdout, encoding='utf-8')
    checks.append('docs/proposals/ is valid')
    return checks
