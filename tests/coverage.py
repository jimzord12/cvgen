"""The Template Contract in the suite (ADR 0016): each Template Variation's claims proved on its Domain's
Coverage Fixture, then the judging itself and the checks before a client's render. Run by tests/run.py."""
import json
import subprocess
import sys

import pymupdf as fitz

from verify import ROOT

sys.path.insert(0, str(ROOT / 'packages/cv-workflow'))

from cv_workflow import WorkflowError  # noqa: E402
from cv_workflow.contracts import check_groups, choose, claims, contract, coverage, holds, manifests, read, template_in, versions  # noqa: E402

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


def prove(out, typst, flags, domain, template, design, name, version):
    """Render the Coverage Fixture through one Template Variation and judge the PDF."""
    fixture = DOMAINS / domain / 'fixtures' / f'coverage-v{version}.json'
    pdf = out / f'{template}-{name}-{domain}-v{version}.pdf'
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
    failures, warnings = coverage(text, images, groups, claimed, markers)
    assert not failures, (template, name, failures)
    covered = sum(1 for key, group in groups.items() if not group['required'] and key in claimed)
    optional = sum(1 for group in groups.values() if not group['required'])
    (out / f'{template}-{name}-{domain}-v{version}.json').write_text(json.dumps(
        {'covered': covered, 'optional': optional, 'warnings': warnings}, indent=2), encoding='utf-8')
    return f'{template} {name} on {domain}@{version}: {covered} of {optional} optional groups'


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
                    checks.append(prove(folder, typst, flags, owner, template, design, name, version))

    # The judging itself, on a fixed text.
    markers = {'identity': ['QXNAME'], 'skills': ['QXSKILL'], 'ships': ['QXSHIP']}
    assert coverage('QXNAME QXSKILL', 0, GROUPS, {'skills': 1}, markers) == ([], [])
    assert coverage('QXNAME', 0, GROUPS, {'skills': 1}, markers)[0] == ['claims skills but a marker is not in the PDF']
    assert coverage('QXSKILL', 0, GROUPS, {}, markers)[0] == ['required identity but a marker is not in the PDF']
    assert coverage('QXNAME QXSKILL', 0, GROUPS, {}, markers)[1] == ['renders skills but does not claim it: update the manifest']
    assert coverage('QXNAME', 0, GROUPS, {'skills': 2}, markers)[0] == ['claims skills@2, the contract has @1']
    assert coverage('QXNAME', 0, GROUPS, {'nothing': 1}, markers)[0] == ['claims nothing, which the contract does not have']
    assert coverage('QXNAME', 0, GROUPS, {}, {'identity': ['QXNAME']})[0] == ['the fixture has no marker for skills', 'the fixture has no marker for ships']
    assert coverage('', 1, {'p': {'required': True, 'schemaVersion': 1}}, {}, {'p': ['image']}) == ([], [])
    checks.append('a false claim, a missing required group and an unclaimed group are caught')

    # What a record holds, and what a Template Variation drops.
    record = {'identity': {'name': 'A'}, 'skill_groups': [['B']], 'companies': [{'ships': [{'engine': 'C'}, {}]}]}
    assert holds(record, GROUPS['ships']) and not holds({'companies': [{'ships': [{}]}]}, GROUPS['ships'])
    assert check_groups(record, GROUPS, {}) == ([], ['skills', 'ships'])
    assert check_groups({}, GROUPS, {})[0] == ['identity']
    checks.append('a group is found through a path, and dropped groups are named')

    # The checks before a render, on the real marine contract.
    facts = json.loads((ROOT / 'examples/candidates/engineer-example.json').read_text(encoding='utf-8'))
    source = '#show: flagship.with(candidate: record)'
    envelope = {'domain': 'marine', 'template': 'flagship', 'variation': 'showcase'}
    assert versions('marine') == [1] and versions('travel') == [] and template_in('marine', source) == 'flagship'
    assert template_in('marine', '#fc.hero(ctx, d) // flagship-components') is None
    assert choose({'domain': 'travel'}, source, facts) is None
    chosen, warnings = choose(envelope, source, facts)
    assert chosen == {'template': 'flagship', 'variation': 'showcase', 'domain_contract': 1, 'dropped': []} and not warnings, (chosen, warnings)
    assert "envelope.json names no template; 'flagship' read from typst/cv.typ" in choose({'domain': 'marine'}, source, facts)[1]
    assert choose({'domain': 'marine'}, '#fc.hero(ctx, d)', facts)[0] == {'domain_contract': 1}
    refused(lambda: choose(envelope, source, {k: v for k, v in facts.items() if k != 'contacts'}), 'candidate.json has no contacts, required by the marine contract')
    refused(lambda: choose({'domain': 'marine'}, '#fc.hero(ctx, d)', {}), 'candidate.json has no identity, contacts, experience, rank')
    refused(lambda: choose({**envelope, 'template': 'other'}, source, facts), "envelope.json says template 'other' but typst/cv.typ renders 'flagship'")
    refused(lambda: choose({**envelope, 'variation': 'other'}, source, facts), "'flagship' has no Template Variation 'other'")
    refused(lambda: choose(envelope, '#show: flagship.with(variation: "other")', facts), "envelope.json says variation 'showcase' but typst/cv.typ renders 'other'")
    refused(lambda: choose(envelope, source, {**facts, 'domainContract': 9}), 'marine contract version 9, which is not kept')
    checks.append('a render stops on a missing group and on a choice that disagrees')
    return checks
