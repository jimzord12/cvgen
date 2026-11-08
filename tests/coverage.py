"""The Template Contract in the suite (ADR 0016): each Template Variation's claims proved on its Domain's
Coverage Fixture, then the judging itself and the checks before a client's render. Run by tests/run.py."""
from datetime import date
import json
import re
import subprocess
import sys

import pymupdf as fitz

from verify import ROOT

sys.path.insert(0, str(ROOT / 'packages/cv-workflow'))

from cv_workflow import WorkflowError  # noqa: E402
from cv_workflow.contracts import (FIX, check_domain, check_groups, choose, claims, compatibility, contract, coverage, describe,  # noqa: E402
                                  holds, manifests, oldest_supported, read, supported, template_in, unproved, versions)
from cv_workflow.checks import check_certificates  # noqa: E402
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


def refused_text(call, message):
    """The refusal's whole text, after checking it says `message`."""
    try:
        call()
    except WorkflowError as error:
        assert message in str(error), str(error)
        return str(error)
    raise AssertionError('not refused: ' + message)


def prove(out, typst, flags, domain, template, design, name, version, fixture, elsewhere):
    """Render one Coverage Fixture through one Template Variation and judge the PDF."""
    stem = f'{template}-{name}-{fixture.stem}'
    pdf = out / f'{stem}.pdf'
    entry = DOMAINS / domain / 'templates' / template / design['coverage']
    root_path = '/' + fixture.relative_to(ROOT).as_posix()
    run = subprocess.run([typst, 'compile', '--root', str(ROOT), *flags, '--input', f'fixture={root_path}', '--input', f'variation={name}', str(entry), str(pdf)],
                         capture_output=True, text=True, encoding='utf-8')
    assert run.returncode == 0, run.stderr
    with fitz.open(pdf) as doc:
        text = ' '.join(page.get_text() for page in doc)
        images = sum(len(page.get_images()) for page in doc)
    groups = contract(domain, version)['groups']
    claimed, _ = claims(design['variations'][name], domain)
    markers = read(fixture.with_suffix('.markers.json'))
    failures, warnings = coverage(text, images, groups, claimed, markers, elsewhere)
    assert not failures, (template, name, failures)
    covered = sum(1 for key, group in groups.items() if not group['required'] and group['schemaVersion'] in claimed.get(key, ()))
    optional = sum(1 for group in groups.values() if not group['required'])
    (out / f'{stem}.json').write_text(json.dumps(
        {'covered': covered, 'optional': optional, 'warnings': warnings}, indent=2), encoding='utf-8')
    return f'{template} {name} on {fixture.stem}: {covered} of {optional} optional groups'


def run_coverage(out, typst, flags):
    folder = out / 'coverage'
    folder.mkdir(exist_ok=False)
    checks = []
    reports = []
    for _domain, template, design in manifests():
        assert design['default'] in design['variations'], template
        for name, variation in design['variations'].items():
            for owner, _support in variation['supports'].items():
                # Each version it declares and the engine still reads; a claim another of them has may be absent here.
                renders = supported(variation, owner)
                elsewhere = {g for v in renders for g in contract(owner, v)['groups']}
                reports.append(compatibility(owner, template, name, variation))
                # Every claim is proved: each name@schemaVersion is in a version it names and the suite renders.
                missing = unproved(variation, owner)
                assert not missing, f'{template} {name} claims {", ".join(missing)}, which no version it renders has'
                for version in renders:
                    fixtures = [p for p in sorted((DOMAINS / owner / 'fixtures').glob(f'coverage-v{version}*.json')) if re.fullmatch(rf'coverage-v{version}(-[a-z-]+)?\.json', p.name)]
                    assert fixtures, (owner, version)
                    for fixture in fixtures:
                        checks.append(prove(folder, typst, flags, owner, template, design, name, version, fixture, elsewhere))
    # Behind is reported, never a failure (P-0019 section 7); the lines are what `cv.py contracts` prints.
    (folder / 'compatibility.json').write_text(json.dumps(reports, indent=2), encoding='utf-8')
    lines = [line for r in reports for line in describe(r)]
    (folder / 'compatibility.txt').write_text('\n'.join(lines) + '\n', encoding='utf-8')
    checks += [describe(r)[0] for r in reports]

    # Every Domain's kept contracts: none missing, none broken, and oldestSupported never past a version a frozen
    # record uses (constitution step: ADR, new Frozen Reference, version bump).
    for domain in sorted(p.name for p in DOMAINS.iterdir() if versions(p.name)):
        assert not check_domain(domain), (domain, check_domain(domain))
        for entry in sorted((ROOT / 'examples' / domain).rglob('*.typ')):
            for path in re.findall(r'json\("([^"]+)"\)', entry.read_text(encoding='utf-8')):
                used = read(entry.parent / path).get('domainContract', 1)
                assert used >= oldest_supported(domain), f'{entry.name} uses {domain} version {used}, below oldestSupported'
    checks.append('every kept Domain Contract is whole, unbroken and still reads the frozen records')

    # The judging itself, on a fixed text.
    markers = {'identity': ['QXNAME'], 'skills': ['QXSKILL'], 'ships': ['QXSHIP']}
    assert coverage('QXNAME QXSKILL', 0, GROUPS, {'skills': {1}}, markers) == ([], [])
    assert coverage('QXNAME', 0, GROUPS, {'skills': {1}}, markers)[0] == ['claims skills but a marker is not in the PDF']
    assert coverage('QXSKILL', 0, GROUPS, {}, markers)[0] == ['required identity but a marker is not in the PDF']
    assert coverage('QXNAME QXSKILL', 0, GROUPS, {}, markers)[1] == ['renders skills but does not claim it: update the manifest']
    assert coverage('QXNAME', 0, GROUPS, {'skills': {2}}, markers)[0] == ['claims skills@2, the contract has @1']
    assert coverage('QXNAME QXSKILL', 0, GROUPS, {'skills': {1, 2}}, markers) == ([], [])
    assert coverage('QXNAME', 0, GROUPS, {'skills': {2, 3}}, markers)[0] == ['claims skills@2/3, the contract has @1']
    assert coverage('QXNAME', 0, GROUPS, {'nothing': {1}}, markers)[0] == ['claims nothing, which the contract does not have']
    assert coverage('QXNAME', 0, GROUPS, {'nothing': {1}}, markers, elsewhere={'nothing'})[0] == []
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
        for version in versions(domain):
            fixture = read(DOMAINS / domain / f'fixtures/coverage-v{version}.json')
            assert fixture.get('domainContract', 1) == version, (domain, version)
            for name, group in contract(domain, version)['groups'].items():
                assert holds(fixture, group), (domain, version, name)

    # The checks before a render, on the real marine contract.
    facts = json.loads((ROOT / 'examples/candidates/engineer-example.json').read_text(encoding='utf-8'))
    imports = '#import "/packages/domains/marine/lib.typ": flagship\n'
    source = imports + '#show: flagship.with(candidate: record)'
    envelope = {'domain': 'marine', 'template': 'flagship', 'variation': 'showcase'}
    assert versions('marine') == [1] and versions('travel') == [1, 2] and versions('software') == [] and template_in('marine', source) == 'flagship'
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
    assert choose(trip, hanami, tour) == ({'template': 'hanami', 'variation': 'showcase', 'domain_contract': 2, 'dropped': []}, [])
    bare = {k: v for k, v in tour.items() if k in ('identity', 'contacts', 'experience')}
    assert choose(trip, hanami, bare)[0]['dropped'] == []
    assert choose(trip, hanami, {**tour, 'certificates': [{'title': 'A', 'scope': 'B', 'issued': 'C'}]})[0]['dropped'] == ['certificates']
    refused(lambda: choose(trip, hanami, {**tour, 'identity': {'name': 'A'}}), 'candidate.json has no rank, required by the travel contract')
    refused(lambda: choose({**trip, 'template': 'flagship'}, hanami, tour), "envelope.json says template 'flagship' but typst/cv.typ renders 'hanami'")
    checks.append('the travel contract: Hanami chosen, certificates dropped, a missing rank refused')

    # Travel contract version 2 (TASK-80): destinations@2 states each trip's role, licences is new and optional.
    # The twin follows version 2; without its roles and licence it is a version 1 record, which still renders.
    older = {k: v for k, v in tour.items() if k not in ('domainContract', 'licences')}
    older['destinations'] = {**tour['destinations'], 'trips': [{k: v for k, v in t.items() if k != 'role'} for t in tour['destinations']['trips']]}
    assert choose(trip, hanami, older) == ({'template': 'hanami', 'variation': 'showcase', 'domain_contract': 1, 'dropped': []}, [])
    # A Template Variation that stops at version 1 (as `essential` may) and one at version 2 without licences.
    shapes = ['profile@1', 'education@1', 'languages@1', 'portrait@1', 'availability@1', 'practical@1', 'references@1']
    travel_design = {'default': 'calm', 'variations': {
        'calm': {'supports': {'travel': {'upTo': 1, 'groups': [*shapes, 'destinations@1']}}},
        'plain': {'supports': {'travel': {'upTo': 2, 'groups': [*shapes, 'destinations@2']}}}}}

    def on(name, record):
        source = f'#import "/packages/domains/travel/lib.typ": hanami\n#show: hanami.with(candidate: record, variation: "{name}")'
        return choose({**trip, 'variation': name}, source, record, design=travel_design)
    assert on('calm', older) == ({'template': 'hanami', 'variation': 'calm', 'domain_contract': 1, 'dropped': []}, [])
    refusal = refused_text(lambda: on('calm', tour), 'hanami calm supports travel contract up to version 1; this record follows version 2:')
    assert refusal.splitlines()[1:] == ['  destinations changed (schemaVersion 1 to 2), and this record holds it', FIX], refusal
    nowhere = {k: v for k, v in tour.items() if k != 'destinations'}
    assert on('calm', nowhere) == ({'template': 'hanami', 'variation': 'calm', 'domain_contract': 2, 'dropped': ['licences']}, [
        'hanami calm does not show licences: this CV leaves those facts out',
        'hanami calm supports travel contract up to version 1; this record follows version 2 (1 version behind); it renders: '
        'destinations changed (schemaVersion 1 to 2); licences is a new optional group by version 2'])
    assert on('plain', tour) == ({'template': 'hanami', 'variation': 'plain', 'domain_contract': 2, 'dropped': ['licences']},
                                 ['hanami plain does not show licences: this CV leaves those facts out'])
    assert on('plain', older)[0]['dropped'] == [] and not on('plain', older)[1]
    # What `cv.py contracts` says of each: showcase renders both versions; calm is one behind.
    assert describe(compatibility('travel', 'hanami', 'calm', travel_design['variations']['calm'])) == [
        'hanami calm on travel: renders version 1, newest 2; 6 of 10 optional groups at version 2',
        '  1 version behind: a version 2 record can stop the render',
        '  - destinations changed (schemaVersion 1 to 2): error when the record holds it',
        '  - licences is a new optional group by version 2: warning']
    # An expired licence is a loud Certificate Warning at render, never a failure (owner, 2026-09-25).
    expiry = check_certificates({**tour, 'licences': [{'title': 'A', 'issuer': 'B', 'until': '1 Jan 2026'},
                                                       {'title': 'C', 'issuer': 'D', 'until': '30 Jan 2027'}, {'title': 'E', 'issuer': 'F'}]},
                                today=date(2026, 11, 8))
    assert expiry['warnings'] == [
        'Licence "A" EXPIRED on 1 Jan 2026 (311 days before the render date). Renew and update the date, or remove the licence.',
        'Licence "C" expires on 30 Jan 2027, in 83 days (within 180). Check the candidate has booked the renewal.'] and expiry['date_checked'] == 2, expiry
    assert check_certificates(tour, today=date(2026, 11, 8))['warnings'] == []
    checks.append('travel version 2: a version 1 record renders, a version 2 record with destinations is refused '
                  'below version 2, licences dropped where not claimed')
    return checks
