"""Local candidate CV workflow: render, approve, export and status for one workspace.

    python scripts/cv.py render  private/<candidate> [--pages 2] [--input key=value] [--typst path]
    python scripts/cv.py approve private/<candidate> <revision> --approver "<name>" --sha256 <reviewed hash>
    python scripts/cv.py export  private/<candidate> <revision>
    python scripts/cv.py status  private/<candidate>

Exit codes: 0 done, 1 the render or its checks failed (the revision is kept),
2 the operation was refused or the arguments were wrong (the message says why).
"""
import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'packages/cv-workflow'))

from cv_workflow import WorkflowError, approve_revision, export_revision, render_revision, workspace_status  # noqa: E402


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    commands = parser.add_subparsers(dest='command', required=True)

    render = commands.add_parser('render', help='snapshot the inputs into a new revision, compile and check it')
    render.add_argument('workspace')
    render.add_argument('--pages', type=int, default=2, help='expected page count for the checks (default 2)')
    render.add_argument('--input', action='append', default=[], metavar='KEY=VALUE', help='passed to typst --input')
    render.add_argument('--typst', default='typst')

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
            result = render_revision(args.workspace, typst=args.typst, pages=args.pages, inputs=inputs)
            code = 0 if result['status'] == 'success' and result['checks_passed'] else 1
        elif args.command == 'approve':
            result = approve_revision(args.workspace, args.revision, args.approver, args.sha256, test_only=args.test_only)
            code = 0
        elif args.command == 'export':
            result = export_revision(args.workspace, args.revision)
            code = 0
        else:
            result = workspace_status(args.workspace)
            code = 0
    except WorkflowError as error:
        print(f'REFUSED: {error}', file=sys.stderr)
        return 2
    print(json.dumps(result, indent=2))
    return code


if __name__ == '__main__':
    sys.exit(main())
