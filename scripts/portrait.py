"""Portrait tool: prepare a candidate's photograph for any template, or find the face in one.

    python scripts/portrait.py prepare <photo> [--fill '#1b2a4a'] [--keep-background] [--face-y 0.43] [--output <png>]
    python scripts/portrait.py detect <image>

`prepare` converts the photograph to sRGB, crops a square around the one face (its centre at 50% across
and 45% down, or --face-y between 0.40 and 0.50; the face box about 45% of the side), removes the
background (transparent; --fill paints it one colour; --keep-background leaves the photograph's own) and
writes <photo>-prepared.png and <photo>-prepared.json (colour, face box, crop, check, models, versions) next
to the photograph, which it never changes. It refuses a photograph with no face or several, a face too close
to an edge, and a photograph too small for a 600 px square. Exit 0: written and checked; 1: refused or a
usage error, nothing written; 3: written, but the face found again in the result is missing, doubled or off
target (look at it before rendering). --keep-background is for checking a crop only, never for a CV: the
owner's rule is no background.
`detect` prints the faces it finds, as shares of the image too.
See packages/cv-workflow/cv_workflow/portrait.py and docs/guides/client-workflow.md, section 1.
"""
import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'packages/cv-workflow'))

from cv_workflow import WorkflowError  # noqa: E402
from cv_workflow import portrait  # noqa: E402


class Parser(argparse.ArgumentParser):
    """argparse with usage errors on exit 1, "refused, nothing written", so exit 3 alone means "written, look"."""

    def error(self, message):
        self.print_usage(sys.stderr)
        self.exit(1, f'refused: {message}\n')


def main(argv=None):
    parser = Parser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest='command', required=True)
    p = sub.add_parser('prepare', help='crop around the face, remove the background, optionally fill it')
    p.add_argument('photo', type=Path)
    p.add_argument('--output', type=Path, help='the prepared PNG (default: <photo>-prepared.png beside the photo)')
    p.add_argument('--fill', help="paint the removed background one colour, such as '#1b2a4a' (default: transparent)")
    p.add_argument('--keep-background', action='store_true',
                   help='crop only, keeping the photograph\'s own background: for checking a crop, never for a CV '
                        '(the owner\'s rule is no background)')
    p.add_argument('--face-y', type=float, default=portrait.FACE_Y,
                   help=f'where the face centre sits, as a share of the side from the top, {portrait.FACE_Y_RANGE[0]} to '
                        f'{portrait.FACE_Y_RANGE[1]} (default: {portrait.FACE_Y})')
    p.add_argument('--model', default=portrait.MODEL, help=f'rembg model (default: {portrait.MODEL})')
    p.add_argument('--min-size', type=int, default=portrait.MIN_SIDE, help=f'smallest square accepted, in pixels (default: {portrait.MIN_SIDE})')
    p.add_argument('--replace', action='store_true', help='write over a PNG and sidecar this tool wrote earlier (never anything else)')
    d = sub.add_parser('detect', help='print the faces found in an image')
    d.add_argument('image', type=Path)
    args = parser.parse_args(argv)
    try:
        if args.command == 'prepare':
            record = portrait.prepare_portrait(args.photo, args.output, remove=not args.keep_background, fill=args.fill,
                                               model=args.model, min_side=args.min_size, face_y=args.face_y, replace=args.replace)
            out, target = record['output'], record['crop']['target']
            print(f"wrote {record['paths']['portrait']} ({out['size'][0]} px square, background {out['background']})")
            print(f"face centre at {out['face_centre']} of the square (target {target['x']}, {target['y']}); "
                  f"face {record['crop']['face_share']:.0%} of the side" +
                  (f"; the square was limited by the photo's {record['crop']['limited_by']} edge" if record['crop']['limited_by'] else ''))
            print(f"evidence: {record['paths']['sidecar']}")
            if not record['check']['passed']:
                print(f"CHECK FAILED: the result shows {out['faces_found']} face(s), centre {out['face_centre']}, not one face within "
                      f"{record['check']['tolerance']:.0%} of the target. Both files were written and kept: look at the portrait, "
                      'and use it only if it is right; otherwise use another photograph.', file=sys.stderr)
                return 3
        else:
            image, _ = portrait.load_photo(args.image, keep_alpha=True)
            faces = portrait.detect_faces(image)
            for face in faces:
                face['centre_share'] = [round(face['centre'][0] / image.width, 3), round(face['centre'][1] / image.height, 3)]
            print(json.dumps({'image': args.image.name, 'size': list(image.size), 'faces': faces}, indent=2))
    except WorkflowError as error:
        print(f'refused: {error}', file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
