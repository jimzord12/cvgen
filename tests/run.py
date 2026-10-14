"""Run the meaningful library regression suite into a NEW output directory."""
import argparse
from datetime import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

import pymupdf as fitz
from verify import ROOT, FONTS, FLAGSHIP, verify, check_frozen
from workflow import run_workflow, system_font_family
from design_review import run_design_review
from repo_maintenance import run_repo_maintenance
from release import examples, run_build_script, shells
from proposals import run_proposals
from cv_workflow.render import STRICT_FONTS, font_fallbacks  # on the path through workflow.py


def check_core_boundary():
    """The Framework never reaches a domain (ADR 0011, 0012): core files import only their siblings, lib.typ
    only core files, and no Framework file names packages/domains, speaks marine or Flagship, reads a
    template's layout key or colour, names a Flagship colour or hard-codes a colour; every domain file that reaches the core goes through
    packages/cv-framework."""
    import re
    imports = re.compile(r'(?<![\w-])(?:import|include)\s+"([^"]+)"')
    framework = ROOT / 'packages/cv-framework'
    for source in sorted((framework / 'core').glob('*.typ')):
        for target in imports.findall(source.read_text(encoding='utf-8')):
            assert '/' not in target and '..' not in target, f'core/{source.name} imports outside core: {target}'
    for target in imports.findall((framework / 'lib.typ').read_text(encoding='utf-8')):
        assert target.startswith('core/') and '..' not in target, f'the Framework lib.typ imports outside core: {target}'
    # Nor may any Framework code read a file by a domain path (read, image, json); comments may name one.
    # Beyond imports, the Framework holds no marine or Flagship rule (TASK-45). Three checks on the same
    # comment-free code, each chosen so that it cannot fire on neutral code by accident:
    # 1. Vocabulary: no word that only a marine fact or a Flagship part uses, and no Flagship layout key
    #    (whole words, so `relationship` or `ranking` pass). Common facts (certificates, education) are the
    #    core's own words.
    # 2. What it reads: the core reads only the layout keys, artwork slots and theme colours it owns. An
    #    allowlist, so a template key fails whatever it is called; a template gives the shell its say
    #    through `shell`. `hero` is read only by the shell's optional band, so the core never requires it,
    #    and no core string names a Flagship colour, so `core/theme.typ` cannot require one (TASK-59).
    # 3. Colour: no colour literal (a hex string, a colour constructor, a named colour other than white and
    #    black, which mark the unpainted canvas); colours come from the theme, source-art colours from the
    #    theme's `art-palette`, which the domain supplies. A hard-coded palette is exactly what this catches.
    # Comments are removed by one scan that also matches string literals, so `//` inside a string is kept.
    vocabulary = re.compile(r'(?<![a-z])(vessels?|ships?|marine|maritime|seafar\w*|flagship|synopsis|tonnage|voyages?'
                            r'|crew|rank|opening-margin|continuation-margin|band-height|anchor-education|stack-gap)(?![a-z])', re.I)
    owned = {'layout': {'paper', 'width', 'height', 'shell', 'header', 'footer'},
             'artwork': {'background-first', 'background-continuation'},
             'colors': {'ink', 'accent', 'metal', 'muted', 'paper', 'hero'}}
    flagship_colours = re.compile(r'"(?:hero|plate|on-hero|surface|rule)"')
    colour = re.compile(r'"#[0-9a-fA-F]{3,8}"|(?<![\w-])(?:rgb|cmyk|luma|oklab|oklch|hsl|hsv|linear-rgb)\(')
    named = re.compile(r'(?:(?<![\w.-])|(?<=color\.))(?:gray|silver|navy|blue|aqua|teal|eastern|purple|fuchsia|maroon|red'
                       r'|orange|yellow|olive|green|lime)(?![\w-])')
    string = r'"(?:[^"\\\n]|\\.)*"'
    for source in sorted(framework.rglob('*.typ')):
        name = source.relative_to(ROOT).as_posix()
        code = re.sub(rf'({string})|/\*.*?\*/|//[^\n]*', lambda m: m.group(1) or '', source.read_text(encoding='utf-8'), flags=re.S)
        assert 'domains/' not in code, f'{name} names a domain path'
        words = sorted({m.group(0) for m in vocabulary.finditer(code)})
        assert not words, f'{name} speaks marine or Flagship: {words}'
        for owner, keys in owned.items():
            # A method call (`colors.keys()`, `layout.at(...)`) is not a key read.
            read = set(re.findall(rf'(?<![\w-]){owner}\.([\w-]+)(?![\w(-])', code)) | set(re.findall(rf'(?<![\w-]){owner}\.at\("([^"]+)"', code))
            assert read <= keys, f'{name} reads {owner} keys the Framework does not own: {sorted(read - keys)}'
        named_colours = flagship_colours.findall(code)
        assert not named_colours, f'{name} names a Flagship colour: {named_colours}'
        literals = colour.findall(code) + named.findall(re.sub(string, '""', code))
        assert not literals, f'{name} hard-codes colours instead of reading the theme: {literals}'
    for source in sorted((ROOT / 'packages/domains').rglob('*.typ')):
        for target in imports.findall(source.read_text(encoding='utf-8')):
            assert not re.search(r'(^|/)core/', target) or 'cv-framework/core/' in target, \
                f'{source.relative_to(ROOT)} reaches a core file outside the Framework: {target}'


def check_example_records():
    """Every public example's record matches the contract its entry point imports (the check cv.py render runs)."""
    import re
    from jsonschema import Draft202012Validator  # noqa: F401  A missing or pre-4.0 jsonschema fails here, not as a broken record.
    from cv_workflow.render import IMPORT
    from cv_workflow import WorkflowError
    from cv_workflow.validate import MAX_REPORTED, schema_for, validate_record
    FLAGSHIP_INPUT = '/packages/domains/marine/templates/flagship/schema/flagship-input.schema.json'
    entries = sorted((ROOT / 'examples').rglob('*.typ'))
    assert entries, 'no example entry points found'
    checked = set()
    for entry in entries:
        source = entry.read_text(encoding='utf-8')
        for path in re.findall(r'json\("([^"]+)"\)', source):
            checked.add(entry)
            record = json.loads((entry.parent / path).read_text(encoding='utf-8'))
            try:
                schema = validate_record(record, IMPORT.findall(source))
            except WorkflowError as error:
                raise AssertionError(f'example record {path} (read by {entry.name}) breaks its schema: {error}') from error
            assert schema == FLAGSHIP_INPUT, (entry.name, schema)
    # Every entry must read its record with a literal json("...") path, or it was not checked at all.
    assert checked == set(entries), f'no record found in: {sorted(e.name for e in set(entries) - checked)}'
    # Template beats domain whatever the import order; marine's lib.typ alone means Flagship; the Framework's
    # lib.typ names no domain, so it alone has no contract; no engine import, no contract.
    assert schema_for(['/packages/domains/marine/roles/deck/role.typ',
                       '/packages/domains/marine/templates/flagship/themes/golden-blue.typ']) == ROOT / FLAGSHIP_INPUT[1:]
    assert schema_for(['/packages/domains/marine/lib.typ']) == ROOT / FLAGSHIP_INPUT[1:]
    assert schema_for(['/packages/cv-framework/lib.typ']) is None
    assert schema_for(['/private/helpers.typ']) is None
    # lib.typ with a non-marine domain never falls back to Flagship's contract.
    assert schema_for(['/packages/domains/marine/lib.typ', '/packages/domains/travel-and-tourism/domain.typ']) is None
    # The refusal lists the first MAX_REPORTED problems, then a count.
    many = json.loads((ROOT / 'examples/candidates/engineer-example.json').read_text(encoding='utf-8'))
    ships = [s for c in many['companies'] for g in c['groups'] for s in g['ships']]
    for ship in ships:
        ship['months'] = 'x'
    try:
        validate_record(many, ['/packages/domains/marine/lib.typ'])
        raise AssertionError(f'{len(ships)} bad months were accepted')
    except WorkflowError as error:
        lines = str(error).splitlines()[1:]
        assert len(lines) == MAX_REPORTED + 1 and lines[-1] == f'  ... and {len(ships) - MAX_REPORTED} more', lines
    # The facts contract and the Flagship input contract share their definitions, vessel particulars included.
    facts_schema, input_schema = (json.loads((ROOT / 'packages/domains' / p).read_text(encoding='utf-8')) for p in
                                  ['marine/schema/candidate.schema.json', FLAGSHIP_INPUT[len('/packages/domains/'):]])
    assert facts_schema['$defs'] == input_schema['$defs'], 'the two marine schemas define different $defs'
    record = json.loads((ROOT / 'examples/candidates/engineer-example.json').read_text(encoding='utf-8'))
    ship = record['companies'][0]['groups'][0]['ships'][0]
    ship.update(tonnage={'value': 49990, 'unit': 'GT'}, engine='MAN B&W', power={'value': 9480, 'unit': 'kW'})
    validate_record(record, ['/packages/domains/marine/lib.typ'])
    ship['power'] = {'value': 9480, 'unit': 'hp'}
    try:
        validate_record(record, ['/packages/domains/marine/lib.typ'])
        raise AssertionError('an unknown power unit was accepted')
    except WorkflowError:
        pass
    # lib.typ plus a marine role but no template still means Flagship's contract.
    assert schema_for(['/packages/domains/marine/lib.typ', '/packages/domains/marine/roles/deck/role.typ']) == ROOT / FLAGSHIP_INPUT[1:]
    # The template-over-domain choice must not depend on the checkout path: domains under a folder
    # named `templates` still resolve the template schema, whatever the import order.
    import tempfile
    with tempfile.TemporaryDirectory() as scratch:
        domains = Path(scratch) / 'templates' / 'checkout' / 'packages' / 'domains'
        for schema in ['marine/schema/candidate.schema.json', FLAGSHIP_INPUT[len('/packages/domains/'):]]:
            (domains / schema).parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(ROOT / 'packages/domains' / schema, domains / schema)
        chosen = schema_for(['/packages/domains/marine/roles/deck/role.typ',
                             '/packages/domains/marine/templates/flagship/themes/golden-blue.typ'], domains_root=domains)
        assert chosen.name == 'flagship-input.schema.json', chosen


def main():
    # Every check here is a bare assert, which python -O (or PYTHONOPTIMIZE) strips: the suite would pass vacuously.
    if not __debug__:
        sys.exit('tests/run.py checks with assert, which -O and PYTHONOPTIMIZE remove: run it without them')
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--typst', default=shutil.which('typst'))
    parser.add_argument('--output', default=str(ROOT / 'builds' / ('tests-' + datetime.now().strftime('%Y%m%d-%H%M%S-%f'))))
    args = parser.parse_args()
    if not args.typst:
        parser.error('Typst not on PATH; provide --typst path/to/typst.exe')
    out = Path(args.output).resolve()
    out.mkdir(parents=True, exist_ok=False)
    results = []

    # One folder per case holds all its evidence (ADR 0013): <case>.pdf, compile.log, and for a
    # checked case check/result.json (plus diff-N.png on a mismatch) and page-N.png renders.
    def compile_case(name, source, inputs=None, error=None):
        assert name not in ('workflow', 'design-review', 'build-script', 'proposals', 'workflow-model'), \
            'the workflow, app, build script, proposal and Workflow Model checks own those folders'
        folder = out / name
        folder.mkdir(exist_ok=False)
        pdf = folder / (name + '.pdf')
        command = [args.typst, 'compile', '--root', str(ROOT), *STRICT_FONTS, '--font-path', str(ROOT / FONTS)]
        for key, value in (inputs or {}).items():
            command.extend(['--input', key + '=' + value])
        command.extend([str(ROOT / source), str(pdf)])
        result = subprocess.run(command, capture_output=True, text=True, encoding='utf-8', errors='replace')
        (folder / 'compile.log').write_text(result.stderr, encoding='utf-8')
        # A font family that is not bundled compiles in another font with exit code 0: a failure here (task-46).
        failed = result.returncode != 0 or bool(font_fallbacks(result.stderr))
        if error:
            assert failed and error in result.stderr, (name, result.stderr)
        else:
            assert not failed, (name, result.stderr)
        results.append({'case': name, 'passed': True, 'folder': name})
        return pdf

    def skip(*cases, reason):
        """A case that cannot run on this machine: said loudly now, in report.json and in the final line."""
        for name in cases:
            print(f'SKIPPED {name}: {reason}')
            results.append({'case': name, 'passed': None, 'skipped': reason})

    def check_case(pdf, reference=None, pages=2):
        """The PDF checks of verify.py into the case's own folder, plus a PNG of every page to look at."""
        outcome = verify(pdf, reference, pages=pages, output=pdf.parent / 'check')
        with fitz.open(pdf) as doc:
            for i, page in enumerate(doc):
                page.get_pixmap(dpi=110).save(pdf.parent / f'page-{i + 1}.png')
        return outcome

    check_frozen()
    check_example_records()
    results.append({'case': 'example-records-match-schema', 'passed': True})
    compile_case('configuration', 'tests/fixtures/configuration.typ')
    # Theme checks (TASK-59): the core accepts a theme with only its own colours and still refuses one
    # without them; Flagship refuses a theme that lacks any of its own colours, with the same messages.
    compile_case('theme-core', 'tests/fixtures/theme.typ', {'case': 'core'})
    for key in ['ink', 'accent', 'metal', 'muted', 'paper']:
        compile_case('theme-core-missing-' + key, 'tests/fixtures/theme.typ', {'case': 'core-missing', 'key': key}, error='Missing theme color: ' + key)
    for key in ['hero', 'surface', 'plate', 'rule', 'on-hero']:
        compile_case('theme-flagship-missing-' + key, 'tests/fixtures/theme.typ', {'case': 'missing', 'key': key}, error='Missing theme color: ' + key)
    compile_case('theme-flagship-not-color', 'tests/fixtures/theme.typ', {'case': 'not-color', 'key': 'plate'}, error='Theme color must be a color: plate')
    content = compile_case('content', 'tests/fixtures/content.typ')
    assert check_case(content, pages=1)['passed']
    with fitz.open(content) as doc:
        text = ' '.join(doc[0].get_text().split())
        for phrase in ['Northline Marine', 'TOTAL EXPERIENCE', 'Certificates & endorsements', 'Education & languages']:
            assert phrase in text, phrase
    skills = compile_case('skills', 'tests/fixtures/skills.typ')
    assert check_case(skills, pages=1)['passed']
    with fitz.open(skills) as doc:
        text = ' '.join(doc[0].get_text().split())
        for phrase in ['Professional Skills', 'Technical Skills', 'Three columns', 'Navigation', 'Plain bullet', 'Third']:
            assert text.count(phrase) == 1, phrase
        # The theme's art-palette seam (TASK-45): the compass bullet bakes in Golden Blue's brass and teal
        # (#c8a579, #236a70). Golden Blue keeps them; Silver Bridge's bullets must show neither, which holds
        # only if its theme carries the domain's art-palette and the core's decoration applies it.
        page = doc[0]
        def baked(top, bottom):
            pix = page.get_pixmap(matrix=fitz.Matrix(2, 2), alpha=False, clip=fitz.Rect(0, top, page.rect.width, bottom))
            return sum(n for rgb, n in pix.color_count(colors=True).items()
                       if any(all(abs(c - t) <= 4 for c, t in zip(rgb, target)) for target in ((0xc8, 0xa5, 0x79), (0x23, 0x6a, 0x70))))
        gold = baked(page.search_for('Professional Skills')[0].y0, page.search_for('Technical Skills')[0].y0)
        silver = baked(page.search_for('Three columns')[0].y0, page.rect.height)
        assert gold > 0 and silver == 0, f'art-palette not applied: {silver} gold-art pixels in the Silver Bridge bullets (gold section: {gold})'
    # Every public example, from the one list scripts/build.ps1 also reads (examples/release.json).
    listed = {Path(e['source']).stem: compile_case(Path(e['source']).stem, e['source']) for e in examples()}
    results.append({'case': f'example-list ({len(listed)} examples, the list build.ps1 reads)', 'passed': True})
    engineer = listed['engineer']
    result = check_case(engineer, ROOT / FLAGSHIP / 'tests/approved/Marine-Engineer-CV-v11.pdf')
    assert result['passed'], result
    # document-shell writes the PDF metadata flagship passes it: name | rank | domain title, and the domain's author.
    with fitz.open(engineer) as doc:
        assert (doc.metadata['title'], doc.metadata['author']) == ('ALEX MORGAN | SECOND ENGINEER | CVgen', 'CVgen'), doc.metadata
    hidden = compile_case('engineer-hidden', 'examples/marine/flagship/engineer.typ', {'vessel-durations': 'false'})
    with fitz.open(engineer) as a, fitz.open(hidden) as b:
        assert len(a) == len(b) == 2
        data = json.loads((ROOT / 'examples/candidates/engineer-example.json').read_text())
        vessel_names = [s['name'] for c in data['companies'] for g in c['groups'] for s in g['ships']]
        vessel_names += ['Second Engineer', 'Third Engineer', 'Fourth Engineer', 'Engineering Cadet']
        for pa, pb in zip(a, b):
            for name in vessel_names:
                assert pa.search_for(name) == pb.search_for(name), name
        assert '8 months' not in ' '.join(p.get_text() for p in b)
    classic, silver = listed['captain'], listed['captain-silver']
    for pdf in [hidden, classic, silver]:
        assert check_case(pdf)['passed']
    with fitz.open(classic) as a, fitz.open(silver) as b:
        assert [' '.join(p.get_text().split()) for p in a] == [' '.join(p.get_text().split()) for p in b]
        assert 'Engineer' not in ''.join(p.get_text() for p in a)
    # Third dataset: deck officer without a portrait, on the same page plan.
    officer = listed['chief-officer']
    assert check_case(officer)['passed']
    with fitz.open(officer) as doc:
        text = ' '.join(' '.join(p.get_text().split()) for p in doc)
        for phrase in ['ELENI MARKOU', 'Boreal Gas Carriers', 'Aegean Coastal Shipping', '10 years 9 months',
                       'FICTIONAL CANDIDATE / DESIGN STUDY', 'Certificates & endorsements', 'FLAGSHIP']:
            assert phrase in text, phrase
        assert 'AI PORTRAIT' not in text and not doc[0].get_images()
    # Copy overrides reach the page through the adapter, and nothing else moves.
    branded = compile_case('chief-officer-copy', 'examples/marine/flagship/chief-officer.typ', {'brand': 'SILVER BRIDGE'})
    with fitz.open(officer) as a, fitz.open(branded) as b:
        assert 'SILVER BRIDGE' in b[1].get_text() and 'FLAGSHIP' not in b[1].get_text()
        brand = {'FLAGSHIP', 'SILVER', 'BRIDGE'}
        for pa, pb in zip(a, b):
            def keep(page):
                return [w for w in page.get_text('words') if w[4] not in brand]
            assert keep(pa) == keep(pb)
    # Short career on the one-page profile: the whole record on one page, whatever its company count.
    cadet = listed['deck-cadet']
    assert check_case(cadet, pages=1)['passed']
    with fitz.open(cadet) as doc:
        text = ' '.join(doc[0].get_text().split())
        for phrase in ['NIKOS PETRIDIS', 'Northwind Container Lines', 'Saronic Bulk Carriers', '1 year 3 months',
                       'Certificates & endorsements', 'Education & languages', 'Diploma in Nautical Studies']:
            assert phrase in text, phrase
    for mode, companies in [('one', 1), ('three', 3)]:
        short = compile_case('one-page-' + mode, 'tests/fixtures/one-page.typ', {'case': mode})
        assert check_case(short, pages=1)['passed']
        with fitz.open(short) as doc:
            captions = ['1 VESSEL ', '1 COMPANY '] if companies == 1 else ['3 VESSELS', '3 COMPANIES']
            text = ' '.join(doc[0].get_text().split()).upper()
            assert all(c in text for c in captions), (mode, captions)
    compile_case('one-page-overflow', 'tests/fixtures/one-page.typ', {'case': 'overflow'}, error='Content overflow on planned page 1')
    # `spread`: with certificates and education, a thin record gets two even gaps above them and the
    # synopsis stays on the Experience block; with one missing, everything stacks from the top with the
    # wider `stack-gap` between blocks (owner): wider than the tight default, far from a shared gap.
    def top(page, word, edge=1):
        return next(w[edge] for w in page.get_text('words') if w[4] == word) / 72 * 25.4
    with fitz.open(out / 'one-page-one' / 'one-page-one.pdf') as doc:
        page = doc[0]
        attached = top(page, 'TOTAL') - top(page, 'Grace', 3)
        first, second = top(page, 'Certificates') - top(page, 'TOTAL', 3), top(page, 'Education') - top(page, 'medical', 3)
        assert attached < 17 and first > 15 and second > 15 and abs(first - second) < 8, (attached, first, second)
    for mode, heading in [('no-education', 'Certificates'), ('no-certificates', 'Education')]:
        packed = compile_case('one-page-' + mode, 'tests/fixtures/one-page.typ', {'case': mode})
        assert check_case(packed, pages=1)['passed']
        with fitz.open(packed) as doc:
            page = doc[0]
            gaps = (top(page, 'TOTAL') - top(page, 'Grace', 3), top(page, heading) - top(page, 'TOTAL', 3))
            assert all(17 < g < 32 for g in gaps), (mode, gaps)
    # Fonts strict (task-46): a family that is not bundled fails the case instead of rendering in another font,
    # whether it exists nowhere or only among this machine's fonts (which proves --ignore-system-fonts).
    compile_case('fonts-missing', 'tests/fixtures/fonts.typ', {'case': 'missing'}, error='unknown font family: cvgen missing family')
    system_family = system_font_family(args.typst)
    if system_family:
        compile_case('fonts-system', 'tests/fixtures/fonts.typ', {'case': 'system', 'family': system_family},
                     error='unknown font family: ' + system_family.lower())
    else:
        # CI installs a font for this (verify.yml); finding none there is a broken runner, not a skip.
        assert not os.environ.get('CI'), ('fonts-system', 'CI has no font outside the bundled ones, so --ignore-system-fonts '
                                          'is not proven; install one in .github/workflows/verify.yml')
        skip('fonts-system', 'workflow-system-font-fails-checks',
             reason='this machine has no font outside the bundled ones, so --ignore-system-fonts is not proven here')
    compile_case('data-valid', 'tests/fixtures/data.typ')
    # ADR 0008 fixtures: 31 of the 32 ctx-first components rendered alone, one page each, headed by
    # its name; the 32nd, document-shell, wraps a whole document: every example goes through it, and
    # the engineer example's PDF metadata check (above) proves it forwards title and author.
    components = compile_case('contract-components', 'tests/fixtures/contract.typ')
    with fitz.open(components) as doc:
        names = [page.get_text().split()[1] for page in doc]
        assert len(names) == len(set(names)) == 31, names
    # The core paginates a domain that has no ships, and composes domain < role < template.
    compile_case('core-model', 'tests/fixtures/core-model.typ')
    # A role reaches the page only if `flagship` forwards it to the adapter.
    roled = compile_case('role', 'tests/fixtures/role.typ')
    with fitz.open(roled) as doc:
        first = doc[0].get_text()
        assert 'ROLE SUBTITLE' in first and 'Company / vessel type / vessel' not in first
    for mode, message in [('missing-visible', 'Visible vessel durations'), ('mismatch', 'does not match'), ('negative', 'non-negative integer'), ('missing-name', 'Required text: identity.name')]:
        compile_case('data-' + mode, 'tests/fixtures/data.typ', {'case': mode}, error=message)
    for mode in ['normal', 'no-portrait', 'no-contact']:
        compile_case('hero-' + mode, 'tests/fixtures/components.typ', {'case': mode})
    for mode in ['long-name', 'long-email']:
        compile_case('hero-' + mode, 'tests/fixtures/components.typ', {'case': mode}, error='exceeds')
    for mode in ['missing-months', 'optional', 'long-vessel']:
        pdf = compile_case('options-' + mode, 'tests/fixtures/options.typ', {'case': mode})
        assert check_case(pdf)['passed']
    long_hidden = compile_case('long-hidden', 'tests/fixtures/options.typ', {'case': 'long-vessel', 'times': 'false'})
    with fitz.open(out / 'options-long-vessel' / 'options-long-vessel.pdf') as a, fitz.open(long_hidden) as b:
        for pa, pb in zip(a, b):
            for token in ['MV Aurora', 'MV Caspian', 'Second Engineer']:
                assert pa.search_for(token) == pb.search_for(token), token
    # Optional vessel particulars: a muted suffix on the vessel's own row, in the documented unit, so no
    # row moves; a repeated vessel must agree, units are closed, and a row that would wrap fails loudly.
    particulars = compile_case('particulars', 'tests/fixtures/particulars.typ')
    assert check_case(particulars)['passed']
    with fitz.open(engineer) as a, fitz.open(particulars) as b:
        lines = [line for page in b for line in page.get_text().splitlines()]
        for expected in ['MV Meridian · 49,990 GT · MAN B&W · 9,480 kW', 'MV Aurora · MAN B&W · 9,480 kW',
                         'MV Atlas · 51,200 DWT', 'MV North Passage · Wärtsilä · 12,900 BHP', 'MV Solstice · 850 kW']:
            assert expected in lines, expected
        assert 'MV Polaris' in lines
        assert len(a) == len(b) == 2
        # Apart from the suffix words, every word of both pages sits exactly where the engineer example has it.
        suffix = {'·', '49,990', 'GT', 'MAN', 'B&W', '9,480', 'kW', '51,200', 'DWT', 'Wärtsilä', '12,900', 'BHP', '850'}
        for pa, pb in zip(a, b):
            def keep(page):
                return [w[:5] for w in page.get_text('words') if w[4] not in suffix]
            assert len(keep(pa)) > 100 and keep(pa) == keep(pb), 'a vessel row moved or a word changed'
    for mode, message in [('conflict', 'repeats with a different power'), ('bad-unit', 'unit must be one of GT, DWT'),
                          ('bad-value', 'must be a positive whole number'), ('bad-keys', 'needs exactly value and unit'),
                          ('too-long', 'do not fit on one row')]:
        compile_case('particulars-' + mode, 'tests/fixtures/particulars.typ', {'case': mode}, error=message)
    three = compile_case('three-pages', 'tests/fixtures/pagination.typ')
    assert check_case(three, pages=3)['passed']
    with fitz.open(three) as doc:
        text = ' '.join(' '.join(p.get_text().split()) for p in doc)
        assert 'Northline Marine (continued)' in text
        # Both halves of the split company show the full company's 60 months, never the page's rows.
        assert text.count('5 years') == 2
        assert '13 years 6 months' in text and text.count('TOTAL EXPERIENCE') == 1
        assert 'TOTAL EXPERIENCE' in doc[2].get_text()
        for i in range(8):
            assert text.count('MV Test Vessel ' + str(i + 1)) == 1
    compile_case('overflow', 'tests/fixtures/pagination.typ', {'case': 'overflow'}, error='Content overflow')
    compile_case('duplicate', 'tests/fixtures/pagination.typ', {'case': 'duplicate'}, error='each vessel row once')
    # The closing-section rules are Flagship's, not the core's (core-model accepts a plan with no synopsis).
    compile_case('no-synopsis', 'tests/fixtures/pagination.typ', {'case': 'no-synopsis'}, error='exactly one synopsis')
    compile_case('early-credentials', 'tests/fixtures/pagination.typ', {'case': 'early-credentials'}, error='Credentials must follow Experience')
    # Layout keys the shell's `shell` slice replaced fail loudly, never silently ignored on page 1.
    for key in ['margin', 'band']:
        compile_case(f'retired-{key}-flagship', 'tests/fixtures/retired-keys.typ', {'case': key},
                     error='retired: set the ' + ("first page's margin as shell.margin" if key == 'margin' else "hero band's height as shell.band"))
    certs = compile_case('certificate-continuation', 'tests/fixtures/certificate-continuation.typ')
    with fitz.open(certs) as doc:
        assert len(doc) == 2
        assert all('Scope / record' in p.get_text() for p in doc)
    # The Sign-off text draft (house design First Fitting): the Greek Check Page first, then the
    # content with its running head, one embedded family (Bona Nova).
    draft = compile_case('text-draft', 'tests/fixtures/text-draft.typ')
    with fitz.open(draft) as doc:
        assert len(doc) == 2, len(doc)
        check = doc[0].get_text()
        assert all(t in check for t in ['προς έλεγχο', 'Ελένη Παράδειγμα', 'Ελέγξτε μόνο', 'Example Tours', '27.09.2026']), check
        assert 'Page 1' not in check and 'Profile' in doc[1].get_text() and 'Page 2 of 2' in doc[1].get_text()
        fonts = {f[3] for p in doc for f in p.get_fonts()}
        assert fonts and all('BonaNova' in name for name in fonts), fonts
        # The Check Page says "check only the underlined facts": every fact carries the copper
        # stitch just under it, and our own wording carries none.
        for page, marked, plain in [(0, ['Example', '600'], ['Ελέγξτε']), (1, ['seven', 'Athens', '600', 'Kyoto'], ['Licensed', 'walking'])]:
            stitched = [d['rect'] for d in doc[page].get_drawings()
                        if d.get('color') and all(abs(a - b) < 0.02 for a, b in zip(d['color'], (0xB0 / 255, 0x60 / 255, 0x2B / 255)))]
            words = doc[page].get_text('words')
            for word, wanted in [(w, True) for w in marked] + [(w, False) for w in plain]:
                box = next(fitz.Rect(w[:4]) for w in words if w[4].strip('.,;:') == word)
                under = any(r.x0 < box.x1 and r.x1 > box.x0 and box.y1 - 2 <= r.y0 <= box.y1 + 8 for r in stitched)
                assert under == wanted, (page, word, 'stitched' if under else 'not stitched')
    # Rows grow and the reply stays in the flow: a long company name and seven rows never overprint.
    long_draft = compile_case('text-draft-long', 'tests/fixtures/text-draft.typ', {'case': 'long'})
    with fitz.open(long_draft) as doc:
        # Below the tilted tag (its rotated letters overlap as boxes): the intro, rows and reply.
        boxes = [fitz.Rect(w[:4]) for w in doc[0].get_text('words') if w[1] > 260]
        overlaps = [(a, b) for i, a in enumerate(boxes) for b in boxes[i + 1:] if (a & b).get_area() > 1]
        assert not overlaps, overlaps[:3]
        assert 'Όλα σωστά' in doc[0].get_text() and 'Services S.A.' in doc[0].get_text()
    # One row more than fits: the reply is in the flow, so the page overflows and the compile fails
    # (a reply placed at the foot would overprint; a missing guard would spill onto page 2).
    compile_case('text-draft-full', 'tests/fixtures/text-draft.typ', {'case': 'full'}, error='the Check Page runs past one page')
    compile_case('text-draft-english', 'tests/fixtures/text-draft.typ', {'case': 'english'}, error='no house copy for check-lang "en"')
    # The candidate workflow, end to end and every refusal, in a fresh fictional workspace.
    for check in run_workflow(out, args.typst, system_family):
        results.append({'case': 'workflow-' + check, 'passed': True, 'folder': 'workflow'})
    # scripts/build.ps1 in a throwaway copy, under every PowerShell here: the list, and no silent Release overwrite.
    if shells():
        for check in run_build_script(out, args.typst):
            results.append({'case': 'build-script-' + check, 'passed': True, 'folder': 'build-script'})
    else:
        assert not os.environ.get('CI'), 'CI has no PowerShell, so scripts/build.ps1 is not tested'
        skip('build-script', reason='no PowerShell on this machine, so scripts/build.ps1 is not tested here')
    # Output Contract: every public PDF sits in its home with a valid, current Meta File.
    sys.path.insert(0, str(ROOT / 'packages/cv-workflow'))
    from cv_workflow.outputs import scan
    indexed, problems = scan(ROOT, include_private=False)
    assert not problems, [f'{p.relative_to(ROOT).as_posix()}: {r}' for p, r in problems]
    results.append({'case': f'output-contract ({len(indexed)} PDFs)', 'passed': True, 'folder': None})
    # The repo-maintenance skill's audit script and agent files, on throwaway repositories.
    for check in run_repo_maintenance():
        results.append({'case': 'repo-maintenance: ' + check, 'passed': True, 'folder': None})
    # The proposal snapshot script on fixture folders (and each refusal), then on docs/proposals/.
    for check in run_proposals(out):
        results.append({'case': 'proposals: ' + check, 'passed': True, 'folder': 'proposals'})
    # The owner's Design Review app, through its real server, on a fictional tree.
    for check in run_design_review(out):
        results.append({'case': 'design-review-' + check, 'passed': True, 'folder': 'design-review'})
    # The Workflow Model (docs/workflow, ADR 0015): the workflow tool's check, levels 1 and 2 (TASK-38), and its generated
    # READMEs, which must be what render writes from the model (TASK-39), and the Atlas client-journey page (TASK-41).
    bun = shutil.which('bun')
    if bun:
        tool, folder = ROOT / 'tools' / 'workflow', out / 'workflow-model'
        folder.mkdir()
        def bun_run(log, *command):
            # PYTHON: the check runs `scripts/cv.py --help` and `scripts/outputs.py --help` with this interpreter.
            done = subprocess.run([bun, *command], cwd=tool, capture_output=True, text=True, encoding='utf-8',
                                  errors='replace', env={**os.environ, 'PYTHON': sys.executable})
            (folder / log).write_text(done.stdout + done.stderr, encoding='utf-8')
            return done
        if not (tool / 'node_modules').is_dir():
            install = bun_run('install.log', 'install', '--frozen-lockfile')
            assert install.returncode == 0, ('workflow-model', install.stdout + install.stderr)
        check = bun_run('check.log', 'run', 'check')
        assert check.returncode == 0 and 'levels 1 and 2 pass' in check.stdout, ('workflow-model', check.stdout + check.stderr)
        rendered = bun_run('render.log', 'run', 'render', '--check')
        assert rendered.returncode == 0, ('workflow-model', rendered.stdout + rendered.stderr)
        page = bun_run('atlas.log', 'run', 'atlas', '--check')
        assert page.returncode == 0, ('workflow-model', page.stdout + page.stderr)
        results.append({'case': 'workflow-model', 'passed': True, 'folder': 'workflow-model'})
    else:
        assert not os.environ.get('CI'), 'CI has no Bun, so the Workflow Model is not checked; see .github/workflows/verify.yml'
        skip('workflow-model', reason='no Bun on this machine, so the Workflow Model (docs/workflow) is not checked here')
    check_frozen()
    check_core_boundary()
    report = {'passed': True, 'cases': results, 'exact_reference': result, 'output': str(out)}
    (out / 'report.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
    skipped = [r['case'] for r in results if r.get('skipped')]
    print(f'PASS: {len(results) - len(skipped)} compilation cases plus PDF/data/layout assertions. Evidence: {out}')
    if skipped:
        print(f'SKIPPED {len(skipped)}: {", ".join(skipped)} (reasons in report.json)')


if __name__ == '__main__':
    main()
