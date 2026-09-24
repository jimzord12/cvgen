"""Run the meaningful library regression suite into a NEW output directory."""
import argparse
from datetime import datetime
import json
from pathlib import Path
import shutil
import subprocess

import pymupdf as fitz
from verify import ROOT, FONTS, FLAGSHIP, verify, check_frozen
from workflow import run_workflow


def check_core_boundary():
    """The shared core imports only its own siblings: never a domain, never lib.typ (ADR 0011)."""
    import re
    for source in sorted((ROOT / 'packages/cv-engine/core').glob('*.typ')):
        for target in re.findall(r'(?<![\w-])(?:import|include)\s+"([^"]+)"', source.read_text(encoding='utf-8')):
            assert '/' not in target and '..' not in target, f'core/{source.name} imports outside core: {target}'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--typst', default=shutil.which('typst'))
    parser.add_argument('--output', default=str(ROOT / 'builds' / ('tests-' + datetime.now().strftime('%Y%m%d-%H%M%S-%f'))))
    args = parser.parse_args()
    if not args.typst:
        parser.error('Typst not on PATH; provide --typst path/to/typst.exe')
    out = Path(args.output).resolve()
    out.mkdir(parents=True, exist_ok=False)
    results = []

    def compile_case(name, source, inputs=None, error=None):
        pdf = out / (name + '.pdf')
        command = [args.typst, 'compile', '--root', str(ROOT), '--font-path', str(ROOT / FONTS)]
        for key, value in (inputs or {}).items():
            command.extend(['--input', key + '=' + value])
        command.extend([str(ROOT / source), str(pdf)])
        result = subprocess.run(command, capture_output=True, text=True)
        (out / (name + '.log')).write_text(result.stderr, encoding='utf-8')
        if error:
            assert result.returncode != 0 and error in result.stderr, (name, result.stderr)
        else:
            assert result.returncode == 0, (name, result.stderr)
        results.append({'case': name, 'passed': True})
        return pdf

    check_frozen()
    compile_case('configuration', 'tests/fixtures/configuration.typ')
    content = compile_case('content', 'tests/fixtures/content.typ')
    assert verify(content, pages=1, output=out / 'content-check')['passed']
    with fitz.open(content) as doc:
        text = ' '.join(doc[0].get_text().split())
        for phrase in ['Northline Marine', 'TOTAL EXPERIENCE', 'Certificates & endorsements', 'Education & languages']:
            assert phrase in text, phrase
    skills = compile_case('skills', 'tests/fixtures/skills.typ')
    assert verify(skills, pages=1, output=out / 'skills-check')['passed']
    with fitz.open(skills) as doc:
        text = ' '.join(doc[0].get_text().split())
        for phrase in ['Professional Skills', 'Technical Skills', 'Three columns', 'Navigation', 'Plain bullet', 'Third']:
            assert text.count(phrase) == 1, phrase
    engineer = compile_case('engineer', 'examples/marine/flagship/engineer.typ')
    result = verify(engineer, ROOT / FLAGSHIP / 'tests/approved/Marine-Engineer-CV-v11.pdf', output=out / 'exact')
    assert result['passed'], result
    hidden = compile_case('engineer-hidden', 'examples/marine/flagship/engineer.typ', {'vessel-durations': 'false'})
    with fitz.open(engineer) as a, fitz.open(hidden) as b:
        assert len(a) == len(b) == 2
        data = json.loads((ROOT / 'examples/candidates/engineer-example.json').read_text())
        names = [s['name'] for c in data['companies'] for g in c['groups'] for s in g['ships']]
        names += ['Second Engineer', 'Third Engineer', 'Fourth Engineer', 'Engineering Cadet']
        for pa, pb in zip(a, b):
            for name in names:
                assert pa.search_for(name) == pb.search_for(name), name
        assert '8 months' not in ' '.join(p.get_text() for p in b)
    classic = compile_case('captain', 'examples/marine/flagship/captain.typ')
    silver = compile_case('captain-silver', 'examples/marine/flagship/captain-silver.typ')
    for pdf in [hidden, classic, silver]:
        assert verify(pdf, output=out / (pdf.stem + '-check'))['passed']
    with fitz.open(classic) as a, fitz.open(silver) as b:
        assert [' '.join(p.get_text().split()) for p in a] == [' '.join(p.get_text().split()) for p in b]
        assert 'Engineer' not in ''.join(p.get_text() for p in a)
    # Third dataset: deck officer without a portrait, on the same page plan.
    officer = compile_case('chief-officer', 'examples/marine/flagship/chief-officer.typ')
    assert verify(officer, output=out / 'chief-officer-check')['passed']
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
            keep = lambda page: [w for w in page.get_text('words') if w[4] not in brand]
            assert keep(pa) == keep(pb)
    compile_case('data-valid', 'tests/fixtures/data.typ')
    # ADR 0008 fixtures: 31 of the 32 ctx-first components rendered alone, one page each, headed by
    # its name; the 32nd, document-shell, wraps a whole document and is covered by legacy-parity.
    components = compile_case('contract-components', 'tests/fixtures/contract.typ')
    with fitz.open(components) as doc:
        names = [page.get_text().split()[1] for page in doc]
        assert len(names) == len(set(names)) == 31, names
    # lib.typ's 32 deprecated pre-contract names draw exactly what the ctx-first components draw;
    # the fixture must call every one of them.
    import re
    lib = (ROOT / 'packages/cv-engine/lib.typ').read_text(encoding='utf-8')
    legacy_names = [n.strip() for line in lib.splitlines() if 'legacy.typ"' in line for n in line.split(':', 1)[1].split(',')]
    parity = (ROOT / 'tests/fixtures/legacy-parity.typ').read_text(encoding='utf-8')
    code = re.sub(r'//[^\n]*', '', re.sub(r'/\*.*?\*/', '', parity, flags=re.S))  # a call in a comment does not count
    uncalled = [n for n in legacy_names if not re.search(r'L\.' + re.escape(n) + r'[(.]', code)]
    assert len(legacy_names) == 32 and not uncalled, uncalled
    old = compile_case('legacy-api', 'tests/fixtures/legacy-parity.typ', {'api': 'legacy'})
    new = compile_case('contract-api', 'tests/fixtures/legacy-parity.typ', {'api': 'contract'})
    with fitz.open(old) as a, fitz.open(new) as b:
        assert len(a) == len(b) == 5
        # document-shell forwards the PDF metadata through both APIs.
        for doc in (a, b):
            assert (doc.metadata['title'], doc.metadata['author']) == ('Parity title', 'Parity author'), doc.metadata
        for pa, pb in zip(a, b):
            ra, rb = (p.get_pixmap(matrix=fitz.Matrix(2, 2), alpha=False) for p in (pa, pb))
            assert (ra.width, ra.height, ra.samples) == (rb.width, rb.height, rb.samples), 'legacy API draws differently'
        # Page 5 holds only page-background, with the shell's background off: it must draw art.
        assert len(set(a[4].get_pixmap(alpha=False).samples)) > 1, 'page-background drew nothing'
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
        assert verify(pdf, output=out / ('options-' + mode + '-check'))['passed']
    long_hidden = compile_case('long-hidden', 'tests/fixtures/options.typ', {'case': 'long-vessel', 'times': 'false'})
    with fitz.open(out / 'options-long-vessel.pdf') as a, fitz.open(long_hidden) as b:
        for pa, pb in zip(a, b):
            for token in ['MV Aurora', 'MV Caspian', 'Second Engineer']:
                assert pa.search_for(token) == pb.search_for(token), token
    three = compile_case('three-pages', 'tests/fixtures/pagination.typ')
    assert verify(three, pages=3, output=out / 'three-check')['passed']
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
    certs = compile_case('certificate-continuation', 'tests/fixtures/certificate-continuation.typ')
    with fitz.open(certs) as doc:
        assert len(doc) == 2
        assert all('Scope / record' in p.get_text() for p in doc)
    # The candidate workflow, end to end and every refusal, in a fresh fictional workspace.
    for check in run_workflow(out, args.typst):
        results.append({'case': 'workflow-' + check, 'passed': True})
    check_frozen()
    check_core_boundary()
    report = {'passed': True, 'cases': results, 'exact_reference': result, 'output': str(out)}
    (out / 'report.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
    print(f'PASS: {len(results)} compilation cases plus PDF/data/layout assertions. Evidence: {out}')


if __name__ == '__main__':
    main()
