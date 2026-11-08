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
import re
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
MAX_ROUNDS = 10
# Each section: the keys every item needs, and the values a key may take.
SECTIONS = (('meters', ('label', 'value'), {'tone': ('ok', 'wait', 'stop', 'thread')}),
            ('stages', ('label', 'state'), {'state': ('done', 'active', 'waiting', 'blocked')}),
            ('needs_you', ('title', 'options', 'context', 'decision'), {}),
            ('evidence', ('id', 'kind', 'caption'), {'kind': ('page', 'compare')}),
            ('reviews', ('name', 'cap', 'rounds'), {}),
            ('decisions', ('grade', 'title', 'why'), {'grade': ('Minor', 'Major')}),
            ('changes', ('area', 'lines'), {}))
NOT_TEXT = ('value', 'options', 'cap', 'rounds', 'lines', 'id')
# A figure's id is its short name on the page ("Figure 1"): a number, because the owner finds numbers
# easier than letters (2026-11-08). Cards and decisions cite it in `figures`; 1 and "1" are the same.
FIGURE_ID = re.compile(r'[1-9][0-9]{0,2}')
CITERS = ('needs_you', 'decisions')
EVIDENCE = {'page': ('src',), 'compare': ('before', 'after', 'before_label', 'after_label')}
MEDIA = {'.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.svg': 'image/svg+xml', '.webp': 'image/webp'}


def data_uri(media, data):
    return f'data:{media};base64,{base64.b64encode(data).decode()}'


def picture(source, root):
    """A data URI for a PDF page ({"pdf": path, "page": n, counted from 1}) or an image path, from the repository root."""
    if isinstance(source, dict):
        with pymupdf.open(root / source['pdf']) as pdf:
            number = source.get('page', 1)
            if not 1 <= number <= pdf.page_count:
                raise ValueError(f'{source["pdf"]} has no page {number}')
            page = pdf[number - 1]
            scale = PAGE_WIDTH / page.rect.width
            return data_uri('image/jpeg', page.get_pixmap(matrix=pymupdf.Matrix(scale, scale)).tobytes('jpeg', jpg_quality=82))
    path = root / source
    if path.suffix.lower() not in MEDIA:
        raise ValueError(f'{source} is not an image: a PDF page is {{"pdf": path, "page": n}}')
    return data_uri(MEDIA[path.suffix.lower()], path.read_bytes())


def font_faces():
    return '\n'.join(f'@font-face{{font-family:"{family}";font-weight:{weight};font-display:swap;'
                     f'src:url({data_uri("font/ttf", (FONTS / name).read_bytes())}) format("truetype")}}'
                     for family, weight, name in FACES)


def is_count(value):
    return isinstance(value, int) and not isinstance(value, bool) and value >= 0


def is_text(value):
    return isinstance(value, str) and bool(value.strip())


def is_private(path):
    return 'private' in [part.casefold() for part in (ROOT / str(path)).resolve().parts]


def picture_paths(data):
    for item in data.get('evidence', []):
        for key in ('src', 'before', 'after'):
            if key in item:
                yield item[key].get('pdf', '') if isinstance(item[key], dict) else item[key]


def normalise(data):
    """Figure ids and citations as text: a bare JSON whole number reads as its digits (1 is "1"); anything
    else is left for `refusal` to judge. Changes `data` in place and returns it; running it twice is harmless."""
    number = lambda x: str(x) if isinstance(x, int) and not isinstance(x, bool) else x  # noqa: E731
    for item in data.get('evidence', []) if isinstance(data.get('evidence'), list) else []:
        if isinstance(item, dict) and 'id' in item:
            item['id'] = number(item['id'])
    for field in CITERS:
        for item in data.get(field, []) if isinstance(data.get(field), list) else []:
            if isinstance(item, dict) and isinstance(item.get('figures'), list):
                item['figures'] = [number(name) for name in item['figures']]
    return data


def refusal(data, fragment=False, source=''):
    """What is wrong with the report's data, or None. A section that passes here renders; the page has no error state."""
    if not isinstance(data, dict):
        return 'the JSON file must hold one object'
    missing = [field for field in REQUIRED if not is_text(data.get(field))]
    if missing:
        return f'the report needs {", ".join(missing)}: add them to the JSON file'
    if data['verdict'] not in VERDICTS:
        return f'verdict {data["verdict"]!r} is not one of {", ".join(VERDICTS)}'
    if data['verdict'] == 'done' and data.get('needs_you'):
        return 'a done report has nothing that needs the owner: use needs-you'
    for field in ('next_move', 'evidence_path'):
        if field in data and not is_text(data[field]):
            return f'{field} must be text'
    for field, keys, allowed in SECTIONS:
        items = data.get(field, [])
        if not isinstance(items, list) or not all(isinstance(item, dict) for item in items):
            return f'{field} must be a list of objects'
        for item in items:
            for key in keys:
                if item.get(key) in (None, '') or (key not in NOT_TEXT and not is_text(item[key])):
                    return f'{field}: an item needs {key}'
            for key, values in allowed.items():
                if key in item and item[key] not in values:
                    return f'{field}: {key} {item[key]!r} is not one of {", ".join(values)}'
    for meter in data.get('meters', []):
        whole = is_count(meter['value']) and ('of' not in meter or (is_count(meter['of']) and meter['value'] <= meter['of'] and meter['of']))
        if not whole:
            return f'meters: {meter["label"]} needs whole numbers, with value no higher than of'
    figures = []
    for item in data.get('evidence', []):
        for key in EVIDENCE[item['kind']]:
            if not item.get(key):
                return f'evidence: a {item["kind"]} needs {key}'
        if not isinstance(item['id'], str) or not FIGURE_ID.fullmatch(item['id']):
            return f'evidence: id {item["id"]!r} must be a number from 1 to 999, such as 1'
        if item['id'] in figures:
            return f'evidence: two figures share the id {item["id"]!r}'
        figures.append(item['id'])
    for field in CITERS:
        for item in data.get(field, []):
            cited = item.get('figures', [])
            if not isinstance(cited, list) or not cited and 'figures' in item:
                return f'{item["title"]!r} has figures that are not a list of figure ids: leave it out or name one'
            unknown = [str(name) for name in cited if name not in figures]
            if unknown:
                return f'{item["title"]!r} cites Figure {", ".join(unknown)}, which the evidence does not hold'
            twice = sorted({name for name in cited if cited.count(name) > 1})
            if twice:
                return f'{item["title"]!r} cites Figure {", ".join(twice)} twice'
    for gate in data.get('reviews', []):
        if not is_count(gate['cap']) or gate['cap'] > MAX_ROUNDS or not isinstance(gate['rounds'], list):
            return f'reviews: {gate["name"]} needs a whole number cap up to {MAX_ROUNDS} and a list of rounds'
        for review in gate['rounds']:
            if not isinstance(review, dict) or review.get('verdict') not in ROUNDS:
                return f'reviews: {gate["name"]} has a round whose verdict is not one of {", ".join(ROUNDS)}'
            if not all(is_count(review.get(key, 0)) for key in ('hard', 'soft')):
                return f'reviews: {gate["name"]} has a round whose hard or soft is not a whole number'
            if review['verdict'] == 'findings' and not review.get('hard', 0) + review.get('soft', 0):
                return f'reviews: {gate["name"]} has a findings round with no findings'
            if review['verdict'] == 'pass' and review.get('hard', 0):
                return f'reviews: {gate["name"]} has a passed round with blocking findings'
    for change in data.get('changes', []):
        if not is_count(change['lines']):
            return f'changes: {change["area"]} needs a whole number of lines'
    for card in data.get('needs_you', []):
        if 'example' in card and not is_text(card['example']):
            return f'{card["title"]!r} has an empty example: leave it out'
        options = card['options']
        if not isinstance(options, list) or not 2 <= len(options) <= 4:
            return f'{card["title"]!r} needs two to four options'
        if not all(isinstance(option, dict) and is_text(option.get('label')) for option in options):
            return f'{card["title"]!r} has an option without a label'
        if not all(isinstance(option.get('recommended', False), bool) for option in options):
            return f'{card["title"]!r} has a recommended that is not true or false'
        if sum(option.get('recommended') is True for option in options) != 1:
            return f'{card["title"]!r} needs exactly one recommended option'
    if fragment and any(is_private(path) for path in [source, data.get('evidence_path', ''), *picture_paths(data)]):
        return 'a client\'s pages stay out of a hosted page: leave out --fragment'
    return None


def placement(data):
    """Where each picture goes: inside the one card that alone cites it, else under Figures, linked from each citer."""
    citers = [*data.get('needs_you', []), *data.get('decisions', [])]
    count = {item['id']: sum(item['id'] in citer.get('figures', []) for citer in citers) for item in data.get('evidence', [])}
    cards = [[name for name in card.get('figures', []) if count[name] == 1] for card in data.get('needs_you', [])]
    held = {name for names in cards for name in names}
    return {'cards': cards, 'figures': [item['id'] for item in data.get('evidence', []) if item['id'] not in held]}


def build(data, fragment, root=ROOT):
    data['placement'] = placement(normalise(data))
    for item in data.get('evidence', []):
        for key in ('src', 'before', 'after'):
            if key in item:
                item[key] = picture(item[key], root)
    # Inside a <script> block a raw "<" could close it; the JSON escape reads back as the same text.
    try:
        embedded = json.dumps(data, ensure_ascii=False, allow_nan=False).replace('<', '\\u003c')
    except ValueError:  # Python words this differently from version to version
        raise ValueError('the data holds a number that is not finite (NaN or infinity)') from None
    logo = lambda name: data_uri('image/svg+xml', (LOGOS / name).read_bytes())  # noqa: E731
    values = {'FONTS': font_faces(), 'TITLE': escape(data['title']), 'MARK_REVERSED': logo('cvgen-mark-c-eye-reversed.svg'),
              'MARK_INK': logo('cvgen-mark-c-eye.svg'), 'DATA': embedded}
    # One pass, so a title holding a placeholder stays text.
    page = re.sub(r'\{\{(\w+)\}\}', lambda match: values[match[1]], (REPORT / 'report.html').read_text(encoding='utf-8'))
    return page if fragment else '<!doctype html>\n<html lang="en">\n<meta name="viewport" content="width=device-width,initial-scale=1">\n' + page


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('data', type=Path)
    parser.add_argument('--fragment', action='store_true')
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    folder = args.output or ROOT / 'builds' / f'report-{datetime.now():%Y%m%d-%H%M%S-%f}'
    out = folder / 'report.html'
    try:
        data = json.loads(args.data.read_text(encoding='utf-8'))
        problem = refusal(normalise(data), args.fragment, args.data.resolve())
        if problem:
            sys.exit(f'report: {problem}')
        page = build(data, args.fragment).encode('utf-8')
        folder.mkdir(parents=True, exist_ok=False)
        out.write_bytes(page)
    # pymupdf reports a missing file as a RuntimeError; a wrong-typed picture is a TypeError.
    except (AttributeError, KeyError, OSError, RuntimeError, TypeError, ValueError) as error:
        sys.exit(f'report: {error}')
    print(out)


if __name__ == '__main__':
    main()
