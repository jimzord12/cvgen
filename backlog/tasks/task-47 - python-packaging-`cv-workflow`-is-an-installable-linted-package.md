---
id: TASK-47
title: 'python-packaging: `cv-workflow` is an installable, linted package'
status: Active
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 08:45'
labels:
  - restructure
dependencies: []
ordinal: 47000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
A `pyproject.toml` with pinned dependencies (pillow is unpinned in CI); drop the `sys.path` inserts; ruff; consider pytest for `tests/run.py` (bare asserts stop at the first failure and vanish under `-O`). Source: docs/work/workflow-model/handoff.md, section 4, item 15 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
2026-10-14, from TASK-48 review round 2 (N4, N5): CI now pins pillow==12.3.0, pymupdf==1.28.2, jsonschema==4.26.0 in .github/workflows/verify.yml; jsonschema's transitive dependencies (attrs, referencing, jsonschema-specifications, rpds-py) still float, so a constraints or lock file belongs here; docs/tech-stack.md local setup line and docs/work/workflow-model/handoff.md still describe pillow as unpinned.

2026-10-14, implementation (branch feature/task-47-python-packaging):
- 🧭 Done: packages/cv-workflow/pyproject.toml (cv-workflow 0.1.0, requires-python >=3.11; pymupdf==1.28.2, jsonschema==4.26.0; extras test = pillow==12.3.0, lint = ruff==0.16.10). requirements.lock at the root, compiled with uv pip compile --all-extras --universal --python-version 3.11 --generate-hashes (command at the top of the lock): every transitive dependency pinned with SHA-256 hashes (attrs 26.1.0, referencing 0.37.0, jsonschema-specifications 2025.9.1, rpds-py 2026.9.1, typing-extensions 4.16.0 below Python 3.13). CI and the local setup line both run pip install -r requirements.lock (pip checks the hashes). Reason: one source of versions for CI and the owner's machine; hashes because CI already checksums Typst.
- 🧭 ruff 0.16.10 rather than the newest 0.17.0 (released after 2026-10-07, under two weeks old). ruff.toml at the root: include scripts/, tests/, packages/cv-workflow/ only (vendored .atlas/_kit, .claude/skills scripts and concept asset scripts stay out); select E4, E7, E9, F, B; ignore E701/E702 (compact one-liners in the test helpers, style only) and B905 (zip strict= changes behaviour). 34 findings, fixed behaviour-neutrally: 6 B904 (raise ... from error), 6 B023 in tests/release.py (closure variables bound as keyword-only defaults; the closure was only called inside its own loop iteration, so not a live bug), 6 E741 (l renamed line), 3 E731 (lambda to def), 2 E401 (imports split; the local re-import of shutil in run.py dropped). CI step "Lint with ruff" runs before the suite on both runners.
- 🧭 Not done, per the lead: the sys.path inserts stay (scripts run from a plain checkout with no install step; requiring pip install -e adds setup for no product gain) and tests/run.py stays its own runner (it reports every case and writes evidence). run.py checks are bare asserts, so main() now refuses to run when __debug__ is off (python -O or PYTHONOPTIMIZE) with a clear message; checked by hand (exit 1, message printed).
- .gitignore: .ruff_cache/, *.egg-info/, packages/*/build/ (left by building the package). The wheel builds (uv build: cv_workflow plus output.schema.json), checked once, not kept.
- Docs: docs/tech-stack.md (Verification and CI rows, setup line), AGENTS.md (packages/cv-workflow row, ruff check command, the dependency line), docs/engine/verification.md (CI steps, the -O refusal), packages/cv-workflow/README.md; Atlas github-ci role and system-map CI blurb.
<!-- SECTION:NOTES:END -->
