"""The Template Contract (ADR 0016): what a Domain's facts hold and what a Template Variation shows.

Domain Contracts and Template Manifests are JSON files; this module reads them, finds which Fact Groups
a record holds, compares them with a Template Variation's claims, and judges a Coverage Fixture's PDF.
Stage 2 (P-0019 section 6): a record on a version newer than a Template Variation supports is judged by
comparing the two contracts group by group, and `oldestSupported` names the oldest version still read.
"""
import json
import re

from .workspace import DOMAINS, ROOT, WorkflowError

BASE = ROOT / 'packages/cv-framework/contracts'
VERSION = re.compile(r'v(\d+)\.json$')
FIX = 'Update the Template, keep the record on a version it renders, or pick another Template Variation.'
# When a finding stops a render: always, when the record holds the group, when it has none of it, or never.
RESULT = {'always': 'error', 'held': 'error when the record holds it', 'lacking': 'error when the record has none of it',
          'never': 'warning'}


def read(path):
    return json.loads(path.read_text(encoding='utf-8'))


def versions(domain, domains_root=DOMAINS):
    """The Domain Contract versions kept for a Domain, oldest first; empty when it has none yet."""
    folder = domains_root / domain / 'contracts'
    return sorted(int(VERSION.search(p.name)[1]) for p in folder.glob('v*.json')) if folder.is_dir() else []


def oldest_supported(domain, domains_root=DOMAINS):
    """The oldest version the engine still reads: `oldestSupported` in the newest kept contract, else 1;
    None for a Domain with no contract."""
    kept = versions(domain, domains_root)
    return read(domains_root / domain / 'contracts' / f'v{kept[-1]}.json').get('oldestSupported', 1) if kept else None


def readable(domain, domains_root=DOMAINS):
    """The kept versions the engine still reads, oldest first."""
    oldest = oldest_supported(domain, domains_root)
    return [v for v in versions(domain, domains_root) if v >= oldest]


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
    """(the optional groups a Template Variation claims, each with the set of schema versions it renders,
    the Domain Contract versions it declares); (None, []) when it does not support the Domain.

    A Variation declares `upTo` N (versions 1 to N) or `exactly` a rising list. It may claim a group at
    several schema versions (`places@1`, `places@2`) when it renders both shapes.
    """
    support = variation['supports'].get(domain)
    if support is None:
        return None, []
    if ('upTo' in support) == ('exactly' in support):
        raise WorkflowError(f'supports.{domain} must name either upTo or exactly')
    declared = support['exactly'] if 'exactly' in support else list(range(1, support['upTo'] + 1))
    whole = all(isinstance(v, int) and not isinstance(v, bool) and v >= 1 for v in declared)
    if not declared or not whole or declared != sorted(set(declared)):
        raise WorkflowError(f'supports.{domain} must name versions from 1 up, each once and rising: {declared}')
    named = {}
    for item in support['groups']:
        if not re.fullmatch(r'[a-z][a-z0-9-]*@[1-9]\d*', item):
            raise WorkflowError(f'supports.{domain}.groups: {item!r} is not name@schemaVersion')
        name, version = item.split('@')
        named.setdefault(name, set()).add(int(version))
    return named, declared


def supported(variation, domain, domains_root=DOMAINS):
    """The versions a Template Variation declares that the engine still reads, oldest first."""
    _, declared = claims(variation, domain)
    reads = readable(domain, domains_root)
    return [v for v in declared if v in reads]


def check_groups(record, groups, claimed):
    """(missing required groups, optional groups the record holds and the Template Variation does not claim)."""
    missing = [name for name, group in groups.items() if group['required'] and not holds(record, group)]
    dropped = [name for name, group in groups.items()
               if not group['required'] and name not in claimed and holds(record, group)]
    return missing, dropped


def span(numbers):
    """1, 2, 3 as "1 to 3"; anything else as a list."""
    if len(numbers) > 1 and numbers == list(range(numbers[0], numbers[-1] + 1)):
        return f'{numbers[0]} to {numbers[-1]}'
    return ', '.join(map(str, numbers))


def choose(envelope_data, source, record, design=None, domains_root=DOMAINS, base_root=BASE):
    """Check a Client's record against the design it renders, before the render.

    `source` is the entry point without its comments. Returns None for a Domain with no contract yet and
    for a one-off, which imports no Domain; else (what the Meta File records, warnings). A custom
    composition is checked against the Domain Contract alone. `design` replaces the manifest in a test.
    A record on a version newer than the Template Variation declares is judged by `compare` (section 6).
    """
    domain = envelope_data.get('domain', '')
    kept = versions(domain, domains_root)
    if not kept or f'domains/{domain}/' not in source:
        return None
    version = record.get('domainContract', 1)
    if not isinstance(version, int) or isinstance(version, bool) or version not in kept:
        raise WorkflowError(f'candidate.json follows {domain} contract version {version}, which is not kept; '
                            f'use one of {", ".join(map(str, kept))}')
    oldest = oldest_supported(domain, domains_root)
    if version < oldest:
        raise WorkflowError(f'candidate.json follows {domain} contract version {version}, which the engine no longer '
                            f'reads (oldest {oldest}); upgrade the record to version {oldest} or later')
    groups = contract(domain, version, domains_root, base_root)['groups']
    template = template_in(domain, source, domains_root)
    stated = envelope_data.get('template')
    for key in ('template', 'variation'):
        if envelope_data.get(key) is not None and not isinstance(envelope_data[key], str):
            raise WorkflowError(f'envelope.json {key} must be a name in quotes')
    warnings = []
    if template is None and stated:
        raise WorkflowError(f'envelope.json says template {stated!r} but typst/cv.typ does not render it; make them agree')
    if template is None:
        missing, _ = check_groups(record, groups, groups)
        if missing:
            raise WorkflowError(f'candidate.json has no {", ".join(missing)}, required by the {domain} contract')
        return {'domain_contract': version}, warnings
    design = design or manifest(domain, template, domains_root)
    if stated and stated != template:
        raise WorkflowError(f'envelope.json says template {stated!r} but typst/cv.typ renders {template!r}; make them agree')
    if not stated:
        warnings.append(f'envelope.json names no template; {template!r} read from typst/cv.typ')
    variation = envelope_data.get('variation') or design['default']
    if variation not in design['variations']:
        raise WorkflowError(f'{template!r} has no Template Variation {variation!r}: {", ".join(design["variations"])}')
    written = re.search(r'(?<![-\w])variation\s*:\s*("([\w-]+)"|none\b)?', source)
    if written and not written[1]:
        raise WorkflowError('typst/cv.typ must name its variation as plain text, so the check can read it')
    rendered = written[2] if written and written[2] else design['default']
    if rendered != variation:
        raise WorkflowError(f'envelope.json says variation {variation!r} but typst/cv.typ renders '
                            f'{rendered!r}; make them agree')
    claimed, declared = claims(design['variations'][variation], domain)
    if claimed is None:
        raise WorkflowError(f'{template} {variation} does not support {domain} contract version {version}; '
                            'pick another Template Variation')
    missing, dropped = check_groups(record, groups, claimed)
    if missing:
        raise WorkflowError(f'candidate.json has no {", ".join(missing)}, required by the {domain} contract')
    warnings += [f'{template} {variation} does not show {name}: this CV leaves those facts out' for name in dropped]
    if version not in declared:
        below = [v for v in declared if v < version and v >= oldest]
        if not below:
            raise WorkflowError(f'{template} {variation} supports {domain} contract version {span(declared)}; this record '
                                f'follows version {version}, which it does not render. {FIX}')
        last = below[-1]
        findings = compare(contract(domain, last, domains_root, base_root), contract(domain, version, domains_root, base_root),
                           claimed)
        errors, notes, new_facts = judge(findings, record)
        head = f'{template} {variation} supports {domain} contract up to version {last}; this record follows version {version}'
        if errors:
            raise WorkflowError(head + ':\n' + '\n'.join(f'  {text}' for text in errors) + '\n' + FIX)
        warnings.append(f'{head} ({behind(version - last)}); it renders' + (': ' + '; '.join(notes) if notes else ''))
        warnings += [f'{template} {variation} does not show the new field {item}: this CV leaves those facts out'
                     for item in new_facts]
        dropped += new_facts
    return {'template': template, 'variation': variation, 'domain_contract': version, 'dropped': dropped}, warnings


def behind(gap):
    return f'{gap} version{"" if gap == 1 else "s"} behind'


def broken(old, new):
    """Structural breaks between two versions of a Domain Contract left without a schemaVersion rise: a
    group whose schemaVersion fell, or that lost a path while its schemaVersion stayed."""
    problems = []
    for name in sorted(set(old['groups']) & set(new['groups'])):
        a, b = old['groups'][name], new['groups'][name]
        if b['schemaVersion'] < a['schemaVersion']:
            problems.append(f'{name} schemaVersion fell from {a["schemaVersion"]} to {b["schemaVersion"]}')
        elif b['schemaVersion'] == a['schemaVersion'] and not set(a['paths']) <= set(b['paths']):
            lost = ', '.join(sorted(set(a['paths']) - set(b['paths'])))
            problems.append(f'{name} lost {lost} without its schemaVersion rising')
    return problems


def compare(old, new, claimed):
    """Group by group, what a record on contract `new` meets in a Template Variation that last supports
    `old` and claims `claimed` (P-0019 section 6). Returns findings, each a dictionary: `group`, `text`,
    `error` (a key of RESULT), `paths` (where a record holds the group) and `new_paths` (fields added to a
    group the Variation renders, so dropped when held). A group nothing changed in has no finding.
    Refuses a contract whose structure broke without a schemaVersion rise."""
    problems = broken(old, new)
    if problems:
        raise WorkflowError(f'{new["domain"]} contract version {new["version"]} breaks a group without raising its '
                            f'schemaVersion: {"; ".join(problems)}; raise it')
    version, findings = new['version'], []
    for name in sorted(set(old['groups']) | set(new['groups'])):
        a, b = old['groups'].get(name), new['groups'].get(name)
        if a is None:
            kind = 'required' if b['required'] else 'optional'
            findings.append({'group': name, 'text': f'{name} is a new {kind} group in version {version}',
                             'error': 'always' if b['required'] else 'never', 'paths': b['paths'], 'new_paths': []})
            continue
        shown = name in claimed
        if b is None:
            findings.append({'group': name, 'text': f'{name} was removed in version {version}',
                             'error': 'always' if a['required'] else 'held' if shown else 'never',
                             'paths': a['paths'], 'new_paths': []})
            continue
        renders, rose = a['required'] or shown, b['schemaVersion'] > a['schemaVersion']
        texts, conditions = [], set()
        if rose:
            texts.append(f'{name} changed (schemaVersion {a["schemaVersion"]} to {b["schemaVersion"]})')
            conditions.add('always' if a['required'] and b['required'] else 'held' if renders else 'never')
        if a['required'] and not b['required']:
            texts.append(f'{name} became optional in version {version}')
            conditions.add('lacking')
        if not a['required'] and b['required']:
            texts.append(f'{name} became required in version {version}')
            conditions.add('never' if shown else 'always')
        added = [] if rose else [p for p in b['paths'] if p not in a['paths']]
        if added:
            texts.append(f'{name} has new optional fields in version {version}: {", ".join(added)}')
            conditions.add('never')
        if texts:
            findings.append({'group': name, 'text': '; '.join(texts), 'error': worst(conditions), 'paths': b['paths'],
                             'new_paths': added if renders else []})
    return findings


def worst(conditions):
    """One finding's result from several: an error both when held and when lacking is always an error."""
    if 'always' in conditions or {'held', 'lacking'} <= conditions:
        return 'always'
    return next((c for c in ('held', 'lacking') if c in conditions), 'never')


def judge(findings, record):
    """Apply `compare`'s findings to one record: (errors, warnings, new fields it holds and the Variation
    does not show, as "group: path")."""
    errors, warnings, new_facts = [], [], []
    for finding in findings:
        held = holds(record, finding)
        if finding['error'] == 'always' or (finding['error'] == 'held' and held) or (finding['error'] == 'lacking' and not held):
            reason = {'held': ', and this record holds it', 'lacking': ', and this record has none of it'}.get(finding['error'], '')
            errors.append(finding['text'] + reason)
        else:
            warnings.append(finding['text'])
        new_facts += [f'{finding["group"]}: {path}' for path in finding['new_paths'] if holds(record, {'paths': [path]})]
    return errors, warnings, new_facts


def check_domain(domain, domains_root=DOMAINS, base_root=BASE):
    """Problems with a Domain's kept contracts: a version missing, a file whose `domain` or `version`
    disagrees with its name, an `oldestSupported` that is not kept, a structural break between versions."""
    kept, problems = versions(domain, domains_root), []
    if kept != list(range(1, len(kept) + 1)):
        problems.append(f'kept versions {kept} skip one: every past version stays')
    for v in kept:
        own = read(domains_root / domain / 'contracts' / f'v{v}.json')
        if own.get('version') != v or own.get('domain') != domain:
            problems.append(f'v{v}.json says domain {own.get("domain")!r}, version {own.get("version")!r}')
    oldest = oldest_supported(domain, domains_root)
    if kept and (not isinstance(oldest, int) or isinstance(oldest, bool) or oldest not in kept):
        problems.append(f'oldestSupported {oldest!r} is not a kept version')
    for a, b in zip(kept, kept[1:]):
        old, new = contract(domain, a, domains_root, base_root), contract(domain, b, domains_root, base_root)
        problems += [f'v{a} to v{b}: {text}' for text in broken(old, new)]
    return problems


def compatibility(domain, template, name, variation, domains_root=DOMAINS, base_root=BASE):
    """One Template Variation against a Domain's newest kept contract, for the suite and `cv.py contracts`:
    the versions it renders, how many it is behind, what a record on the newest version meets there
    (each finding with its RESULT), and the coverage figure at the newest version."""
    claimed, _ = claims(variation, domain)
    reads = supported(variation, domain, domains_root)
    newest = versions(domain, domains_root)[-1]
    groups = contract(domain, newest, domains_root, base_root)['groups']
    optional = [g for g, group in groups.items() if not group['required']]
    covered = [g for g in optional if groups[g]['schemaVersion'] in (claimed or {}).get(g, ())]
    report = {'template': template, 'variation': name, 'domain': domain, 'renders': reads, 'newest': newest,
              'behind': newest - reads[-1] if reads else None, 'findings': [],
              'coverage': f'{len(covered)} of {len(optional)} optional groups'}
    if reads and report['behind']:
        old = contract(domain, reads[-1], domains_root, base_root)
        report['findings'] = [{'group': f['group'], 'text': f['text'], 'result': RESULT[f['error']]}
                              for f in compare(old, contract(domain, newest, domains_root, base_root), claimed)]
    return report


def describe(report):
    """A compatibility report as lines for the CLI and the suite's evidence."""
    head = f'{report["template"]} {report["variation"]} on {report["domain"]}'
    if not report['renders']:
        return [f'{head}: renders no version the engine still reads (newest {report["newest"]}); update the Template']
    lines = [f'{head}: renders version {span(report["renders"])}, newest {report["newest"]}; '
             f'{report["coverage"]} at version {report["newest"]}']
    if report['behind']:
        stops = any(f['result'] != 'warning' for f in report['findings'])
        lines.append(f'  {behind(report["behind"])}: a version {report["newest"]} record '
                     + ('can stop the render' if stops else 'renders with warnings'))
        lines += [f'  - {f["text"]}: {f["result"]}' for f in report['findings']]
    return lines


def report(domains_root=DOMAINS, base_root=BASE):
    """Every Template Variation's compatibility with its Domains' newest contracts."""
    return [compatibility(domain, template, name, variation, domains_root, base_root)
            for _folder, template, design in manifests(domains_root)
            for name, variation in design['variations'].items()
            for domain in variation['supports'] if versions(domain, domains_root)]


def squeeze(text):
    return ''.join(text.split()).casefold()


def coverage(text, images, groups, claimed, markers, elsewhere=()):
    """Judge a Coverage Fixture's PDF: (failures, warnings). `text` is the PDF's text, `images` its raster
    image count, `markers` each group's tokens; a group with the marker "image" is proved by an image.
    `claimed` maps each claimed group to its schema versions; `elsewhere` names the groups another
    version the Variation supports has, so a claim of one this version lacks is not refused."""
    found = squeeze(text)

    def shown(name):
        return bool(markers[name]) and all(images > 0 if token == 'image' else squeeze(token) in found for token in markers[name])

    failures, warnings = [], []
    unknown = sorted(set(claimed) - set(groups) - set(elsewhere))
    failures += [f'claims {name}, which the contract does not have' for name in unknown]
    for name, group in groups.items():
        if name not in markers:
            failures.append(f'the fixture has no marker for {name}')
        elif group['required'] or name in claimed:
            if name in claimed and group['schemaVersion'] not in claimed[name]:
                at = '/'.join(map(str, sorted(claimed[name])))
                failures.append(f'claims {name}@{at}, the contract has @{group["schemaVersion"]}')
            elif not shown(name):
                failures.append(f'{"required" if group["required"] else "claims"} {name} but a marker is not in the PDF')
        elif shown(name):
            warnings.append(f'renders {name} but does not claim it: update the manifest')
    return failures, warnings
