"""The Template Contract (ADR 0016): what a Domain's facts hold and what a Template Variation shows.

Domain Contracts and Template Manifests are JSON files; this module reads them, finds which Fact Groups
a record holds, compares them with a Template Variation's claims, and judges a Coverage Fixture's PDF.
Stage 1: every Domain Contract is at version 1, so a version is either supported or refused.
"""
import json
import re

from .workspace import DOMAINS, ROOT, WorkflowError

BASE = ROOT / 'packages/cv-framework/contracts'
VERSION = re.compile(r'v(\d+)\.json$')


def read(path):
    return json.loads(path.read_text(encoding='utf-8'))


def versions(domain, domains_root=DOMAINS):
    """The Domain Contract versions kept for a Domain, oldest first; empty when it has none yet."""
    folder = domains_root / domain / 'contracts'
    return sorted(int(VERSION.search(p.name)[1]) for p in folder.glob('v*.json')) if folder.is_dir() else []


def contract(domain, version, domains_root=DOMAINS, base_root=BASE):
    """A Domain Contract with the Base Contract's groups merged in; the Domain's entry for a group wins."""
    own = read(domains_root / domain / 'contracts' / f'v{version}.json')
    name, base_version = own['extends'].split('@')
    base = read(base_root / f'{name}-v{base_version}.json')
    return {**own, 'groups': {**base['groups'], **own['groups']}}


def manifest(domain, template, domains_root=DOMAINS):
    return read(domains_root / domain / 'templates' / template / 'template.json')


def manifests(domains_root=DOMAINS):
    """Every Template Manifest: (domain folder, template id, manifest)."""
    for path in sorted(domains_root.glob('*/templates/*/template.json')):
        yield path.parts[-4], path.parts[-2], read(path)


def template_in(domain, source, domains_root=DOMAINS):
    """The Template an entry point renders, by its call; None for a custom composition or a one-off."""
    for path in sorted((domains_root / domain / 'templates').glob('*/template.json')):
        name = path.parts[-2]
        if re.search(rf'(?<![-\w]){re.escape(name)}(\.with\s*\(|\()', source):
            return name
    return None


def walk(value, parts):
    if not parts:
        yield value
    elif parts[0] == '*':
        for item in value if isinstance(value, list) else []:
            yield from walk(item, parts[1:])
    elif isinstance(value, dict) and parts[0] in value:
        yield from walk(value[parts[0]], parts[1:])


def holds(record, group):
    """Whether a record has anything in a Fact Group. A group points at parts of the record."""
    return any(value not in (None, '', [], {}) for path in group['paths'] for value in walk(record, path.split('.')))


def claims(variation, domain):
    """The optional groups a Template Variation claims, without their schema versions, and those versions."""
    support = variation['supports'].get(domain)
    if support is None:
        return None, []
    named = dict(item.split('@') for item in support['groups'])
    kept = support['exactly'] if 'exactly' in support else list(range(1, support['upTo'] + 1))
    return {name: int(version) for name, version in named.items()}, kept


def check_groups(record, groups, claimed):
    """(missing required groups, optional groups the record holds and the Template Variation does not claim)."""
    missing = [name for name, group in groups.items() if group['required'] and not holds(record, group)]
    dropped = [name for name, group in groups.items()
               if not group['required'] and name not in claimed and holds(record, group)]
    return missing, dropped


def choose(envelope_data, source, record, design=None):
    """Check a Client's record against the design it renders, before the render.

    `source` is the entry point without its comments. Returns None for a Domain with no contract yet and
    for a one-off, which imports no Domain; else (what the Meta File records, warnings). A custom
    composition is checked against the Domain Contract alone. `design` replaces the manifest in a test.
    """
    domain = envelope_data.get('domain', '')
    kept = versions(domain)
    if not kept or f'domains/{domain}/' not in source:
        return None
    version = record.get('domainContract', 1)
    if not isinstance(version, int) or isinstance(version, bool) or version not in kept:
        raise WorkflowError(f'candidate.json follows {domain} contract version {version}, which is not kept; '
                            f'use one of {", ".join(map(str, kept))}')
    groups = contract(domain, version)['groups']
    template = template_in(domain, source)
    stated = envelope_data.get('template')
    warnings = []
    if template is None and stated:
        raise WorkflowError(f'envelope.json says template {stated!r} but typst/cv.typ does not render it; make them agree')
    if template is None:
        missing, _ = check_groups(record, groups, groups)
        if missing:
            raise WorkflowError(f'candidate.json has no {", ".join(missing)}, required by the {domain} contract')
        return {'domain_contract': version}, warnings
    design = design or manifest(domain, template)
    if stated and stated != template:
        raise WorkflowError(f'envelope.json says template {stated!r} but typst/cv.typ renders {template!r}; make them agree')
    if not stated:
        warnings.append(f'envelope.json names no template; {template!r} read from typst/cv.typ')
    variation = envelope_data.get('variation') or design['default']
    if variation not in design['variations']:
        raise WorkflowError(f'{template!r} has no Template Variation {variation!r}: {", ".join(design["variations"])}')
    written = re.search(r'\bvariation:\s*("([\w-]+)")?', source)
    if written and not written[1]:
        raise WorkflowError('typst/cv.typ must name its variation as plain text, so the check can read it')
    if (written[2] if written else design['default']) != variation:
        raise WorkflowError(f'envelope.json says variation {variation!r} but typst/cv.typ renders '
                            f'{written[2] if written else design["default"]!r}; make them agree')
    claimed, supported = claims(design['variations'][variation], domain)
    if claimed is None or version not in supported:
        raise WorkflowError(f'{template} {variation} does not support {domain} contract version {version}; '
                            'pick another Template Variation')
    missing, dropped = check_groups(record, groups, claimed)
    if missing:
        raise WorkflowError(f'candidate.json has no {", ".join(missing)}, required by the {domain} contract')
    warnings += [f'{template} {variation} does not show {name}: this CV leaves those facts out' for name in dropped]
    return {'template': template, 'variation': variation, 'domain_contract': version, 'dropped': dropped}, warnings


def squeeze(text):
    return ''.join(text.split()).casefold()


def coverage(text, images, groups, claimed, markers):
    """Judge a Coverage Fixture's PDF: (failures, warnings). `text` is the PDF's text, `images` its raster
    image count, `markers` each group's tokens; a group with the marker "image" is proved by an image."""
    found = squeeze(text)

    def shown(name):
        return bool(markers[name]) and all(images > 0 if token == 'image' else squeeze(token) in found for token in markers[name])

    failures, warnings = [], []
    unknown = sorted(set(claimed) - set(groups))
    failures += [f'claims {name}, which the contract does not have' for name in unknown]
    for name, group in groups.items():
        if name not in markers:
            failures.append(f'the fixture has no marker for {name}')
        elif group['required'] or name in claimed:
            if name in claimed and claimed[name] != group['schemaVersion']:
                failures.append(f'claims {name}@{claimed[name]}, the contract has @{group["schemaVersion"]}')
            elif not shown(name):
                failures.append(f'{"required" if group["required"] else "claims"} {name} but a marker is not in the PDF')
        elif shown(name):
            warnings.append(f'renders {name} but does not claim it: update the manifest')
    return failures, warnings
