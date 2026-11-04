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
    card = {'title': 'A', 'context': 'B', 'decision': 'C'}
    for name, broken, word in (('no headline', {k: v for k, v in data.items() if k != 'headline'}, 'headline'),
                               ('unknown verdict', {**data, 'verdict': 'fine'}, 'verdict'),
                               ('one option', {**data, 'needs_you': [{**card, 'options': [{'label': 'B'}]}]}, 'two to four'),
                               ('no recommendation', {**data, 'needs_you': [{**card, 'options': [{'label': 'B'}, {'label': 'C'}]}]}, 'recommended'),
                               ('a Critical decision', {**data, 'decisions': [{'grade': 'Critical', 'title': 'A', 'why': 'B'}]}, 'grade'),
                               ('a review without rounds', {**data, 'reviews': [{'name': 'A', 'cap': 5}]}, 'rounds')):
        path = folder / 'broken.json'
        path.write_text(json.dumps(broken), encoding='utf-8')
        target = folder / 'broken'
        refused = run(path, '--output', target)
        assert refused.returncode != 0 and word in refused.stderr, refused.stderr
        assert not target.exists(), 'a refused report left a folder'
        checks.append('refused: ' + name)
    return checks
