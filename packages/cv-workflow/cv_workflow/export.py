"""Copy an approved revision's exact bytes into exports/<id>/ and verify the copy."""
import secrets
import shutil

from .workspace import PARTIAL_EXPORT, Workspace, WorkflowError, read_json, sha256_file


def export_revision(workspace, revision_id):
    """Verify render, checks and approval, then copy cv.pdf and the receipt. Never compiles.

    A completed export is returned as is when its bytes still match; a folder
    with different content is never overwritten. The copy is made in a
    `.partial-` folder and renamed into place only after verification.
    """
    ws = Workspace(workspace)
    revision = ws.revision(revision_id)
    render, sha256 = revision.require_rendered()
    revision.require_checks(sha256)
    approval = revision.require_approval(sha256)
    if revision.export.exists():
        verify_bundle(revision.export, sha256, approval)
        return {'revision': revision.id, 'export': str(revision.export), 'sha256': sha256, 'existing': True}

    ws.exports.mkdir(exist_ok=True)
    partial = ws.exports / f'{PARTIAL_EXPORT}{revision.id}-{secrets.token_hex(3)}'
    partial.mkdir(exist_ok=False)
    try:
        shutil.copyfile(revision.pdf, partial / 'cv.pdf')
        shutil.copyfile(revision.approval_record, partial / 'cv.approval.json')
        verify_bundle(partial, sha256, approval)
    except Exception:
        shutil.rmtree(partial, ignore_errors=True)  # only ever our own seconds-old copy
        raise
    try:
        partial.rename(revision.export)  # fails, and leaves the partial folder, if the destination appeared meanwhile
    except OSError as error:
        raise WorkflowError(f'Could not move {partial.name} into place: {error}; the destination may have appeared '
                            f'during the copy, run the export again')
    verify_bundle(revision.export, sha256, approval)
    return {'revision': revision.id, 'export': str(revision.export), 'sha256': sha256, 'existing': False}


def verify_bundle(folder, sha256, approval):
    pdf, receipt = folder / 'cv.pdf', folder / 'cv.approval.json'
    if not pdf.is_file() or not receipt.is_file():
        raise WorkflowError(f'Export folder {folder} exists but is not a complete bundle; it is left untouched, '
                            f'inspect it before exporting again')
    if sha256_file(pdf) != sha256:
        raise WorkflowError(f'Export folder {folder} holds a different cv.pdf ({sha256_file(pdf)[:12]}, approved {sha256[:12]}); '
                            f'it is not overwritten')
    if read_json(receipt) != approval:
        raise WorkflowError(f'Export folder {folder} holds a different approval receipt; it is not overwritten')
