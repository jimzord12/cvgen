"""Hanami Line artwork generator (magazine-editor, 2026-10-02).

Writes every SVG in this folder. All drawing is original: procedural cherry
branches (zigzag nodes, tapering bark, five-petal notched blossoms, buds,
drifting petals), a torii, a tour group following its leader's flag, Mount
Fuji, a plane, and six single-ink eki-style stamp drawings. Nothing is traced.

Colours are the light-field defaults; the Typst file swaps them by string
replacement for the dark hero (see `recolor` in spacious-stylish.typ).

    python design-concepts/2026-10-02-hanami-line/assets/make_assets.py
"""
import math
import os
import random

HERE = os.path.dirname(os.path.abspath(__file__))

BARK = "#5e4a55"
PETAL = "#f2c2cd"
EDGE = "#d4869c"
HEART = "#b0405f"
GOLD = "#c9a86a"
INK = "#c23a2b"   # cinnabar, the one stamp ink
FLAG = "#d2462f"


def f(x):
    return f"{x:.2f}".rstrip("0").rstrip(".")


def write(name, body, vb):
    path = os.path.join(HERE, name)
    with open(path, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(f"<svg xmlns='http://www.w3.org/2000/svg' viewBox='{vb}'>{body}</svg>\n")


# ---------------------------------------------------------------- smoothing --
def smooth_open(pts):
    """Catmull-Rom through pts -> cubic Bezier path commands (no initial M)."""
    out = []
    for i in range(len(pts) - 1):
        p0 = pts[i - 1] if i > 0 else pts[i]
        p1, p2 = pts[i], pts[i + 1]
        p3 = pts[i + 2] if i + 2 < len(pts) else p2
        c1 = (p1[0] + (p2[0] - p0[0]) / 6, p1[1] + (p2[1] - p0[1]) / 6)
        c2 = (p2[0] - (p3[0] - p1[0]) / 6, p2[1] - (p3[1] - p1[1]) / 6)
        out.append(f"C{f(c1[0])},{f(c1[1])} {f(c2[0])},{f(c2[1])} {f(p2[0])},{f(p2[1])}")
    return " ".join(out)


# ----------------------------------------------------------------- blossoms --
def petal_path(r):
    """One notched cherry petal pointing up (-y), base at the origin."""
    k = r / 6.4
    pts = [
        "M0,0",
        f"C{f(2.4*k)},{f(-1.0*k)} {f(3.4*k)},{f(-3.6*k)} {f(2.3*k)},{f(-5.9*k)}",
        f"Q{f(1.4*k)},{f(-6.7*k)} {f(0.5*k)},{f(-6.3*k)}",
        f"L0,{f(-5.3*k)}",
        f"L{f(-0.5*k)},{f(-6.3*k)}",
        f"Q{f(-1.4*k)},{f(-6.7*k)} {f(-2.3*k)},{f(-5.9*k)}",
        f"C{f(-3.4*k)},{f(-3.6*k)} {f(-2.4*k)},{f(-1.0*k)} 0,0Z",
    ]
    return " ".join(pts)


def blossom(x, y, r, rot, squash, rng, petal=PETAL, edge=EDGE, heart=HEART, sw=0.16):
    s = f"<g transform='translate({f(x)},{f(y)}) rotate({f(rot)}) scale(1,{f(squash)})'>"
    pp = petal_path(r)
    for i in range(5):
        a = i * 72 + rng.uniform(-6, 6)
        s += f"<path d='{pp}' transform='rotate({f(a)})' fill='{petal}' stroke='{edge}' stroke-width='{f(sw)}'/>"
    # stamens
    n = 7
    for i in range(n):
        a = math.radians(i * 360 / n + rng.uniform(-10, 10))
        rr = r * rng.uniform(0.38, 0.52)
        ex, ey = rr * math.cos(a), rr * math.sin(a)
        s += f"<line x1='0' y1='0' x2='{f(ex)}' y2='{f(ey)}' stroke='{heart}' stroke-width='{f(sw*0.9)}'/>"
        s += f"<circle cx='{f(ex)}' cy='{f(ey)}' r='{f(r*0.055)}' fill='{heart}'/>"
    s += f"<circle cx='0' cy='0' r='{f(r*0.17)}' fill='{heart}'/>"
    return s + "</g>"


def bud(x, y, r, ang, petal=PETAL, edge=EDGE, bark=BARK, sw=0.16):
    deg = math.degrees(ang) + 90
    return (f"<g transform='translate({f(x)},{f(y)}) rotate({f(deg)})'>"
            f"<path d='M0,0 C{f(r*0.9)},{f(-r*0.6)} {f(r*0.7)},{f(-r*1.9)} 0,{f(-r*2.3)} C{f(-r*0.7)},{f(-r*1.9)} {f(-r*0.9)},{f(-r*0.6)} 0,0Z' fill='{edge}' stroke='{edge}' stroke-width='{f(sw)}'/>"
            f"<path d='M{f(-r*0.55)},{f(-r*0.15)} Q0,{f(r*0.5)} {f(r*0.55)},{f(-r*0.15)}' fill='{bark}'/></g>")


def loose_petal(x, y, r, rot, squash, petal=PETAL, edge=EDGE, sw=0.16):
    return (f"<g transform='translate({f(x)},{f(y)}) rotate({f(rot)}) scale(1,{f(squash)})'>"
            f"<path d='{petal_path(r)}' transform='translate(0,{f(r*0.45)})' fill='{petal}' stroke='{edge}' stroke-width='{f(sw)}'/></g>")


# ------------------------------------------------------------------- branch --
class Tree:
    def __init__(self, seed):
        self.rng = random.Random(seed)
        self.bark = []      # path strings
        self.flowers = []   # (x, y, r, kind, extra)
        self.pts = []       # every spine point, for the bounding box

    def limb(self, x, y, ang, length, w0, w1, depth, sign=1):
        rng = self.rng
        n = max(4, int(length / 3.2))
        step = length / n
        pts, ws, angs = [(x, y)], [w0], [ang]
        a = ang
        nodes = []
        for i in range(1, n + 1):
            if i % 2 == 0:      # zigzag at the nodes, as cherry wood grows
                sign = -sign
                a += sign * rng.uniform(0.18, 0.42)
                nodes.append(i)
            a += rng.uniform(-0.07, 0.07)
            x += step * math.cos(a)
            y += step * math.sin(a)
            t = i / n
            w = w0 + (w1 - w0) * t
            if i in nodes:
                w *= 1.12      # a knuckle at each node
            pts.append((x, y))
            ws.append(w)
            angs.append(a)
        # outline
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
        # bark texture: a few short lengthwise strokes on thick limbs
        if w0 > 1.6:
            for i in range(1, len(pts) - 1, 2):
                px, py = pts[i]
                aa = angs[i]
                off = rng.uniform(-0.25, 0.25) * ws[i]
                nx, ny = -math.sin(aa), math.cos(aa)
                sx, sy = px + nx * off, py + ny * off
                L = rng.uniform(1.5, 3.2)
                self.bark.append(("line", sx, sy, sx + math.cos(aa) * L, sy + math.sin(aa) * L, ws[i] * 0.08))
        self.pts.extend(pts)
        # children: few, alternating sides, so the branch keeps its gesture
        if depth > 0:
            side = rng.choice([-1, 1])
            for i in range(3, n - 1, 3 if depth > 1 else 4):
                if rng.random() < (0.85 if depth > 1 else 0.6):
                    side = -side
                    ca = angs[i] + side * rng.uniform(0.5, 0.85)
                    cl = (length - i * step) * rng.uniform(0.35, 0.55) + 5
                    self.limb(pts[i][0], pts[i][1], ca, cl, ws[i] * 0.55, 0.3, depth - 1, side)
        # flowers sit on the thin wood: small clusters at nodes, a bud at the tip
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

    def svg(self, petal=PETAL, edge=EDGE, heart=HEART, bark=BARK):
        rng = self.rng
        s = "<g id='art' opacity='1.00'>"
        for item in self.bark:
            if isinstance(item, tuple):
                _, x1, y1, x2, y2, w = item
                s += f"<line x1='{f(x1)}' y1='{f(y1)}' x2='{f(x2)}' y2='{f(y2)}' stroke='#f6efe2' stroke-opacity='0.35' stroke-width='{f(max(w,0.12))}' stroke-linecap='round'/>"
            else:
                s += f"<path d='{item}' fill='{bark}'/>"
        # stalks first, then blossoms on top
        for (x, y, r, kind, extra) in self.flowers:
            if kind == "flower":
                ox, oy = extra
                s += f"<line x1='{f(ox)}' y1='{f(oy)}' x2='{f(x)}' y2='{f(y)}' stroke='{bark}' stroke-width='0.22'/>"
        for (x, y, r, kind, extra) in self.flowers:
            if kind == "bud":
                s += bud(x, y, r, extra, petal, edge, bark)
        for (x, y, r, kind, extra) in sorted(self.flowers, key=lambda t: t[2]):
            if kind == "flower":
                s += blossom(x, y, r, rng.uniform(0, 72), rng.choice([1, 1, 0.92, 0.8, 0.7]), rng, petal, edge, heart)
        return s


def window_svg(name, seed, start, ang, length, w0, window, open_edges, petals=(), depth=2, min_blossoms=8, tries=400):
    """A branch seen through a fixed frame (x0, y0, w, h) that sits flush with a page
    or band edge. Only the `open_edges` (the page or band edge) may cut the drawing:
    wood never crosses a closed edge, and a blossom that would be sliced by one is
    left out. Seeds are tried upwards from `seed` until one passes."""
    x0, y0, w, h = window
    m = 0.6

    def closed_ok(x, y, r):
        if "left" not in open_edges and x - r < x0 + m: return False
        if "right" not in open_edges and x + r > x0 + w - m: return False
        if "top" not in open_edges and y - r < y0 + m: return False
        if "bottom" not in open_edges and y + r > y0 + h - m: return False
        return True

    for s in range(seed, seed + tries):
        t = Tree(s)
        t.limb(start[0], start[1], ang, length, w0, 0.5, depth)
        if not all(closed_ok(x, y, 0.8) for (x, y) in t.pts):
            continue
        t.flowers = [fl for fl in t.flowers if closed_ok(fl[0], fl[1], fl[2] * (1.15 if fl[3] == "flower" else 2.4))]
        inside = sum(1 for fl in t.flowers if fl[3] == "flower" and x0 <= fl[0] <= x0 + w and y0 <= fl[1] <= y0 + h)
        if inside < min_blossoms:
            continue
        body = t.svg()
        rng = random.Random(s + 99)
        for (x, y, r) in petals:
            body += loose_petal(x, y, r, rng.uniform(0, 360), rng.uniform(0.55, 1.0))
        body += "</g>"
        print(f"{name}: seed {s}  window {window}  open {sorted(open_edges)}  blossoms {inside}")
        write(name, body, f"{x0} {y0} {w} {h}")
        return s
    raise SystemExit(f"{name}: no seed in {seed}..{seed + tries} keeps the wood inside the closed edges")

# ------------------------------------------------------------- hero drawings --
def torii(name, w=80, h=58, stroke=GOLD, sw=0.5):
    """Myojin torii outline, pillars at x 12..17 and w-17..w-12 (mm)."""
    c = w / 2
    S = f" fill='none' stroke='{stroke}' stroke-width='{f(sw)}' stroke-linejoin='round'"
    s = "<g id='art' opacity='1.00'>"
    # kasagi with upswept ends (sori), and shimaki beneath it
    s += f"<path d='M0,1.2 Q{f(c)},7.6 {w},1.2 L{f(w-1.4)},5.2 Q{f(c)},10.6 1.4,5.2 Z'{S}/>"
    s += f"<path d='M5,6.5 Q{f(c)},11.6 {f(w-5)},6.5 L{f(w-5.4)},9.2 Q{f(c)},14.2 5.4,9.2 Z'{S}/>"
    # gakuzuka (centre strut)
    s += f"<path d='M{f(c-2.2)},12.3 L{f(c+2.2)},12.3 L{f(c+2.2)},18 L{f(c-2.2)},18'{S}/>"
    # nuki (tie beam), runs through the pillars
    s += f"<path d='M4,18 L{f(w-4)},18 L{f(w-4)},21.2 L4,21.2 Z'{S}/>"
    # pillars, a little wider at the foot (outward lean), kamebara bases
    for x0 in (12, w - 17):
        lean = -1.2 if x0 < c else 1.2   # uchikorobi: the feet stand wider than the tops
        b0, b1 = x0 + lean, x0 + 5 + lean
        s += f"<path d='M{f(x0)},9.6 L{f(x0+5)},9.6 L{f(b1)},{f(h-3)} L{f(b0)},{f(h-3)} Z'{S}/>"
        s += f"<path d='M{f(b0-1.2)},{f(h-3)} L{f(b1+1.2)},{f(h-3)} L{f(b1+0.8)},{h} L{f(b0-0.8)},{h} Z'{S}/>"
        # a second inner hairline on each pillar: the craft of a drawn line
        s += f"<line x1='{f(x0+2.5)}' y1='22.4' x2='{f(x0+2.5+lean*0.85)}' y2='{f(h-4.2)}' stroke='{stroke}' stroke-width='{f(sw*0.45)}' stroke-opacity='0.7'/>"
    s += "</g>"
    write(name, s, f"0 0 {w} {h}")


def figure(x, base, hgt, fill, case=None, flag=None, step=0):
    """A walking traveller seen from the side, facing +x. Returns svg."""
    k = hgt / 12.0
    hx, hy = x + 0.3 * k, base - 10.6 * k
    s = f"<circle cx='{f(hx)}' cy='{f(hy)}' r='{f(1.35*k)}' fill='{fill}'/>"
    # coat / torso (a soft bell)
    s += (f"<path d='M{f(x-1.6*k)},{f(base-4.2*k)} C{f(x-1.7*k)},{f(base-7.4*k)} {f(x-1.2*k)},{f(base-8.9*k)} {f(x+0.2*k)},{f(base-8.9*k)} "
          f"C{f(x+1.6*k)},{f(base-8.9*k)} {f(x+1.9*k)},{f(base-7.0*k)} {f(x+1.8*k)},{f(base-4.2*k)} Z' fill='{fill}'/>")
    # legs, mid-stride
    sw = 0.95 * k
    s += f"<line x1='{f(x-0.6*k)}' y1='{f(base-4.4*k)}' x2='{f(x-1.6*k - step*k)}' y2='{f(base)}' stroke='{fill}' stroke-width='{f(sw)}' stroke-linecap='round'/>"
    s += f"<line x1='{f(x+0.7*k)}' y1='{f(base-4.4*k)}' x2='{f(x+1.6*k + step*k)}' y2='{f(base)}' stroke='{fill}' stroke-width='{f(sw)}' stroke-linecap='round'/>"
    if case == "roll":   # a roller case pulled behind
        cx = x - 4.6 * k
        s += f"<rect x='{f(cx-1.5*k)}' y='{f(base-4.6*k)}' width='{f(3.0*k)}' height='{f(4.2*k)}' rx='{f(0.5*k)}' fill='{fill}'/>"
        s += f"<line x1='{f(cx+1.0*k)}' y1='{f(base-4.6*k)}' x2='{f(x-1.4*k)}' y2='{f(base-6.6*k)}' stroke='{fill}' stroke-width='{f(0.4*k)}' stroke-linecap='round'/>"
        s += f"<circle cx='{f(cx-0.8*k)}' cy='{f(base-0.2*k)}' r='{f(0.45*k)}' fill='{fill}'/><circle cx='{f(cx+0.8*k)}' cy='{f(base-0.2*k)}' r='{f(0.45*k)}' fill='{fill}'/>"
    if case == "pack":   # a small backpack
        s += f"<rect x='{f(x-2.9*k)}' y='{f(base-8.4*k)}' width='{f(1.6*k)}' height='{f(3.4*k)}' rx='{f(0.5*k)}' fill='{fill}'/>"
    if flag:             # the leader raises the group flag
        px = x + 2.3 * k
        s += f"<line x1='{f(x+1.2*k)}' y1='{f(base-6.4*k)}' x2='{f(px)}' y2='{f(base-7.4*k)}' stroke='{fill}' stroke-width='{f(0.7*k)}' stroke-linecap='round'/>"
        s += f"<line x1='{f(px)}' y1='{f(base-3.0*k)}' x2='{f(px)}' y2='{f(base-17.5*k)}' stroke='{fill}' stroke-width='{f(0.42*k)}' stroke-linecap='round'/>"
        s += (f"<path d='M{f(px)},{f(base-17.5*k)} C{f(px+2.4*k)},{f(base-18.3*k)} {f(px+3.8*k)},{f(base-16.4*k)} {f(px+6.4*k)},{f(base-16.9*k)} "
              f"L{f(px+6.0*k)},{f(base-13.6*k)} C{f(px+3.6*k)},{f(base-13.2*k)} {f(px+2.2*k)},{f(base-14.8*k)} {f(px)},{f(base-14.0*k)} Z' fill='{flag}'/>")
    return s


def group(name, fill=GOLD, flag=FLAG):
    """Six travellers with cases following the leader's flag, facing right."""
    base = 20
    s = "<g id='art' opacity='1.00'>"
    spec = [(6.5, 10.6, "roll", 0.3), (13.6, 11.6, None, -0.2), (19.4, 10.2, "pack", 0.4),
            (26.4, 11.3, "roll", -0.1), (32.4, 10.8, None, 0.3)]
    for (x, hgt, case, st) in spec:
        s += figure(x, base, hgt, fill, case=case, step=st)
    s += figure(40.5, base, 12.4, fill, flag=flag, step=0.35)
    s += "</g>"
    write(name, s, "0 0 50 21")


def fuji(name, stroke=GOLD, cap="#f3ead8", sw=0.45):
    w, h = 56, 26
    S = f" fill='none' stroke='{stroke}' stroke-width='{f(sw)}' stroke-linecap='round' stroke-linejoin='round'"
    s = "<g id='art' opacity='1.00'>"
    s += f"<circle cx='41' cy='7.5' r='4.6'{S}/>"   # the sun, as an outline
    # profile with concave slopes
    s += f"<path d='M1,25 C10,23.5 17,19 22.6,6.2 L33.4,6.2 C39,19 46,23.5 55,25'{S}/>"
    # snow cap with a torn lower edge
    s += (f"<path d='M22.6,6.2 L33.4,6.2 C34.6,8.8 35.6,10.6 36.6,12.2 L34.8,11.0 L33.4,13.6 L31.6,10.8 L29.6,14.2 L27.8,10.6 "
          f"L25.6,13.4 L24.2,10.6 L21.4,12.4 C22.0,10.6 22.0,9.0 22.6,6.2 Z' fill='{cap}' fill-opacity='0.92' stroke='{stroke}' stroke-width='{f(sw)}' stroke-linejoin='round'/>")
    # ridge lines
    for (x1, y1, x2, y2) in ((27.8, 14.6, 24.0, 22.6), (31.6, 15.2, 33.0, 23.4), (35.6, 15.0, 40.6, 22.2), (23.4, 15.6, 17.2, 21.6)):
        s += f"<line x1='{x1}' y1='{y1}' x2='{x2}' y2='{y2}' stroke='{stroke}' stroke-width='{f(sw*0.6)}' stroke-opacity='0.75' stroke-linecap='round'/>"
    s += "</g>"
    write(name, s, f"0 0 {w} {h}")


def plane(name, fill=INK):
    s = ("<g id='art' opacity='1.00'>"
         f"<path d='M1,6 L18.5,5.1 C21,5.1 22.4,5.6 22.4,6 C22.4,6.4 21,6.9 18.5,6.9 L1,6 Z' fill='{fill}'/>"
         f"<path d='M8.6,5.5 L14.2,5.3 L7.2,0.2 L5.2,0.2 Z' fill='{fill}'/>"
         f"<path d='M8.6,6.5 L14.2,6.7 L7.2,11.8 L5.2,11.8 Z' fill='{fill}'/>"
         f"<path d='M1.6,5.8 L4.6,5.7 L1.6,2.6 L0.4,2.6 Z' fill='{fill}'/>"
         f"<path d='M1.6,6.2 L4.6,6.3 L1.6,9.4 L0.4,9.4 Z' fill='{fill}'/>"
         "</g>")
    write(name, s, "0 0 23 12")


# --------------------------------------------------- stamp drawings (40x40) --
def stamp_art():
    k = INK
    def S(w):
        return f" fill='none' stroke='{k}' stroke-width='{w}' stroke-linecap='round' stroke-linejoin='round'"
    F = f" fill='{k}'"
    arts = {}
    # Kyoto 2018, spring: a torii with a blossom over it
    arts["torii"] = (
        f"<path d='M4,9.5 Q20,13.6 36,9.5 L35.2,13.2 Q20,16.8 4.8,13.2 Z'{F}/>"
        f"<path d='M7,17.2 L33,17.2'{S(1.7)}/>"
        f"<path d='M12.2,13.6 L11.2,35 M27.8,13.6 L28.8,35'{S(2.5)}/>"
        f"<path d='M20,14.8 L20,17.2'{S(1.4)}/>"
        f"<path d='M3,36 L37,36'{S(1)}/>"
        + "".join(f"<path d='{petal_path(2.6)}' transform='translate(31.5,4.6) rotate({a})'{F}/>" for a in range(0, 360, 72))
    )
    # Fukuoka 2019, study: an open book under a rising sun, a line of sea
    arts["book"] = (
        f"<path d='M5,29.5 Q12,26.8 20,30 Q28,26.8 35,29.5 L35,14 Q28,11.4 20,14.4 Q12,11.4 5,14 Z'{S(1.5)}/>"
        f"<path d='M20,14.4 L20,30'{S(1.3)}/>"
        f"<path d='M8,18 Q12,16.6 17,18.2 M8,21.6 Q12,20.2 17,21.8 M8,25.2 Q12,23.8 17,25.4 M23,18.2 Q28,16.6 32,18 M23,21.8 Q28,20.2 32,21.6'{S(0.85)}/>"
        f"<circle cx='20' cy='6.6' r='3.4'{F}/>"
        f"<path d='M4,35.5 q4,-2.4 8,0 q4,-2.4 8,0 q4,-2.4 8,0 q4,-2.4 8,0'{S(1.1)}/>"
    )
    # Kanazawa 2022, autumn: a maple leaf over the Alps
    lobes = []
    for i in range(7):
        a = math.radians(-90 + (i - 3) * 31)
        a1 = math.radians(-90 + (i - 3) * 31 - 9)
        a2 = math.radians(-90 + (i - 3) * 31 + 9)
        R = 7.6 if i in (2, 3, 4) else (6.2 if i in (1, 5) else 4.4)
        lobes.append((0.32 * R * math.cos(a1 - 0.14), 0.32 * R * math.sin(a1 - 0.14)))
        lobes.append((0.72 * R * math.cos(a1), 0.72 * R * math.sin(a1)))
        lobes.append((R * math.cos(a), R * math.sin(a)))
        lobes.append((0.72 * R * math.cos(a2), 0.72 * R * math.sin(a2)))
    leaf = "M" + " L".join(f"{f(x)},{f(y)}" for x, y in lobes) + " L0,1.6 Z"
    arts["maple"] = (
        f"<path d='M2,35 L10,24 L14.5,28.5 L22,18 L27,24 L30.5,20.5 L38,35'{S(1.5)}/>"
        f"<path d='M19.4,20.6 L22,18 L24.4,21.2'{S(1.2)}/>"
        f"<g transform='translate(20,10.6) scale(1.02)'><path d='{leaf}'{F}/><path d='M0,1.6 L0,5.4'{S(1)}/></g>"
    )
    # Sapporo 2024, winter: a snow crystal over snowy hills
    flake = ""
    for a in range(0, 360, 60):
        flake += (f"<g transform='rotate({a})'><path d='M0,0 L0,-8.6'{S(1.3)}/>"
                  f"<path d='M-2.4,-5.6 L0,-3.8 L2.4,-5.6 M-1.8,-8.2 L0,-6.8 L1.8,-8.2'{S(0.9)}/></g>")
    arts["snow"] = (
        f"<g transform='translate(20,12.4)'>{flake}<circle r='1.3'{F}/></g>"
        f"<path d='M2,35 Q9,26 15,29 Q22,23 29,28 Q34,26 38,35'{S(1.5)}/>"
        f"<path d='M8,33.6 L10,33.6 M18,32 L21,32 M28,33.6 L30.4,33.6'{S(1)}/>"
    )
    # Hakone 2026, co-led: the leader's flag and the group, Fuji behind
    g = ""
    for (x, hgt) in ((6.5, 9.6), (11.6, 10.6), (16.6, 9.8), (21.8, 10.4)):
        g += figure(x, 35, hgt, k, step=0.2)
    g += figure(28.4, 35, 11.4, k, flag=k, step=0.3)
    arts["flag"] = f"<path d='M1,18 Q8,16.4 11.6,7.6 L16.4,7.6 Q20,16.4 27,18'{S(1)}/>" + f"<path d='M11.6,7.6 L16.4,7.6 L17.6,10.4 L15.6,9.6 L14,11 L12.4,9.6 L10.6,10.4 Z'{F}/>" + g
    # the national seal: Fuji, a sun and waves
    arts["fuji"] = (
        f"<circle cx='29.4' cy='9.4' r='4.4'{F}/>"
        f"<path d='M3,30 Q13.4,26.4 16.8,10.6 L23.2,10.6 Q26.6,26.4 37,30'{S(1.6)}/>"
        f"<path d='M14.6,17.6 L16.8,20.4 L18.6,17.2 L20.4,20.8 L22.2,17.2 L24.6,19.6'{S(1.3)}/>"
        f"<path d='M3,35.4 q3.4,-2.6 6.8,0 q3.4,-2.6 6.8,0 q3.4,-2.6 6.8,0 q3.4,-2.6 6.8,0 q3.4,-2.6 6.8,0'{S(1.2)}/>"
    )
    for key, body in arts.items():
        write(f"stamp-{key}.svg", f"<g id='art' opacity='1.00'>{body}</g>", "0 0 40 40")


if __name__ == "__main__":
    # Each branch is drawn into the exact frame it occupies on the page (mm), so
    # no blossom can reach the text around it. Seeds picked by eye from a contact sheet.
    # Page 1 hero: a canopy along the band's top edge, entering from the right (80 x 16).
    window_svg("sakura-canopy.svg", 599, (84, 2), math.radians(177), 60, 3.4, (0, 0, 80, 16), {"top", "right"}, min_blossoms=7)
    # Page 1 field: between the profile and section 01, entering from the right page edge (78 x 29).
    window_svg("sakura-field.svg", 217, (80, 10), math.radians(188), 64, 4.0, (0, 0, 78, 29), {"right"},
               petals=[(10, 22, 2.0), (22, 26, 1.6)], min_blossoms=10)
    # Page 2 field: hangs in from the right page edge just under the band (90 x 26).
    window_svg("sakura-field-2.svg", 286, (92, 3), math.radians(170), 72, 4.0, (0, 0, 90, 26), {"top", "right"},
               petals=[(10, 20, 1.9), (24, 23, 1.5)], min_blossoms=13)    # Drift: a few loose petals for the outer margin (10 x 120 mm)
    rng = random.Random(5)
    drift = "<g id='art' opacity='1.00'>"
    for i in range(7):
        drift += loose_petal(rng.uniform(3.5, 6.5), 8 + i * 16 + rng.uniform(-4, 4), rng.uniform(2.4, 3.0), rng.uniform(0, 360), rng.uniform(0.5, 1.0))
    drift += "</g>"
    write("petals-drift.svg", drift, "0 0 10 120")
    torii("torii.svg")
    group("group.svg")
    fuji("fuji.svg")
    plane("plane.svg")
    stamp_art()
    print("ok")
