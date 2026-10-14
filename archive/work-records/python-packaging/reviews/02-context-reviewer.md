## Review round 2 (context round 1): context-reviewer, 2026-10-14

Snapshot: `.worktrees/task-47` at 00f16cc. Lead lenses: one owner per fact, every install line points at the lock, ruff named where agents check before pushing; AGENTS.md growth justified, Atlas citations right.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Material
1. `.claude/skills/verify-cv/SKILL.md:14` and `:39` stale: line 14 lists packages; line 39 says `pip install "jsonschema>=4"` (copying `packages/cv-workflow/cv_workflow/validate.py:69`'s message). Fix: point to the lock and `docs/tech-stack.md`; change the code message the same way.
2. `README.md:79` "Needs Python with `pymupdf`, `pillow` and `jsonschema`". Fix: Python 3.11 and `pip install -r requirements.lock` (`docs/tech-stack.md`).
3. Nothing tells agents to run `ruff check` before pushing; the AGENTS.md working-agreement bullet and verify-cv's Run block list only the suite, and `docs/git-workflow.md:90-91` says CI cannot prevent the first publication. Fix: add `ruff check` to verify-cv's Run block; optionally to the AGENTS.md bullet.

Minor
4. `docs/guides/build-a-cv.md:137` names no setup step. Fix: "...the packages in `requirements.lock`, like the test suite."

Notes
5. `AGENTS.md:139` repeats the install command tech-stack owns; "(setup: `docs/tech-stack.md`)" would only point. The map row and the `ruff check` line belong in AGENTS.md.
6. A venv is optional; "(a venv keeps it separate)" in tech-stack.md is optional.
7. `handoff.md:305` and the TASK-47 description are dated records.

Checked and correct: lock pins agree with tech-stack and pyproject; ruff scope matches AGENTS.md and verify.yml; the `-O` refusal is real (`tests/run.py:152`); site.json role and the system-map blurb match verify.yml; `atlas check --strict` exit 0; LF; no client data.

## Dispositions (lead)

- 1-4: fix (README case count too). 5: point instead of restating. 6: add the one venv clause. 7: accepted.
