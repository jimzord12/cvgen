"""Portrait preparation: background removal, a face-centred square crop and an optional flat fill.

The owner's rule (2026-11-08): the background goes, and the face sits in the centre of the shape, or a
tiny bit higher. Every template shows the portrait in a circle or another shape with a cover fit, so a
square crop with the face centre at FACE_X, FACE_Y keeps it there in any of them. The source photograph
is never written; the prepared PNG and a JSON sidecar (the evidence) go next to it.

rembg, onnxruntime and opencv-python-headless are imported only when a portrait is prepared, so the rest
of cv_workflow runs without them.
"""
from datetime import datetime, timezone
import hashlib
import importlib.metadata
import json
from pathlib import Path
import platform

from .workspace import WorkflowError

# Where the face centre lands, as a share of the square's side: centred across, a little above the middle
# (0.50 would be the middle), the "tiny bit higher" the owner allows. The face is YuNet's box, which runs
# from the brows to just under the chin, so its centre is about the tip of the nose; at 0.45 the eyes sit
# near the upper third of the circle and the hair keeps its room. The face box is FACE_SHARE of the side:
# head and the top of the shoulders, as in a passport-style portrait. Both are calibrated on the portrait
# the Flagship examples show (examples/candidates/fictional-engineer.png: face centre at 0.49,
# 0.44, face 0.49 of the side). The square is made smaller only when the photograph has no room, and is
# refused when the face would fill more than MAX_FACE_SHARE (a forehead-to-chin close-up).
FACE_X = 0.50
FACE_Y = 0.45
FACE_SHARE = 0.45
MAX_FACE_SHARE = 0.60
# The Flagship circle is 46 mm (flagship-v11, hero.portrait-size): 543 px at 300 dpi. 600 px leaves room
# for a slightly larger shape; a larger crop is scaled down to MAX_SIDE, never up.
MIN_SIDE = 600
MAX_SIDE = 1200
# The face detector: YuNet (OpenCV Zoo, MIT licence in models/yunet-LICENSE.txt), vendored so detection
# needs no download. It was trained on small inputs and scores a face filling a large photo lower, so it
# runs on a copy scaled down to DETECT_SIDE.
YUNET = Path(__file__).parent / 'models' / 'face_detection_yunet_2023mar.onnx'
DETECT_SIDE = 640
SCORE = 0.7
# rembg's model for portraits (BiRefNet trained on portraits): clean hair edges where u2net_human_seg and
# isnet-general-use left a grey halo (trial on the fictional engineer portrait, 2026-11-08). About 930 MB,
# downloaded by rembg on first use into ~/.rembg/models (REMBG_HOME or U2NET_HOME move it); never committed.
MODEL = 'birefnet-portrait'


def _modules():
    """cv2, numpy and PIL, or a refusal naming the install command."""
    try:
        import cv2
        import numpy
        from PIL import Image, ImageOps
    except ImportError as error:
        raise WorkflowError(f'portrait preparation needs {error.name}: pip install -r requirements.lock') from error
    return cv2, numpy, Image, ImageOps


def load_photo(path, keep_alpha=False):
    """The photograph upright (EXIF orientation applied) as RGB (RGBA with keep_alpha, when it has
    transparency), or a refusal."""
    _, _, Image, ImageOps = _modules()
    path = Path(path)
    if not path.is_file():
        raise WorkflowError(f'no photograph at {path}')
    try:
        with Image.open(path) as image:
            upright = ImageOps.exif_transpose(image)
            transparent = upright.mode in ('RGBA', 'LA', 'PA') or 'transparency' in upright.info
            return upright.convert('RGBA' if keep_alpha and transparent else 'RGB')
    except OSError as error:
        raise WorkflowError(f'{path.name} is not an image Pillow can read: {error}') from error


def detect_faces(image):
    """Every face YuNet finds in a PIL image, largest first: dicts with box (x, y, w, h), centre and score.

    A transparent image is judged on mid-grey, so a cut-out portrait is detected like a photograph."""
    cv2, numpy, Image, _ = _modules()
    if image.mode in ('RGBA', 'LA', 'PA'):
        flat = Image.new('RGB', image.size, (128, 128, 128))
        flat.paste(image.convert('RGBA'), mask=image.convert('RGBA').getchannel('A'))
        image = flat
    image = image.convert('RGB')
    scale = min(1.0, DETECT_SIDE / max(image.size))
    small = image.resize((max(1, round(image.width * scale)), max(1, round(image.height * scale))), Image.Resampling.LANCZOS) if scale < 1 else image
    pixels = cv2.cvtColor(numpy.asarray(small), cv2.COLOR_RGB2BGR)
    detector = cv2.FaceDetectorYN.create(str(YUNET), '', (small.width, small.height), SCORE, 0.3, 5000)
    _, found = detector.detect(pixels)
    faces = []
    for row in [] if found is None else found:
        x, y, w, h = (float(v) / scale for v in row[:4])
        faces.append({'box': [round(x, 1), round(y, 1), round(w, 1), round(h, 1)],
                      'centre': [round(x + w / 2, 1), round(y + h / 2, 1)], 'score': round(float(row[-1]), 3)})
    return sorted(faces, key=lambda f: -f['box'][2] * f['box'][3])


def find_face(image, name='the photograph'):
    """The one face in the image, or a refusal: no face and several faces both stop the run."""
    faces = detect_faces(image)
    if not faces:
        raise WorkflowError(f'no face found in {name}: use a photograph that shows the face from the front, '
                            'evenly lit, not covered by sunglasses or a hand')
    if len(faces) > 1:
        boxes = ', '.join(str([round(v) for v in f['box']]) for f in faces)
        raise WorkflowError(f'{len(faces)} faces found in {name} (boxes x, y, w, h: {boxes}): crop the photograph '
                            'to the candidate alone, then run again')
    return faces[0]


def crop_square(size, face, min_side=MIN_SIDE):
    """The square (left, top, side) that puts the face centre at FACE_X, FACE_Y, with the face at FACE_SHARE.

    The square shrinks to stay inside the photograph (no padding, so no straight edge cuts the shoulders);
    which edge stopped it is returned as `limited_by`. Refused when the face would fill more than
    MAX_FACE_SHARE or the square is smaller than min_side pixels (never upscaled)."""
    width, height = size
    cx, cy = face['centre']
    face_height = face['box'][3]
    limits = {'wanted': face_height / FACE_SHARE, 'left': cx / FACE_X, 'right': (width - cx) / (1 - FACE_X),
              'top': cy / FACE_Y, 'bottom': (height - cy) / (1 - FACE_Y)}
    limited_by = min(limits, key=limits.get)
    side = int(limits[limited_by])
    if side <= 0 or face_height / side > MAX_FACE_SHARE:
        raise WorkflowError(f'the face sits too close to the {limited_by} edge of the photograph: centred, it would fill '
                            f'{face_height / max(side, 1):.0%} of the square (at most {MAX_FACE_SHARE:.0%}); use a photograph '
                            f'with more room around the head')
    if side < min_side:
        raise WorkflowError(f'the face-centred square is only {side} px; the templates need at least {min_side} px '
                            f'(a 46 mm circle at 300 dpi is 543 px) and a photograph is never enlarged; use a larger '
                            f'photograph, or pass --min-size {side} to accept a softer print')
    # Rounding can push the square one pixel out; the limit above already keeps it inside up to that.
    left = min(max(0, round(cx - FACE_X * side)), width - side)
    top = min(max(0, round(cy - FACE_Y * side)), height - side)
    return {'box': [left, top, side, side], 'limited_by': None if limited_by == 'wanted' else limited_by,
            'face_share': round(face_height / side, 3)}


def remove_background(image, model=MODEL):
    """The image with its background removed (RGBA), through rembg on onnxruntime."""
    try:
        from rembg import new_session, remove
    except ImportError as error:
        raise WorkflowError(f'background removal needs {error.name}: pip install -r requirements.lock') from error
    return remove(image, session=new_session(model)).convert('RGBA')


def parse_colour(text):
    """'#1b2a4a' or '1b2a4a' as an (r, g, b) tuple, or a refusal."""
    value = text.lstrip('#')
    if len(value) != 6 or any(c not in '0123456789abcdefABCDEF' for c in value):
        raise WorkflowError(f'--fill takes a hex colour such as #1b2a4a, not {text!r}')
    return tuple(int(value[i:i + 2], 16) for i in (0, 2, 4))


def sha256_bytes(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def versions():
    found = {'python': platform.python_version()}
    for package in ('rembg', 'onnxruntime', 'opencv-python-headless', 'pillow', 'numpy'):
        try:
            found[package] = importlib.metadata.version(package)
        except importlib.metadata.PackageNotFoundError:
            found[package] = None
    return found


def prepare_portrait(source, output=None, *, remove=True, fill=None, model=MODEL, min_side=MIN_SIDE, replace=False):
    """Prepare one portrait: crop around the face, remove the background, fill it if asked; write the PNG and
    its sidecar next to the source (or at `output`). Returns the sidecar dictionary."""
    _, _, Image, _ = _modules()
    source = Path(source).resolve()
    output = Path(output).resolve() if output else source.with_name(f'{source.stem}-prepared.png')
    sidecar_path = output.with_suffix('.json')
    if output.suffix.lower() != '.png':
        raise WorkflowError(f'the prepared portrait is a PNG (it may be transparent): name it {output.stem}.png')
    if output == source or sidecar_path == source:
        raise WorkflowError('the output would overwrite the source photograph: choose another --output')
    for path in (output, sidecar_path):
        if path.exists() and not replace:
            raise WorkflowError(f'{path.name} already exists: pass --replace to write it again, or choose another --output')
    colour = parse_colour(fill) if fill else None
    if colour and not remove:
        raise WorkflowError('--fill colours the removed background, so it cannot go with --keep-background')

    photo = load_photo(source)
    face = find_face(photo, source.name)
    crop = crop_square(photo.size, face, min_side)
    left, top, side, _ = crop['box']
    portrait = photo.crop((left, top, left + side, top + side))
    if side > MAX_SIDE:
        portrait = portrait.resize((MAX_SIDE, MAX_SIDE), Image.Resampling.LANCZOS)
    if remove:
        portrait = remove_background(portrait, model)
    if colour:
        flat = Image.new('RGB', portrait.size, colour)
        flat.paste(portrait, mask=portrait.getchannel('A'))
        portrait = flat
    output.parent.mkdir(parents=True, exist_ok=True)
    portrait.save(output, optimize=True)

    # Evidence: the face found again in what was written, as a share of the square.
    after = detect_faces(portrait)
    placed = [round(after[0]['centre'][0] / portrait.width, 3), round(after[0]['centre'][1] / portrait.height, 3)] if len(after) == 1 else None
    record = {
        'tool': 'scripts/portrait.py prepare',
        'written': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'),
        'source': {'file': source.name, 'sha256': sha256_bytes(source), 'size': list(photo.size)},
        'face': face,
        'crop': {**crop, 'target': {'x': FACE_X, 'y': FACE_Y}, 'wanted_face_share': FACE_SHARE},
        'output': {'file': output.name, 'sha256': sha256_bytes(output), 'size': list(portrait.size),
                   'background': ('#%02x%02x%02x' % colour) if colour else 'transparent' if remove else 'original',
                   'face_centre': placed, 'faces_found': len(after)},
        'models': {'background': model if remove else None,
                   'face': {'file': YUNET.name, 'sha256': sha256_bytes(YUNET), 'score_threshold': SCORE}},
        'versions': versions(),
    }
    sidecar_path.write_text(json.dumps(record, indent=2) + '\n', encoding='utf-8')
    record['paths'] = {'portrait': str(output), 'sidecar': str(sidecar_path)}
    return record
