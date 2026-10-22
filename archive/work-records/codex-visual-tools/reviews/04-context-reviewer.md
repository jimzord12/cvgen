## Context review round 3, TASK-4 (codex-visual-tools): ec5ceab (fixes f456863..ec5ceab, whole change 38da34d..ec5ceab)

**What I expected before opening the diff:** a client CV built on the Flagship should get the same "faithful to its concept" reading as a client CV built from a concept page, with the Flagship standing in as the concept. That reading should leave Flagship changes, concept pages and non-marine `Domain`s unchanged. It also has to say what happens when a failure belongs to the frozen Flagship and not to the client's page.

**Round-2 dispositions:** m1, m2 and N2 are fixed as stated. The Atlas `calledBy` and the anchors `47-144` / `72-144` are right after the one-line insert. m3 is fixed except for one line, below. N1 is applied. Every changed file is LF, ends with a newline and has no BOM. No client identity appears anywhere in the diff.

**The new clause:** it is in scope, because the codex-visual-reviewer has to name a rubric variant and Flagship clients had none. It is also correctly placed. The rubric's owner (`design-reviewer.md`) carries it, the TOML mirrors it word for word, and `codex-visual-reviewer.md:24-26` restates it briefly and defers to the owner ("the rubric variants are those the design-reviewer defines"). It does not reach Flagship changes, concept pages or other `Domain`s. It also fits owner decision #4 of P-0017 ("Template-built CVs too, since every one must pass the `Batch Test`").

### Material

- **M1. The clause leaves out the case the walk that prompted it found.** `.claude/agents/design-reviewer.md:74-80` (and `.codex/agents/design-reviewer.toml:104-110`). Under the concept reading, criteria 1 to 3 are judged as for any client CV. The third walk (`evidence/README.md:27-31`; raw reply `builds/task-4-codex-review-input-20261022-125307/codex-01.md`) returned Blocking on the `Three-Second Test` for page 2. Codex said the frozen Flagship has the same limit and proposed a design change as the fix.
  - **Why it matters:** on the next Flagship client, the lead gets a Blocking finding that no client-side fix may clear. Changing the page means deviating from the frozen Template, which is a Flagship change under constitution §1 with its own review. So the lead either deviates or spins to `design.cap-reached` (5 or 10 rounds). Both reviewers can raise this, because the clause now governs the design-reviewer too. The dispositions record the walk's result but do not address it.
  - **Smallest fix:** one sentence in the same clause saying how a failure the frozen Flagship's own page shares is handled. For example: report it, but as a candidate Flagship change raised to the owner, not a client-round fix. This sentence decides what "pass" means for every Flagship client under decision #4, so put the reading to the owner under 🔔 at hand-back rather than choosing it silently.

### Minor

- **m1. The evidence overstates which profile the third walk used.** `evidence/README.md:24-25` says the walk ran "on the final profile". Its copied rubric (`codex-prompt-01.md`) has no Flagship-as-concept parenthetical, and its brief asked for "the Flagship-change reading", the opposite of what landed. The dispositions themselves say the clause was added *after* the walk. Smallest fix: write "on the profile before the Flagship-client clause, with a Flagship-change brief".
- **m2. The mirror copies are worded differently.** `.claude/agents/design-reviewer.md:112` says "a Codex-generated image" and `.codex/agents/design-reviewer.toml:142` says "a generated image". This dates from round 1 but is part of the whole change. Align the two, or note the difference as deliberate if the Codex copy drops "Codex" on purpose.
- **m3. One line is still over-long.** `.claude/agents/magazine-editor.md:181` is 82 characters. The m3 rewrap moved the overflow down a line instead of removing it.

### Notes

- **N1.** `design-reviewer.md:39-40`, "What you receive", still says "a client CV's preview PDFs with the concept it was built from". The rubric clause covers the Flagship case well enough; optionally add "(the Flagship, for a Flagship client)".
- **N2.** The clause also changes how the design-reviewer judges Flagship clients, not only Codex. It is a small step past "Codex for CV runs", but it closes a gap that existed before TASK-4, so I am not raising it as an unrelated edit.
- **N3.** The ChatGPT training-data setting is still a hand-back item for the owner (round-2 N4).

Verdict: FINDINGS
