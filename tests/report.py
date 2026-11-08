"""scripts/report.py through its real command line: the worked sample, then each refusal. Run by tests/run.py."""
import importlib.util
import json
import re
import subprocess
import sys

from verify import ROOT

SCRIPT = ROOT / 'scripts' / 'report.py'
SAMPLE = ROOT / 'studio/brand/report/sample.json'


def run(*arguments):
    return subprocess.run([sys.executable, str(SCRIPT), *map(str, arguments)], capture_output=True, text=True, encoding='utf-8')


def run_report(out):
    folder = out / 'report'
    folder.mkdir(exist_ok=False)
    checks = []

    done = run(SAMPLE, '--output', folder / 'sample')
    assert done.returncode == 0, done.stderr
    page = (folder / 'sample/report.html').read_text(encoding='utf-8')
    data = json.loads(SAMPLE.read_text(encoding='utf-8'))
    assert page.startswith('<!doctype html>'), 'a full page opens with its skeleton'
    assert '{{' not in page, 'a placeholder was left in the page'
    assert page.count('data:font/ttf') == 3 and 'data:image/jpeg' in page, 'fonts and pages are embedded'
    assert not re.search(r'(src|href)="https?:', page), 'the page loads nothing from the network'
    embedded = json.loads(re.search(r'<script type="application/json" id="report">(.*?)</script>', page, re.S)[1])
    place = embedded['placement']
    card = next(i for i, a in enumerate(data['needs_you']) if a.get('figures') == ['1'])
    assert place['cards'][card] == ['1'] and place['figures'] == ['2'] and sum(map(len, place['cards'])) == 1, place
    spec = importlib.util.spec_from_file_location('report_script', SCRIPT)
    script = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(script)
    page_of = lambda name: {'id': name, 'kind': 'page', 'caption': name}  # noqa: E731
    mixed = {'evidence': [page_of(name) for name in ('4', '3', '2', '1')],
             'needs_you': [{'figures': ['2', '1']}, {'figures': ['1']}, {}],
             'decisions': [{'figures': ['3']}]}
    assert script.placement(mixed) == {'cards': [['2'], [], []], 'figures': ['4', '3', '1']}, script.placement(mixed)
    checks.append('figures placed: one in its card, one shared under Figures; uncited and decision-only figures stay under Figures')
    opens_new = ('.compare{position:relative;--x:8%;', '<input type="range" min="0" max="100" value="8"', '<span class="compare" style="--x:0%">')
    assert all(text in page for text in opens_new), 'a comparison opens on the new version'
    checks.append('a comparison opens on the new version: the thumbnail shows it alone, the slider leaves the old one a sliver')
    checks.append('sample builds into one page')
    bare_number = json.loads(SAMPLE.read_text(encoding='utf-8'))
    bare_number['evidence'][0]['id'] = 1  # a bare JSON number, cited elsewhere as "1"
    (folder / 'number.json').write_text(json.dumps(bare_number), encoding='utf-8')
    numbered = run(folder / 'number.json', '--output', folder / 'number')
    assert numbered.returncode == 0, numbered.stderr
    checks.append('a bare number id renders and matches its text citations')

    fragment = run(SAMPLE, '--fragment', '--output', folder / 'fragment')
    assert fragment.returncode == 0, fragment.stderr
    assert (folder / 'fragment/report.html').read_text(encoding='utf-8').startswith('<meta charset'), 'a fragment has no skeleton'
    checks.append('fragment has no skeleton and keeps its charset')

    assert run(SAMPLE, '--output', folder / 'sample').returncode != 0, 'an existing folder was overwritten'
    checks.append('an existing folder is refused')

    hostile = folder / 'hostile.json'
    hostile.write_text(json.dumps({**data, 'title': '{{DATA}} A & B', 'headline': '</script><!-- x'}), encoding='utf-8')
    written = run(hostile, '--output', folder / 'hostile')
    assert written.returncode == 0, written.stderr
    page = (folder / 'hostile/report.html').read_text(encoding='utf-8')
    assert '</script><!--' not in page and page.count('</script>') == 2, 'report text closed the script block'
    assert '<title>{{DATA}} A &amp; B</title>' in page, 'a placeholder in a title stays text'
    checks.append('text cannot break out of the page')

    # The refusals swap sections in and out, so they start from the sample without its figure citations.
    bare = {**data, **{field: [{k: v for k, v in item.items() if k != 'figures'} for item in data[field]] for field in ('needs_you', 'decisions')}}
    card = {'title': 'A', 'context': 'B', 'decision': 'C'}
    choices = [{'label': 'B', 'recommended': True}, {'label': 'C'}]
    gate = {'name': 'A', 'cap': 5}
    figure = {'id': '1', 'kind': 'page', 'caption': 'A', 'src': 'studio/brand/logos/cvgen-mark-c-eye.svg'}
    for name, broken, message in (
            ('no headline', {k: v for k, v in bare.items() if k != 'headline'}, 'the report needs headline: add them to the JSON file'),
            ('unknown verdict', {**bare, 'verdict': 'fine'}, "verdict 'fine' is not one of done, needs-you, running, blocked"),
            ('a section that is not a list', {**bare, 'evidence': None}, 'evidence must be a list of objects'),
            ('empty fold-out', {**bare, 'needs_you': [{**card, 'context': '', 'options': choices}]}, 'needs_you: an item needs context'),
            ('one option', {**bare, 'needs_you': [{**card, 'options': choices[:1]}]}, "'A' needs two to four options"),
            ('five options', {**bare, 'needs_you': [{**card, 'options': choices * 2 + choices[:1]}]}, "'A' needs two to four options"),
            ('an option without a label', {**bare, 'needs_you': [{**card, 'options': [choices[0], {'label': ''}]}]}, "'A' has an option without a label"),
            ('no recommendation', {**bare, 'needs_you': [{**card, 'options': [{'label': 'B'}, {'label': 'C'}]}]}, "'A' needs exactly one recommended option"),
            ('two recommendations', {**bare, 'needs_you': [{**card, 'options': [choices[0], choices[0]]}]}, "'A' needs exactly one recommended option"),
            ('a Critical decision', {**bare, 'decisions': [{'grade': 'Critical', 'title': 'A', 'why': 'B'}]}, "decisions: grade 'Critical' is not one of Minor, Major"),
            ('a review without rounds', {**bare, 'reviews': [gate]}, 'reviews: an item needs rounds'),
            ('a cap that is not a number', {**bare, 'reviews': [{**gate, 'cap': 'five', 'rounds': []}]}, 'reviews: A needs a whole number cap up to 10 and a list of rounds'),
            ('rounds that are not a list', {**bare, 'reviews': [{**gate, 'rounds': {}}]}, 'reviews: A needs a whole number cap up to 10 and a list of rounds'),
            ('an unknown round verdict', {**bare, 'reviews': [{**gate, 'rounds': [{'verdict': 'x'}]}]}, 'reviews: A has a round whose verdict is not one of findings, pass, running'),
            ('text as a finding count', {**bare, 'reviews': [{**gate, 'rounds': [{'verdict': 'pass', 'hard': '<img>'}]}]}, 'reviews: A has a round whose hard or soft is not a whole number'),
            ('evidence without a picture', {**bare, 'evidence': [{'id': '1', 'kind': 'page', 'caption': 'A'}]}, 'evidence: a page needs src'),
            ('a page that does not exist', {**bare, 'evidence': [{'id': '1', 'kind': 'page', 'caption': 'A', 'src': {'pdf': 'examples/marine/flagship/captain.pdf', 'page': 0}}]}, 'examples/marine/flagship/captain.pdf has no page 0'),
            ('a blank headline', {**bare, 'headline': '   '}, 'the report needs headline: add them to the JSON file'),
            ('a label that is not text', {**bare, 'stages': [{'label': [], 'state': 'done'}]}, 'stages: an item needs label'),
            ('a meter that is not a count', {**bare, 'meters': [{'label': 'A', 'value': '7/9', 'of': 9}]}, 'meters: A needs whole numbers, with value no higher than of'),
            ('a partial count without of', {**bare, 'meters': [{'label': 'A', 'value': '7/9'}]}, 'meters: A needs whole numbers, with value no higher than of'),
            ('a value above its total', {**bare, 'meters': [{'label': 'A', 'value': 12, 'of': 9}]}, 'meters: A needs whole numbers, with value no higher than of'),
            ('a passed round with blocking findings', {**bare, 'reviews': [{**gate, 'rounds': [{'verdict': 'pass', 'hard': 3}]}]}, 'reviews: A has a passed round with blocking findings'),
            ('a cap past the limit', {**bare, 'reviews': [{**gate, 'cap': 5000000000, 'rounds': []}]}, 'reviews: A needs a whole number cap up to 10 and a list of rounds'),
            ('done with cards open', {**bare, 'verdict': 'done'}, 'a done report has nothing that needs the owner: use needs-you'),
            ('not-a-number in the data', {**bare, 'extra': float('nan')}, 'the data holds a number that is not finite (NaN or infinity)'),
            ('a recommended that is not true', {**bare, 'needs_you': [{**card, 'options': [{'label': 'B', 'recommended': 'false'}, choices[0]]}]}, "'A' has a recommended that is not true or false"),
            ('a findings round with no findings', {**bare, 'reviews': [{**gate, 'rounds': [{'verdict': 'findings'}]}]}, 'reviews: A has a findings round with no findings'),
            ('lines that are not a number', {**bare, 'changes': [{'area': 'A', 'lines': 'many'}]}, 'changes: A needs a whole number of lines'),
            ('a figure without an id', {**bare, 'evidence': [{'kind': 'page', 'caption': 'A', 'src': 'x.png'}]}, 'evidence: an item needs id'),
            ('a figure id that is a sentence', {**bare, 'evidence': [{**figure, 'id': 'Figure 1'}]}, "evidence: id 'Figure 1' must be a number from 1 to 999, such as 1"),
            ('a letter for a figure id', {**bare, 'evidence': [{**figure, 'id': 'A'}]}, "evidence: id 'A' must be a number from 1 to 999, such as 1"),
            ('a list for the whole file', [], 'the JSON file must hold one object'),
            ('a fraction for a figure id', {**bare, 'evidence': [{**figure, 'id': 1.0}]}, 'evidence: id 1.0 must be a number from 1 to 999, such as 1'),
            ('a zero figure id', {**bare, 'evidence': [{**figure, 'id': 0}]}, "evidence: id '0' must be a number from 1 to 999, such as 1"),
            ('two figures with one id', {**bare, 'evidence': [figure, figure]}, "evidence: two figures share the id '1'"),
            ('a card citing a missing figure', {**bare, 'evidence': [figure], 'needs_you': [{**card, 'options': choices, 'figures': ['1', '9']}]}, "'A' cites Figure 9, which the evidence does not hold"),
            ('a decision citing a missing figure', {**bare, 'evidence': [figure], 'decisions': [{'grade': 'Major', 'title': 'D', 'why': 'B', 'figures': ['8']}]}, "'D' cites Figure 8, which the evidence does not hold"),
            ('figures that are not a list', {**bare, 'evidence': [figure], 'needs_you': [{**card, 'options': choices, 'figures': 'A'}]}, "'A' has figures that are not a list of figure ids: leave it out or name one"),
            ('a figure cited twice by one card', {**bare, 'evidence': [figure], 'needs_you': [{**card, 'options': choices, 'figures': ['1', 1]}]}, "'A' cites Figure 1 twice"),
            ('an empty figures list', {**bare, 'evidence': [figure], 'needs_you': [{**card, 'options': choices, 'figures': []}]}, "'A' has figures that are not a list of figure ids: leave it out or name one"),
            ('a PDF given as an image', {**bare, 'evidence': [{'id': '1', 'kind': 'page', 'caption': 'A', 'src': 'examples/marine/flagship/captain.pdf'}]}, 'examples/marine/flagship/captain.pdf is not an image: a PDF page is {"pdf": path, "page": n}')):
        path = folder / 'broken.json'
        path.write_text(json.dumps(broken), encoding='utf-8')
        target = folder / 'broken'
        refused = run(path, '--output', target)
        assert refused.returncode != 0 and refused.stderr.strip() == 'report: ' + message, refused.stderr
        assert not target.exists(), 'a refused report left a folder'
        checks.append('refused: ' + name)

    for name, source in (('plain', 'private/a/portrait.png'), ('absolute', str(ROOT / 'private/a/portrait.png')), ('climbing', 'tests/../private/a/portrait.png'), ('capitals', 'PRIVATE/a/portrait.png')):
        path = folder / 'broken.json'
        path.write_text(json.dumps({**bare, 'evidence': [{'id': '1', 'kind': 'page', 'caption': 'A', 'src': source}]}), encoding='utf-8')
        refused = run(path, '--fragment', '--output', folder / 'broken')
        assert refused.stderr.strip() == "report: a client's pages stay out of a hosted page: leave out --fragment", refused.stderr
        assert not (folder / 'broken').exists(), 'a refused report left a folder'
        checks.append('refused: a client page in a fragment, ' + name)
    path = folder / 'private' / 'report.json'
    path.parent.mkdir()
    path.write_text(json.dumps(data), encoding='utf-8')
    refused = run(path, '--fragment', '--output', folder / 'broken')
    assert refused.stderr.strip() == "report: a client's pages stay out of a hosted page: leave out --fragment", refused.stderr
    assert not (folder / 'broken').exists(), 'a refused report left a folder'
    checks.append('refused: a client report in a fragment')
    return checks
