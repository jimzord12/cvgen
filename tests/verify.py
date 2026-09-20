"""Development-only PDF regression checks. Output directories must be new."""
import argparse
import hashlib
import json
from pathlib import Path

import pymupdf as fitz
from PIL import Image, ImageChops

ROOT = Path(__file__).resolve().parents[1]
# The engine package and the Flagship template inside it (ADR 0010 layout).
ENGINE = Path('packages/cv-engine')
FONTS = ENGINE / 'fonts'
FLAGSHIP = ENGINE / 'domains/marine/templates/flagship'


def check_frozen():
    manifest = json.loads((ROOT / 'tests/baseline.json').read_text())
    for path, digest in manifest['sha256'].items():
        actual = hashlib.sha256((ROOT / path).read_bytes()).hexdigest()
        assert actual == digest, f'Frozen file changed: {path}'


def verify(actual, reference=None, pages=2, output=None):
    if output:
        output = Path(output)
        output.mkdir(parents=True, exist_ok=False)
    check_frozen()
    errors = []
    report = {'actual': str(actual), 'pages': 0, 'page_checks': []}
    with fitz.open(actual) as doc:
        report['pages'] = len(doc)
        if len(doc) != pages:
            errors.append(f'Expected {pages} pages, got {len(doc)}')
        ref = fitz.open(reference) if reference else None
        if ref is not None and len(ref) != len(doc):
            errors.append('Reference page count differs')
        for i, page in enumerate(doc):
            detail = {'page': i + 1}
            if not page.get_text().strip():
                errors.append(f'Empty page {i + 1}')
            for x0, y0, x1, y1, *word in page.get_text('words'):
                if x0 < 0 or y0 < 0 or x1 > page.rect.width or y1 > page.rect.height:
                    errors.append(f'Text out of page bounds: {word}')
            if not all(doc.extract_font(f[0])[3] for f in page.get_fonts()):
                errors.append(f'Unembedded font on page {i + 1}')
            if ref is not None and i < len(ref):
                a = page.get_pixmap(matrix=fitz.Matrix(2, 2), alpha=False)
                b = ref[i].get_pixmap(matrix=fitz.Matrix(2, 2), alpha=False)
                detail['raster_equal'] = (a.width, a.height, a.samples) == (b.width, b.height, b.samples)
                detail['text_equal'] = ' '.join(page.get_text().split()) == ' '.join(ref[i].get_text().split())
                if not detail['raster_equal']:
                    errors.append(f'Raster mismatch on page {i + 1}')
                    if output and (a.width, a.height) == (b.width, b.height):
                        ia = Image.frombytes('RGB', (a.width, a.height), a.samples)
                        ib = Image.frombytes('RGB', (b.width, b.height), b.samples)
                        ImageChops.difference(ia, ib).save(output / f'diff-{i+1}.png')
                if not detail['text_equal']:
                    errors.append(f'Text mismatch on page {i + 1}')
            report['page_checks'].append(detail)
        if ref is not None:
            ref.close()
    report['errors'] = errors
    report['passed'] = not errors
    if output:
        (output / 'result.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--actual', required=True)
    parser.add_argument('--reference')
    parser.add_argument('--mode', choices=['exact', 'sanity'], default='exact')
    parser.add_argument('--pages', type=int, default=2)
    parser.add_argument('--output', required=True)
    args = parser.parse_args()
    if args.mode == 'exact' and not args.reference:
        parser.error('--reference is required for exact mode')
    result = verify(args.actual, args.reference if args.mode == 'exact' else None, args.pages, args.output)
    print(json.dumps(result, ensure_ascii=False))
    raise SystemExit(0 if result['passed'] else 1)
