Round 1 review of 0ea5f6f against main (656f336). I checked three files, all LF only (0 CRLF): `docs/preferences.md`, `docs/proposals/template-contract.md` and the TASK-67 file. No client names appear anywhere in the diff.

Before reading the diff I wrote down what the feedback should change:
- Essential means "one practical page" and is the operator's choice, not tied to rank or job tier.
- The photo is optional.
- A long career shows recent contracts in full and summarises the older ones with totals. It never runs to a second page.
- An agent may delete files that Git holds. Files Git does not hold go on a list for the owner to approve.
- Branches and worktrees may be deleted once checked that they are merged and hold no important work.
- None of this should loosen the owner's control over `private/`, `.local/`, `Release` PDFs, `Frozen Reference`s or `archive/*`.

## Blocking

**B1. `docs/preferences.md:57-58`: the table now contradicts the agents' bullet and the "explicit go" list.**
- **What broke:** the old Critical row said "any deletion … the agents' bullet does not name". The new row says "any deletion of a file or folder Git does not hold". So clearing `builds/` (ignored, listed as routine at :76), `git worktree remove` and "removing what the same run made" have become Critical, which reverses a standing rule.
- **The opposite problem:** Major now covers "deleting a file or folder Git holds". `private/` is a Git repository and the `Release` PDFs are committed, so both match Major and also Critical (:90-96). Nothing says which wins. :92-93 even gives the same reason the owner gave ("history can restore them"), so a reader could take the newer dated rule as overriding it.
- **Lost safeguard:** "ref" was dropped. Deleting an unmerged branch that is not abandoned is now in no grade at all; before, it was Critical.
- **Smallest fix:** Major should read "…deleting a file or folder committed to this repository's Git during approved work, except what Critical names (owner, 2026-11-08)". Critical should read "…and any other deletion of a file, folder or ref that neither Major nor the agents' bullet names; for files Git does not hold, the agent lists them for him to approve."

## Material

**M1. `docs/preferences.md:75`: the branch rule contradicts itself and is narrower than what the owner said.** An abandoned branch by definition holds unmerged work, so "abandoned branches … once checked that they hold no unmerged work" means none can ever be deleted. The owner said "merged and contain no work that is important". Fix: "deleting branches locally and on GitHub once checked that they are merged or hold no unmerged work that matters".

**M2. `docs/preferences.md:76`: the worktree rule invents one condition and misses the one the owner set.** The note "a worktree's ignored evidence moved to the main `builds/` first" comes from no feedback, and no other file states it. If it is wanted, it belongs in `docs/git-workflow.md:43-51`, which covers worktrees. Meanwhile the owner's condition for worktrees (merged, no important work, so no uncommitted changes) is not captured. Fix: "remove and prune once its branch is merged and it holds no uncommitted work". Drop the evidence clause, or move it to git-workflow.md.

**M3. `docs/vision.md:64-65` was not changed and still ties the `scan-first` bar to a kind of job:** "For ordinary jobs, a `Client` may choose one clear page…". Any agent designing or reviewing Essential reads this file first, so it will keep scoping Essential by job tier. The owner's 2026-11-08 answer is his decision on exactly this point. Fix: amend it with his dated words ("When a `Client` needs a practical one-page CV, the operator may choose one clear page…, owner 2026-11-08"). If the writer holds that `vision.md` wording needs a separate go, carry it to the owner.

## Minor

**m1. TASK-67 description (line 16) dropped "First check what crewing offices expect".** Making the portrait optional settles only the portrait. P-0019 §9 (`template-contract.md:287-288`) still says the design starts with a crewing-practice check. Keep the check and drop only "the portrait above all".

**m2. `docs/preferences.md:57-58, 75-76` run well past the file's wrap width.** Rewrap the edited bullet lines.

**m3. `docs/git-workflow.md:80-81` still says branch deletion is an agent decision with no condition.** It now differs from :75. Add "once checked as in `preferences.md`", or leave git-workflow.md as a pointer only.

## Notes

- `backlog/docs/doc-1 - session-handoff.md:24-25` still lists these questions as waiting on the owner. Update it at session end.
- `template-contract.md:384-385`: older contracts are summarised "with totals". Those totals must be computed from the data, never from the displayed rows (constitution §6). A pointer in TASK-67 would stop the design task from getting this wrong.
- The decision entry itself is placed correctly: it is appended as a dated entry, which `docs/proposals/README.md` allows. `Rank` and `Client` are used the way the glossary defines them. ADR 0016 is untouched, which is correct.

Verdict: FINDINGS
