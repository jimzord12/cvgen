# Context review round 1: 9a99476..4aea8d1

Principle I set down before reading the diff: design is the product. Every CV design has to be unskippable in a batch and has to show its domain, specialty and job at a glance. It goes beyond "safe" but stays elegant, at the Flagship's level. This covers CV design, review and proposal work. It does not turn logos or the `Text Draft` into CV tests, and it does not make Japan a global rule. On top of that: the three-by-three editor run, Codex recorded as approved but not built, and the context pair wired in as a gate. The principle was captured: vision.md owns it and the profiles restate it briefly with a pointer. I did not re-raise anything from the earlier dispositions except F5 below. All 19 files use LF with a final newline. No real client is identified anywhere in the diff.

## Material

**F1 The second gate is attached to review.md but not built into it.** Anchors: `docs/review.md:184`, `:71-76`, `:163-168`, `:214-216`; `AGENTS.md:31`, `:156`; `docs/development.md:21`, `:118`.
- **What is wrong:** review.md's loop step 1 still says "requests one fresh `code-reviewer`". Its brief (two lead lenses), its severity table (Blocking = data loss) and its report shape (eight-lens coverage) conflict with context-reviewer.md, which has its own severities and report shape and no lenses.
- **Stale pointers:** AGENTS.md:31 calls review.md "the independent `code-reviewer` gate". AGENTS.md:156 says "the `code-reviewer` subagent follows it". development.md's Review stage still names only the `code-reviewer`.
- **Why it matters:** a lead running a docs-only change cannot tell which rules govern the brief, the severities or the report.
- **Smallest fix:**
  - Add one sentence to review.md: the `context-reviewer` follows this file's timing, loop, caps and storage, but applies its own checks, severities and report shape instead of the lenses.
  - Make line 184 read "the fresh reviewer".
  - Name both reviewers in AGENTS.md:31 and :156 and in development.md:21 and :118.

**F2 "role" now means two things, and "specialty" is a synonym for the official term `Role`.** Anchors: `AGENTS.md:9` vs `:17`; `docs/glossary.md:40-41` vs `:74`; `docs/vision.md:48-50`; `design-reviewer.md:74,132`; `magazine-editor.md:34,82,160`; `idea-run/SKILL.md:37-38`; `new-cv/SKILL.md:58,64`; `client-workflow.md:273`.
- **What is wrong:** the glossary defines `Role` as Deck or Engine and `Rank` as the job title. The `Three-Second Test` example ("marine, engine room, second engineer") uses "specialty" for `Role` and "role" for `Rank`. AGENTS.md uses "role" both ways, seven lines apart. Glossary rule 1 forbids this.
- **Why it matters:** a lead may brief with `Role` = Engine and leave the job title out, which is the element the test most needs.
- **Smallest fix:** write "`Domain`, specialty and `Rank`". Define specialty once in the `Three-Second Test` glossary row: the `Role` where the domain has one, otherwise a focus such as a destination.

## Minor

**F3 `docs/vision.md:38-70`.** The new section splits "What this is": the paragraph at :67 ("The person editing a CV changes data…") now sits under "Design is the product". Fix: move the section below :70.

**F4 `magazine-editor.md:97-104`.** "timeline dots on a line" was dropped from the cliché list (it was line 49 at 9a99476). The design the owner rejected was exactly that device: "a thin rail line with section dots". Fix: restore it.

**F5 `docs/guides/build-a-cv.md:200-270` is not updated.** The skill says "Follow build-a-cv.md", and the maintainer's table names that guide as the owner for real CVs. Yet the client-design loop exists only in new-cv, and section 8 ("Rules for this path") is silent about it. I disagree with round 1 on this, because it pointed only at the checklist. Fix: add one rule line in section 8 that points to the loop.

**F6 `sample.json` is missing from the folder descriptions.** magazine-editor.md:117 adds a `sample.json` to the style folder, but the folder contents listed at `design-concepts/README.md:8-13` and `AGENTS.md:100` omit it. Fix: add a clause to both.

## Notes

- **N1 `docs/proposals/codex-visual-tools.md`:**
  - :96-98 says "the brief carries the `Alias` only", but the page images sent to OpenAI are the real CV, with name and portrait. Say that plainly.
  - The "Docs to update" list (:85-89) misses the lines that say Codex gives no review verdict: `AGENTS.md:32`, `CLAUDE.md:6`, `review.md:17-18` and `development.md:8`. They will contradict the design verdict once it is built.
- **N2** Three words for one example job: "tour guide" (glossary `Rank`, `client-workflow.md:263`), "tour leader" (vision, profiles) and "tour escort" (the test). The research note treats guide and escort as distinct. Pick one.
- **N3** `magazine-editor.md:64-65` says Stylish is "the tier a client CV is most often built from". That is a prediction, not the owner's words.

Verdict: FINDINGS

## Dispositions (lead, 2026-09-29)

Not applied yet: the owner asked to stop once the running agents returned.
All findings stay open for the next session (handoff card). This review ran
as a general-purpose stand-in acting exactly as
`.claude/agents/context-reviewer.md` (the agent is new and loads only in a
fresh session), with that file's tools as its limit.
