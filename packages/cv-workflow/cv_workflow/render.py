"""Snapshot the working inputs into a fresh revision, compile there, record and check the result."""
import json
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

from .checks import certificate_summary, check_certificates, check_pdf
from .outputs import envelope, stamp
from .validate import validate_record
from .workspace import (ENGINE, ENTRY, FONTS, ROOT, Workspace, WorkflowError, new_revision_id, read_json,
                        repo_relative, sha256_file, utc_now, write_json)

IMPORT = re.compile(r'^\s*#import\s+"([^"]+)"', re.MULTILINE)
# Every literal file path a Typst source reads: data loaders, read(), image(), and import or include
# written as code (after #, or starting a statement), never the word "include" in prose.
READS = re.compile(r'(?:(?<![\w.-])(?:json|yaml|toml|csv|xml|cbor|read|image)\(\s*'
                   r'|(?:#|(?:^|[{;=(\[])[ \t]*)(?:import|include)\s+)"([^"]+)"', re.MULTILINE)
# Comments, but not the // of a URL or anything inside a string (strings are put back unchanged).
COMMENTS = re.compile(r'("(?:\\.|[^"\\\n])*")|/\*.*?\*/|(?<!:)//[^\n]*', re.S)
# Typst writes UTF-8 whatever the Windows locale says; a Greek name in an error must survive.
TEXT = {'text': True, 'encoding': 'utf-8', 'errors': 'replace'}
# Fonts strict (task-46): every compile reads only the fonts it is given (--font-path) plus Typst's own
# embedded ones, never the machine's. A family that is not there still compiles, set in another font,
# with only a warning and exit code 0, so the runners read that warning and fail on it.
STRICT_FONTS = ['--ignore-system-fonts']
FONT_FALLBACK = re.compile(r'warning: unknown font family: ([^\r\n]+)')


def font_fallbacks(log):
    """The font families Typst could not find and replaced with another font, from its compile output."""
    return list(dict.fromkeys(name.strip() for name in FONT_FALLBACK.findall(log)))


def without_comments(source):
    return COMMENTS.sub(lambda m: m.group(1) or '', source)


def live_path(path, ws):
    """True when `path` is live data: inside the workspace or under private/ (case and dots resolved)."""
    path = path.resolve()
    return path.is_relative_to(ws.folder) or path.is_relative_to((ROOT / 'private').resolve())


def live_reads(deps, ws, revision):
    """Files the compile read from the live workspace or private/ instead of the revision's snapshot.

    The scan in workspace_files sees only literal paths; Typst's own dependency list
    also catches computed paths, so nothing live can slip into an approvable revision.
    """
    try:
        listed = json.loads(Path(deps).read_text(encoding='utf-8')).get('inputs', [])
    except (OSError, ValueError, AttributeError):
        return ['(the compiler wrote no dependency list, so the snapshot cannot be confirmed)']
    live = []
    for raw in listed if isinstance(listed, list) else []:
        path = Path(str(raw).removeprefix('\\\\?\\')).resolve()
        if not path.is_relative_to(revision.folder.resolve()) and live_path(path, ws):
            live.append(str(path))
    return live


def workspace_files(ws):
    """The workspace files typst/cv.typ reads by a literal path, followed through its local .typ helpers.

    Returned as paths relative to the workspace, so the snapshot (which mirrors the
    workspace under inputs/) keeps them where cv.typ expects them. A path that would read live data outside the snapshot
    (root-absolute into private/, or climbing out of the workspace) or a missing
    file is refused, naming the file. A computed path (image(d.photo)) cannot be
    seen here; render_revision catches it after the compile (live_reads).
    """
    found, queue, seen = [], [ws.entry], {ws.entry}
    while queue:
        source = queue.pop(0)
        where = source.relative_to(ws.folder).as_posix()
        for target in READS.findall(without_comments(source.read_text(encoding='utf-8'))):
            if target.startswith('@'):  # a Typst package, not a file
                continue
            if target.startswith('/'):
                if live_path(ROOT / target.lstrip('/'), ws):
                    raise WorkflowError(f'{where} reads {target} by a root-absolute path, so a revision would read the live '
                                        f'file, not a snapshot; write the path relative to {where}')
                continue  # a repository file (the engine, fonts, examples), recorded by the engine commit
            path = (source.parent / target).resolve()
            if not path.is_relative_to(ws.folder):
                raise WorkflowError(f'{where} reads {target}, which is outside the workspace; copy it into the workspace, '
                                    'or read a repository file by a root-absolute path (/packages/...)')
            if not path.is_file():
                raise WorkflowError(f'{where} reads {target}, which does not exist ({path})')
            if path in (ws.entry, ws.record) or path in seen:
                continue  # typst/cv.typ and candidate.json are always snapshotted, the record rewritten
            seen.add(path)
            found.append(path.relative_to(ws.folder))
            if path.suffix == '.typ':
                queue.append(path)
    return found


def render_revision(workspace, typst='typst', pages=2, inputs=None, reference_date=None):
    """Create revisions/<id>/ with the snapshot, cv.pdf, render.log, render.json and checks.json.

    The revision is kept whether or not the compiler or the checks succeed; a
    later fix is a new revision. Returns a summary dictionary. `reference_date`
    (a date, today by default) is the day certificate expiry is measured against.
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
    envelope(ws.folder)  # who the client is, for the revision's Meta File (Output Contract)
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
    files = workspace_files(ws)
    if source and any(f.as_posix() == 'assets/' + source.name and ws.folder / f != source.resolve() for f in files):
        raise WorkflowError(f'{ENTRY} reads the workspace file assets/{source.name}, which is not the portrait but would take its place '
                            'in the snapshot; rename one of them')

    revision = ws.revision(new_revision_id())
    (revision.inputs / 'assets').mkdir(parents=True, exist_ok=False)
    # Snapshot: the workspace's own layout under inputs/ (TASK-32): the entry point verbatim at
    # inputs/typst/cv.typ, the record with its portrait repointed at the copied asset, so the
    # revision compiles from its own files alone and every relative read lands where it did.
    entry = revision.inputs / ENTRY
    entry.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(ws.entry, entry)
    assets = []
    if source:
        copy = revision.inputs / 'assets' / source.name
        shutil.copyfile(source, copy)
        record['identity']['portrait'] = repo_relative(copy)
        assets.append({'field': 'identity.portrait', 'source': portrait, 'path': 'inputs/assets/' + source.name,
                       'sha256': sha256_file(copy)})
    write_json(revision.inputs / 'candidate.json', record)
    # The other files cv.typ reads, at the same place relative to it.
    extra = []
    for relative in files:
        copy = revision.inputs / relative
        copy.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(ws.folder / relative, copy)
        extra.append({'path': 'inputs/' + relative.as_posix(), 'sha256': sha256_file(copy)})

    command = [compiler, 'compile', '--root', str(ROOT), *STRICT_FONTS, '--font-path', str(FONTS)]
    for key, value in (inputs or {}).items():
        command += ['--input', f'{key}={value}']
    command += [str(entry), str(revision.pdf)]
    with tempfile.TemporaryDirectory() as scratch:
        deps = Path(scratch) / 'deps.json'
        result = subprocess.run(command[:2] + ['--deps', str(deps)] + command[2:], capture_output=True, cwd=ROOT, **TEXT)
        live = live_reads(deps, ws, revision) if result.returncode == 0 else []
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
            'entry': {'path': 'inputs/' + ENTRY, 'sha256': sha256_file(entry),
                      'imports': IMPORT.findall(entry.read_text(encoding='utf-8'))},
            'candidate': {'path': 'inputs/candidate.json', 'sha256': sha256_file(revision.inputs / 'candidate.json'),
                          'source_sha256': sha256_file(ws.record), 'schema': schema},
            'assets': assets,
            'files': extra,
            'compiler_inputs': dict(inputs or {}),
        },
        'settings': {'expected_pages': pages},
        'pdf': {'path': 'cv.pdf', 'sha256': sha256_file(revision.pdf), 'bytes': revision.pdf.stat().st_size} if succeeded else None,
    }
    write_json(revision.render_record, render)
    checks = None
    if succeeded:
        checks = check_pdf(revision.pdf, pages)
        # A live read makes the revision unapprovable: what was rendered is not what the snapshot holds.
        for path in live:
            checks['errors'].append(f'The compile read {path}, a live file outside the revision snapshot; '
                                    'read it by a literal path relative to cv.typ')
        # A missing font family makes the page look wrong while it still compiles: never approvable.
        for family in font_fallbacks(result.stderr):
            checks['errors'].append(f'Font family "{family}" is not in {repo_relative(FONTS).lstrip("/")}, so Typst set '
                                    'that text in another font; fix the name or bundle the font there (render.log '
                                    'shows where it is used)')
        checks['passed'] = not checks['errors']
        # Read from the snapshot the PDF was compiled from; warnings never change `passed`.
        checks['certificates'] = check_certificates(read_json(revision.inputs / 'candidate.json'), reference_date)
        write_json(revision.checks_record, checks)
        lang = str((inputs or {}).get('lang') or '').lower()
        stamp(revision.pdf, {'kind': 'client-cv', 'status': 'render', 'variant': revision.id,
                             'lang': lang if re.fullmatch('[a-z]{2}', lang) else None, 'source': ENTRY,
                             'producedBy': 'scripts/cv.py render'}, envelope_dir=ws.folder)
    counts, warnings = certificate_summary(checks)
    return {
        'revision': revision.id,
        'folder': str(revision.folder),
        'status': render['status'],
        'schema': schema,
        'sha256': render['pdf']['sha256'] if succeeded else None,
        'checks_passed': bool(checks and checks['passed']),
        'errors': (checks or {}).get('errors', []) if succeeded else [result.stderr.strip()],
        'certificate_dates': counts,
        'warnings': warnings,
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
