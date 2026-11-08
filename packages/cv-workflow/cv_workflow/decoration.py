"""Decoration over words: Hanami's sakura petals in flight must never lie on a word.

The petals are laid out once in page millimetres (packages/domains/travel/assets/japan/petals-p<page>-<hero|field>.svg)
and drawn on every page of Hanami showcase, whatever the record holds (Hanami essential draws none). A petal over a word blurs the CV, so the render
(render.py) and the suite take each petal's outline (rotated, skewed, squashed, plus three standard deviations of
its blur) and name every text span it meets. docs/framework-gaps.md, 2026-11-08, has the gap this guards.
"""
import math
import re

from .workspace import DOMAINS

MM = 25.4 / 72
PETALS = DOMAINS / 'travel/assets/japan'
# The Templates that draw the petal layer.
PETAL_TEMPLATES = {'hanami'}
# The Template Variations of those Templates that draw no petal layer: Hanami essential has no petals in flight
# (TASK-79). Every other Variation is checked, so a new one that draws petals cannot skip the check unnoticed.
PETAL_EXEMPT = {'hanami': {'essential'}}
PETAL = re.compile(r"<g transform='translate\(([-\d.]+),([-\d.]+)\) rotate\(([-\d.]+)\) skewX\(([-\d.]+)\) scale\(1,([-\d.]+)\)' "
                   r"opacity='[\d.]+'(?: filter='url\(#blur(\d)\)')?><path d='([^']+)' transform='translate\(0,([-\d.]+)\)'")


def petals(svg):
    """Each petal's box in page millimetres."""
    boxes = []
    for m in PETAL.finditer(svg):
        x, y, angle, skew, squash = map(float, m.group(1, 2, 3, 4, 5))
        blur = {'1': 0.5, '2': 0.75}.get(m.group(6), 0.0)
        shift = float(m.group(8))
        numbers = list(map(float, re.findall(r'-?\d+(?:\.\d+)?', m.group(7))))
        cos, sin, slant = math.cos(math.radians(angle)), math.sin(math.radians(angle)), math.tan(math.radians(skew))
        xs, ys = [], []
        for px, py in zip(numbers[0::2], numbers[1::2]):
            py = (py + shift) * squash
            px += slant * py
            xs.append(x + px * cos - py * sin)
            ys.append(y + px * sin + py * cos)
        reach = 3 * blur
        boxes.append((min(xs) - reach, min(ys) - reach, max(xs) + reach, max(ys) + reach))
    return boxes


def petal_collisions(pdf, art=PETALS):
    """(page, text) for every petal that lies on a word; empty when none does."""
    import pymupdf as fitz  # Only the render path and the suite need it.
    found = []
    with fitz.open(pdf) as doc:
        for number, page in enumerate(doc, start=1):
            layer = [box for part in ('hero', 'field')
                     for box in petals((art / f'petals-p{number}-{part}.svg').read_text(encoding='utf-8'))]
            assert layer, f'no petals parsed for page {number}: the petal SVG format changed'
            for block in page.get_text('dict')['blocks']:
                for line in block.get('lines', []):
                    for span in line['spans']:
                        if not span['text'].strip():
                            continue
                        x0, y0, x1, y1 = (v * MM for v in span['bbox'])
                        if any(a < x1 and c > x0 and b < y1 and d > y0 for a, b, c, d in layer):
                            found.append((number, span['text'].strip()[:30]))
    return found


def decoration_errors(pdf, template, variation=None):
    """The check errors for a rendered PDF of `template` and `variation`: one per word a petal lies on.

    Only a named Template is checked, and every Template Variation of it except those in PETAL_EXEMPT (None is
    checked, as the Template's default). A custom composition (no template in the choice) or Hanami
    essential draws no petals, so checking it against Hanami's layer would report words nothing covers.
    """
    if template not in PETAL_TEMPLATES or variation in PETAL_EXEMPT.get(template, set()):
        return []
    try:
        found = petal_collisions(pdf)
    except (OSError, AssertionError) as error:
        return [f'The petal check could not run ({error}); the petal layer has one SVG pair per page, '
                'petals-p<page>-hero.svg and -field.svg, in ' + PETALS.as_posix()]
    return [f'A sakura petal lies on the words "{text}" on page {page}: shorten or reword that line, '
            'or move the petal in the template\'s petal layer' for page, text in found]
