Context review, round 1: report figures are numbered, not lettered (fix/report-figure-numbers, 0dc93e7..b90678d, docs/ and studio/brand/report/README.md)

The change is sound: no Blocking or Material findings, two Minor ones.

What I expected before opening the diff: any picture an agent names for the owner gets a number in reading order ("Figure 1"), never a letter. That covers the `Report Template`, chat summaries, and documents such as idea-run reports. It should not reach other lettered things, such as decision options, review IDs or catalogue codes.

**What checks out**
- **Placement.** The rule sits in the file that owns owner communication, `docs/preferences.md` ("Reports", "Every picture where it is needed"). The existing bullet was amended rather than a new paragraph added beside it. `studio/brand/report/README.md` owns the field format, and its `evidence` row and placement paragraph now match `scripts/report.py`. I checked that the 1 to 999 range, the `"1"`-or-`1` equivalence and the refusal wording all match the script.
- **No stale teaching.** I searched `.claude/skills/`, `.claude/agents/`, `.codex/`, `docs/` (including `docs/engine/verification.md`, whose step 19 says "malformed" and is still accurate), `AGENTS.md` and `CLAUDE.md`. Nothing else teaches lettered figures. "Figure A" still appears only in dated records: the closed task-82 in `backlog/tasks/`, and the review reports and run notes under `archive/work-records/`. Those correctly stay as they are.
- **Terms.** No new term is needed. `Report Template` is already in the glossary and is unchanged.
- **Hygiene.** No unrelated docs edits. Both files are still LF only (0 CRLF bytes). Everything is in English, and no real client is named or identifiable.

**Minor**

1. `C:\Github\cvgen\.worktrees\report-figure-numbers\docs\preferences.md:115-117`: the rule is scoped a little narrower than the feedback.
   - **What is wrong:** the numbering sits inside the clause "a picture several sections share has a short name … : a number". The owner said "use number for the figures": all figures. The template also labels a picture shown in only one card (the "Figure 2" label). Other reports, such as the idea-run report he was reading, name pictures that are not shared.
   - **Why it matters:** an agent writing a document by hand could read the number rule as covering shared pictures only.
   - **Smallest fix:** split the clauses, e.g. "…and a picture several sections share has a short name that each one cites. A picture's name is a number ("Figure 1"), never a letter, because numbers are easier for him."

2. `C:\Github\cvgen\.worktrees\report-figure-numbers\studio\brand\report\README.md:38`: "(owner, 2026-11-08: numbers are easier than letters)" repeats the reason that `docs/preferences.md` owns.
   - **Why it matters:** it makes an already very long table cell longer. The README's opening paragraph (lines 3-7) already credits the owner's 2026-11-08 rule and points to `docs/preferences.md`, "Reports".
   - **Smallest fix:** keep "number them in reading order" and drop the parenthetical. Leaving it in is defensible, since it is short and correct.

**Note**
- "number them in reading order" is guidance the script does not enforce, which is fine. On this page, reading order is the order of the cards and decisions that cite the pictures, not the order of the `evidence` array, and the sample happens to agree. If you want no ambiguity, say "in the order the page first cites them". I am not asking for this change.

Verdict: PASS

**Next:** the writer chooses whether to apply the two Minor fixes; the change can merge either way.
