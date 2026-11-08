## Round 1: constitution section 6 and the marine totals (commit 5c61ba8)

The change does what the owner approved. Nothing is Blocking or Material: one Minor wording point and two Notes.

**What I checked:**
- **Rule unchanged:** section 6 keeps all three parts: totals are computed once from the full candidate by the domain's rules, pages never recompute them, and calendar periods are never converted into service time. The ADR 0011 line is still true. Only the stale marine list was replaced by a pointer (`docs/constitution.md:76-77`).
- **Pointer:** it names the right file. `docs/engine/domains-and-roles.md` is where the manual says the domain owns `experience-totals`. The new text continues that paragraph rather than sitting beside it as a separate block.
- **Matches the code:** the manual's list agrees with `experience-totals` in `packages/domains/marine/data.typ:35-49`:
  - `months` for a record kept in months, or `contracts` (one per row) for one kept in `Contract Period`s, never both;
  - then the distinct `vessels` and distinct `companies`.
- **Glossary:** `Contract Period` is used as `docs/glossary.md:42` defines it, in backticks.
- **No contradictions:** nothing in `docs/`, `.claude/`, `.codex/`, `AGENTS.md`, `.atlas/` or `studio/` still has the old "service months, vessel counts and company counts" list. The remaining "service months" hits are the months-recording rule or the TASK-3 gap record, and none contradicts the new text.
  - Nearby statements agree with the manual: `docs/engine/candidate-schema.md:66-68` ("the synopsis counts contracts, vessels and companies") and `docs/architecture.md:201-205`.
  - `AGENTS.md:14` ("the totals rule") and the agent profiles ("month totals from data") need no change.
- **Hygiene:**
  - Only the two files the feedback reaches were touched.
  - Both files have LF line endings (0 CRLF, counted with Python).
  - The text is English, and no client is named.

## Findings

**Minor**
- `docs/engine/domains-and-roles.md:77-78`: "the vessel count" can be confused with the code function `vessel-count` (`data.typ:134`), which counts rows per company. `experience-totals` counts distinct vessel ids, so a vessel served on twice counts once. A reader following the pointer from the constitution may take the wrong meaning. Smallest fix: "then the number of distinct vessels (a vessel served on twice counts once) and of companies."

**Note**
- `docs/constitution.md:77`: the pointer is written `docs/engine/domains-and-roles.md`, while some references in the same file are relative to `docs/` (`conventions.md`, `git-workflow.md`, `decisions/...`). The file already mixes both styles (line 112 has `docs/framework-gaps.md`), so this is not drift. No change needed.
- `docs/engine/domains-and-roles.md:23-25`, outside the diff: "ships with rank and months, and totals" predates `Contract Period`s and is slightly out of date. The feedback does not reach it; it could go with a later engine-docs pass.

No earlier rounds.

Verdict: PASS
