"""Explicit approval of one revision's exact bytes, written as cv.approval.json."""
from .workspace import Workspace, WorkflowError, hash_matches, is_private_path, read_json, utc_now, write_json


def approve_revision(workspace, revision_id, approver, sha256, test_only=False):
    """Write the approval receipt after verifying the reviewed hash still matches cv.pdf.

    `sha256` is the digest (or a prefix of at least twelve characters) the
    approver saw on the reviewed PDF. `test_only` marks a fictional fixture
    approval and is refused for any workspace under private/.
    """
    if not (approver or '').strip():
        raise WorkflowError('An approver name is required; approval is an explicit owner action')
    if test_only and is_private_path(workspace):
        raise WorkflowError('Test-only approval is refused under private/: a real candidate PDF is approved by the owner only')
    ws = Workspace(workspace)
    revision = ws.revision(revision_id)
    render, actual = revision.require_rendered()
    revision.require_checks(actual)
    if not hash_matches(sha256, actual):
        raise WorkflowError(f'The reviewed hash {sha256!r} does not match cv.pdf ({actual}); review the current '
                            f'bytes and pass at least the first twelve characters of their SHA-256')
    if revision.approval_record.is_file():
        existing = read_json(revision.approval_record)
        if existing.get('revision') == revision.id and existing.get('sha256') == actual:
            return {'revision': revision.id, 'sha256': actual, 'already_approved': True, 'approval': existing}
        raise WorkflowError(f'Revision {revision.id} already has a cv.approval.json for other bytes; it is not overwritten')
    approval = {
        'revision': revision.id,
        'candidate': ws.name,
        'sha256': actual,
        'bytes': render['pdf']['bytes'],
        'approver': approver.strip(),
        'approved_at': utc_now(),
        'scope': 'test-only' if test_only else 'owner',
    }
    write_json(revision.approval_record, approval)
    return {'revision': revision.id, 'sha256': actual, 'already_approved': False, 'approval': approval}
