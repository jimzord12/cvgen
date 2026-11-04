"""scripts/report.py through its real command line: the worked sample, then each refusal. Run by tests/run.py."""
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
    assert page.startswith('<!doctype html>'), 'a full page opens with its skeleton'
    assert '{{' not in page, 'a placeholder was left in the page'
    assert page.count('data:font/ttf') == 3 and 'data:image/jpeg' in page, 'fonts and pages are embedded'
    assert not re.search(r'(src|href)="https?:', page), 'the page loads nothing from the network'
    checks.append('sample builds into one page')

    fragment = run(SAMPLE, '--fragment', '--output', folder / 'fragment')
    assert fragment.returncode == 0, fragment.stderr
    assert (folder / 'fragment/report.html').read_text(encoding='utf-8').startswith('<meta charset'), 'a fragment has no skeleton'
    checks.append('fragment has no skeleton and keeps its charset')

    assert run(SAMPLE, '--output', folder / 'sample').returncode != 0, 'an existing folder was overwritten'
    checks.append('an existing folder is refused')

    data = json.loads(SAMPLE.read_text(encoding='utf-8'))
    hostile = folder / 'hostile.json'
    hostile.write_text(json.dumps({**data, 'title': '{{DATA}} A & B', 'headline': '</script><!-- x'}), encoding='utf-8')
    written = run(hostile, '--output', folder / 'hostile')
    assert written.returncode == 0, written.stderr
    page = (folder / 'hostile/report.html').read_text(encoding='utf-8')
    assert '</script><!--' not in page and page.count('</script>') == 2, 'report text closed the script block'
    assert '<title>{{DATA}} A &amp; B</title>' in page, 'a placeholder in a title stays text'
    checks.append('text cannot break out of the page')

    card = {'title': 'A', 'context': 'B', 'decision': 'C'}
    choices = [{'label': 'B', 'recommended': True}, {'label': 'C'}]
    gate = {'name': 'A', 'cap': 5}
    for name, broken, message in (
            ('no headline', {k: v for k, v in data.items() if k != 'headline'}, 'the report needs headline: add them to the JSON file'),
            ('unknown verdict', {**data, 'verdict': 'fine'}, "verdict 'fine' is not one of done, needs-you, running, blocked"),
            ('a section that is not a list', {**data, 'evidence': None}, 'evidence must be a list of objects'),
            ('empty fold-out', {**data, 'needs_you': [{**card, 'context': '', 'options': choices}]}, 'needs_you: an item needs context'),
            ('one option', {**data, 'needs_you': [{**card, 'options': choices[:1]}]}, "'A' needs two to four options"),
            ('five options', {**data, 'needs_you': [{**card, 'options': choices * 2 + choices[:1]}]}, "'A' needs two to four options"),
            ('an option without a label', {**data, 'needs_you': [{**card, 'options': [choices[0], {'label': ''}]}]}, "'A' has an option without a label"),
            ('no recommendation', {**data, 'needs_you': [{**card, 'options': [{'label': 'B'}, {'label': 'C'}]}]}, "'A' needs exactly one recommended option"),
            ('two recommendations', {**data, 'needs_you': [{**card, 'options': [choices[0], choices[0]]}]}, "'A' needs exactly one recommended option"),
            ('a Critical decision', {**data, 'decisions': [{'grade': 'Critical', 'title': 'A', 'why': 'B'}]}, "decisions: grade 'Critical' is not one of Minor, Major"),
            ('a review without rounds', {**data, 'reviews': [gate]}, 'reviews: an item needs rounds'),
            ('a cap that is not a number', {**data, 'reviews': [{**gate, 'cap': 'five', 'rounds': []}]}, 'reviews: A needs a whole number cap up to 10 and a list of rounds'),
            ('rounds that are not a list', {**data, 'reviews': [{**gate, 'rounds': {}}]}, 'reviews: A needs a whole number cap up to 10 and a list of rounds'),
            ('an unknown round verdict', {**data, 'reviews': [{**gate, 'rounds': [{'verdict': 'x'}]}]}, 'reviews: A has a round whose verdict is not one of findings, pass, running'),
            ('text as a finding count', {**data, 'reviews': [{**gate, 'rounds': [{'verdict': 'pass', 'hard': '<img>'}]}]}, 'reviews: A has a round whose hard or soft is not a whole number'),
            ('evidence without a picture', {**data, 'evidence': [{'kind': 'page', 'caption': 'A'}]}, 'evidence: a page needs src'),
            ('a page that does not exist', {**data, 'evidence': [{'kind': 'page', 'caption': 'A', 'src': {'pdf': 'examples/marine/flagship/captain.pdf', 'page': 0}}]}, 'examples/marine/flagship/captain.pdf has no page 0'),
            ('a blank headline', {**data, 'headline': '   '}, 'the report needs headline: add them to the JSON file'),
            ('a label that is not text', {**data, 'stages': [{'label': [], 'state': 'done'}]}, 'stages: an item needs label'),
            ('a meter that is not a count', {**data, 'meters': [{'label': 'A', 'value': '7/9', 'of': 9}]}, 'meters: A needs whole numbers, with value no higher than of'),
            ('a partial count without of', {**data, 'meters': [{'label': 'A', 'value': '7/9'}]}, 'meters: A needs whole numbers, with value no higher than of'),
            ('a value above its total', {**data, 'meters': [{'label': 'A', 'value': 12, 'of': 9}]}, 'meters: A needs whole numbers, with value no higher than of'),
            ('a passed round with blocking findings', {**data, 'reviews': [{**gate, 'rounds': [{'verdict': 'pass', 'hard': 3}]}]}, 'reviews: A has a passed round with blocking findings'),
            ('a cap past the limit', {**data, 'reviews': [{**gate, 'cap': 5000000000, 'rounds': []}]}, 'reviews: A needs a whole number cap up to 10 and a list of rounds'),
            ('done with cards open', {**data, 'verdict': 'done'}, 'a done report has nothing that needs the owner: use needs-you'),
            ('not-a-number in the data', {**data, 'extra': float('nan')}, 'Out of range float values are not JSON compliant: nan'),
            ('a recommended that is not true', {**data, 'needs_you': [{**card, 'options': [{'label': 'B', 'recommended': 'false'}, choices[0]]}]}, "'A' has a recommended that is not true or false"),
            ('a findings round with no findings', {**data, 'reviews': [{**gate, 'rounds': [{'verdict': 'findings'}]}]}, 'reviews: A has a findings round with no findings'),
            ('lines that are not a number', {**data, 'changes': [{'area': 'A', 'lines': 'many'}]}, 'changes: A needs a whole number of lines'),
            ('a PDF given as an image', {**data, 'evidence': [{'kind': 'page', 'caption': 'A', 'src': 'examples/marine/flagship/captain.pdf'}]}, 'examples/marine/flagship/captain.pdf is not an image: a PDF page is {"pdf": path, "page": n}')):
        path = folder / 'broken.json'
        path.write_text(json.dumps(broken), encoding='utf-8')
        target = folder / 'broken'
        refused = run(path, '--output', target)
        assert refused.returncode != 0 and refused.stderr.strip() == 'report: ' + message, refused.stderr
        assert not target.exists(), 'a refused report left a folder'
        checks.append('refused: ' + name)

    for name, source in (('plain', 'private/a/portrait.png'), ('absolute', str(ROOT / 'private/a/portrait.png')), ('climbing', 'tests/../private/a/portrait.png'), ('capitals', 'PRIVATE/a/portrait.png')):
        path = folder / 'broken.json'
        path.write_text(json.dumps({**data, 'evidence': [{'kind': 'page', 'caption': 'A', 'src': source}]}), encoding='utf-8')
        refused = run(path, '--fragment', '--output', folder / 'broken')
        assert refused.stderr.strip() == "report: a client's pages stay out of a hosted page: leave out --fragment", refused.stderr
        checks.append('refused: a client page in a fragment, ' + name)
    path = folder / 'private' / 'report.json'
    path.parent.mkdir()
    path.write_text(json.dumps(data), encoding='utf-8')
    refused = run(path, '--fragment', '--output', folder / 'broken')
    assert refused.stderr.strip() == "report: a client's pages stay out of a hosted page: leave out --fragment", refused.stderr
    checks.append('refused: a client report in a fragment')
    return checks
