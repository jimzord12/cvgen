## Context review, round 2: docs/polish-at-deliver (57fed39..760fb01)

All paths are under `C:\Github\cvgen\.worktrees\polish-at-deliver\`. The verdict is FINDINGS: all five round-1 findings are fixed, but this round adds one new Material finding.

### Round-1 findings: all fixed

- **M1, fixed.** `docs/workflow/GAPS.md:64` now cites `06-deliver/stage.yaml:311-317`, and `cmd.page-png` sits on exactly those lines.
- **M2, fixed.** `06-deliver/README.md:82-83` adds name, `Rank` and specialty to the design list. Lines 94-100 add the collision and bad-break test, the 300 dpi check on the changed area, and the rule that a `Revision` failing the check is not reported to him.
- **M3, fixed.** `06-deliver/README.md:89-91` says the brief names his change, nothing reverses or dilutes it, and a finding against it goes to him. `05-design/README.md:107-111` says the same briefly and points to the deliver README.
- **m1, fixed.** The `lead.fix-inputs` `does` is cut to the trigger plus a pointer, and the generated table and the Atlas match it.
- **m2, fixed.** The lines are rewrapped.

### Material

**M1. Neither judge's profile has a place for "his change".** `docs/workflow/06-deliver/README.md:89-90`
- **What is wrong:** the README says "The brief to both judges names his change". But the agents that receive the brief list what it holds, and the owner's change is not on either list:
  - `.claude/agents/codex-visual-reviewer.md:19-27` ("What you receive") and step 5, `:72-79`, build the Codex prompt from a closed list: `Domain`, specialty, `Rank`, rubric variant, image captions, round, `Polish Round` flag, earlier reports.
  - `.claude/agents/design-reviewer.md:38-43` has no such item either.
  - `docs/workflow/05-design/README.md:57-60`, the brief's own list, does not name it. Line 118 says "briefs carry the `Alias`, the `Domain`, specialty and `Rank` only".
- **Why it matters:** a fresh Codex wrapper drops what its list does not name. Codex then cannot tell his change from a flaw, and may raise a Blocking finding or an "Even better" proposal against it. The lead ends up sorting the conflict by hand on every round.
- **Smallest fix:** add one clause to each list: "at a re-review from deliver, the owner's change, named so it is not proposed away". Add it to codex-visual-reviewer "What you receive" and step 5, and to design-reviewer "What you receive". Also add "and, back from deliver, his change" to the brief list at `05-design/README.md:57-60`.

### Minor

**m1. The skill's words-only path skips the new check.** `.claude/skills/new-cv/SKILL.md:95-96`
- **What is wrong:** it says a words-only change "goes straight to `deliver.render`". The checklist then runs only the 96 dpi `deliver.page-png` (`:83-85`). The 300 dpi check and the route for a `Revision` that fails it live only behind the pointer.
- **Why it matters:** an agent following the checklist step by step reads "straight" as "no extra check".
- **Fix:** "goes to `deliver.render`, then the 300 dpi check on the changed area; a failure goes back to the design review (the deliver README, "Branches")".

### Notes

- **Clearing the crops.** The 300 dpi crops of the changed area are a real `Client`'s pages in `builds/`. The clear-by-path rule at `06-deliver/README.md:31-34` names "page PNGs and any preview", which covers them in spirit. One word ("and crops") would make it literal.
- **An anchor that was already stale.** `GAPS.md:74` moving from 485-490 to 494-499 fixes an anchor that was stale before this branch: at 57fed39 it landed on `art.engine-review-report`. The fix is correct and in scope.
- **`vision.md:64-67` and `preferences.md:20-22`.** The vision bullet keeps his words exactly, and preferences now points to it. That settles round 1's triplication note for preferences; `05-design/README.md:24-27` still restates it, which is acceptable.

### Checked and fine

- **Source anchors:** `05-design/README.md:107-111`, the known EDITED anchor, is accurate: its text still states the fact. So are the deliver README `74-100`, `new-cv` `77-104`, `93-97`, `98-101`, `102-103` and `104`, and preferences `62-64`, `80-82`, `88-96`, `88-100` and `94-96`, including the Atlas copies.
- **Terms:** `Polish Round`, `Rank` and `Revision` match `docs/glossary.md`.
- **Records:** no ADR, history entry or old review report was edited. The round-1 report was only added.
- **Line endings:** LF in all 16 files, with no CRLF bytes.
- **Line lengths:** the new prose is wrapped like the text around it.
- **Privacy:** no client is named, and no `Alias` appears.
- **Fresh round cap:** "counted afresh" does not conflict with "When to stop" in the 05-design README.

Verdict: FINDINGS

**Next:** the writer adds the owner's change to both judges' intake lists and the 05-design brief list (M1), optionally fixes m1, and sends round 3.
