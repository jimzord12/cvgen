"""Workspace and revision paths, ids, hashes and the JSON records they hold."""
import hashlib
import json
import os
import secrets
from datetime import datetime, timezone
from pathlib import Path

# Repository root: packages/cv-workflow/cv_workflow/workspace.py -> three levels up.
ROOT = Path(__file__).resolve().parents[3]
# The engine is the Framework plus the domains beside it (ADR 0012).
FRAMEWORK = ROOT / 'packages/cv-framework'
DOMAINS = ROOT / 'packages/domains'
ENGINE = (FRAMEWORK, DOMAINS)
FONTS = FRAMEWORK / 'fonts'
# Prefix of an export folder that is still being written; never a finished bundle.
PARTIAL_EXPORT = '.partial-'
MIN_HASH_PREFIX = 12


class WorkflowError(Exception):
    """A refused operation. The message names the reason and what to do instead."""


def sha256_file(path):
    digest = hashlib.sha256()
    with open(path, 'rb') as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b''):
            digest.update(chunk)
    return digest.hexdigest()


def utc_now():
    return datetime.now(timezone.utc).isoformat(timespec='seconds').replace('+00:00', 'Z')


def new_revision_id():
    return datetime.now(timezone.utc).strftime('%Y%m%d-%H%M%S') + '-' + secrets.token_hex(3)


def write_json(path, data):
    # Through a sibling temporary file, so an interrupted write leaves no half record.
    path = Path(path)
    temporary = path.with_name(path.name + '.tmp')
    temporary.write_text(json.dumps(data, indent=2) + '\n', encoding='utf-8')
    os.replace(temporary, path)


def read_json(path):
    try:
        data = json.loads(Path(path).read_text(encoding='utf-8'))
    except ValueError as error:
        raise WorkflowError(f'{path} is not valid JSON: {error}')
    if not isinstance(data, dict):
        raise WorkflowError(f'{path} must hold a JSON object')
    return data


def hash_matches(reviewed, actual):
    """True when the hash the owner reviewed is the full digest or an unambiguous prefix of it."""
    reviewed = (reviewed or '').strip().lower()
    if len(reviewed) < MIN_HASH_PREFIX or any(c not in '0123456789abcdef' for c in reviewed):
        return False
    return actual.startswith(reviewed)


def repo_relative(path):
    """Path from the repository root, as Typst writes it: '/private/x/y.png'."""
    return '/' + Path(path).resolve().relative_to(ROOT).as_posix()


class Workspace:
    """One candidate folder: candidate.json, cv.typ, revisions/ and exports/."""

    def __init__(self, folder):
        self.folder = Path(folder).resolve()
        try:
            self.folder.relative_to(ROOT)
        except ValueError:
            raise WorkflowError(f'Workspace {self.folder} is outside the repository; Typst resolves assets from '
                                f'the repository root, so keep candidate workspaces under private/ (or builds/ for tests)')
        for name in ('candidate.json', 'cv.typ'):
            if not (self.folder / name).is_file():
                raise WorkflowError(f'Workspace {self.folder} has no {name}; see docs/guides/build-a-cv.md')
        self.name = self.folder.name
        self.record = self.folder / 'candidate.json'
        self.entry = self.folder / 'cv.typ'
        self.revisions = self.folder / 'revisions'
        self.exports = self.folder / 'exports'

    @property
    def is_private(self):
        return is_private_path(self.folder)

    def revision(self, revision_id):
        return Revision(self, revision_id)

    def revision_ids(self):
        if not self.revisions.is_dir():
            return []
        return sorted(p.name for p in self.revisions.iterdir() if p.is_dir())

    def partial_exports(self):
        if not self.exports.is_dir():
            return []
        return sorted(p.name for p in self.exports.iterdir() if p.is_dir() and p.name.startswith(PARTIAL_EXPORT))


def is_private_path(folder):
    try:
        Path(folder).resolve().relative_to(ROOT / 'private')
        return True
    except ValueError:
        return False


class Revision:
    """One render under revisions/<id>/ and its export under exports/<id>/."""

    def __init__(self, workspace, revision_id):
        if not revision_id or revision_id != Path(revision_id).name or revision_id.startswith('.'):
            raise WorkflowError(f'Invalid revision id: {revision_id!r}')
        self.workspace = workspace
        self.id = revision_id
        self.folder = workspace.revisions / revision_id
        self.inputs = self.folder / 'inputs'
        self.pdf = self.folder / 'cv.pdf'
        self.log = self.folder / 'render.log'
        self.render_record = self.folder / 'render.json'
        self.checks_record = self.folder / 'checks.json'
        self.approval_record = self.folder / 'cv.approval.json'
        self.export = workspace.exports / revision_id

    def require_rendered(self):
        """The render record of a successful run whose cv.pdf still has the recorded bytes."""
        if not self.folder.is_dir():
            raise WorkflowError(f'Revision {self.id} does not exist in {self.workspace.revisions}')
        if not self.render_record.is_file():
            raise WorkflowError(f'Revision {self.id} is incomplete: no render.json (the render was interrupted); '
                                f'render a new revision')
        render = read_json(self.render_record)
        if render.get('status') != 'success' or not render.get('pdf'):
            raise WorkflowError(f'Revision {self.id} did not render successfully; read its render.log and render a new revision')
        if not self.pdf.is_file():
            raise WorkflowError(f'Revision {self.id} has no cv.pdf although render.json records one; render a new revision')
        actual = sha256_file(self.pdf)
        if actual != render['pdf']['sha256']:
            raise WorkflowError(f'Revision {self.id}: cv.pdf bytes changed since it was rendered '
                                f'(recorded {render["pdf"]["sha256"][:12]}, now {actual[:12]}); render a new revision')
        return render, actual

    def require_checks(self, sha256):
        """Passing checks that were run against exactly these PDF bytes."""
        if not self.checks_record.is_file():
            raise WorkflowError(f'Revision {self.id} has no checks.json; render a new revision')
        checks = read_json(self.checks_record)
        if checks.get('pdf_sha256') != sha256:
            raise WorkflowError(f'Revision {self.id}: checks.json is stale, it was recorded for other PDF bytes; render a new revision')
        if not checks.get('passed'):
            raise WorkflowError(f'Revision {self.id}: automated checks failed ({"; ".join(checks.get("errors", []))}); '
                                f'fix the inputs and render a new revision')
        return checks

    def require_approval(self, sha256):
        """The approval receipt written for this revision and exactly these bytes."""
        if not self.approval_record.is_file():
            raise WorkflowError(f'Revision {self.id} is not approved: no cv.approval.json; the owner approves with '
                                f'scripts/cv.py approve')
        approval = read_json(self.approval_record)
        if approval.get('revision') != self.id:
            raise WorkflowError(f'Revision {self.id}: cv.approval.json belongs to revision {approval.get("revision")}; '
                                f'an approval is never transferable')
        if approval.get('sha256') != sha256:
            raise WorkflowError(f'Revision {self.id}: cv.approval.json was written for other PDF bytes '
                                f'({str(approval.get("sha256"))[:12]}, now {sha256[:12]}); render and approve a new revision')
        return approval

    def state(self):
        """A one-word state for listings; never a proof of anything."""
        if not self.render_record.is_file():
            return 'incomplete'
        try:
            # A record that is not JSON, or is JSON of the wrong shape (a list, a missing `pdf` block),
            # is 'corrupt', never mistaken for a failed check or a missing approval.
            for record in (self.render_record, self.checks_record, self.approval_record):
                if record.is_file():
                    read_json(record)
            return self.describe()
        except (OSError, WorkflowError, KeyError, TypeError, AttributeError):
            return 'corrupt'

    def describe(self):
        """The state of a revision whose records all parse."""
        render = read_json(self.render_record)
        if render.get('status') != 'success':
            return 'failed'
        pdf = render.get('pdf')
        if not isinstance(pdf, dict) or not isinstance(pdf.get('sha256'), str):
            raise WorkflowError(f'Revision {self.id}: render.json records success without a pdf hash')
        if not self.pdf.is_file() or sha256_file(self.pdf) != render['pdf']['sha256']:
            return 'changed'
        sha256 = render['pdf']['sha256']
        try:
            self.require_checks(sha256)
        except WorkflowError:
            return 'checks-failed'
        try:
            approval = self.require_approval(sha256)
        except WorkflowError:
            return 'rendered'
        if not self.export.exists():
            return 'approved'
        pdf, receipt = self.export / 'cv.pdf', self.export / 'cv.approval.json'
        try:
            complete = pdf.is_file() and sha256_file(pdf) == sha256 and read_json(receipt) == approval
        except (OSError, WorkflowError):
            complete = False
        return 'exported' if complete else 'export-conflict'
