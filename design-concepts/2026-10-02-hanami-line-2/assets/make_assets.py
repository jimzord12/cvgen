"""Hanami Line 2 artwork generator (magazine-editor, 2026-10-02).

Writes every SVG in this folder. All drawing is original vector work, made here:
cherry branches (zigzag nodes, tapered bark with lenticels and spurs, shaded
five-petal blossoms with veins, stamens and anthers, two-tone buds), petals in
flight laid out against the page plan's keep-out rectangles, a myojin torii,
Mount Fuji with strata, the tour group behind its leader's flag, a plane, six
single-ink eki stamp drawings, four profile icons and five pale background
pieces (seigaiha, Shinkansen, lanterns, folding fan, pagoda). Nothing is traced.

Colours are placeholder tokens; spacious-stylish.typ (hanami.typ) swaps them per
palette and per ground:
  LINE #c9a86a line art   CAP #f3ead8 snow/light   ACC #d2462f flag   BAND #0b0b0b hero fill
  INK #c23a2b stamp ink   GROUND #fefefe knock-out  ICON #7a5a3a icons
  BARK #5e4a55  PETAL #f6d2da  DEEP #e595aa  EDGE #d4869c  HEART #b0405f  ANTHER #e0b04c  LENT #f6efe2
  BGF #bbbbbb background fill   BGS #999999 background stroke

    python design-concepts/2026-10-02-hanami-line-2/assets/make_assets.py
"""
import math
import os
import random

HERE = os.path.dirname(os.path.abspath(__file__))

LINE, CAP, ACC, BAND, TONE, SUN = "#c9a86a", "#f3ead8", "#d2462f", "#0b0b0b", "#7f8fa6", "#f1dcae"
INK, GROUND, ICON = "#c23a2b", "#fefefe", "#7a5a3a"
BARK, PETAL, DEEP, EDGE, HEART, ANTHER, LENT = "#5e4a55", "#f6d2da", "#e595aa", "#d4869c", "#b0405f", "#e0b04c", "#f6efe2"
BGF, BGS = "#bbbbbb", "#999999"

PETAL_DEFS = (f"<defs><linearGradient id='pg' x1='0' y1='1' x2='0' y2='0'>"
              f"<stop offset='0' stop-color='{DEEP}'/><stop offset='0.55' stop-color='{PETAL}'/><stop offset='1' stop-color='{PETAL}'/></linearGradient>"
              f"<filter id='blur1' x='-80%' y='-80%' width='260%' height='260%'><feGaussianBlur stdDeviation='0.5'/></filter>"
              f"<filter id='blur2' x='-80%' y='-80%' width='260%' height='260%'><feGaussianBlur stdDeviation='0.75'/></filter></defs>")


def f(x):
    return f"{x:.2f}".rstrip("0").rstrip(".")


def write(name, body, vb):
    with open(os.path.join(HERE, name), "w", encoding="utf-8", newline="\n") as fh:
        fh.write(f"<svg xmlns='http://www.w3.org/2000/svg' viewBox='{vb}'>{body}</svg>\n")


def smooth_open(pts):
    out = []
    for i in range(len(pts) - 1):
        p0 = pts[i - 1] if i > 0 else pts[i]
        p1, p2 = pts[i], pts[i + 1]
        p3 = pts[i + 2] if i + 2 < len(pts) else p2
        c1 = (p1[0] + (p2[0] - p0[0]) / 6, p1[1] + (p2[1] - p0[1]) / 6)
        c2 = (p2[0] - (p3[0] - p1[0]) / 6, p2[1] - (p3[1] - p1[1]) / 6)
        out.append(f"C{f(c1[0])},{f(c1[1])} {f(c2[0])},{f(c2[1])} {f(p2[0])},{f(p2[1])}")
    return " ".join(out)


# ================================================================ sakura ======
def petal_path(r, notch=0.55):
    """A rounded obovate cherry petal pointing up (-y), base at the origin.
    `notch` is the depth of the shallow tip notch as a fraction of r/6."""
    k = r / 6.2
    n = notch * k
    return (f"M0,0 C{f(2.0*k)},{f(-0.7*k)} {f(3.0*k)},{f(-2.9*k)} {f(2.55*k)},{f(-4.7*k)} "
            f"C{f(2.15*k)},{f(-5.95*k)} {f(1.05*k)},{f(-6.35*k)} {f(0.32*k)},{f(-6.05*k)} "
            f"L0,{f(-6.05*k+n)} L{f(-0.32*k)},{f(-6.05*k)} "
            f"C{f(-1.05*k)},{f(-6.35*k)} {f(-2.15*k)},{f(-5.95*k)} {f(-2.55*k)},{f(-4.7*k)} "
            f"C{f(-3.0*k)},{f(-2.9*k)} {f(-2.0*k)},{f(-0.7*k)} 0,0Z")


def petal_veins(r):
    k = r / 6.2
    return (f"<path d='M0,{f(-0.4*k)} L0,{f(-3.9*k)} M0,{f(-0.6*k)} Q{f(0.9*k)},{f(-2.2*k)} {f(1.25*k)},{f(-3.6*k)} "
            f"M0,{f(-0.6*k)} Q{f(-0.9*k)},{f(-2.2*k)} {f(-1.25*k)},{f(-3.6*k)}' fill='none' stroke='{EDGE}' stroke-opacity='0.55' stroke-width='{f(0.05*r)}' stroke-linecap='round'/>")


def blossom(x, y, r, rot, squash, rng):
    s = f"<g transform='translate({f(x)},{f(y)}) rotate({f(rot)}) scale(1,{f(squash)})'>"
    pp = petal_path(r)
    pv = petal_veins(r)
    for i in range(5):
        a = i * 72 + rng.uniform(-7, 7)
        sc = rng.uniform(0.92, 1.05)
        s += (f"<g transform='rotate({f(a)}) scale({f(sc)})'><path d='{pp}' fill='url(#pg)' stroke='{EDGE}' stroke-width='{f(0.035*r)}'/>{pv}</g>")
    # the heart: a small star of sepal tips, filaments and anthers
    s += f"<circle r='{f(r*0.2)}' fill='{HEART}' fill-opacity='0.85'/>"
    n = 11
    for i in range(n):
        a = math.radians(i * 360 / n + rng.uniform(-9, 9))
        rr = r * rng.uniform(0.36, 0.5)
        ex, ey = rr * math.cos(a), rr * math.sin(a)
        s += f"<line x1='0' y1='0' x2='{f(ex)}' y2='{f(ey)}' stroke='{HEART}' stroke-opacity='0.7' stroke-width='{f(r*0.022)}'/>"
        s += f"<circle cx='{f(ex)}' cy='{f(ey)}' r='{f(r*0.045)}' fill='{ANTHER}'/>"
    s += f"<circle r='{f(r*0.07)}' fill='{ANTHER}'/>"
    return s + "</g>"


def bud(x, y, r, ang):
    deg = math.degrees(ang) + 90
    return (f"<g transform='translate({f(x)},{f(y)}) rotate({f(deg)})'>"
            f"<path d='M0,0 C{f(r*0.95)},{f(-r*0.5)} {f(r*0.8)},{f(-r*1.9)} 0,{f(-r*2.4)} C{f(-r*0.8)},{f(-r*1.9)} {f(-r*0.95)},{f(-r*0.5)} 0,0Z' fill='{DEEP}' stroke='{EDGE}' stroke-width='{f(r*0.06)}'/>"
            f"<path d='M0,{f(-r*0.3)} Q{f(r*0.3)},{f(-r*1.3)} 0,{f(-r*2.3)}' fill='none' stroke='{PETAL}' stroke-width='{f(r*0.12)}' stroke-opacity='0.8'/>"
            f"<path d='M{f(-r*0.6)},{f(-r*0.1)} Q0,{f(r*0.55)} {f(r*0.6)},{f(-r*0.1)} L{f(r*0.25)},{f(-r*0.55)} L0,{f(-r*0.2)} L{f(-r*0.25)},{f(-r*0.55)} Z' fill='{BARK}'/></g>")


def flying_petal(x, y, r, rot, squash, skew, opacity, far):
    """A petal in flight. `far` petals are the distant ones: larger, rounder, fainter and
    out of focus (a Gaussian blur scaled to their size), a depth-of-field effect."""
    flt = ""
    if far:
        flt = f" filter='url(#{'blur2' if r > 3.6 else 'blur1'})'"
    return (f"<g transform='translate({f(x)},{f(y)}) rotate({f(rot)}) skewX({f(skew)}) scale(1,{f(squash)})' opacity='{f(opacity)}'{flt}>"
            f"<path d='{petal_path(r, notch=0.3)}' transform='translate(0,{f(r*0.5)})' fill='url(#pg)' stroke='{EDGE}' stroke-width='{f(0.035*r)}'/>"
            f"<path d='M0,{f(r*0.42)} Q{f(r*0.12)},{f(-r*0.05)} 0,{f(-r*0.3)}' fill='none' stroke='{EDGE}' stroke-opacity='0.5' stroke-width='{f(0.05*r)}'/></g>")


class Tree:
    def __init__(self, seed):
        self.rng = random.Random(seed)
        self.bark, self.flowers, self.pts, self.limbs = [], [], [], []

    def limb(self, x, y, ang, length, w0, w1, depth, sign=1):
        rng = self.rng
        n = max(4, int(length / 3.2))
        step = length / n
        pts, ws, angs = [(x, y)], [w0], [ang]
        a = ang
        nodes = []
        for i in range(1, n + 1):
            if i % 2 == 0:
                sign = -sign
                a += sign * rng.uniform(0.18, 0.42)
                nodes.append(i)
            a += rng.uniform(-0.07, 0.07)
            x += step * math.cos(a)
            y += step * math.sin(a)
            w = w0 + (w1 - w0) * (i / n) ** 0.8
            if i in nodes:
                w *= 1.12
            pts.append((x, y)); ws.append(w); angs.append(a)
        left, right = [], []
        for (px, py), w, aa in zip(pts, ws, angs):
            nx, ny = -math.sin(aa), math.cos(aa)
            left.append((px + nx * w / 2, py + ny * w / 2))
            right.append((px - nx * w / 2, py - ny * w / 2))
        tip = pts[-1]
        d = f"M{f(left[0][0])},{f(left[0][1])} " + smooth_open(left)
        d += f" L{f(tip[0] + math.cos(angs[-1]) * ws[-1] * 0.6)},{f(tip[1] + math.sin(angs[-1]) * ws[-1] * 0.6)}"
        rr = list(reversed(right))
        d += f" L{f(rr[0][0])},{f(rr[0][1])} " + smooth_open(rr) + "Z"
        self.bark.append(d)
        self.limbs.append((pts, ws, angs))
        if w0 > 1.6:
            for i in range(1, len(pts) - 1, 2):
                px, py = pts[i]; aa = angs[i]
                off = rng.uniform(-0.25, 0.25) * ws[i]
                L = rng.uniform(1.5, 3.2)
                self.bark.append(("tex", px, py, aa, ws[i], off, L))
        self.pts.extend(pts)
        if depth > 0:
            side = rng.choice([-1, 1])
            for i in range(3, n - 1, 3 if depth > 1 else 4):
                if rng.random() < (0.85 if depth > 1 else 0.6):
                    side = -side
                    ca = angs[i] + side * rng.uniform(0.5, 0.85)
                    cl = (length - i * step) * rng.uniform(0.35, 0.55) + 5
                    self.limb(pts[i][0], pts[i][1], ca, cl, ws[i] * 0.55, 0.3, depth - 1, side)
        if w0 < 2.4 or depth == 0:
            for i in range(2, len(pts), 2):
                if rng.random() < (0.5 if depth == 0 else 0.3):
                    self.cluster(pts[i][0], pts[i][1], angs[i])
            self.flowers.append((tip[0], tip[1], 1.1, "bud", angs[-1]))
        else:
            for i in range(int(len(pts) * 0.6), len(pts), 2):
                if rng.random() < 0.22:
                    self.cluster(pts[i][0], pts[i][1], angs[i])

    def cluster(self, x, y, ang):
        rng = self.rng
        k = rng.choice([1, 1, 2, 2, 3])
        for j in range(k):
            da = ang + rng.choice([-1, 1]) * rng.uniform(0.7, 2.2)
            L = rng.uniform(1.6, 4.0)
            bx, by = x + L * math.cos(da), y + L * math.sin(da)
            if rng.random() < 0.18:
                self.flowers.append((bx, by, rng.uniform(0.9, 1.3), "bud", da))
            else:
                self.flowers.append((bx, by, rng.uniform(2.6, 3.9), "flower", (x, y)))

    def svg(self):
        rng = random.Random(7)   # drawing details only; the geometry is fixed above
        s = PETAL_DEFS + "<g id='art'>"
        for item in self.bark:
            if isinstance(item, str):
                s += f"<path d='{item}' fill='{BARK}'/>"
        # light along the upper edge of each limb (the bark catching light)
        for pts, ws, angs in self.limbs:
            if ws[0] < 0.9:
                continue
            hl = [(px - math.sin(a) * w * 0.22, py + math.cos(a) * w * 0.22) for (px, py), w, a in zip(pts, ws, angs)]
            hl = hl[: max(2, int(len(hl) * 0.8))]
            s += f"<path d='M{f(hl[0][0])},{f(hl[0][1])} {smooth_open(hl)}' fill='none' stroke='{LENT}' stroke-opacity='0.22' stroke-width='{f(ws[0]*0.16)}' stroke-linecap='round'/>"
        # horizontal lenticels: short light dashes across the bark
        for item in self.bark:
            if isinstance(item, tuple):
                _, px, py, aa, w, off, L = item
                nx, ny = -math.sin(aa), math.cos(aa)
                for j in range(2):
                    cx, cy = px + math.cos(aa) * (j * 1.3), py + math.sin(aa) * (j * 1.3)
                    h = w * 0.32
                    s += f"<line x1='{f(cx - nx*h)}' y1='{f(cy - ny*h)}' x2='{f(cx + nx*h)}' y2='{f(cy + ny*h)}' stroke='{LENT}' stroke-opacity='0.45' stroke-width='{f(max(w*0.07,0.1))}' stroke-linecap='round'/>"
        # spurs: short knobs where the flowers sit, then stalks
        seen = set()
        for (x, y, r, kind, extra) in self.flowers:
            if kind == "flower":
                ox, oy = extra
                if (round(ox, 1), round(oy, 1)) not in seen:
                    seen.add((round(ox, 1), round(oy, 1)))
                    s += f"<circle cx='{f(ox)}' cy='{f(oy)}' r='0.55' fill='{BARK}'/>"
                s += f"<path d='M{f(ox)},{f(oy)} Q{f((ox+x)/2 + 0.5)},{f((oy+y)/2 + 0.5)} {f(x)},{f(y)}' fill='none' stroke='{BARK}' stroke-width='0.2'/>"
        for (x, y, r, kind, extra) in self.flowers:
            if kind == "bud":
                s += bud(x, y, r, extra)
        for (x, y, r, kind, extra) in sorted(self.flowers, key=lambda t: t[2]):
            if kind == "flower":
                s += blossom(x, y, r, rng.uniform(0, 72), rng.choice([1, 1, 0.92, 0.82, 0.72]), rng)
        return s


def window_svg(name, seed, start, ang, length, w0, window, open_edges, depth=2, min_blossoms=8, tries=6000):
    """A branch drawn into the exact frame it occupies on the page. Only `open_edges`
    (the page or band edge) may cut it; wood never crosses a closed edge and a blossom
    a closed edge would slice is left out. Seeds are tried upwards from `seed`."""
    x0, y0, w, h = window
    m = 0.6

    def ok(x, y, r):
        if "left" not in open_edges and x - r < x0 + m: return False
        if "right" not in open_edges and x + r > x0 + w - m: return False
        if "top" not in open_edges and y - r < y0 + m: return False
        if "bottom" not in open_edges and y + r > y0 + h - m: return False
        return True

    for s in range(seed, seed + tries):
        t = Tree(s)
        t.limb(start[0], start[1], ang, length, w0, 0.5, depth)
        if not all(ok(x, y, 0.8) for (x, y) in t.pts):
            continue
        t.flowers = [fl for fl in t.flowers if ok(fl[0], fl[1], fl[2] * (1.15 if fl[3] == "flower" else 2.4))]
        inside = sum(1 for fl in t.flowers if fl[3] == "flower")
        if inside < min_blossoms:
            continue
        print(f"{name}: seed {s}  window {window}  open {sorted(open_edges)}  blossoms {inside}")
        write(name, t.svg() + "</g>", f"{x0} {y0} {w} {h}")
        return s
    raise SystemExit(f"{name}: no seed found")


# ------------------------------------------------------- petals in flight --
def page_petals(prefix, band, keepouts, trails, scatter, seed, page=(210, 297), distant=0):
    """Petals drifting over one page, laid out once in page coordinates (mm) and split
    at the band edge into <prefix>-hero.svg (on the band) and <prefix>-field.svg (on
    paper), so a trail can cross the edge without any petal being sliced.
    trails: (p0, p1, p2, p3, count, r_start, r_end) cubic paths the wind carries them along.
    scatter: loose petals placed at random in the open areas. Nothing lands in a keep-out."""
    rng = random.Random(seed)
    W, H = page
    placed = []

    def free(x, y, r, bleed=False):
        lo = -r * 0.35 if bleed else r          # a distant petal may drift off the page edge
        if not (lo < x < W - lo and lo < y < H - lo) or abs(y - band) < r * 1.35:
            return False
        for (a, b, c, d) in keepouts:
            if a - r < x < c + r and b - r < y < d + r:
                return False
        return all(math.hypot(x - px, y - py) > (r + pr) * 1.25 for px, py, pr, _ in placed)

    def bez(p0, p1, p2, p3, t):
        u = 1 - t
        return tuple(u**3 * a + 3 * u * u * t * b + 3 * u * t * t * c + t**3 * d for a, b, c, d in zip(p0, p1, p2, p3))

    def put(x, y, r, heading, force_far=False):
        far = force_far or rng.random() < 0.45   # drawn often, placed less often
        if far and not force_far:                       # a distant petal: bigger, rounder, out of focus, faint
            r = r * rng.uniform(1.45, 1.8)
        reach = r + 2.2 if far else r          # its blur keeps clear of text and small labels
        if not free(x, y, reach, bleed=far):
            return False
        if far:
            svg = flying_petal(x, y, r, heading + rng.uniform(-60, 60), rng.uniform(0.82, 1.0), rng.uniform(-5, 5), rng.uniform(0.45, 0.6), True)
        else:
            svg = flying_petal(x, y, r, heading + rng.uniform(-80, 80), rng.uniform(0.45, 1.0), rng.uniform(-14, 14), rng.uniform(0.6, 0.95), False)
        placed.append((x, y, reach, svg))
        return True

    for (p0, p1, p2, p3, count, ra, rb) in trails:
        for t in sorted(rng.uniform(0, 1) for _ in range(count)):
            x, y = bez(p0, p1, p2, p3, t)
            x2, y2 = bez(p0, p1, p2, p3, min(1, t + 0.01))
            heading = math.degrees(math.atan2(y2 - y, x2 - x)) + 90
            r = (ra + (rb - ra) * t) * rng.uniform(0.78, 1.18)
            for attempt in range(8):          # nudge across the wind until it lands in the open
                j = 0.4 + attempt * 0.45      # start close to the path, so narrow gaps still get their petals
                jx, jy = rng.uniform(-3.0, 3.0), rng.uniform(-j, j)
                if put(x + jx, y + jy, r, heading):
                    if rng.random() < 0.16:   # a tiny cluster riding together
                        for _ in range(rng.choice([1, 2])):
                            put(x + jx + rng.uniform(-2.6, 2.6), y + jy + rng.uniform(-2.6, 2.6), r * rng.uniform(0.6, 0.85), heading)
                    break
    n, tries = 0, 0
    while n < scatter and tries < 6000:
        tries += 1
        if put(rng.uniform(0, W), rng.uniform(0, H), rng.uniform(1.5, 2.6), rng.uniform(0, 360)):
            n += 1
    n, tries = 0, 0
    while n < distant and tries < 8000:       # the depth-of-field pass: a few big, soft, distant petals
        tries += 1
        if put(rng.uniform(-2, W + 2), rng.uniform(0, H), rng.uniform(3.4, 4.8), rng.uniform(0, 360), force_far=True):
            n += 1
    hero = [s for x, y, r, s in placed if y < band]
    field = [s for x, y, r, s in placed if y > band]
    print(f"{prefix}: {len(placed)} petals ({len(hero)} on the band)")
    write(f"{prefix}-hero.svg", PETAL_DEFS + "".join(hero), f"0 0 {W} {band}")
    write(f"{prefix}-field.svg", PETAL_DEFS + "".join(field), f"0 {band} {W} {H - band}")


# ====================================================== hero line drawings ===
def torii(name, w=80, h=58, sw=0.5):
    """Myojin torii, front view: kasagi with sori over the shimaki, gakuzuka, nuki
    through tapered, inward-leaning hashira with kusabi wedges, daiwa and kamebara."""
    c = w / 2
    S = f" stroke='{LINE}' stroke-width='{f(sw)}' stroke-linejoin='round'"
    T = f" fill='{BAND}'"     # underlay that hides what stands behind the gate
    V = f" fill='{LINE}' fill-opacity='0.14'"
    parts = []
    # kasagi: the top lintel, ends swept up, with a thin top board
    parts.append(f"M0,1.6 Q{f(c)},7.4 {w},1.6 L{f(w-1.1)},5.6 Q{f(c)},11 1.1,5.6 Z")
    parts.append(f"M1.8,0.6 Q{f(c)},6.0 {f(w-1.8)},0.6 L{w},1.6 Q{f(c)},7.4 0,1.6 Z")
    # shimaki directly beneath
    parts.append(f"M4.2,6.5 Q{f(c)},11.4 {f(w-4.2)},6.5 L{f(w-4.6)},9.4 Q{f(c)},14.2 4.6,9.4 Z")
    # gakuzuka: central strut with a tablet
    parts.append(f"M{f(c-3.2)},12.6 L{f(c+3.2)},12.6 L{f(c+3.2)},19.4 L{f(c-3.2)},19.4 Z")
    # nuki: tie beam running through and past the posts
    parts.append(f"M6.4,19.4 L{f(w-6.4)},19.4 L{f(w-6.4)},22.6 L6.4,22.6 Z")
    for side in (-1, 1):
        top_c = c + side * (c - 14.6)      # post centre at the top
        bot_c = c + side * (c - 13.2)      # wider at the foot (uchikorobi)
        tw, bw = 2.4, 3.0                  # half widths: tapered posts
        parts.append(f"M{f(top_c-tw)},9.6 L{f(top_c+tw)},9.6 L{f(bot_c+bw)},{f(h-3.2)} L{f(bot_c-bw)},{f(h-3.2)} Z")
        # daiwa ring under the shimaki
        parts.append(f"M{f(top_c-tw-0.6)},10.4 L{f(top_c+tw+0.6)},10.4 L{f(top_c+tw+0.6)},12.0 L{f(top_c-tw-0.6)},12.0 Z")
        # kusabi wedge on the nuki beside each post
        wx = top_c + side * (tw + 0.5) * -1
        parts.append(f"M{f(wx-0.8)},19.0 L{f(wx+0.8)},19.0 L{f(wx+0.6)},23.0 L{f(wx-0.6)},23.0 Z")
        # kamebara foot and nemaki band
        parts.append(f"M{f(bot_c-bw-1.3)},{f(h-3.2)} L{f(bot_c+bw+1.3)},{f(h-3.2)} L{f(bot_c+bw+0.9)},{h} L{f(bot_c-bw-0.9)},{h} Z")
        parts.append(f"M{f(bot_c-bw-0.1)},{f(h-7.4)} L{f(bot_c+bw+0.1)},{f(h-7.4)} L{f(bot_c+bw+0.1)},{f(h-3.2)} L{f(bot_c-bw-0.1)},{f(h-3.2)} Z")
    s = "<g id='art'>"
    s += "".join(f"<path d='{p}'{T}/>" for p in parts)
    s += "".join(f"<path d='{p}'{V}{S}/>" for p in parts)
    # grain hairlines on the posts
    for side in (-1, 1):
        top_c = c + side * (c - 14.6); bot_c = c + side * (c - 13.2)
        s += f"<line x1='{f(top_c - side*0.6)}' y1='23.6' x2='{f(bot_c - side*0.8)}' y2='{f(h-8.4)}' stroke='{LINE}' stroke-width='{f(sw*0.4)}' stroke-opacity='0.75'/>"
    write(name, s + "</g>", f"0 0 {w} {h}")


def fuji(name, sw=0.45):
    w, h = 56, 26
    S = f" stroke='{LINE}' stroke-width='{f(sw)}' stroke-linecap='round' stroke-linejoin='round'"
    s = "<g id='art'>"
    # a subtle sun
    s += f"<circle cx='42.5' cy='7.2' r='6.6' fill='{SUN}' fill-opacity='0.16'/>"
    s += f"<circle cx='42.5' cy='7.2' r='4.4' fill='{SUN}' fill-opacity='0.72'/>"
    body = "M0.6,25.4 C9,24 16.5,19.6 22.4,6.2 L33.6,6.2 C39.5,19.6 47,24 55.4,25.4 Z"
    s += f"<path d='{body}' fill='{BAND}'/><path d='{body}' fill='{TONE}' fill-opacity='0.12'{S}/>"
    # strata: two lower bands, a little deeper
    s += f"<path d='M4.6,24.9 C11,23.2 15.6,20.6 18.6,16.4 C22,18.6 27,17.2 30.6,19.2 C34.4,17.4 37.4,18.8 40.6,17.6 C43.4,21 48,23.4 51.4,24.9 Z' fill='{TONE}' fill-opacity='0.14'/>"
    s += f"<path d='M8.6,25.4 C13,24.2 16.4,22.6 18.8,21 C23,22.6 27.4,21.6 31.4,23 C35.4,21.6 39.6,22.6 43,21.4 C45.2,23 48.4,24.4 50.6,25.4 Z' fill='{TONE}' fill-opacity='0.16'/>"
    # snow cap: uneven tongues running down the gullies
    cap = ("M22.4,6.2 L33.6,6.2 C34.5,8.3 35.4,10.1 36.4,11.7 L35.3,11.2 L34.6,13.6 L33.5,11.4 L32.5,15.6 L31.2,11.9 "
           "L29.9,14.4 L28.9,11.5 L27.8,16.2 L26.6,11.9 L25.3,13.4 L24.4,11.4 L23.0,12.9 L21.8,11.6 L19.9,12.4 "
           "C20.9,10.6 21.6,8.6 22.4,6.2 Z")
    s += f"<path d='{cap}' fill='{CAP}'{S}/>"
    s += f"<path d='M24.6,6.2 L25.4,9.4 M28,6.2 L28.2,9.6 M31.4,6.2 L30.8,9.2' stroke='{LINE}' stroke-width='{f(sw*0.45)}' stroke-opacity='0.55'/>"
    for (x1, y1, x2, y2, cx) in ((27.8, 16.6, 24.4, 23.0, 26.6), (32.5, 16.0, 34.4, 23.4, 33.0), (35.4, 14.0, 41.4, 22.4, 37.6), (23.0, 13.4, 16.4, 22.0, 20.6)):
        s += f"<path d='M{x1},{y1} Q{cx},{(y1+y2)/2} {x2},{y2}' fill='none' stroke='{LINE}' stroke-width='{f(sw*0.55)}' stroke-opacity='0.7' stroke-linecap='round'/>"
    s += f"<path d='{body}' fill='none'{S}/>"
    write(name, s + "</g>", f"0 0 {w} {h}")


# ---- the escort group --------------------------------------------------------
LEG, ARM = 0.95, 0.78        # one limb weight for every figure (drawing units)


def person(x, base, hgt, fill, pose="walk", dress=False, hat=None, luggage=None, flag=None, stride=1.0):
    """A traveller seen from the side, facing +x, built from one set of proportions."""
    k = hgt / 12.0
    def L(x1, y1, x2, y2, w):
        return f"<line x1='{f(x1)}' y1='{f(y1)}' x2='{f(x2)}' y2='{f(y2)}' stroke='{fill}' stroke-width='{f(w)}' stroke-linecap='round'/>"
    hip = (x, base - 5.3 * k)
    sh = (x + 0.35 * k, base - 9.2 * k)
    s = ""
    # legs mid-stride (knee bend on the back leg)
    fx = x + 1.7 * k * stride
    bx = x - 1.5 * k * stride
    s += L(hip[0] + 0.3 * k, hip[1], fx, base - 0.15, LEG)
    s += f"<polyline points='{f(hip[0]-0.3*k)},{f(hip[1])} {f(x-0.8*k*stride)},{f(base-2.6*k)} {f(bx)},{f(base-0.15)}' fill='none' stroke='{fill}' stroke-width='{f(LEG)}' stroke-linecap='round' stroke-linejoin='round'/>"
    s += f"<path d='M{f(fx-0.2)},{f(base-0.45)} l{f(1.0*k)},0' stroke='{fill}' stroke-width='{f(LEG*0.8)}' stroke-linecap='round'/>"
    # torso: coat, or a dress that flares
    if dress:
        s += (f"<path d='M{f(sh[0]-1.25*k)},{f(sh[1]+0.2*k)} C{f(sh[0]-1.6*k)},{f(sh[1]+2.4*k)} {f(x-1.5*k)},{f(base-6.4*k)} {f(x-2.1*k)},{f(base-3.6*k)} "
              f"L{f(x+2.3*k)},{f(base-3.6*k)} C{f(x+1.6*k)},{f(base-6.4*k)} {f(sh[0]+1.5*k)},{f(sh[1]+2.4*k)} {f(sh[0]+1.15*k)},{f(sh[1]+0.2*k)} Z' fill='{fill}'/>")
    else:
        s += (f"<path d='M{f(sh[0]-1.3*k)},{f(sh[1]+0.1*k)} C{f(sh[0]-1.7*k)},{f(sh[1]+2.0*k)} {f(x-1.45*k)},{f(base-6.2*k)} {f(x-1.35*k)},{f(base-4.6*k)} "
              f"L{f(x+1.45*k)},{f(base-4.6*k)} C{f(x+1.6*k)},{f(base-6.2*k)} {f(sh[0]+1.6*k)},{f(sh[1]+2.0*k)} {f(sh[0]+1.2*k)},{f(sh[1]+0.1*k)} Z' fill='{fill}'/>")
    # neck and head
    s += L(sh[0], sh[1], sh[0] + 0.15 * k, sh[1] - 0.6 * k, ARM)
    hx, hy = sh[0] + 0.3 * k, sh[1] - 1.75 * k
    s += f"<circle cx='{f(hx)}' cy='{f(hy)}' r='{f(1.18*k)}' fill='{fill}'/>"
    if hat == "sun":
        s += f"<ellipse cx='{f(hx)}' cy='{f(hy-0.75*k)}' rx='{f(2.3*k)}' ry='{f(0.42*k)}' fill='{fill}'/><path d='M{f(hx-1.0*k)},{f(hy-0.8*k)} Q{f(hx)},{f(hy-2.3*k)} {f(hx+1.0*k)},{f(hy-0.8*k)} Z' fill='{fill}'/>"
    if hat == "cap":
        s += f"<path d='M{f(hx-1.15*k)},{f(hy-0.35*k)} Q{f(hx-0.9*k)},{f(hy-1.55*k)} {f(hx+0.3*k)},{f(hy-1.45*k)} Q{f(hx+1.2*k)},{f(hy-1.2*k)} {f(hx+1.2*k)},{f(hy-0.5*k)} L{f(hx+2.3*k)},{f(hy-0.35*k)} Z' fill='{fill}'/>"
    # arms
    if pose == "walk":
        s += L(sh[0] + 0.3 * k, sh[1] + 0.4 * k, sh[0] + 1.6 * k, sh[1] + 3.6 * k, ARM)
        s += L(sh[0] - 0.3 * k, sh[1] + 0.4 * k, sh[0] - 1.5 * k, sh[1] + 3.4 * k, ARM)
    elif pose == "pull":
        s += L(sh[0] + 0.3 * k, sh[1] + 0.4 * k, sh[0] + 1.4 * k, sh[1] + 3.5 * k, ARM)
        s += L(sh[0] - 0.3 * k, sh[1] + 0.4 * k, x - 2.7 * k, base - 5.6 * k, ARM)
    elif pose == "phone":
        s += f"<polyline points='{f(sh[0]+0.3*k)},{f(sh[1]+0.4*k)} {f(sh[0]+1.9*k)},{f(sh[1]+1.6*k)} {f(sh[0]+2.3*k)},{f(sh[1]-1.2*k)}' fill='none' stroke='{fill}' stroke-width='{f(ARM)}' stroke-linecap='round' stroke-linejoin='round'/>"
        s += f"<rect x='{f(sh[0]+2.0*k)}' y='{f(sh[1]-2.5*k)}' width='{f(0.75*k)}' height='{f(1.4*k)}' rx='0.15' fill='{fill}'/>"
        s += L(sh[0] - 0.3 * k, sh[1] + 0.4 * k, sh[0] - 1.2 * k, sh[1] + 3.5 * k, ARM)
    elif pose == "strap":
        s += f"<polyline points='{f(sh[0]+0.3*k)},{f(sh[1]+0.4*k)} {f(sh[0]+1.2*k)},{f(sh[1]+2.4*k)} {f(sh[0]+0.2*k)},{f(sh[1]+1.4*k)}' fill='none' stroke='{fill}' stroke-width='{f(ARM)}' stroke-linecap='round' stroke-linejoin='round'/>"
        s += L(sh[0] - 0.3 * k, sh[1] + 0.4 * k, sh[0] - 1.5 * k, sh[1] + 3.3 * k, ARM)
    elif pose == "flag":
        px, top = sh[0] + 2.3 * k, base - 19.0 * k
        s += f"<polyline points='{f(sh[0]+0.3*k)},{f(sh[1]+0.4*k)} {f(sh[0]+1.7*k)},{f(sh[1]-0.6*k)} {f(px)},{f(sh[1]-2.6*k)}' fill='none' stroke='{fill}' stroke-width='{f(ARM)}' stroke-linecap='round' stroke-linejoin='round'/>"
        s += L(sh[0] - 0.3 * k, sh[1] + 0.4 * k, sh[0] - 1.4 * k, sh[1] + 3.4 * k, ARM)
        s += L(px, sh[1] + 1.2 * k, px, top, 0.42 * ARM / 0.78)
        s += f"<circle cx='{f(px)}' cy='{f(top-0.3)}' r='0.35' fill='{fill}'/>"
        s += (f"<path d='M{f(px)},{f(top+0.2)} C{f(px+2.2*k)},{f(top-0.6*k)} {f(px+3.8*k)},{f(top+1.2*k)} {f(px+6.6*k)},{f(top+0.5*k)} "
              f"L{f(px+6.3*k)},{f(top+3.6*k)} C{f(px+3.8*k)},{f(top+4.2*k)} {f(px+2.2*k)},{f(top+2.6*k)} {f(px)},{f(top+3.4*k)} Z' fill='{flag}'/>")
        # lanyard and badge
        s += f"<path d='M{f(sh[0]-0.5*k)},{f(sh[1]+0.1*k)} L{f(sh[0]+0.6*k)},{f(sh[1]+2.0*k)} L{f(sh[0]+1.1*k)},{f(sh[1]+0.1*k)}' fill='none' stroke='{GROUND}' stroke-width='0.18'/>"
        s += f"<rect x='{f(sh[0]+0.15*k)}' y='{f(sh[1]+2.0*k)}' width='{f(0.95*k)}' height='{f(1.2*k)}' rx='0.12' fill='{GROUND}'/>"
    # luggage
    if luggage == "roller":
        cx = x - 4.4 * k
        s += f"<rect x='{f(cx-1.55*k)}' y='{f(base-5.0*k)}' width='{f(3.1*k)}' height='{f(4.5*k)}' rx='{f(0.55*k)}' fill='{fill}'/>"
        s += f"<line x1='{f(cx-0.6*k)}' y1='{f(base-4.4*k)}' x2='{f(cx-0.6*k)}' y2='{f(base-1.2*k)}' stroke='{GROUND}' stroke-width='0.16' stroke-opacity='0.8'/>"
        s += f"<line x1='{f(cx+0.6*k)}' y1='{f(base-4.4*k)}' x2='{f(cx+0.6*k)}' y2='{f(base-1.2*k)}' stroke='{GROUND}' stroke-width='0.16' stroke-opacity='0.8'/>"
        s += L(cx + 1.0 * k, base - 5.0 * k, x - 2.7 * k, base - 5.6 * k, 0.32)
        s += f"<circle cx='{f(cx-0.95*k)}' cy='{f(base-0.32*k)}' r='{f(0.42*k)}' fill='{fill}'/><circle cx='{f(cx+0.95*k)}' cy='{f(base-0.32*k)}' r='{f(0.42*k)}' fill='{fill}'/>"
    if luggage == "pack":
        s += f"<rect x='{f(sh[0]-3.0*k)}' y='{f(sh[1]+0.2*k)}' width='{f(1.9*k)}' height='{f(3.7*k)}' rx='{f(0.7*k)}' fill='{fill}'/>"
    if luggage == "bag":
        s += f"<path d='M{f(sh[0]-0.2*k)},{f(sh[1]+0.2*k)} L{f(x+1.5*k)},{f(base-5.4*k)}' stroke='{GROUND}' stroke-width='0.16'/>"
        s += f"<rect x='{f(x+0.9*k)}' y='{f(base-5.6*k)}' width='{f(1.9*k)}' height='{f(1.6*k)}' rx='{f(0.35*k)}' fill='{fill}'/>"
    return s


def group(name):
    base = 22
    s = "<g id='art'>"
    s += person(6.6, base, 10.7, LINE, pose="pull", dress=True, hat="sun", luggage="roller", stride=0.8)
    s += person(14.4, base, 11.9, LINE, pose="walk", luggage="pack", stride=1.0)
    s += person(21.0, base, 10.4, LINE, pose="strap", dress=True, luggage="bag", stride=0.7)
    s += person(30.2, base, 12.3, LINE, pose="pull", hat="cap", luggage="roller", stride=1.0)
    s += person(37.4, base, 11.2, LINE, pose="phone", stride=0.5)
    s += person(46.2, base, 12.0, LINE, pose="flag", flag=ACC, stride=1.15)
    write(name, s + "</g>", "0 0 56 23")


def plane(name):
    """Airliner from above, nose to +x: rounded nose, swept wings with two engines, tailplane."""
    s = (f"<g id='art' fill='{ACC}'>"
         "<path d='M1.6,6 C1.6,5.35 2.6,5.1 4,5.05 L19.2,4.9 C21.6,4.9 23.2,5.4 23.6,6 C23.2,6.6 21.6,7.1 19.2,7.1 L4,6.95 C2.6,6.9 1.6,6.65 1.6,6 Z'/>"
         "<path d='M10.6,5.1 L14.6,5.0 L8.6,0.2 L6.9,0.2 Z'/><path d='M10.6,6.9 L14.6,7.0 L8.6,11.8 L6.9,11.8 Z'/>"
         "<rect x='9.3' y='2.55' width='2.2' height='0.75' rx='0.35'/><rect x='9.3' y='8.7' width='2.2' height='0.75' rx='0.35'/>"
         "<path d='M2.8,5.2 L4.9,5.15 L2.4,2.7 L1.4,2.7 Z'/><path d='M2.8,6.8 L4.9,6.85 L2.4,9.3 L1.4,9.3 Z'/>"
         "</g>")
    write(name, s, "0 0 24 12")


# ============================================== stamp drawings (40 x 40) ====
def stamp_art():
    k = INK
    def S(w, extra=""):
        return f" fill='none' stroke='{k}' stroke-width='{w}' stroke-linecap='round' stroke-linejoin='round'{extra}"
    F = f" fill='{k}'"
    G = f" fill='{GROUND}'"
    M, D = 1.4, 0.8          # main and detail line weights, the same in every stamp
    DASH = " stroke-dasharray='0.9 1.1'"
    arts = {}

    def mini_blossom(cx, cy, r):
        return "".join(f"<path d='{petal_path(r, 0.7)}' transform='translate({cx},{cy}) rotate({a})'{F}/>" for a in range(0, 360, 72)) + f"<circle cx='{cx}' cy='{cy}' r='{f(r*0.22)}'{G}/>"

    # Kyoto 2018, spring: a vermilion-gate silhouette with blossom, on a gravel path
    arts["torii"] = (
        f"<path d='M3.6,8.6 Q20,12.6 36.4,8.6 L35.6,12.0 Q20,15.2 4.4,12.0 Z'{F}/>"
        f"<path d='M6.4,13.0 L33.6,13.0 L33.3,14.8 L6.7,14.8 Z'{F}/>"
        f"<path d='M18.6,14.8 L21.4,14.8 L21.4,18.6 L18.6,18.6 Z'{F}/>"
        f"<path d='M5.6,18.6 L34.4,18.6 L34.4,20.8 L5.6,20.8 Z'{F}/>"
        f"<path d='M10.9,14.8 L13.9,14.8 L14.3,33.6 L10.3,33.6 Z'{F}/><path d='M26.1,14.8 L29.1,14.8 L29.7,33.6 L25.7,33.6 Z'{F}/>"
        f"<path d='M9.6,33.4 L15.0,33.4 L15.3,35.2 L9.3,35.2 Z'{F}/><path d='M25.0,33.4 L30.4,33.4 L30.7,35.2 L24.7,35.2 Z'{F}/>"
        f"<path d='M2.5,36.6 L37.5,36.6'{S(D)}/><path d='M16.6,36.6 L18.2,30.6 M23.4,36.6 L21.8,30.6'{S(D, DASH)}/>"
        + mini_blossom(33.0, 4.6, 2.5) + mini_blossom(6.4, 4.0, 1.7)
    )
    # Fukuoka 2019, study: an open book, a ribbon, the sun over the bay
    arts["book"] = (
        f"<circle cx='20' cy='6.6' r='3.3'{F}/>"
        + "".join(f"<path d='M{f(20+4.8*math.cos(math.radians(a)))},{f(6.6+4.8*math.sin(math.radians(a)))} L{f(20+6.0*math.cos(math.radians(a)))},{f(6.6+6.0*math.sin(math.radians(a)))}'{S(D)}/>" for a in (-160, -125, -90, -55, -20))
        + f"<path d='M4.2,29.2 Q12,26.4 20,29.6 Q28,26.4 35.8,29.2 L35.8,13.8 Q28,11.2 20,14.2 Q12,11.2 4.2,13.8 Z'{S(M)}/>"
        f"<path d='M20,14.2 L20,29.6'{S(M)}/><path d='M5.6,31.0 Q12.5,28.6 20,31.4 Q27.5,28.6 34.4,31.0'{S(D)}/>"
        f"<path d='M7.4,17.6 Q12,16.2 17.2,17.8 M7.4,20.8 Q12,19.4 17.2,21.0 M7.4,24.0 Q12,22.6 17.2,24.2 M22.8,17.8 Q28,16.2 32.6,17.6 M22.8,21.0 Q28,19.4 32.6,20.8'{S(D)}/>"
        f"<path d='M27.2,22.8 L27.2,27.6 L28.4,26.6 L29.6,27.6 L29.6,22.6'{F}/>"
        f"<path d='M3,35.6 q2.8,-2.2 5.6,0 q2.8,-2.2 5.6,0 q2.8,-2.2 5.6,0 q2.8,-2.2 5.6,0 q2.8,-2.2 5.6,0 q2.8,-2.2 5.6,0'{S(D)}/>"
    )
    # Kanazawa 2022, autumn: a seven-lobed maple leaf with veins over the snow-capped Alps
    def maple_leaf(scale):
        pts = []
        spec = ((-90, 8.0), (-56, 7.6), (-22, 6.4), (12, 5.0), (168, 5.0), (202, 6.4), (236, 7.6))
        order = [3, 2, 1, 0, 6, 5, 4]
        for idx in order:
            a, R = spec[idx]
            for da, rr in ((15.5, 0.38), (12, 0.6), (9.5, 0.76), (6.5, 0.72), (3.5, 0.9), (0, 1.0), (-3.5, 0.9), (-6.5, 0.72), (-9.5, 0.76), (-12, 0.6), (-15.5, 0.38)):
                ang = math.radians(a + da)
                pts.append((rr * R * scale * math.cos(ang), rr * R * scale * math.sin(ang)))
        leaf = "M" + " L".join(f"{f(x)},{f(y)}" for x, y in pts) + " Z"
        vs = "".join(f"<path d='M0,0 L{f(0.8*R*scale*math.cos(math.radians(a)))},{f(0.8*R*scale*math.sin(math.radians(a)))}' stroke='{GROUND}' stroke-width='0.32' stroke-linecap='round'/>" for a, R in spec)
        return f"<path d='{leaf}'{F}/>{vs}<path d='M0,0 Q0.6,{f(3.6*scale)} 2.0,{f(5.6*scale)}'{S(1.1)}/>"
    arts["maple"] = (
        f"<path d='M1.6,35.4 L9.4,25.6 L13.4,29.4 L21.4,20.4 L26.4,25.6 L29.6,22.8 L38.4,35.4'{S(M)}/>"
        f"<path d='M18.8,23.4 L21.4,20.4 L24.0,23.2 L22.6,22.6 L21.4,23.8 L20.2,22.4 Z'{F}/><path d='M7.8,27.6 L9.4,25.6 L10.9,27.0 L9.6,26.7 Z'{F}/>"
        f"<path d='M8,35.4 L11,31.8 L14,35.4 M24,35.4 L27.6,31.0 L31.6,35.4'{S(D)}/>"
        f"<g transform='translate(20,11.2) rotate(-6)'>{maple_leaf(1.2)}</g>"
    )    # Sapporo 2024, winter: a dendrite snow crystal over snowy hills and falling flakes
    flake = ""
    for a in range(0, 360, 60):
        flake += (f"<g transform='rotate({a})'><path d='M0,0 L0,-9.2'{S(1.3)}/>"
                  f"<path d='M-2.6,-6.6 L0,-4.4 L2.6,-6.6 M-1.9,-8.9 L0,-7.4 L1.9,-8.9'{S(D)}/>"
                  f"<circle cx='0' cy='-9.4' r='0.55'{F}/></g>")
    arts["snow"] = (
        f"<g transform='translate(20,12.0)'>{flake}<path d='M0,-2 L1.73,-1 L1.73,1 L0,2 L-1.73,1 L-1.73,-1 Z'{F}/></g>"
        f"<path d='M1.4,35.6 Q8.6,26.2 15.2,29.4 Q22,23.2 29,28.4 Q34.2,26.0 38.6,35.6'{S(M)}/>"
        f"<path d='M7.6,33.4 Q9.4,32.4 11.2,33.4 M19.6,31.6 Q21.6,30.6 23.6,31.6 M28.2,33.8 Q29.8,32.8 31.4,33.8'{S(D)}/>"
        + "".join(f"<circle cx='{cx}' cy='{cy}' r='{r}'{F}/>" for cx, cy, r in ((5, 8, 0.8), (35, 6, 0.7), (33.6, 15.6, 0.6), (6.4, 18.4, 0.6), (3.6, 24.4, 0.5), (36.4, 22.6, 0.5)))
    )
    # Hakone 2026, co-led: the group behind the leader's flag by the lake, Fuji beyond
    g = ""
    for (x, hgt, pose, lug, dress) in ((5.6, 9.2, "pull", "roller", True), (10.6, 10.2, "walk", "pack", False), (15.4, 9.4, "strap", "bag", True), (20.6, 10.0, "walk", None, False)):
        g += person(x, 33.6, hgt, k, pose=pose, luggage=lug, dress=dress, stride=0.8)
    g += person(28.6, 33.6, 10.8, k, pose="flag", flag=k, stride=1.0)
    arts["flag"] = (
        f"<path d='M2,17.8 Q9,16.2 12.6,6.8 L17.4,6.8 Q21,16.2 28,17.8'{S(D)}/>"
        f"<path d='M12.6,6.8 L17.4,6.8 L18.6,9.6 L16.6,8.8 L15,10.4 L13.4,8.8 L11.4,9.6 Z'{F}/>"
        f"<path d='M2,35.4 L38,35.4'{S(D)}/>" + g.replace(GROUND, GROUND)
    )
    # the national seal: Fuji with strata, the sun, waves
    arts["fuji"] = (
        f"<circle cx='30' cy='8.6' r='4.4'{F}/>"
        f"<path d='M2.6,30.2 Q13.2,26.6 16.6,10.2 L23.4,10.2 Q26.8,26.6 37.4,30.2'{S(1.6)}/>"
        f"<path d='M16.6,10.2 L23.4,10.2 L25.0,15.0 L23.4,13.8 L22.0,16.6 L20.2,13.6 L18.4,16.4 L17.0,13.8 L15.0,15.0 Z'{F}/>"
        f"<path d='M9.6,25.6 Q15,24.2 18,20.4 M30.4,25.6 Q25,24.2 22,20.4'{S(D)}/>"
        f"<path d='M2.4,35.4 q3.5,-2.6 7,0 q3.5,-2.6 7,0 q3.5,-2.6 7,0 q3.5,-2.6 7,0 q3.5,-2.6 7,0'{S(1.2)}/>"
    )
    for key, body in arts.items():
        write(f"stamp-{key}.svg", f"<g id='art'>{body}</g>", "0 0 40 40")


# =================================================== profile icons (24) =====
def icons():
    def W(w=1.8, extra=""):
        return f" fill='none' stroke='{ICON}' stroke-width='{w}' stroke-linecap='round' stroke-linejoin='round'{extra}"
    S = W()
    DOTS = " stroke-dasharray='0.1 2.7'"
    HALF = " stroke-opacity='0.5'"
    F = f" fill='{ICON}'"
    out = {
        # all seasons: a blossom, a sun ray, a leaf and a flake around one circle
        "seasons": (f"<circle cx='12' cy='12' r='9.6'{W(1.5)}/>"
                    + "".join(f"<circle cx='{f(12+9.6*math.cos(math.radians(a)))}' cy='{f(12+9.6*math.sin(math.radians(a)))}' r='1.5'{F}/>" for a in (-90, 0, 90, 180))
                    + "".join(f"<path d='{petal_path(4.6, 0.8)}' transform='translate(12,12) rotate({a})'{F}/>" for a in range(0, 360, 72))
                    + f"<circle cx='12' cy='12' r='1.1' fill='{GROUND}'/>"),
        # co-leading: the leader's flag over two travellers
        "flag": (f"<path d='M17.4,2.2 L17.4,21.6'{W(1.6)}/><path d='M17.4,2.4 L23.4,4.6 L17.4,7.6 Z'{F}/>"
                 + f"<circle cx='5.6' cy='11.4' r='2.2'{F}/><path d='M2.0,22 C2.0,16.6 3.4,14.4 5.6,14.4 C7.8,14.4 9.2,16.6 9.2,22 Z'{F}/>"
                 + f"<circle cx='12.6' cy='10.4' r='2.3'{F}/><path d='M8.8,22 C8.8,16 10.4,13.6 12.6,13.6 C14.8,13.6 16.0,15.4 16.2,17.4 L17.4,14.6' {F}/>"
                 + f"<path d='M10.2,22 L10.2,17 M15,22 L15,17'{W(0.1)}/>"),        # precision: a clipboard with ticks
        "check": (f"<rect x='4.6' y='4.2' width='14.8' height='17' rx='1.8'{S}/><rect x='8.6' y='2.6' width='6.8' height='3.4' rx='1'{F}/>"
                  f"<path d='M7.6,11 L9,12.4 L11.4,9.8 M7.6,16.4 L9,17.8 L11.4,15.2'{W(1.2)}/><path d='M13.4,11.2 L16.6,11.2 M13.4,16.6 L16.6,16.6'{W(1.2)}/>"),
        # availability: a calendar page with departures in a row
        "calendar": (f"<rect x='3.4' y='5' width='17.2' height='15.6' rx='1.8'{S}/><path d='M3.4,9.6 L20.6,9.6'{S}/><path d='M8,3 L8,6.6 M16,3 L16,6.6'{S}/>"
                     f"<path d='M6.6,15.2 L17.4,15.2'{W(1.1, DOTS)}/><path d='M14.8,13.2 L17.4,15.2 L14.8,17.2'{W(1.2)}/>"),
    }
    for key, body in out.items():
        write(f"icon-{key}.svg", f"<g id='art'>{body}</g>", "0 0 24 24")


# =============================================== background pieces ===========
def background():
    SW = f" fill='{BGF}' stroke='{BGS}' stroke-width='0.7' stroke-linejoin='round' stroke-linecap='round'"
    LN = f" fill='none' stroke='{BGS}' stroke-width='0.7' stroke-linecap='round'"
    LT = f" fill='none' stroke='{BGS}' stroke-width='0.45' stroke-linecap='round'"

    def seigaiha(name, w, h, r=4.2):
        s = "<g id='art'>"
        row = 0
        y = -r * 0.5
        while y < h + r:
            off = (r if row % 2 else 0)
            x = -r + off
            while x < w + 2 * r:
                for i, rr in enumerate((r, r * 0.74, r * 0.5, r * 0.26)):
                    s += f"<circle cx='{f(x)}' cy='{f(y)}' r='{f(rr)}' fill='{BAND if i == 0 else 'none'}' stroke='{BGS}' stroke-width='0.42'/>"
                x += 2 * r
            y += r * 0.5
            row += 1
        write(name, s + "</g>", f"0 0 {w} {h}")

    def seigaiha_band(name, w, h, r=4.2, fade=None):
        """Seigaiha whose top row is complete arcs (centres at y = r), so the band's top edge
        is a clean scalloped line; `fade` (start, end as fractions of w) fades the right end."""
        s = ""
        if fade:
            s += (f"<defs><linearGradient id='fh' gradientUnits='userSpaceOnUse' x1='{f(w*fade[0])}' y1='0' x2='{f(w*fade[1])}' y2='0'>"
                  "<stop offset='0' stop-color='#ffffff'/><stop offset='1' stop-color='#000000'/></linearGradient>"
                  f"<mask id='mf' maskUnits='userSpaceOnUse' x='0' y='0' width='{w}' height='{h}'><rect width='{w}' height='{h}' fill='url(#fh)'/></mask></defs>")
        s += "<g id='art'" + (" mask='url(#mf)'" if fade else "") + ">"
        row, y = 0, r
        while y - r < h:
            off = r if row % 2 else 0
            x = off - 2 * r if off else 0
            while x < w + 2 * r:
                for i, rr in enumerate((r, r * 0.74, r * 0.5, r * 0.26)):
                    s += f"<circle cx='{f(x)}' cy='{f(y)}' r='{f(rr)}' fill='{BAND if i == 0 else 'none'}' stroke='{BGS}' stroke-width='0.42'/>"
                x += 2 * r
            y += r * 0.5
            row += 1
        write(name, s + "</g>", f"0 0 {w} {h}")

    seigaiha_band("bg-seigaiha-band.svg", 210, 23)
    seigaiha_band("bg-seigaiha-p2.svg", 100, 8, r=3.4, fade=(0.45, 1.0))
    # Shinkansen, side view, nose to the left
    s = (f"<g id='art'><path d='M2,10.6 C4.6,6.8 10,4.2 18,3.8 L68,3.8 L68,12.4 L5.2,12.4 C3.4,12.4 1.4,11.8 2,10.6 Z'{SW}/>"
         f"<path d='M10.6,5.6 C12.6,4.9 15,4.6 17.4,4.6 L17.4,7.2 L9.2,7.2 Z'{LN}/>"
         + "".join(f"<rect x='{x}' y='5.2' width='2.6' height='1.9' rx='0.5'{LN}/>" for x in range(21, 66, 4))
         + f"<path d='M3.6,9.4 L68,9.4'{LN}/><path d='M30,4.6 L30,11.6 M52,4.6 L52,11.6'{LN}/>"
         + "".join(f"<circle cx='{x}' cy='13.4' r='1.1'{SW}/>" for x in (12, 16, 40, 44, 60, 64))
         + f"<path d='M0,15.2 L70,15.2'{LN}/></g>")
    write("bg-shinkansen.svg", s, "0 0 70 16")
    # a pair of paper lanterns on a cord
    s = f"<g id='art'><path d='M0,1.6 Q14,5 28,1.6'{LN}/>"
    for cx, cy, sc in ((8, 4.6, 1.0), (20.4, 4.0, 0.86)):
        s += f"<g transform='translate({cx},{cy}) scale({sc})'><path d='M0,0 L0,1.4'{LN}/><rect x='-2.2' y='1.4' width='4.4' height='1.4' rx='0.3'{SW}/>"
        s += f"<path d='M-2.2,2.8 C-5.4,4.6 -5.4,12.4 -2.2,14.2 L2.2,14.2 C5.4,12.4 5.4,4.6 2.2,2.8 Z'{SW}/>"
        s += "".join(f"<path d='M{f(-4.5+abs(y-8.5)*0.4)},{y} L{f(4.5-abs(y-8.5)*0.4)},{y}'{LT}/>" for y in (5, 6.8, 8.5, 10.2, 12))
        s += f"<rect x='-2.2' y='14.2' width='4.4' height='1.4' rx='0.3'{SW}/><path d='M0,15.6 L0,17.8 M-0.6,17.8 L0.6,17.8'{LN}/></g>"
    write("bg-lanterns.svg", s + "</g>", "0 0 28 20")
    # folding fan (sensu), open
    s = "<g id='art'>"
    cx, cy, R, r0 = 17, 17, 16, 4.6
    a0, a1, n = 200, 340, 12
    pts = [(cx + R * math.cos(math.radians(a0 + (a1 - a0) * i / n)), cy + R * math.sin(math.radians(a0 + (a1 - a0) * i / n))) for i in range(n + 1)]
    inner = [(cx + r0 * math.cos(math.radians(a0 + (a1 - a0) * i / n)), cy + r0 * math.sin(math.radians(a0 + (a1 - a0) * i / n))) for i in range(n + 1)]
    d = f"M{f(inner[0][0])},{f(inner[0][1])} L{f(pts[0][0])},{f(pts[0][1])} A{R},{R} 0 0 1 {f(pts[-1][0])},{f(pts[-1][1])} L{f(inner[-1][0])},{f(inner[-1][1])} A{r0},{r0} 0 0 0 {f(inner[0][0])},{f(inner[0][1])} Z"
    s += f"<path d='{d}'{SW}/>"
    for i in range(1, n):
        s += f"<path d='M{f(inner[i][0])},{f(inner[i][1])} L{f(pts[i][0])},{f(pts[i][1])}'{LT}/>"
    s += f"<path d='M{f(cx)},{f(cy)} L{f(inner[0][0])},{f(inner[0][1])} M{f(cx)},{f(cy)} L{f(inner[-1][0])},{f(inner[-1][1])}'{LN}/><circle cx='{cx}' cy='{cy}' r='0.9'{SW}/>"
    write("bg-fan.svg", s + "</g>", "0 0 34 19")
    # five-storey pagoda
    s = "<g id='art'><path d='M15,1 L15,7'" + LN + "/>" + "".join(f"<circle cx='15' cy='{y}' r='0.7'{SW}/>" for y in (2.6, 4.2, 5.8))
    y = 7
    for i in range(5):
        half = 7.6 + i * 1.5
        body = 3.4 + i * 0.6
        s += f"<path d='M{f(15-half)},{f(y+2.6)} Q{f(15-half*0.55)},{f(y+1.6)} {f(15-body)},{f(y)} L{f(15+body)},{f(y)} Q{f(15+half*0.55)},{f(y+1.6)} {f(15+half)},{f(y+2.6)} Q{f(15)},{f(y+2.0)} {f(15-half)},{f(y+2.6)} Z'{SW}/>"
        s += f"<rect x='{f(15-body*0.8)}' y='{f(y+2.4)}' width='{f(body*1.6)}' height='3.2'{SW}/>"
        y += 5.6
    s += f"<rect x='{f(15-6.4)}' y='{f(y+0.2)}' width='12.8' height='1.6'{SW}/></g>"
    write("bg-pagoda.svg", s, f"0 0 30 {f(y+2.4)}")


# ========================================================================= main
if __name__ == "__main__":
    # Branches, each drawn into the frame it occupies on the page (mm); seeds picked by eye.
    window_svg("sakura-canopy.svg", 1141, (84, 2), math.radians(177), 60, 3.4, (0, 0, 80, 16), {"top", "right"}, min_blossoms=11)
    window_svg("sakura-field-2.svg", 4248, (92, 6), math.radians(176), 70, 4.0, (0, 0, 90, 20), {"right"}, min_blossoms=11)

    # Petals in flight, page coordinates (mm). Keep-outs mirror the page plan in ../hanami.typ:
    # every text block, the portrait, seal, plate, group and Fuji, and the background pieces.
    page_petals("petals-p1", 86,
        [(14, 15, 63, 41), (142, 15, 196, 41), (80, 9, 131, 61), (113, 39, 139, 64), (16, 40, 66, 63), (146, 38, 195, 63),
         (13, 64, 37, 84), (166, 64, 197, 84), (53, 59, 157, 96),                       # band
         (15, 95.8, 130, 106.3), (130, 94.3, 195, 109.8), (15, 111.8, 195, 131.8),    # profile
         (15, 132.8, 140, 150.8), (137, 132.8, 208, 150.8), (15, 149.8, 195, 208.3),   # 01, Shinkansen, stamps
         (15, 211.8, 137, 228.5), (164, 208.8, 194, 230.8), (15, 227, 195, 283), (15, 283, 195, 292)],
        [((178, 9), (150, 2), (110, 18), (60, 6), 18, 3.0, 2.2),        # off the canopy, across the top of the band
         ((204, 14), (209, 60), (196, 150), (205, 296), 12, 2.8, 2.0),  # down the right edge, thinned
         ((8, 6), (2, 100), (12, 200), (5, 295), 10, 2.4, 2.0),         # down the left edge, thinned
         ((42, 60), (48, 74), (38, 88), (26, 96), 5, 2.4, 2.0),         # across the band edge, left of the plate
         ((160, 60), (164, 72), (162, 86), (180, 93), 5, 2.4, 2.0),     # across the band edge, right of the plate
         ((22, 108.4), (58, 111.2), (96, 107.6), (126, 110.4), 3, 2.0, 1.7),    # drifting over the profile rule
         ((24, 210.2), (80, 209.6), (130, 211.0), (190, 210.2), 6, 1.6, 1.4),   # between the stamps and section 02
         ((205, 198), (185, 212), (160, 220), (140, 224), 5, 2.4, 1.8)],        # into the gap by heading 02
        scatter=8, seed=23, distant=6)
    page_petals("petals-p2", 46,
        [(14, 6, 104, 39), (147, 3, 197, 15), (100, 16, 197, 44),                    # band
         (15, 55, 116, 73), (119, 47, 210, 69), (15, 73, 195, 148),                    # 03, branch, table, strip, note
         (15, 152, 151, 170), (158, 149, 196, 170), (15, 169, 119, 220), (121, 169, 197, 223.5),   # 04, fan
         (15, 227, 151, 245), (15, 223.5, 31, 245), (166, 221, 192, 246), (15, 245, 195, 276), (15, 283, 195, 292)],     # 05, pagoda, lists
        [((150, 6), (136, 0), (118, 14), (100, 6), 9, 2.8, 2.0),
         ((204, 4), (209, 30), (198, 52), (205, 74), 4, 2.8, 2.4),       # right edge, down to the table
         ((205, 150), (209, 200), (196, 250), (205, 296), 7, 2.4, 2.0),  # right edge, from section 04 down (thin run beside 03)
         ((6, 4), (2, 100), (12, 200), (5, 295), 9, 2.4, 2.0),
         ((60, 42), (80, 40), (96, 50), (112, 52), 6, 2.2, 1.8),        # across the band edge
         ((36, 223.4), (64, 223.0), (92, 224.0), (117, 223.4), 5, 1.9, 1.6),  # between sections 04 and 05, left half
         ((30, 279.5), (90, 279), (140, 280), (190, 279.5), 4, 1.6, 1.4)],
        scatter=7, seed=47, distant=5)

    torii("torii.svg")
    group("group.svg")
    fuji("fuji.svg")
    plane("plane.svg")
    stamp_art()
    icons()
    background()
    print("ok")
