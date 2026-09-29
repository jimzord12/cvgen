"""Output Contract tool: stamp a PDF's Meta File, or check that every PDF has a valid one.

    python scripts/outputs.py stamp <pdf> status=proposed [key=value ...]
    python scripts/outputs.py check [--private]

`stamp` computes pages, SHA-256 and the date, fills what the PDF's place and
the client's envelope.json say, and validates. `check` lists every PDF in the
public trees (and, with --private, the client homes) that has no valid, current
Meta File or sits outside a home; it exits 1 when there is any.
See docs/proposals/output-contract.md.
"""
import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'packages/cv-workflow'))

from cv_workflow import WorkflowError  # noqa: E402
from cv_workflow.outputs import scan, stamp  # noqa: E402


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest='command', required=True)
    s = sub.add_parser('stamp')
    s.add_argument('pdf', type=Path)
    s.add_argument('fields', nargs='*', help='key=value (pages=2 and similar numbers are read as numbers)')
    c = sub.add_parser('check')
    c.add_argument('--private', action='store_true', help='also check the client homes under private/')
    args = parser.parse_args(argv)
    if args.command == 'stamp':
        fields = {}
        for pair in args.fields:
            key, sep, value = pair.partition('=')
            if not sep:
                parser.error(f'{pair!r} is not key=value')
            fields[key] = int(value) if value.isdigit() and key == 'pages' else value
        try:
            meta = stamp(args.pdf, fields)
        except WorkflowError as error:
            print(f'REFUSED: {error}', file=sys.stderr)
            return 2
        print(json.dumps(meta, indent=2, ensure_ascii=False))
        return 0
    indexed, problems = scan(ROOT, include_private=args.private)
    for pdf, reason in problems:
        print(f'FAIL {pdf.relative_to(ROOT).as_posix()}: {reason}')
    print(f'{len(indexed)} PDFs indexed, {len(problems)} problem(s)')
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(main())
