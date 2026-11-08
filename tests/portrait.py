"""scripts/portrait.py through its real command line, on fictional portraits only. Run by tests/run.py.

Each case returns (name, None) when it ran, or (name, reason) when this machine cannot run it; tests/run.py
skips those loudly, and fails them on CI, where requirements.lock installs everything."""
import hashlib
import io
import json
import struct
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


def snapshot(folder):
    return {path.name: digest(path) for path in folder.iterdir() if path.is_file()}


def refuses(folder, arguments, message):
    """The command exits 1 with the message, and the folder is byte for byte as it was: nothing written or changed."""
    before = snapshot(folder)
    done = run(*arguments)
    assert done.returncode == 1, (arguments, done.returncode, done.stdout, done.stderr)
    assert message in done.stderr, done.stderr
    assert snapshot(folder) == before, (arguments, 'a refusal wrote or changed a file')


def linear_srgb_profile():
    """A small ICC v2 profile: sRGB primaries with linear (gamma 1.0) curves, so its numbers differ from sRGB's.
    Stands in for a phone's Display P3 tag, which Pillow cannot make."""
    def s15(value):
        return struct.pack('>i', round(value * 65536))

    def xyz(x, y, z):
        return b'XYZ ' + b'\0' * 4 + s15(x) + s15(y) + s15(z)

    curve = b'curv' + b'\0' * 4 + struct.pack('>IH', 1, 0x0100) + b'\0\0'
    text = b'Linear sRGB (test)\0'
    desc = b'desc' + b'\0' * 4 + struct.pack('>I', len(text)) + text + struct.pack('>IIHB', 0, 0, 0, 0) + b'\0' * 67
    tags = [(b'desc', desc), (b'wtpt', xyz(0.9642, 1.0, 0.8249)), (b'rXYZ', xyz(0.4361, 0.2225, 0.0139)),
            (b'gXYZ', xyz(0.3851, 0.7169, 0.0971)), (b'bXYZ', xyz(0.1431, 0.0606, 0.7141)),
            (b'rTRC', curve), (b'gTRC', curve), (b'bTRC', curve), (b'cprt', b'text' + b'\0' * 4 + b'none\0')]
    offset, table, data = 128 + 4 + 12 * len(tags), b'', b''
    for signature, body in tags:
        body += b'\0' * (-len(body) % 4)
        table += signature + struct.pack('>II', offset + len(data), len(body))
        data += body
    header = (struct.pack('>I', offset + len(data)) + b'\0' * 4 + bytes([2, 0x10, 0, 0]) + b'mntrRGB XYZ ' + b'\0' * 12
              + b'acsp' + b'\0' * 28 + s15(0.9642) + s15(1.0) + s15(0.8249) + b'\0' * 48)
    return header + struct.pack('>I', len(tags)) + table + data


def run_portrait(out):
    sys.path.insert(0, str(ROOT / 'packages/cv-workflow'))
    try:
        from PIL import Image, ImageCms
        from cv_workflow import portrait
        import cv2  # noqa: F401
    except ImportError as error:
        return [('portrait', f'{error.name} is not installed: pip install -r requirements.lock')]
    folder = out / 'portrait'
    folder.mkdir(exist_ok=False)
    checks = []
    sources = {path: digest(path) for path in (ENGINEER, SMALL)}

    def prepared(name):
        return json.loads((folder / f'{name}.json').read_text(encoding='utf-8'))

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
        record = prepared(f'{name}-prepared')
        side = record['crop']['box'][2]
        assert record['crop']['limited_by'] == edge, record['crop']
        assert record['output']['size'] == [min(side, portrait.MAX_SIDE)] * 2 and side <= min(canvas), (side, record['output'])
        assert record['output']['background'] == 'original' and record['models']['background'] is None
        assert record['check'] == {'passed': True, 'tolerance': TOLERANCE}, record['check']
        with Image.open(folder / f'{name}-prepared.png') as result:
            found = portrait.detect_faces(result)
            assert len(found) == 1, found
            x, y = found[0]['centre'][0] / result.width, found[0]['centre'][1] / result.height
        assert abs(x - portrait.FACE_X) <= TOLERANCE and abs(y - portrait.FACE_Y) <= TOLERANCE, (name, x, y)
        assert record['output']['face_centre'] == [round(x, 3), round(y, 3)], record['output']
        assert set(record['versions']) >= {'python', 'rembg', 'onnxruntime', 'opencv-python-headless'}, record['versions']
    checks.append(f'face centre lands within {TOLERANCE:.0%} of ({portrait.FACE_X}, {portrait.FACE_Y}) from a high-left and a low-right photo')

    # --face-y moves the face within the owner's band, and only there.
    done = run('prepare', folder / 'low-right.jpg', '--keep-background', '--face-y', 0.41, '--output', folder / 'higher.png')
    assert done.returncode == 0, done.stderr
    record = prepared('higher')
    assert record['crop']['target'] == {'x': 0.5, 'y': 0.41} and record['check']['passed'], record
    assert abs(record['output']['face_centre'][1] - 0.41) <= TOLERANCE, record['output']
    refuses(folder, ['prepare', folder / 'low-right.jpg', '--keep-background', '--face-y', 0.6, '--output', folder / 'low.png'],
            '--face-y 0.6 is outside 0.4-0.5')
    checks.append('--face-y 0.41 puts the face there; 0.6, outside 0.40-0.50, is refused')

    # A photo tagged with another colour profile is converted to sRGB, recorded, and the result is tagged sRGB.
    linear = linear_srgb_profile()
    engineer.save(folder / 'tagged.jpg', quality=95, icc_profile=linear)
    done = run('prepare', folder / 'tagged.jpg', '--keep-background')
    assert done.returncode == 0, done.stderr
    record = prepared('tagged-prepared')
    assert record['source']['colour'] == {'source_profile': 'Linear sRGB (test)', 'converted_to': 'sRGB'}, record['source']
    with Image.open(folder / 'tagged.jpg') as tagged, Image.open(folder / 'tagged-prepared.png') as result:
        left, top = record['crop']['box'][:2]
        scale = result.width / record['crop']['box'][2]
        raw = tagged.convert('RGB').getpixel((left + 20, top + 20))
        wanted = ImageCms.profileToProfile(Image.new('RGB', (1, 1), raw), ImageCms.ImageCmsProfile(io.BytesIO(linear)),
                                           ImageCms.createProfile('sRGB')).getpixel((0, 0))
        got = result.getpixel((round(20 * scale), round(20 * scale)))
        assert all(abs(a - b) <= 3 for a, b in zip(got, wanted)) and abs(got[0] - raw[0]) > 30, (raw, wanted, got)
        assert ImageCms.getProfileDescription(ImageCms.ImageCmsProfile(io.BytesIO(result.info['icc_profile']))).strip() == 'sRGB built-in'
    checks.append('a photo tagged with another colour profile is converted to sRGB, and the result is tagged sRGB')

    # Too small for the templates: refused, never enlarged; accepted with an explicit --min-size, at its own size.
    small = folder / 'small.jpg'
    with Image.open(SMALL) as concept:
        concept.resize((560, 560), Image.Resampling.LANCZOS).save(small, quality=92)
    refuses(folder, ['prepare', small, '--keep-background'], 'a photograph is never enlarged')
    done = run('prepare', small, '--keep-background', '--min-size', 400)
    assert done.returncode == 0, done.stderr
    record = prepared('small-prepared')
    assert record['output']['size'] == record['crop']['box'][2:] and record['crop']['box'][2] < 560, record
    checks.append('a photo too small for a 600 px square is refused, and never enlarged when accepted')

    # Refusals, each on its message, each leaving the folder byte for byte as it was.
    engineer.crop((0, 0, 360, 360)).resize((720, 720)).save(folder / 'no-face.png')  # the studio backdrop alone
    refuses(folder, ['prepare', folder / 'no-face.png'], 'no face found in no-face.png')
    pair = Image.new('RGB', (2508, 1254))
    pair.paste(engineer, (0, 0)); pair.paste(engineer, (1254, 0))
    pair.save(folder / 'two-faces.jpg', quality=90)
    refuses(folder, ['prepare', folder / 'two-faces.jpg'], '2 faces found in two-faces.jpg')
    engineer.crop((360, 220, 870, 880)).resize((1020, 1320)).save(folder / 'close-up.jpg', quality=92)  # forehead to chin
    refuses(folder, ['prepare', folder / 'close-up.jpg', '--keep-background'], 'the face sits too close to the')
    Image.open(folder / 'high-left.jpg').save(folder / 'high-left.png')
    refuses(folder, ['prepare', folder / 'high-left.png', '--output', folder / 'high-left.png'], 'would overwrite the source photograph')
    refuses(folder, ['prepare', folder / 'high-left.jpg', '--keep-background'], 'high-left-prepared.png already exists')
    refuses(folder, ['prepare', folder / 'high-left.jpg', '--keep-background', '--fill', '#1b2a4a', '--output', folder / 'x.png'],
            'cannot go with --keep-background')
    # --replace writes over the tool's own output only: never a file that shares the name, nor its edited output.
    (folder / 'candidate.json').write_text('{"identity": {"name": "Fictional Example"}}\n', encoding='utf-8')
    refuses(folder, ['prepare', folder / 'high-left.jpg', '--keep-background', '--output', folder / 'candidate.png', '--replace'],
            'was not written by this tool')
    with Image.open(folder / 'small-prepared.png') as edited:
        edited.rotate(1).save(folder / 'small-prepared.png')
    refuses(folder, ['prepare', small, '--keep-background', '--min-size', 400, '--replace'], 'was not written by this tool')
    first = digest(folder / 'high-left-prepared.png')
    done = run('prepare', folder / 'high-left.jpg', '--keep-background', '--replace', '--face-y', 0.43)
    assert done.returncode == 0 and digest(folder / 'high-left-prepared.png') != first, done.stderr
    checks.append('no face, two faces, a close-up, the source as output, an existing output, a fill on a kept background and '
                  '--replace over a file the tool did not write are refused, writing nothing; --replace over its own output works')

    # The face found again in the result decides the exit: a face too small to find in the whole photo shows up
    # in the crop, so the result has two; the files are written and kept, and the run exits 2.
    canvas = Image.new('RGB', (3000, 3000), (150, 160, 175))
    canvas.paste(engineer, (900, 900))
    canvas.paste(engineer.crop((380, 200, 860, 860)).resize((50, 69)), (980, 960))
    canvas.save(folder / 'tiny-second-face.jpg', quality=92)
    done = run('prepare', folder / 'tiny-second-face.jpg', '--keep-background')
    assert done.returncode == 2 and 'CHECK FAILED' in done.stderr and 'kept' in done.stderr, (done.returncode, done.stderr)
    record = prepared('tiny-second-face-prepared')
    assert (folder / 'tiny-second-face-prepared.png').is_file() and record['check']['passed'] is False, record['check']
    assert record['output']['faces_found'] == 2 and record['output']['face_centre'] is None, record['output']
    checks.append('a result whose face check fails is kept and the run exits 2, saying so')

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
    record = prepared('engineer-prepared')
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
