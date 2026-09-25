"""Snapshot the working inputs into a fresh revision, compile there, record and check the result."""
import re
import shutil
import subprocess

from .checks import check_pdf
from .validate import validate_record
from .workspace import (ENGINE, FONTS, ROOT, Workspace, WorkflowError, new_revision_id, read_json,
                        repo_relative, sha256_file, utc_now, write_json)

IMPORT = re.compile(r'^\s*#import\s+"([^"]+)"', re.MULTILINE)
# Typst writes UTF-8 whatever the Windows locale says; a Greek name in an error must survive.
TEXT = {'text': True, 'encoding': 'utf-8', 'errors': 'replace'}


def render_revision(workspace, typst='typst', pages=2, inputs=None):
    """Create revisions/<id>/ with the snapshot, cv.pdf, render.log, render.json and checks.json.

    The revision is kept whether or not the compiler or the checks succeed; a
    later fix is a new revision. Returns a summary dictionary.
    """
    ws = Workspace(workspace)
    compiler = shutil.which(typst) or typst
    try:
        version = subprocess.run([compiler, '--version'], capture_output=True, **TEXT, check=True).stdout.strip()
    except (OSError, subprocess.CalledProcessError):
        raise WorkflowError(f'Typst compiler not found: {typst!r}; pass --typst path/to/typst')
    # Everything that can be refused is checked before the revision folder exists,
    # so a refusal leaves nothing behind.
    record = read_json(ws.record)
    if not isinstance(record, dict):
        raise WorkflowError(f'{ws.record} must hold a JSON object')
    # A misspelt or unknown key would otherwise be dropped silently by the engine.
    schema = validate_record(record, IMPORT.findall(ws.entry.read_text(encoding='utf-8')))
    portrait = (record.get('identity') or {}).get('portrait')
    source = None
    if portrait:
        source = ROOT / portrait.lstrip('/') if portrait.startswith('/') else ws.folder / portrait
        if not source.is_file():
            raise WorkflowError(f'identity.portrait {portrait!r} resolves to {source}, which does not exist')

    revision = ws.revision(new_revision_id())
    (revision.inputs / 'assets').mkdir(parents=True, exist_ok=False)
    # Snapshot: the entry point verbatim, the record with its portrait repointed
    # at the copied asset, so the revision compiles from its own files alone.
    shutil.copyfile(ws.entry, revision.inputs / 'cv.typ')
    assets = []
    if source:
        copy = revision.inputs / 'assets' / source.name
        shutil.copyfile(source, copy)
        record['identity']['portrait'] = repo_relative(copy)
        assets.append({'field': 'identity.portrait', 'source': portrait, 'path': 'inputs/assets/' + source.name,
                       'sha256': sha256_file(copy)})
    write_json(revision.inputs / 'candidate.json', record)

    command = [compiler, 'compile', '--root', str(ROOT), '--font-path', str(FONTS)]
    for key, value in (inputs or {}).items():
        command += ['--input', f'{key}={value}']
    command += [str(revision.inputs / 'cv.typ'), str(revision.pdf)]
    result = subprocess.run(command, capture_output=True, cwd=ROOT, **TEXT)
    revision.log.write_text(result.stdout + result.stderr, encoding='utf-8')
    succeeded = result.returncode == 0 and revision.pdf.is_file()

    render = {
        'revision': revision.id,
        'candidate': ws.name,
        'created_at': utc_now(),
        'status': 'success' if succeeded else 'failed',
        'exit_code': result.returncode,
        'engine': engine_state(),
        'compiler': {'version': version, 'command': command},
        'inputs': {
            'entry': {'path': 'inputs/cv.typ', 'sha256': sha256_file(revision.inputs / 'cv.typ'),
                      'imports': IMPORT.findall((revision.inputs / 'cv.typ').read_text(encoding='utf-8'))},
            'candidate': {'path': 'inputs/candidate.json', 'sha256': sha256_file(revision.inputs / 'candidate.json'),
                          'source_sha256': sha256_file(ws.record), 'schema': schema},
            'assets': assets,
            'compiler_inputs': dict(inputs or {}),
        },
        'settings': {'expected_pages': pages},
        'pdf': {'path': 'cv.pdf', 'sha256': sha256_file(revision.pdf), 'bytes': revision.pdf.stat().st_size} if succeeded else None,
    }
    write_json(revision.render_record, render)
    checks = None
    if succeeded:
        checks = check_pdf(revision.pdf, pages)
        write_json(revision.checks_record, checks)
    return {
        'revision': revision.id,
        'folder': str(revision.folder),
        'status': render['status'],
        'schema': schema,
        'sha256': render['pdf']['sha256'] if succeeded else None,
        'checks_passed': bool(checks and checks['passed']),
        'errors': (checks or {}).get('errors', []) if succeeded else [result.stderr.strip()],
        'engine_uncommitted_changes': render['engine']['uncommitted_changes'],
    }


def engine_state():
    """Engine commit plus whether the Framework or a domain has uncommitted edits (then the run is not reproducible)."""
    packages = [repo_relative(p).lstrip('/') for p in ENGINE]
    try:
        commit = subprocess.run(['git', 'rev-parse', 'HEAD'], cwd=ROOT, capture_output=True, **TEXT, check=True).stdout.strip()
        dirty = subprocess.run(['git', 'status', '--porcelain', '--', *map(str, ENGINE)], cwd=ROOT, capture_output=True,
                               **TEXT, check=True).stdout.strip()
        return {'packages': packages, 'commit': commit, 'uncommitted_changes': bool(dirty)}
    except (OSError, subprocess.CalledProcessError):
        return {'packages': packages, 'commit': None, 'uncommitted_changes': None}
