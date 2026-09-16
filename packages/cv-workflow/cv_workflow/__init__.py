"""Candidate CV workflow: fresh revisions, checks, explicit approval, verified export (ADR 0010).

The engine renders; this package owns the document operations around it. Local
commands under scripts/ call these functions today; the future web backend
calls the same ones. Nothing here sends or publishes a PDF.
"""
from .approve import approve_revision
from .export import export_revision
from .render import render_revision
from .workspace import ROOT, Revision, Workspace, WorkflowError, sha256_file


def workspace_status(workspace):
    """Every revision with its one-word state, plus any interrupted export folders."""
    ws = Workspace(workspace)
    return {
        'workspace': str(ws.folder),
        'revisions': [{'revision': rid, 'state': ws.revision(rid).state()} for rid in ws.revision_ids()],
        'partial_exports': ws.partial_exports(),
    }


__all__ = ['ROOT', 'Revision', 'Workspace', 'WorkflowError', 'approve_revision', 'export_revision',
           'render_revision', 'sha256_file', 'workspace_status']
