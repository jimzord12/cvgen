"""The public example list (examples/release.json) and scripts/build.ps1, which reads it.

`examples()` is how the suite reads the list; it fails when the list and the entry points under
examples/ disagree. `run_build_script()` drives the real build.ps1, under every PowerShell on this
machine, in a throwaway copy of the repository, so no `Release` PDF in examples/ is ever touched:
the list is the only source of what is built, and -Release never overwrites a `Release` without
-ReplaceRelease (constitution section 2; replacing one is the owner's go).
"""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

from verify import ROOT

LIST = 'examples/release.json'


def examples(root=ROOT):
    """The listed examples, after checking that they are exactly the entry points under examples/."""
    root = Path(root)
    listed = json.loads((root / LIST).read_text(encoding='utf-8'))['examples']
    sources = [e['source'] for e in listed]
    assert sources, f'{LIST} lists no examples'
    assert len(sources) == len(set(sources)), f'{LIST} lists an example twice'
    for e in listed:
        assert e.get('title') and e.get('variant'), f'{LIST}: {e["source"]} needs a title and a variant'
    entries = {p.relative_to(root).as_posix() for p in (root / 'examples').rglob('*.typ')}
    missing, unknown = sorted(entries - set(sources)), sorted(set(sources) - entries)
    assert not missing, f'entry points not in {LIST}, so build.ps1 and the suite skip them: {missing}'
    assert not unknown, f'{LIST} lists entry points that do not exist: {unknown}'
    return listed


def shells():
    """Every PowerShell here: pwsh 7, and on Windows also Windows PowerShell 5.1."""
    found = [s for s in (shutil.which('pwsh'), shutil.which('powershell') if os.name == 'nt' else None) if s]
    return list(dict.fromkeys(found))


def _sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def _copy(repo):
    """What build.ps1 needs, copied: the packages, every entry point and record, the two scripts."""
    shutil.copytree(ROOT / 'packages', repo / 'packages', ignore=shutil.ignore_patterns('__pycache__', 'approved'))
    shutil.copytree(ROOT / 'examples', repo / 'examples')
    (repo / 'scripts').mkdir()
    for script in ['build.ps1', 'outputs.py']:
        shutil.copy2(ROOT / 'scripts' / script, repo / 'scripts' / script)


def run_build_script(out, typst):
    """Yield the name of each check that passed, per PowerShell found (run.py skips when there is none)."""
    for shell in shells():
        label = Path(shell).stem.lower()
        repo = Path(out) / 'build-script' / label
        _copy(repo)
        log = []

        def build(*flags, shell=shell, repo=repo, label=label, log=log):  # bound now: B023
            command = [shell, '-NoProfile', '-NonInteractive', '-ExecutionPolicy', 'Bypass', '-File',
                       str(repo / 'scripts/build.ps1'), '-TypstExecutable', typst, '-PythonExecutable', sys.executable, *flags]
            result = subprocess.run(command, capture_output=True, text=True, encoding='utf-8', errors='replace')
            log.append(f'$ {" ".join(flags)}\nexit {result.returncode}\n{result.stdout}{result.stderr}')
            (repo.parent / f'{label}.log').write_text('\n'.join(log), encoding='utf-8')
            return result

        # The list alone says what is built: cut to one example, both build.ps1 and the suite see it.
        listing = json.loads((repo / LIST).read_text(encoding='utf-8'))
        listing['examples'] = [e for e in listing['examples'] if e['source'].endswith('/deck-cadet.typ')]
        (repo / LIST).write_text(json.dumps(listing, indent=2), encoding='utf-8')
        try:
            examples(repo)
        except AssertionError as error:
            assert 'not in examples/release.json' in str(error) and 'engineer.typ' in str(error), error
        else:
            raise AssertionError('the suite accepted a list that leaves entry points out')
        # A list without its `examples` key, or with an entry lacking its title, is refused before anything is built.
        untitled = [{k: v for k, v in e.items() if k != 'title'} for e in listing['examples']]
        for case, broken in [('no-key', {'about': 'misspelt key', 'example': listing['examples']}),
                             ('no-title', {'examples': untitled})]:
            (repo / LIST).write_text(json.dumps(broken), encoding='utf-8')
            result = build('-OutputDirectory', 'builds/malformed-' + case)
            text = result.stdout + result.stderr
            assert result.returncode != 0 and 'needs an "examples" array' in text, (case, text)
            assert not (repo / ('builds/malformed-' + case)).exists(), f'a malformed list ({case}) still built'
        (repo / LIST).write_text(json.dumps(listing, indent=2), encoding='utf-8')
        yield f'{label}-malformed-list-refused'
        result = build('-OutputDirectory', 'builds/plain')
        assert result.returncode == 0, result.stderr
        assert sorted(p.name for p in (repo / 'builds/plain').iterdir()) == ['deck-cadet.pdf'], 'build.ps1 ignored the list'
        yield f'{label}-reads-the-list'

        # A Release exists and differs from a new build: -Release refuses before it builds or writes anything.
        pdf = repo / 'examples/marine/flagship/deck-cadet.pdf'
        meta = pdf.with_name('deck-cadet.meta.json')
        before = (_sha(pdf), _sha(meta))
        result = build('-Release', '-OutputDirectory', 'builds/refused')
        text = result.stdout + result.stderr
        assert result.returncode != 0 and 'Refused: the Release already exists' in text and '-ReplaceRelease' in text, text
        assert (_sha(pdf), _sha(meta)) == before, 'a refused -Release changed the Release'
        assert not (repo / 'builds/refused').exists(), 'a refused -Release still built'
        yield f'{label}-release-refuses-to-overwrite'

        # No Release yet: -Release writes it and stamps a valid, current Meta File from the list.
        pdf.unlink()
        meta.unlink()
        result = build('-Release', '-OutputDirectory', 'builds/first')
        assert result.returncode == 0, result.stdout + result.stderr
        assert _sha(pdf) == _sha(repo / 'builds/first/deck-cadet.pdf')
        stamped = json.loads(meta.read_text(encoding='utf-8'))
        assert (stamped['status'], stamped['title'], stamped['sha256']) == ('release', listing['examples'][0]['title'], _sha(pdf)), stamped
        yield f'{label}-first-release-written'

        # The owner's go: -ReplaceRelease replaces an older Release and re-stamps it.
        shutil.copyfile(repo / 'examples/marine/flagship/captain.pdf', pdf)
        result = build('-ReplaceRelease', '-OutputDirectory', 'builds/replaced')
        assert result.returncode == 0, result.stdout + result.stderr
        assert _sha(pdf) == _sha(repo / 'builds/replaced/deck-cadet.pdf') != _sha(repo / 'examples/marine/flagship/captain.pdf')
        assert json.loads(meta.read_text(encoding='utf-8'))['sha256'] == _sha(pdf)
        yield f'{label}-replace-release-with-owners-go'
