"""scripts/portrait.py through its real command line, on fictional portraits only. Run by tests/run.py.

Each case returns (name, None) when it ran, or (name, reason) when this machine cannot run it; tests/run.py
skips those loudly, and fails them on CI, where requirements.lock installs everything."""
import hashlib
import json
import subprocess
import sys

from verify import ROOT

SCRIPT = ROOT / 'scripts' / 'portrait.py'
ENGINEER = ROOT / 'examples/candidates/fictional-engineer.png'  # the fictional AI portrait every example shows
SMALL = ROOT / 'studio/design-concepts/2026-09-29-concourse/portrait.jpg'  # the same fictional face, 627 px
# A small rembg model (about 5 MB) for the removal cases: they test the tool's handling of a cut-out, not the
# model, and the default (about 930 MB) would make the first run of the suite a long download.
TEST_MODEL = 'u2netp'
TOLERANCE = 0.02  # of the square's side: 24 px at 1200 px


def run(*arguments):
    return subprocess.run([sys.executable, str(SCRIPT), *map(str, arguments)], capture_output=True, text=True, encoding='utf-8')


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def refused(done, message):
    assert done.returncode == 1, (done.returncode, done.stdout, done.stderr)
    assert message in done.stderr, done.stderr


def run_portrait(out):
    sys.path.insert(0, str(ROOT / 'packages/cv-workflow'))
    try:
        from PIL import Image
        from cv_workflow import portrait
        import cv2  # noqa: F401
    except ImportError as error:
        return [('portrait', f'{error.name} is not installed: pip install -r requirements.lock')]
    folder = out / 'portrait'
    folder.mkdir(exist_ok=False)
    checks = []
    sources = {path: digest(path) for path in (ENGINEER, SMALL)}

    # Off-centre photographs made from the fictional portrait: the face high and left on a wide canvas, then
    # low and right. Cropped only (no model), the face centre lands on the target either way.
    with Image.open(ENGINEER) as engineer:
        engineer = engineer.convert('RGB')
    for name, canvas, at, edge in [('high-left', (1800, 1600), (80, 20), 'top'), ('low-right', (1900, 1900), (600, 640), 'bottom')]:
        photo = Image.new('RGB', canvas, (150, 160, 175))
        photo.paste(engineer, at)
        photo.save(folder / f'{name}.jpg', quality=92)
        done = run('prepare', folder / f'{name}.jpg', '--keep-background')
        assert done.returncode == 0, done.stderr
        record = json.loads((folder / f'{name}-prepared.json').read_text(encoding='utf-8'))
        side = record['crop']['box'][2]
        assert record['crop']['limited_by'] == edge, record['crop']
        assert record['output']['size'] == [min(side, portrait.MAX_SIDE)] * 2 and side <= min(canvas), (side, record['output'])
        assert record['output']['background'] == 'original' and record['models']['background'] is None
        with Image.open(folder / f'{name}-prepared.png') as prepared:
            found = portrait.detect_faces(prepared)
            assert len(found) == 1, found
            x, y = found[0]['centre'][0] / prepared.width, found[0]['centre'][1] / prepared.height
        assert abs(x - portrait.FACE_X) <= TOLERANCE and abs(y - portrait.FACE_Y) <= TOLERANCE, (name, x, y)
        assert record['output']['face_centre'] == [round(x, 3), round(y, 3)], record['output']
        assert set(record['versions']) >= {'python', 'rembg', 'onnxruntime', 'opencv-python-headless'}, record['versions']
    checks.append(f'face centre lands within {TOLERANCE:.0%} of ({portrait.FACE_X}, {portrait.FACE_Y}) from a high-left and a low-right photo')

    # Too small for the templates: refused, never enlarged; accepted with an explicit --min-size, at its own size.
    small = folder / 'small.jpg'
    with Image.open(SMALL) as concept:
        concept.resize((560, 560), Image.Resampling.LANCZOS).save(small, quality=92)
    refused(run('prepare', small, '--keep-background'), 'a photograph is never enlarged')
    done = run('prepare', small, '--keep-background', '--min-size', 400)
    assert done.returncode == 0, done.stderr
    record = json.loads((folder / 'small-prepared.json').read_text(encoding='utf-8'))
    assert record['output']['size'] == record['crop']['box'][2:] and record['crop']['box'][2] < 560, record
    checks.append('a photo too small for a 600 px square is refused, and never enlarged when accepted')

    # Refusals: no face, two faces, the source as the output, an existing output, a fill on a kept background.
    nobody = folder / 'no-face.png'
    engineer.crop((0, 0, 360, 360)).resize((720, 720)).save(nobody)  # the studio backdrop alone
    refused(run('prepare', nobody), 'no face found in no-face.png')
    pair = Image.new('RGB', (2508, 1254))
    pair.paste(engineer, (0, 0)); pair.paste(engineer, (1254, 0))
    pair.save(folder / 'two-faces.jpg', quality=90)
    refused(run('prepare', folder / 'two-faces.jpg'), '2 faces found in two-faces.jpg')
    png = folder / 'high-left.png'
    Image.open(folder / 'high-left.jpg').save(png)
    refused(run('prepare', png, '--output', png), 'would overwrite the source photograph')
    refused(run('prepare', folder / 'high-left.jpg', '--keep-background'), 'high-left-prepared.png already exists')
    refused(run('prepare', folder / 'high-left.jpg', '--keep-background', '--fill', '#1b2a4a', '--output', folder / 'x.png'),
            'cannot go with --keep-background')
    assert not list(folder.glob('no-face-prepared*')) and not list(folder.glob('two-faces-prepared*')), 'a refusal wrote a file'
    checks.append('no face, two faces, overwriting the source or an earlier output, and a fill on a kept background are refused')

    # Background removal, through rembg. The model is downloaded on first use; without it the case is skipped.
    # Loaded in a fresh interpreter: numba (under rembg) imports `coverage`, which tests/coverage.py shadows here.
    load = subprocess.run([sys.executable, '-c', f'from rembg import new_session; new_session({TEST_MODEL!r})'],
                          capture_output=True, text=True, encoding='utf-8', cwd=folder)
    if load.returncode != 0:
        reason = (load.stderr.strip().splitlines() or ['no message'])[-1]
        return [(c, None) for c in checks] + [('background removal', f'rembg cannot load {TEST_MODEL} here: {reason}')]
    photo = folder / 'engineer.png'
    photo.write_bytes(ENGINEER.read_bytes())
    done = run('prepare', photo, '--model', TEST_MODEL)
    assert done.returncode == 0, done.stderr
    record = json.loads((folder / 'engineer-prepared.json').read_text(encoding='utf-8'))
    assert record['output']['background'] == 'transparent' and record['models']['background'] == TEST_MODEL, record
    with Image.open(folder / 'engineer-prepared.png') as cut:
        assert cut.mode == 'RGBA', cut.mode
        alpha, size = cut.getchannel('A'), cut.width
        for left, top in [(0, 0), (size - 24, 0)]:  # the top corners are backdrop; the bottom ones are the shirt
            assert alpha.crop((left, top, left + 24, top + 24)).getextrema()[1] <= 8, ('corner not transparent', left, top)
        cx, cy = record['output']['face_centre']
        assert alpha.getpixel((round(cx * size), round(cy * size))) >= 250, 'the face was removed'
        assert abs(cx - portrait.FACE_X) <= TOLERANCE and abs(cy - portrait.FACE_Y) <= TOLERANCE, (cx, cy)
    done = run('prepare', photo, '--model', TEST_MODEL, '--fill', '#1b2a4a', '--output', folder / 'engineer-navy.png')
    assert done.returncode == 0, done.stderr
    with Image.open(folder / 'engineer-navy.png') as filled:
        assert filled.mode == 'RGB' and filled.getpixel((4, 4)) == (0x1B, 0x2A, 0x4A), (filled.mode, filled.getpixel((4, 4)))
    checks.append('the background is removed (top corners transparent, face opaque) or filled with one colour')

    assert all(digest(path) == sha for path, sha in sources.items()), 'a fictional source portrait changed'
    checks.append('the fictional source portraits are unchanged')
    return [(c, None) for c in checks]
