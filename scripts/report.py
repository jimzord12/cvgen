"""Build a final report for the owner from a JSON file, into a new folder.

    python scripts/report.py <data.json> [--fragment] [--output <folder>]

Writes <folder>/report.html (default builds/report-<timestamp>/), one page
holding its pictures, fonts and logo. `--fragment` leaves out the document
skeleton, for a page hosted on claude.ai. The fields:
studio/brand/report/README.md.
"""
import argparse
import base64
from datetime import datetime
from html import escape
import json
from pathlib import Path
import sys

import pymupdf

ROOT = Path(__file__).resolve().parents[1]
REPORT = ROOT / 'studio/brand/report'
FONTS = ROOT / 'packages/cv-framework/fonts'
LOGOS = ROOT / 'studio/brand/logos'
PAGE_WIDTH = 760
REQUIRED = ('title', 'date', 'verdict', 'headline')
VERDICTS = ('done', 'needs-you', 'running', 'blocked')
FACES = (('Bona Nova', '700', 'BonaNova-Bold.ttf'),
         ('Sofia Sans Extra Condensed', '100 900', 'SofiaSansExtraCondensed[wght].ttf'),
         ('Source Sans 3', '200 900', 'SourceSans3[wght].ttf'))
ROUNDS = ('findings', 'pass', 'running')
# Each section: the keys every item needs, and the values a key may take.
SECTIONS = (('meters', ('label', 'value'), {'tone': ('ok', 'wait', 'stop', 'thread')}),
            ('stages', ('label', 'state'), {'state': ('done', 'active', 'waiting', 'blocked')}),
            ('needs_you', ('title', 'options', 'context', 'decision'), {}),
            ('evidence', ('kind', 'caption'), {'kind': ('page', 'compare')}),
            ('reviews', ('name', 'cap', 'rounds'), {}),
            ('decisions', ('grade', 'title', 'why'), {'grade': ('Minor', 'Major')}),
            ('changes', ('area', 'lines'), {}))
MEDIA = {'.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.svg': 'image/svg+xml', '.webp': 'image/webp'}


def data_uri(media, data):
    return f'data:{media};base64,{base64.b64encode(data).decode()}'


def picture(source, root):
    """A data URI for a PDF page ({"pdf": path, "page": n, counted from 1}) or an image path, from the repository root."""
    if isinstance(source, dict):
        with pymupdf.open(root / source['pdf']) as pdf:
            page = pdf[source.get('page', 1) - 1]
            scale = PAGE_WIDTH / page.rect.width
            return data_uri('image/jpeg', page.get_pixmap(matrix=pymupdf.Matrix(scale, scale)).tobytes('jpeg', jpg_quality=82))
    path = root / source
    return data_uri(MEDIA[path.suffix.lower()], path.read_bytes())


def font_faces():
    return '\n'.join(f'@font-face{{font-family:"{family}";font-weight:{weight};font-display:swap;'
                     f'src:url({data_uri("font/ttf", (FONTS / name).read_bytes())}) format("truetype")}}'
                     for family, weight, name in FACES)


def refusal(data):
    """What is wrong with the report's data, or None. A section that passes here renders; the page has no error state."""
    missing = [field for field in REQUIRED if not data.get(field)]
    if missing:
        return f'the report needs {", ".join(missing)}: add them to the JSON file'
    if data['verdict'] not in VERDICTS:
        return f'verdict {data["verdict"]!r} is not one of {", ".join(VERDICTS)}'
    for field, keys, allowed in SECTIONS:
        for item in data.get(field, []):
            for key in keys:
                if key not in item:
                    return f'{field}: {item} needs {key}'
            for key, values in allowed.items():
                if key in item and item[key] not in values:
                    return f'{field}: {key} {item[key]!r} is not one of {", ".join(values)}'
    for gate in data.get('reviews', []):
        for review in gate['rounds']:
            if review.get('verdict') not in ROUNDS:
                return f'reviews: {gate["name"]} has a round whose verdict is not one of {", ".join(ROUNDS)}'
    for card in data.get('needs_you', []):
        options = card['options']
        if not 2 <= len(options) <= 4:
            return f'{card["title"]!r} needs two to four options'
        if any('label' not in option for option in options):
            return f'{card["title"]!r} has an option without a label'
        if sum(bool(option.get('recommended')) for option in options) != 1:
            return f'{card["title"]!r} needs exactly one recommended option'
    return None


def build(data, fragment, root=ROOT):
    for item in data.get('evidence', []):
        for key in ('src', 'before', 'after'):
            if key in item:
                item[key] = picture(item[key], root)
    # Inside a <script> block a raw "<" could close it; the JSON escape reads back as the same text.
    embedded = json.dumps(data, ensure_ascii=False).replace('<', '\\u003c')
    logo = lambda name: data_uri('image/svg+xml', (LOGOS / name).read_bytes())  # noqa: E731
    page = (REPORT / 'report.html').read_text(encoding='utf-8')
    for key, value in (('{{FONTS}}', font_faces()), ('{{TITLE}}', escape(data['title'])),
                       ('{{MARK_REVERSED}}', logo('cvgen-mark-c-eye-reversed.svg')),
                       ('{{MARK_INK}}', logo('cvgen-mark-c-eye.svg')), ('{{DATA}}', embedded)):
        page = page.replace(key, value)
    return page if fragment else '<!doctype html>\n<html lang="en">\n<meta name="viewport" content="width=device-width,initial-scale=1">\n' + page


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('data', type=Path)
    parser.add_argument('--fragment', action='store_true')
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    data = json.loads(args.data.read_text(encoding='utf-8'))
    problem = refusal(data)
    if problem:
        sys.exit(f'report: {problem}')
    page = build(data, args.fragment)
    folder = args.output or ROOT / 'builds' / f'report-{datetime.now():%Y%m%d-%H%M%S-%f}'
    folder.mkdir(parents=True, exist_ok=False)
    out = folder / 'report.html'
    out.write_text(page, encoding='utf-8', newline='\n')
    print(out)


if __name__ == '__main__':
    main()
