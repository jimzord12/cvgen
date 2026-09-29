"""The Output Contract: one home and one Meta File for every PDF we show.

Every reviewable PDF sits in one of the homes below and has `<stem>.meta.json`
beside it, valid against `output.schema.json` and carrying the PDF's SHA-256.
`stamp` writes a Meta File; `scan` finds every PDF in its home and says which
are indexed and which are not, and why. See docs/proposals/output-contract.md.
"""
import json
import re
from datetime import date
from pathlib import Path

from .workspace import ROOT, WorkflowError, read_json, sha256_file, write_json

CONTRACT = 'cvgen.output/1'
SCHEMA_PATH = Path(__file__).with_name('output.schema.json')
DENSITIES = ('condensed', 'spacious')
TIERS = ('safe', 'stylish', 'creative')
ENVELOPE_FIELDS = ('alias', 'domain', 'candidate', 'rank')
# Trees whose every PDF must sit in a home (public). private/ is checked only in its homes:
# a client's own old CV under intake/ or a verified bundle under exports/ is not a review target.
PUBLIC_TREES = ('design-concepts', 'examples', 'exports')


def meta_path(pdf):
    pdf = Path(pdf)
    return pdf.with_name(pdf.stem + '.meta.json')


def home_of(pdf, root=ROOT):
    """What the path alone says about a PDF, or None when it is not in a home."""
    try:
        parts = Path(pdf).resolve().relative_to(Path(root).resolve()).parts
    except ValueError:
        return None
    name = parts[-1]
    if parts[0] == 'design-concepts' and len(parts) == 5 and re.match(r'\d{4}-\d{2}-\d{2}-', parts[1]):
        density, tier = parts[2], parts[3]
        if density in DENSITIES and tier in TIERS and name == f'{density}-{tier}.pdf':
            return {'kind': 'concept', 'density': density, 'tier': tier}
    if parts[0] == 'design-concepts' and len(parts) == 3 and re.match(r'\d{4}-\d{2}-\d{2}-', parts[1]) \
            and re.fullmatch(r'concept(-[a-z0-9-]+)?\.pdf', name):
        variant = name[:-4].replace('concept', '').strip('-')
        return {'variant': variant} if variant else {}
    if parts[0] == 'examples' and len(parts) == 4 and (Path(root) / Path(*parts[:-1]) / (name[:-4] + '.typ')).is_file():
        return {'kind': 'example', 'domain': parts[1], 'source': '/'.join(parts[:-1] + (name[:-4] + '.typ',))}
    if parts[0] == 'private' and len(parts) == 4 and parts[2] == 'draft' and re.match(r'draft-\d+\.pdf$', name):
        return {'kind': 'client-draft', 'variant': name[:-4]}
    if parts[0] == 'private' and len(parts) == 5 and parts[2] == 'revisions' and name == 'cv.pdf':
        return {'kind': 'client-cv', 'variant': parts[3]}
    if parts[0] == 'private' and len(parts) == 3 and name == 'reference.pdf':
        return {'kind': 'client-cv'}
    return None


def envelope(folder):
    """private/<envelope>/envelope.json: who the client is, once (alias, domain, candidate, rank)."""
    path = Path(folder) / 'envelope.json'
    if not path.is_file():
        raise WorkflowError(f'{path} is missing; write it once per client: '
                            '{"alias": "client-YYYY-MM-NN", "domain": "...", "candidate": "...", "rank": "..."}')
    data = read_json(path)
    missing = [k for k in ENVELOPE_FIELDS if not isinstance(data.get(k), str) or not data[k].strip()]
    if missing:
        raise WorkflowError(f'{path} lacks {", ".join(missing)}')
    import jsonschema
    rules = json.loads(SCHEMA_PATH.read_text(encoding='utf-8'))['properties']
    bad = [f'{k}={data[k]!r}' for k in ENVELOPE_FIELDS
           if not jsonschema.Draft202012Validator(rules[k]).is_valid(data[k])]
    if bad:
        raise WorkflowError(f'{path} has values the Output Contract refuses: {", ".join(bad)} '
                            '(domain is a lowercase id such as "marine"; alias is client-YYYY-MM-NN)')
    return {k: data[k] for k in ENVELOPE_FIELDS}


def _example_identity(entry):
    """An example's candidate and rank, from the fictional record its entry point reads."""
    found = re.search(r'json\("([^"]+)"\)', entry.read_text(encoding='utf-8'))
    if not found:
        return {}
    identity = read_json(entry.parent / found.group(1)).get('identity') or {}
    return {k: identity[f].title() for k, f in (('candidate', 'name'), ('rank', 'rank')) if identity.get(f)}


def _validator():
    import jsonschema
    return jsonschema.Draft202012Validator(json.loads(SCHEMA_PATH.read_text(encoding='utf-8')))


def validate(meta):
    """Schema errors as short strings, empty when valid."""
    return sorted(f'{"/".join(map(str, e.absolute_path)) or "meta"}: {e.message}' for e in _validator().iter_errors(meta))


def _pages(pdf):
    import pymupdf
    with pymupdf.open(pdf) as doc:
        return len(doc)


def stamp(pdf, fields=None, envelope_dir=None, root=ROOT):
    """Write or refresh the Meta File beside `pdf` and return it.

    Pages, SHA-256 and the contract are computed; the path's home, the client's
    envelope.json and an earlier Meta File fill the rest; `fields` override.
    The date is today when the PDF changed, else the earlier date.
    """
    pdf = Path(pdf).resolve()
    if not pdf.is_file():
        raise WorkflowError(f'{pdf} does not exist')
    home = home_of(pdf, root)
    if home is None and envelope_dir is None:
        raise WorkflowError(f'{pdf} is not in a home of the Output Contract (docs/proposals/output-contract.md)')
    path = meta_path(pdf)
    earlier = {}
    if path.is_file():
        try:
            earlier = read_json(path)
        except WorkflowError:
            earlier = {}
    if envelope_dir is None and home and home.get('kind', '').startswith('client'):
        envelope_dir = Path(root) / 'private' / pdf.relative_to(Path(root).resolve() / 'private').parts[0]
    meta = dict(earlier)
    meta.update(home or {})
    if envelope_dir is not None:
        meta.update(envelope(envelope_dir))
    if meta.get('kind') == 'example' and meta.get('source'):
        meta.update(_example_identity(Path(root) / meta['source']))
    meta.update({k: v for k, v in (fields or {}).items() if v is not None})
    digest = sha256_file(pdf)
    if not (fields or {}).get('date'):
        meta['date'] = earlier['date'] if earlier.get('sha256') == digest and earlier.get('date') else date.today().isoformat()
    meta.update({'contract': CONTRACT, 'pages': _pages(pdf), 'sha256': digest})
    errors = validate(meta)
    if errors:
        raise WorkflowError(f'Meta File for {pdf.name} is not valid: ' + '; '.join(errors))
    write_json(path, meta)
    return meta


def load(pdf, root=ROOT):
    """(meta, None) for an indexed PDF, or (None, reason)."""
    pdf = Path(pdf)
    path = meta_path(pdf)
    if not path.is_file():
        return None, f'no Meta File ({path.name})'
    try:
        meta = json.loads(path.read_text(encoding='utf-8-sig'))
    except (OSError, ValueError) as error:
        return None, f'{path.name} is not valid JSON ({error})'
    if not isinstance(meta, dict):
        return None, f'{path.name} is not a JSON object'
    errors = validate(meta)
    if errors:
        return None, f'{path.name}: ' + '; '.join(errors)
    for key, value in (home_of(pdf, root) or {}).items():
        if meta.get(key) != value:
            return None, f'{path.name} says {key}={meta.get(key)!r} but its place says {value!r}'
    if meta['sha256'] != sha256_file(pdf):
        return None, f'{path.name} is stale: the PDF changed after it was stamped (re-stamp it)'
    return meta, None


def _candidates(root, include_private):
    root = Path(root)
    for tree in PUBLIC_TREES:
        folder = root / tree
        if folder.is_dir():
            yield from (p for p in folder.rglob('*.pdf') if 'fonts' not in p.relative_to(folder).parts)
    if include_private:
        for env in sorted((root / 'private').glob('*/')):
            yield from sorted(env.glob('draft/draft-*.pdf'))
            yield from sorted(env.glob('revisions/*/cv.pdf'))
            if (env / 'reference.pdf').is_file():
                yield env / 'reference.pdf'


def scan(root=ROOT, include_private=True):
    """Every PDF in scope: ([(pdf, meta)], [(pdf, reason)])."""
    indexed, problems = [], []
    for pdf in sorted(set(_candidates(root, include_private))):
        if home_of(pdf, root) is None:
            where = 'the root exports/ is retired; the Release lives beside its entry point in examples/' \
                if pdf.relative_to(root).parts[0] == 'exports' else 'not in a home of the Output Contract'
            problems.append((pdf, where))
            continue
        meta, reason = load(pdf, root)
        if meta is None:
            problems.append((pdf, reason))
        else:
            indexed.append((pdf, meta))
    return indexed, problems
