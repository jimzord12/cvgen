"""Portrait tool: prepare a candidate's photograph for any template, or find the face in one.

    python scripts/portrait.py prepare <photo> [--fill '#1b2a4a'] [--keep-background] [--output <png>]
    python scripts/portrait.py detect <image>

`prepare` crops a square around the one face (its centre at 50% across and 45% down, the face box about 45%
of the side), removes the background (transparent; --fill paints it one colour; --keep-background leaves
the photograph's own) and writes <photo>-prepared.png and <photo>-prepared.json (face box, crop, models,
versions) next to the photograph, which it never changes. It refuses a photograph with no face or several,
and one too small for a 600 px square. `detect` prints the faces it finds, as shares of the image too.
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


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest='command', required=True)
    p = sub.add_parser('prepare', help='crop around the face, remove the background, optionally fill it')
    p.add_argument('photo', type=Path)
    p.add_argument('--output', type=Path, help='the prepared PNG (default: <photo>-prepared.png beside the photo)')
    p.add_argument('--fill', help="paint the removed background one colour, such as '#1b2a4a' (default: transparent)")
    p.add_argument('--keep-background', action='store_true', help='crop only; keep the photograph\'s own background')
    p.add_argument('--model', default=portrait.MODEL, help=f'rembg model (default: {portrait.MODEL})')
    p.add_argument('--min-size', type=int, default=portrait.MIN_SIDE, help=f'smallest square accepted, in pixels (default: {portrait.MIN_SIDE})')
    p.add_argument('--replace', action='store_true', help='write over an earlier prepared PNG and sidecar (never the photo)')
    d = sub.add_parser('detect', help='print the faces found in an image')
    d.add_argument('image', type=Path)
    args = parser.parse_args(argv)
    try:
        if args.command == 'prepare':
            record = portrait.prepare_portrait(args.photo, args.output, remove=not args.keep_background, fill=args.fill,
                                               model=args.model, min_side=args.min_size, replace=args.replace)
            out = record['output']
            print(f"wrote {record['paths']['portrait']} ({out['size'][0]} px square, background {out['background']})")
            print(f"face centre at {out['face_centre']} of the square (target {portrait.FACE_X}, {portrait.FACE_Y}); "
                  f"face {record['crop']['face_share']:.0%} of the side" +
                  (f"; the square was limited by the photo's {record['crop']['limited_by']} edge" if record['crop']['limited_by'] else ''))
            print(f"evidence: {record['paths']['sidecar']}")
        else:
            image = portrait.load_photo(args.image, keep_alpha=True)
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
