"""Hanami's petal layer against a PDF's words. Run by tests/run.py on the tour-leader example.

The sakura petals in flight are laid out in page millimetres once (assets/japan/petals-p<page>-<hero|field>.svg)
and drawn on every Hanami page. A petal over a word would blur the CV, so the suite takes each petal's outline
(rotated, skewed, squashed, plus three standard deviations of its blur) and fails when it meets a text span.
"""
import math
import re

import pymupdf as fitz

MM = 25.4 / 72
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


def petal_collisions(pdf, art):
    """(page, text) for every petal that lies on a word; empty when none does."""
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
