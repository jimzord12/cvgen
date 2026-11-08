"""The Template Contract in the suite (ADR 0016): each Template Variation's claims proved on its Domain's
Coverage Fixture, then the judging itself and the checks before a client's render. Run by tests/run.py."""
import json
import re
import subprocess
import sys

import pymupdf as fitz

from verify import ROOT

sys.path.insert(0, str(ROOT / 'packages/cv-workflow'))

from cv_workflow import WorkflowError  # noqa: E402
from cv_workflow.contracts import check_groups, choose, claims, contract, coverage, holds, manifests, read, template_in, versions  # noqa: E402
from cv_workflow.render import without_comments  # noqa: E402

DOMAINS = ROOT / 'packages/domains'
GROUPS = {'identity': {'required': True, 'schemaVersion': 1, 'paths': ['identity.name']},
          'skills': {'required': False, 'schemaVersion': 1, 'paths': ['skill_groups']},
          'ships': {'required': False, 'schemaVersion': 1, 'paths': ['companies.*.ships.*.engine']}}


def refused(call, message):
    try:
        call()
    except WorkflowError as error:
        assert message in str(error), str(error)
    else:
        raise AssertionError('not refused: ' + message)


def prove(out, typst, flags, domain, template, design, name, version, fixture):
    """Render one Coverage Fixture through one Template Variation and judge the PDF."""
    stem = f'{template}-{name}-{fixture.stem}'
    pdf = out / f'{stem}.pdf'
    entry = DOMAINS / domain / 'templates' / template / design['coverage']

    def render(record, target):
        root_path = '/' + record.relative_to(ROOT).as_posix()
        run = subprocess.run([typst, 'compile', '--root', str(ROOT), *flags, '--input', f'fixture={root_path}', '--input', f'variation={name}', str(entry), str(target)],
                             capture_output=True, text=True, encoding='utf-8')
        assert run.returncode == 0, run.stderr
        with fitz.open(target) as doc:
            return ' '.join(page.get_text() for page in doc), sum(len(page.get_images()) for page in doc)

    text, images = render(fixture, pdf)
    # A template may draw small rasters of its own (Hanami's blurred petals), so the portrait is proved by the
    # images the same fixture without one lacks, never by "any image".
    plain = read(fixture)
    if (plain.get('identity') or {}).get('portrait'):
        plain['identity'] = {k: v for k, v in plain['identity'].items() if k != 'portrait'}
        bare = out / f'{stem}-no-portrait.json'
        bare.write_text(json.dumps(plain, ensure_ascii=False), encoding='utf-8')
        images -= render(bare, out / f'{stem}-no-portrait.pdf')[1]
    groups = contract(domain, version)['groups']
    claimed, _ = claims(design['variations'][name], domain)
    markers = read(fixture.with_suffix('.markers.json'))
    failures, warnings = coverage(text, images, groups, claimed, markers)
    assert not failures, (template, name, failures)
    covered = sum(1 for key, group in groups.items() if not group['required'] and key in claimed)
    optional = sum(1 for group in groups.values() if not group['required'])
    (out / f'{stem}.json').write_text(json.dumps(
        {'covered': covered, 'optional': optional, 'warnings': warnings}, indent=2), encoding='utf-8')
    return f'{template} {name} on {fixture.stem}: {covered} of {optional} optional groups'


def run_coverage(out, typst, flags):
    folder = out / 'coverage'
    folder.mkdir(exist_ok=False)
    checks = []
    for _domain, template, design in manifests():
        assert design['default'] in design['variations'], template
        for name, variation in design['variations'].items():
            for owner, _support in variation['supports'].items():
                _, supported = claims(variation, owner)
                for version in supported:
                    fixtures = [p for p in sorted((DOMAINS / owner / 'fixtures').glob(f'coverage-v{version}*.json')) if re.fullmatch(rf'coverage-v{version}(-[a-z-]+)?\.json', p.name)]
                    assert fixtures, (owner, version)
                    for fixture in fixtures:
                        checks.append(prove(folder, typst, flags, owner, template, design, name, version, fixture))

    # The judging itself, on a fixed text.
    markers = {'identity': ['QXNAME'], 'skills': ['QXSKILL'], 'ships': ['QXSHIP']}
    assert coverage('QXNAME QXSKILL', 0, GROUPS, {'skills': 1}, markers) == ([], [])
    assert coverage('QXNAME', 0, GROUPS, {'skills': 1}, markers)[0] == ['claims skills but a marker is not in the PDF']
    assert coverage('QXSKILL', 0, GROUPS, {}, markers)[0] == ['required identity but a marker is not in the PDF']
    assert coverage('QXNAME QXSKILL', 0, GROUPS, {}, markers)[1] == ['renders skills but does not claim it: update the manifest']
    assert coverage('QXNAME', 0, GROUPS, {'skills': 2}, markers)[0] == ['claims skills@2, the contract has @1']
    assert coverage('QXNAME', 0, GROUPS, {'nothing': 1}, markers)[0] == ['claims nothing, which the contract does not have']
    assert coverage('QXNAME', 0, GROUPS, {}, {'identity': ['QXNAME']})[0] == ['the fixture has no marker for skills', 'the fixture has no marker for ships']
    picture = {'p': {'required': True, 'schemaVersion': 1}}
    assert coverage('', 1, picture, {}, {'p': ['image']}) == ([], [])
    assert coverage('', 0, picture, {}, {'p': ['image']})[0] == ['required p but a marker is not in the PDF']
    assert coverage('', 1, picture, {}, {'p': []})[0] == ['required p but a marker is not in the PDF']
    checks.append('a false claim, a missing required group and an unclaimed group are caught')

    # What a record holds, and what a Template Variation drops.
    record = {'identity': {'name': 'A'}, 'skill_groups': [['B']], 'companies': [{'ships': [{'engine': 'C'}, {}]}]}
    assert holds(record, GROUPS['ships']) and not holds({'companies': [{'ships': [{}]}]}, GROUPS['ships'])
    assert check_groups(record, GROUPS, {}) == ([], ['skills', 'ships'])
    assert check_groups({}, GROUPS, {})[0] == ['identity']
    checks.append('a group is found through a path, and dropped groups are named')

    # Every path of each real contract resolves on its fixture, so no drop can pass unseen through a typo.
    for domain in ('marine', 'travel'):
        fixture = read(DOMAINS / domain / 'fixtures/coverage-v1.json')
        for name, group in contract(domain, 1)['groups'].items():
            assert holds(fixture, group), (domain, name)

    # The checks before a render, on the real marine contract.
    facts = json.loads((ROOT / 'examples/candidates/engineer-example.json').read_text(encoding='utf-8'))
    imports = '#import "/packages/domains/marine/lib.typ": flagship\n'
    source = imports + '#show: flagship.with(candidate: record)'
    envelope = {'domain': 'marine', 'template': 'flagship', 'variation': 'showcase'}
    assert versions('marine') == [1] and versions('travel') == [1] and versions('software') == [] and template_in('marine', source) == 'flagship'
    assert template_in('marine', '#fc.hero(ctx, d) // flagship-components') is None
    assert template_in('marine', without_comments(imports + '#fc.hero(ctx, d) // not flagship(): it does not fit')) is None
    assert choose({'domain': 'travel'}, source, facts) is None
    chosen, warnings = choose(envelope, source, facts)
    assert chosen == {'template': 'flagship', 'variation': 'showcase', 'domain_contract': 1, 'dropped': []} and not warnings, (chosen, warnings)
    assert "envelope.json names no template; 'flagship' read from typst/cv.typ" in choose({'domain': 'marine'}, source, facts)[1]
    custom = imports + '#fc.hero(ctx, d)'
    assert choose({'domain': 'marine'}, custom, facts)[0] == {'domain_contract': 1}
    assert choose({'domain': 'marine'}, '#import "/packages/cv-framework/lib.typ": make-ctx', {'identity': {'name': 'A'}}) is None
    narrow = {'default': 'calm', 'variations': {'calm': {'supports': {'marine': {'upTo': 1, 'groups': ['profile@1', 'education@1', 'languages@1', 'certificates@1', 'vessel-particulars@1']}}}}}
    dropped = choose({'domain': 'marine', 'template': 'flagship', 'variation': 'calm'}, source, {**facts, 'skill_groups': [['A']]}, design=narrow)
    assert dropped[0]['dropped'] == ['portrait', 'skills'] and dropped[1] == [f'flagship calm does not show {name}: this CV leaves those facts out' for name in ('portrait', 'skills')], dropped
    assert 'dropped' in read(ROOT / 'packages/cv-workflow/cv_workflow/output.schema.json')['properties']
    refused(lambda: choose(envelope, source, {k: v for k, v in facts.items() if k != 'contacts'}), 'candidate.json has no contacts, required by the marine contract')
    refused(lambda: choose({'domain': 'marine'}, custom, {}), 'candidate.json has no identity, contacts, experience, rank')
    refused(lambda: choose(envelope, custom, facts), "envelope.json says template 'flagship' but typst/cv.typ does not render it")
    refused(lambda: choose(envelope, source + '\n// x\n#let a = (variation: sys.inputs.v)', facts), 'must name its variation as plain text')
    refused(lambda: choose(envelope, imports + '#show: flagship.with(variation : "other")', facts), "typst/cv.typ renders 'other'")
    assert choose(envelope, imports + '#show: flagship.with(variation: none, layout-variation: auto)', facts)[0]['variation'] == 'showcase'
    refused(lambda: choose({**envelope, 'variation': ['x']}, source, facts), 'envelope.json variation must be a name in quotes')
    refused(lambda: choose(envelope, source, {**facts, 'domainContract': 1.0}), 'marine contract version 1.0, which is not kept')
    refused(lambda: choose({**envelope, 'template': 'other'}, source, facts), "envelope.json says template 'other' but typst/cv.typ renders 'flagship'")
    refused(lambda: choose({**envelope, 'variation': 'other'}, source, facts), "'flagship' has no Template Variation 'other'")
    refused(lambda: choose(envelope, imports + '#show: flagship.with(variation: "other")', facts), "envelope.json says variation 'showcase' but typst/cv.typ renders 'other'")
    refused(lambda: choose(envelope, source, {**facts, 'domainContract': 9}), 'marine contract version 9, which is not kept')
    checks.append('a render stops on a missing group and on a choice that disagrees')

    # The same checks on the travel contract (P-0013): Hanami, its default, and a record without its optional groups.
    tour = json.loads((ROOT / 'examples/candidates/tour-leader-example.json').read_text(encoding='utf-8'))
    hanami = '#import "/packages/domains/travel/lib.typ": hanami\n#show: hanami.with(candidate: record, variation: "showcase")'
    trip = {'domain': 'travel', 'template': 'hanami', 'variation': 'showcase'}
    assert template_in('travel', hanami) == 'hanami' and template_in('travel', source) is None
    assert choose(trip, hanami, tour) == ({'template': 'hanami', 'variation': 'showcase', 'domain_contract': 1, 'dropped': []}, [])
    bare = {k: v for k, v in tour.items() if k in ('identity', 'contacts', 'experience', 'destinations')}
    assert choose(trip, hanami, bare)[0]['dropped'] == []
    refused(lambda: choose(trip, hanami, {k: v for k, v in bare.items() if k != 'destinations'}),
            'candidate.json has no destinations, required by the travel contract')
    assert choose(trip, hanami, {**tour, 'certificates': [{'title': 'A', 'scope': 'B', 'issued': 'C'}]})[0]['dropped'] == ['certificates']
    refused(lambda: choose(trip, hanami, {**tour, 'identity': {'name': 'A'}}), 'candidate.json has no rank, required by the travel contract')
    refused(lambda: choose({**trip, 'template': 'flagship'}, hanami, tour), "envelope.json says template 'flagship' but typst/cv.typ renders 'hanami'")
    checks.append('the travel contract: Hanami chosen, certificates dropped, a missing rank or destinations refused')
    return checks
