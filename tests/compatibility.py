"""Stage 2 of the Template Contract (P-0019 section 6) on synthetic contracts in a temporary folder: a Domain
at versions 1 and 2, Template Variations that support up to 1, exactly 1 and 2, up to 2 and exactly 2,
and every refusal and warning a record on another version meets. Run by tests/run.py."""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

from verify import ROOT

sys.path.insert(0, str(ROOT / 'packages/cv-workflow'))

from cv_workflow import WorkflowError  # noqa: E402
from cv_workflow.contracts import (FIX, check_domain, choose, claims, compare, compatibility, describe, judge,  # noqa: E402
                                  oldest_supported, readable, report, supported)

BASE = {'id': 'base', 'version': 1, 'groups': {
    'identity': {'required': True, 'schemaVersion': 1, 'paths': ['identity.name']},
    'profile': {'required': False, 'schemaVersion': 1, 'paths': ['profile']}}}
V1 = {'domain': 'demo', 'version': 1, 'extends': 'base@1', 'groups': {
    'experience': {'required': True, 'schemaVersion': 1, 'paths': ['jobs']},
    'places': {'required': False, 'schemaVersion': 1, 'paths': ['places.*.name']},
    'skills': {'required': False, 'schemaVersion': 1, 'paths': ['skills']}}}
# Version 2: places breaks (schemaVersion 2), licences is a new optional group, skills gains an optional field.
V2 = {'domain': 'demo', 'version': 2, 'extends': 'base@1', 'groups': {
    'experience': {'required': True, 'schemaVersion': 1, 'paths': ['jobs']},
    'places': {'required': False, 'schemaVersion': 2, 'paths': ['places.*.city']},
    'skills': {'required': False, 'schemaVersion': 1, 'paths': ['skills', 'skill_notes']},
    'licences': {'required': False, 'schemaVersion': 1, 'paths': ['licences']}}}
CARD = {'id': 'card', 'default': 'behind', 'variations': {
    'behind': {'supports': {'demo': {'upTo': 1, 'groups': ['profile@1', 'places@1', 'skills@1']}}},
    'both': {'supports': {'demo': {'exactly': [1, 2], 'groups': ['profile@1', 'places@1', 'places@2', 'skills@1', 'licences@1']}}},
    'latest': {'supports': {'demo': {'upTo': 2, 'groups': ['places@2', 'licences@1']}}},
    'only-two': {'supports': {'demo': {'exactly': [2], 'groups': ['places@2']}}}}}


def card(domain):
    """The same Template under another Domain."""
    return json.loads(json.dumps(CARD).replace('"demo"', json.dumps(domain)))


R1 = {'identity': {'name': 'A'}, 'jobs': ['J'], 'places': [{'name': 'P'}]}
R2 = {'domainContract': 2, 'identity': {'name': 'A'}, 'jobs': ['J'], 'places': [{'city': 'C'}], 'licences': ['L'],
      'skills': ['S'], 'skill_notes': ['N']}
QUIET = {k: v for k, v in R2.items() if k != 'places'}


def write(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data), encoding='utf-8')


def refused(call, message):
    try:
        call()
    except WorkflowError as error:
        assert message in str(error), str(error)
        return str(error)
    raise AssertionError('not refused: ' + message)


def g(required, schema_version=1, paths=None):
    return {'required': required, 'schemaVersion': schema_version, 'paths': paths or ['x']}


def one(old, new, claimed=()):
    """The single finding for group x between two one-group contracts."""
    found = compare({'version': 1, 'groups': {'x': old} if old else {}},
                    {'domain': 'd', 'version': 2, 'groups': {'x': new} if new else {}}, set(claimed))
    assert len(found) == 1, found
    return found[0]


def run_compatibility(out):
    folder = out / 'compatibility'
    folder.mkdir(exist_ok=False)
    checks = []
    with tempfile.TemporaryDirectory() as scratch:
        base, domains = Path(scratch) / 'base', Path(scratch) / 'domains'
        write(base / 'base-v1.json', BASE)
        for domain, last in (('demo', V2), ('later', {**V2, 'domain': 'later', 'oldestSupported': 2})):
            write(domains / domain / 'contracts/v1.json', {**V1, 'domain': domain})
            write(domains / domain / 'contracts/v2.json', last)
            write(domains / domain / 'templates/card/template.json', card(domain))
        roots = {'domains_root': domains, 'base_root': base}

        def pick(variation, record, domain='demo'):
            source = f'#import "/packages/domains/{domain}/lib.typ": card\n#show: card.with(candidate: r, variation: "{variation}")'
            return choose({'domain': domain, 'template': 'card', 'variation': variation}, source, record, **roots)

        # How a Variation declares support, and which versions the engine still reads.
        variations = CARD['variations']
        assert claims(variations['behind'], 'demo') == ({'profile': {1}, 'places': {1}, 'skills': {1}}, [1])
        assert claims(variations['both'], 'demo')[0]['places'] == {1, 2} and claims(variations['latest'], 'demo')[1] == [1, 2]
        assert claims(variations['behind'], 'other') == (None, [])
        refused(lambda: claims({'supports': {'d': {'upTo': 1, 'exactly': [1], 'groups': []}}}, 'd'), 'must name either upTo or exactly')
        refused(lambda: claims({'supports': {'d': {'exactly': [2, 1], 'groups': []}}}, 'd'), 'each once and rising')
        refused(lambda: claims({'supports': {'d': {'upTo': 1, 'groups': ['places']}}}, 'd'), "'places' is not name@schemaVersion")
        assert oldest_supported('demo', domains) == 1 and oldest_supported('later', domains) == 2 and oldest_supported('none', domains) is None
        later = card('later')['variations']
        assert readable('later', domains) == [2] and supported(later['latest'], 'later', domains) == [2]
        assert supported(later['behind'], 'later', domains) == []
        checks.append('a Variation declares upTo or exactly, and claims a group at one or more schema versions')

        # A supported version renders as in Stage 1.
        assert pick('both', R2) == ({'template': 'card', 'variation': 'both', 'domain_contract': 2, 'dropped': []}, [])
        assert pick('behind', R1) == ({'template': 'card', 'variation': 'behind', 'domain_contract': 1, 'dropped': []}, [])
        chosen, warnings = pick('latest', R2)
        assert chosen['dropped'] == ['skills'] and warnings == ['card latest does not show skills: this CV leaves those facts out'], warnings

        # A record one version ahead: a group the Variation renders that changed stops it when the record holds it.
        error = refused(lambda: pick('behind', R2), 'card behind supports demo contract up to version 1; this record follows version 2:')
        assert error.splitlines()[1:] == ['  places changed (schemaVersion 1 to 2), and this record holds it', FIX], error
        # Without that group it renders: behind, the new optional group and the new field count as dropped.
        chosen, warnings = pick('behind', QUIET)
        assert chosen['dropped'] == ['licences', 'skills: skill_notes'], chosen
        assert warnings == [
            'card behind does not show licences: this CV leaves those facts out',
            'card behind supports demo contract up to version 1; this record follows version 2 (1 version behind); it renders: '
            'licences is a new optional group in version 2; places changed (schemaVersion 1 to 2); '
            'skills has new optional fields in version 2: skill_notes',
            'card behind does not show the new field skills: skill_notes: this CV leaves those facts out'], warnings
        # A record older than every version a Variation declares stops, as does one below oldestSupported.
        refused(lambda: pick('only-two', R1), f'card only-two supports demo contract version 2; this record follows version 1, '
                                              f'which it does not render. {FIX}')
        refused(lambda: pick('behind', R1, 'later'), 'later contract version 1, which the engine no longer reads (oldest 2); '
                                                     'upgrade the record to version 2 or later')
        checks.append('a record on a newer version renders with warnings, or stops naming the group and the fix')

        # The report the suite keeps and `cv.py contracts` prints.
        found = {r['variation']: r for r in report(**roots) if r['domain'] == 'demo'}
        assert found['both']['behind'] == 0 and found['both']['coverage'] == '4 of 4 optional groups'
        assert found['behind']['behind'] == 1 and found['behind']['coverage'] == '2 of 4 optional groups'
        assert describe(found['behind']) == [
            'card behind on demo: renders version 1, newest 2; 2 of 4 optional groups at version 2',
            '  1 version behind: a version 2 record can stop the render',
            '  - licences is a new optional group in version 2: warning',
            '  - places changed (schemaVersion 1 to 2): error when the record holds it',
            '  - skills has new optional fields in version 2: skill_notes: warning'], describe(found['behind'])
        assert describe(found['latest'])[0] == 'card latest on demo: renders version 1 to 2, newest 2; 2 of 4 optional groups at version 2'
        assert describe(compatibility('later', 'card', 'behind', later['behind'], **roots)) == [
            'card behind on later: renders no version the engine still reads (newest 2); update the Template']
        (folder / 'report.txt').write_text('\n'.join(line for r in report(**roots) for line in describe(r)) + '\n', encoding='utf-8')
        checks.append('the report says how far behind each Variation is and what a newer record meets')

        # Every row of the section 6 table, group by group.
        assert one(g(False), g(False, 2))['error'] == 'never'                     # nothing it uses
        assert one(None, g(False))['error'] == 'never'                            # a new optional group
        assert one(g(False, 1, ['a']), g(False, 1, ['a', 'b']), 'x')['new_paths'] == ['b']   # a new optional field
        assert one(g(False, 1, ['a']), g(False, 1, ['a', 'b']))['new_paths'] == []           # ... in a group it drops anyway
        assert one(g(False), g(False, 2), 'x')['error'] == 'held'                 # an optional group it claims changed
        assert one(g(False), None, 'x')['error'] == 'held'                        # ... or was removed
        assert one(g(False), None)['error'] == 'never'
        assert one(g(True), g(False))['error'] == 'lacking'                       # a required group became optional
        assert one(g(False), g(True), 'x')['error'] == 'never'                    # an optional group became required, claimed
        assert one(g(False), g(True))['error'] == 'always'                        # ... not claimed
        assert one(None, g(True))['error'] == 'always'                            # a required group is new
        assert one(g(True), g(True, 2))['error'] == 'always'                      # ... changed
        assert one(g(True), None)['error'] == 'always'                            # ... removed
        assert one(g(True), g(False, 2))['error'] == 'always'                     # rendered, changed and now optional
        finding = one(g(True), g(False))
        assert judge([finding], {'x': 1}) == ([], ['x became optional in version 2'], [])
        assert judge([finding], {}) == (['x became optional in version 2, and this record has none of it'], [], [])
        assert judge([one(g(False), None, 'x')], {'x': 1})[0] == ['x was removed in version 2, and this record holds it']
        assert judge([one(g(False), None, 'x')], {})[1] == ['x was removed in version 2']
        checks.append('every row of the compatibility table, one group at a time')

        # A structural break without a schemaVersion rise is refused, and so is a gap in the kept versions.
        refused(lambda: one(g(False, 1, ['a', 'b']), g(False, 1, ['a'])), 'x lost b without its schemaVersion rising; raise it')
        refused(lambda: one(g(False, 2), g(False, 1)), 'x schemaVersion fell from 2 to 1')
        assert check_domain('demo', **roots) == [] and check_domain('later', **roots) == []
        write(domains / 'gap/contracts/v1.json', {**V1, 'domain': 'gap'})
        write(domains / 'gap/contracts/v3.json', {**V2, 'domain': 'gap', 'version': 2, 'oldestSupported': 2,
                                                  'groups': {**V2['groups'], 'skills': g(False, 1, ['skill_notes'])}})
        assert check_domain('gap', **roots) == ['kept versions [1, 3] skip one: every past version stays',
                                                "v3.json says domain 'gap', version 2",
                                                'oldestSupported 2 is not a kept version',
                                                'v1 to v3: skills lost skills without its schemaVersion rising'], check_domain('gap', **roots)
        checks.append('a contract that breaks a group without raising its schemaVersion is refused')

    # The CLI prints the same report for the real Domains.
    run = subprocess.run([sys.executable, str(ROOT / 'scripts/cv.py'), 'contracts'], capture_output=True, text=True, encoding='utf-8')
    assert run.returncode == 0 and run.stdout.startswith('flagship showcase on marine: renders version 1'), (run.stdout, run.stderr)
    (folder / 'cv-contracts.txt').write_text(run.stdout, encoding='utf-8')
    checks.append('cv.py contracts prints each Template Variation against its newest contract')
    return checks
