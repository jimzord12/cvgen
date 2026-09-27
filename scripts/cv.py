"""Local candidate CV workflow: render, approve, export and status for one workspace.

    python scripts/cv.py render  private/<candidate> [--pages 2] [--input key=value] [--typst path] [--reference-date YYYY-MM-DD]
    python scripts/cv.py approve private/<candidate> <revision> --approver "<name>" --sha256 <reviewed hash>
    python scripts/cv.py export  private/<candidate> <revision>
    python scripts/cv.py status  private/<candidate>

Exit codes: 0 done, 1 the render or its checks failed (the revision is kept),
2 the operation was refused or the arguments were wrong (the message says why).
Certificate expiry warnings (expired, or within 180 days) print as WARNING lines
on stderr for render and status, render adds a NOTE line when some certificate
dates could not be checked; neither changes the exit code.
"""
import argparse
from datetime import date
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'packages/cv-workflow'))

from cv_workflow import WorkflowError, approve_revision, export_revision, render_revision, workspace_status  # noqa: E402


def warn(warnings, revision=None):
    """Certificate warnings, loud on stderr; they never change the exit code (owner, 2026-09-25)."""
    for text in warnings:
        print(f'WARNING{f" [{revision}]" if revision else ""}: {text}', file=sys.stderr)


def unchecked(counts):
    """Say how many certificate dates were not checked, so silence is never read as a pass."""
    if counts and counts.get('not_date_checked'):
        print(f'NOTE: {counts["not_date_checked"]} certificate date(s) not checked (free text or not written like '
              f'14 Jul 2029); {counts["date_checked"]} checked against {counts["reference_date"]}', file=sys.stderr)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    commands = parser.add_subparsers(dest='command', required=True)

    render = commands.add_parser('render', help='snapshot the inputs into a new revision, compile and check it')
    render.add_argument('workspace')
    render.add_argument('--pages', type=int, default=2, help='expected page count for the checks (default 2)')
    render.add_argument('--input', action='append', default=[], metavar='KEY=VALUE', help='passed to typst --input')
    render.add_argument('--typst', default='typst')
    render.add_argument('--reference-date', type=date.fromisoformat, default=None, metavar='YYYY-MM-DD',
                        help='measure certificate expiry against this day instead of today (tests, re-checks)')

    approve = commands.add_parser('approve', help='record the explicit approval of a reviewed revision')
    approve.add_argument('workspace')
    approve.add_argument('revision')
    approve.add_argument('--approver', required=True, help='who approved, for the receipt')
    approve.add_argument('--sha256', required=True, help='the hash shown for the PDF you reviewed (12+ characters)')
    approve.add_argument('--test-only', action='store_true', help='fictional fixtures only; refused under private/')

    export = commands.add_parser('export', help='verify and copy an approved revision into exports/<revision>/')
    export.add_argument('workspace')
    export.add_argument('revision')

    status = commands.add_parser('status', help='list revisions and their state')
    status.add_argument('workspace')

    args = parser.parse_args(argv)
    try:
        if args.command == 'render':
            inputs = {}
            for item in args.input:
                if '=' not in item:
                    parser.error(f'--input expects KEY=VALUE, got {item!r}')
                key, value = item.split('=', 1)
                inputs[key] = value
            result = render_revision(args.workspace, typst=args.typst, pages=args.pages, inputs=inputs,
                                     reference_date=args.reference_date)
            code = 0 if result['status'] == 'success' and result['checks_passed'] else 1
            warn(result['warnings'])
            unchecked(result['certificate_dates'])
        elif args.command == 'approve':
            result = approve_revision(args.workspace, args.revision, args.approver, args.sha256, test_only=args.test_only)
            code = 0
        elif args.command == 'export':
            result = export_revision(args.workspace, args.revision)
            code = 0
        else:
            result = workspace_status(args.workspace)
            code = 0
            for item in result['revisions']:
                warn(item['warnings'], item['revision'])
    except WorkflowError as error:
        print(f'REFUSED: {error}', file=sys.stderr)
        return 2
    print(json.dumps(result, indent=2))
    return code


if __name__ == '__main__':
    sys.exit(main())
