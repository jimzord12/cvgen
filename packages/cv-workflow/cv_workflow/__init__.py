"""Candidate CV workflow: fresh revisions, checks, explicit approval, verified export (ADR 0010).

The engine renders; this package owns the document operations around it. Local
commands under scripts/ call these functions today; the future web backend
calls the same ones. Nothing here sends or publishes a PDF.
"""
from .approve import approve_revision
from .checks import certificate_summary
from .export import export_revision
from .render import render_revision
from .workspace import ROOT, Revision, Workspace, WorkflowError, read_json, sha256_file


def workspace_status(workspace):
    """Every revision with its one-word state, plus any interrupted export folders."""
    ws = Workspace(workspace)
    revisions = []
    for rid in ws.revision_ids():
        revision = ws.revision(rid)
        # The hash prefix is what the owner passes to approve after reviewing cv.pdf.
        sha256 = sha256_file(revision.pdf)[:12] if revision.pdf.is_file() else None
        # Certificate warnings as recorded at render (against that day's date); a broken
        # checks.json already shows in the state, so it adds no warning here.
        try:
            checks = read_json(revision.checks_record) if revision.checks_record.is_file() else {}
        except WorkflowError:
            checks = {}
        counts, warnings = certificate_summary(checks)
        revisions.append({'revision': rid, 'state': revision.state(), 'sha256': sha256,
                          'certificate_dates': counts, 'warnings': warnings})
    return {'workspace': str(ws.folder), 'revisions': revisions, 'partial_exports': ws.partial_exports()}


__all__ = ['ROOT', 'Revision', 'Workspace', 'WorkflowError', 'approve_revision', 'export_revision',
           'render_revision', 'sha256_file', 'workspace_status']
