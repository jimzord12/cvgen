"""Proposal snapshot: read docs/proposals/ and print the one-line session summary.

    python scripts/proposals.py            # the one line a new session tells the owner
    python scripts/proposals.py --json     # also write the snapshot into a new builds/proposals-<timestamp>/

The status in each file's opening metadata block is the single truth
(docs/proposals/README.md); the snapshot is a derived, regenerable view and
never a second queue. A file with a missing or invalid id, kind or status is
refused by name and nothing is written (exit 2). Standard library only.
"""
import argparse
from datetime import date, datetime
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
STATES = ('pending', 'trial', 'approved', 'applied', 'rejected', 'deferred')
ID = re.compile(r'P-\d{4}')
STALE_DAYS = 7  # a pending proposal older than this is called out in the summary


def metadata(path):
    """The key: value pairs of the opening --- block only (examples later in the file never count), and the title."""
    lines = path.read_text(encoding='utf-8').splitlines()
    if not lines or lines[0].strip() != '---' or '---' not in (line.strip() for line in lines[1:]):
        raise ValueError('no opening metadata block (--- ... ---) on the first line')
    end = next(i for i, line in enumerate(lines[1:], 1) if line.strip() == '---')
    meta = {}
    for line in lines[1:end]:
        key, sep, value = line.partition(':')
        if sep and key.strip():
            meta[key.strip()] = value.strip()
    title = next((line[2:].strip() for line in lines[end + 1:] if line.startswith('# ')), None)
    return meta, title


def read(folder, today):
    """Every Markdown file under folder as a snapshot item, or (items, problems) with every problem named."""
    items, problems, seen = [], [], {}
    for path in sorted(folder.rglob('*.md')):
        rel = path.relative_to(folder).as_posix()
        try:
            meta, title = metadata(path)
        except (ValueError, UnicodeDecodeError) as error:
            problems.append(f'{rel}: {error}')
            continue
        kind, pid, status = meta.get('kind'), meta.get('id'), meta.get('status')
        wrong = []
        if not pid or not ID.fullmatch(pid):
            wrong.append(f'id {pid!r} is missing or not P-NNNN')
        elif pid in seen:
            wrong.append(f'id {pid} is already used by {seen[pid]}')
        else:
            seen[pid] = rel
        if kind not in ('proposal', 'reference'):
            wrong.append(f'kind {kind!r} is neither proposal nor reference')
        item = {'id': pid, 'kind': kind, 'title': title, 'status': None, 'revision': None, 'created': None,
                'age_days': None, 'path': rel}
        if kind == 'reference' and status:
            wrong.append(f'a reference carries no status (found {status!r})')
        if kind == 'proposal':
            if status not in STATES:
                wrong.append(f'status {status!r} is not one of {", ".join(STATES)}')
            elif (status == 'rejected') != rel.startswith('rejected/'):
                wrong.append('a rejected proposal lives in rejected/, and only a rejected one does')
            if not (meta.get('revision') or '').isdigit():
                wrong.append(f'revision {meta.get("revision")!r} is not a whole number')
            try:
                created = date.fromisoformat(meta.get('created') or '')
            except ValueError:
                wrong.append(f'created {meta.get("created")!r} is not a YYYY-MM-DD date')
            else:
                if created > today:
                    wrong.append(f'created {created} is after today ({today})')
                item.update(created=created.isoformat(), age_days=(today - created).days)
            item.update(status=status, revision=int(meta['revision']) if (meta.get('revision') or '').isdigit() else None)
        if wrong:
            problems.append(f'{rel}: ' + '; '.join(wrong))
        else:
            items.append(item)
    return sorted(items, key=lambda i: i['id']), problems


def summary(items):
    """'N proposals: X pending (Y older than 7 days), Z approved-not-applied, ...' with every state, zeros included."""
    proposals = [i for i in items if i['kind'] == 'proposal']
    count = {s: sum(1 for i in proposals if i['status'] == s) for s in STATES}
    stale = sum(1 for i in proposals if i['status'] == 'pending' and i['age_days'] > STALE_DAYS)
    return (f'{len(proposals)} proposals: {count["pending"]} pending ({stale} older than {STALE_DAYS} days), '
            f'{count["trial"]} trial, {count["approved"]} approved-not-applied, {count["deferred"]} deferred, '
            f'{count["applied"]} applied, {count["rejected"]} rejected')


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--proposals', type=Path, default=ROOT / 'docs' / 'proposals', help='folder to read')
    parser.add_argument('--json', action='store_true', help='also write snapshot.json into a new folder')
    parser.add_argument('--output', type=Path, help='that new folder (default builds/proposals-<timestamp>/); refused if it exists')
    parser.add_argument('--today', type=date.fromisoformat, default=date.today(), help='YYYY-MM-DD the ages count to')
    args = parser.parse_args(argv)
    if not args.proposals.is_dir():
        print(f'REFUSED: {args.proposals} is not a folder', file=sys.stderr)
        return 2
    items, problems = read(args.proposals, args.today)
    if problems:
        for problem in problems:
            print(f'REFUSED: {problem}', file=sys.stderr)
        print(f'REFUSED: {len(problems)} file(s) in {args.proposals} need a valid opening metadata block '
              '(docs/proposals/README.md); nothing written', file=sys.stderr)
        return 2
    line = summary(items)
    if args.json:
        out = args.output or ROOT / 'builds' / ('proposals-' + datetime.now().strftime('%Y%m%d-%H%M%S-%f'))
        try:
            out.mkdir(parents=True, exist_ok=False)  # constitution section 2: a new folder, never an overwrite
        except FileExistsError:
            print(f'REFUSED: {out} already exists; every output goes to a new folder', file=sys.stderr)
            return 2
    print(line)
    if args.json:
        used = [int(i['id'][2:]) for i in items]
        snapshot = {'today': args.today.isoformat(), 'folder': str(args.proposals.resolve()), 'summary': line,
                    'next_id': f'P-{max(used, default=0) + 1:04d}', 'items': items}
        (out / 'snapshot.json').write_text(json.dumps(snapshot, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
        print(f'Snapshot: {out / "snapshot.json"}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
