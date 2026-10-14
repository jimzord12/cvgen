## Review round 1 (context): context-reviewer, 2026-10-14

Snapshot: `.worktrees/task-32`, `f6aebb4..6a35729`. Lead lenses: one owner for the tree; the flat-workspace refusal matches the documented migration; Atlas citations; AGENTS.md tight.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Checked: the tree is stated once (`client-workflow.md` section 1); no live doc puts `cv.typ` at the root or lists `reviews/text-NN.md`; Output Contract homes (`pdf-workflow.md:128-129`) match `outputs.py:52,210`; `verification.md` matches `tests/workflow.py` 11b; `atlas check --strict` exit 0; no CRLF.

Material
1. `.atlas/src/site.json:55,56,307,381,436,455`: six actor citations into changed files are stale (`check --strict` does not cover site.json); the worst, `client-workflow.md:64-68`, now points into the tree. Fix: `client-workflow.md:363-365`, `87-91`, `115-152`, `105-113`, `new-client/SKILL.md:96-107`, `build-a-cv.md:112-207`.
2. `docs/glossary.md:47` vs `:49`: the `Envelope` row calls `typst/`, `images/portrait/` and `reviews/` drawers while the `Drawer` row and `client-workflow.md:34` limit drawers to `intake/`, `research/`, `draft/`. Fix: widen `Drawer` or say "folders".
3. `client-workflow.md:75-76` with `workspace.py:86-90`: the refusal only says move `cv.typ` and add `../`; following it leaves portrait, `presentation.json` and helpers at the root, breaking the three-files rule unflagged. Fix: state the full move (portrait to `images/portrait/` plus `identity.portrait`, data and helpers into `typst/`).

Minor
4. `client-workflow.md:34` "only three files at its root" vs the marine `reference.pdf` exception. Fix: name the exception.
5. `docs/preferences.md:64-66` still lists `cv.typ`, `presentation.json` as the files agents edit without asking. Fix: "the `typst/` sources and the portrait in `images/portrait/`".
6. `AGENTS.md:115` `private/` row restates 11 entries of the tree. Fix: pointer plus "`typst/cv.typ` entry point".

Notes
7. Merge risk with main's `docs/reference` -> `docs/engine` rename (candidate-schema.md, verification.md, build-a-cv.md:67-73 link): re-check links and citations after the merge.
8. Partial tree copies in `build-a-cv.md:12-20`, `new-cv/SKILL.md:19-27`, `pdf-workflow.md:71-81` point to section 1; acceptable.
9. Say in the tree that older Envelopes may hold `reviews/text-NN.md`, kept as is.
10. `docs/workflow/inventory/*` flat `cv.typ` mentions are dated records; correctly untouched.

## Dispositions (lead)

- 1-6: fix. 7: handled at the merge. 9: fix. 8, 10: accepted. Round 2 follows.
