## Review round 1 (context): context-reviewer, 2026-10-14

Snapshot: `refactor/task-58-legacy-delete` at e92c619 against merge-base 70631ed. Lead lenses: nothing live still says the legacy layer exists; AGENTS.md shorter, Atlas citations right.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Material
- M1: `docs/vision.md:137-138` roadmap item 4 still says "the old signatures stay as deprecated wrappers (`docs/framework-gaps.md`)", present tense, pointing at a now-closed gap entry. Fix: "...stayed as deprecated wrappers until their removal on 2026-10-14 (TASK-58)."

Minor
- m1: `docs/guides/build-a-cv.md:290` pointer "(section 8)" should name the subsection "Migrating a composition written before 2026-09-25" (70631ed is on origin/main; the table is there).

Notes
- Lens 1 holds apart from M1: the accepted gap (`cc.document-shell` ignores old layout keys) is stated in `build-a-cv.md:292-296` and `layout-and-pagination.md:68-70`; code backs every changed-doc claim (title/author check, two `retired-keys` cases, 31 contract components, `check-layout` in `flagship.typ`); no live doc shows an old positional call except the deliberate "old form" example (`build-a-cv.md:285`).
- `docs/framework-gaps.md:49` follows the file's close convention; a merge hash would match its template exactly.
- `docs/history.md` entry appended; earlier entries untouched.
- AGENTS.md is three lines shorter; no new term; `atlas check --strict` exit 0; citations sit above the edits; site.json cites whole files.
- LF; no client identity.
- `packages/domains/marine/lib.typ:2` comment ("under the flat names...") is code; for the code round.

## Dispositions (lead)

- M1, m1: fixed by the lead. framework-gaps: keep "TASK-58" (the merge hash does not exist before the merge). lib.typ comment: fixed (no longer mentions flat names).
