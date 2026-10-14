**Context review, round 2: Atlas** (general-purpose stand-in acting as `context-reviewer`, Opus at high effort; I treated its tools line as a hard limit)

**Verdict: PASS.** There are no Blocking or Material findings. I found 3 Minor findings and some Notes.

**Snapshot:** `feat/atlas` HEAD 5c4c825 against base b83795e (origin/main has not moved). The working tree has one uncommitted change: `.atlas/atlas.data.js`, where only the build stamp changed (builtAt, commit 7aabd70 → 71ae9f7). It is generated, so I did not review it.

**What I ran:**
- A script that resolved all 167 citations, including every `git:` citation (both branch refs match origin) and printed each cited range. Every one exists and none runs past the end of its file. I then read every range against the claim it backs.
- `atlas.py check --root .`: all 5 pages are UNVERIFIED (no lock file yet).
- A line-ending check on every touched file: LF only.
- A privacy grep over `src/`, the README and `atlas.data.js`.
- I did not read `private/`, `.local/` or Trello.

## Round 1 findings: resolved?
- **M1 (`Density` shown as current): resolved.** The 36–37 run-branch citations resolve and say what is claimed. I sampled `magazine-editor.md:50-82, 88-209, 211-219`, `idea-run/SKILL.md:36-49, 66-71, 114-134`, `design-concepts/README.md:44-47`, `new-cv/SKILL.md:62-85, 104-114` and `client-workflow.md:285-318`. The design-run summary, the magazine-editor note and the `Density` term all say the change reaches `main` with the run. One leftover is Minor 1 below.
- **M2 (`context-reviewer` routing): resolved.**
  - The review step (`change-review.json:130`) and `tldr[1]` now say `main`'s gate is `code-reviewer`.
  - The branch file says the routing (`git:docs/codex-visual-tools:docs/review.md:12,79`).
  - The stand-in is confirmed at `docs/work/anti-examples/reviews/01-context.md:36`.
- **Round 1 Minors 1, 2 and 5–7: resolved.** The status block matches `reviews/01.md:74` and `03-context-reviewer.md:39,44`.
- **Round 1 Minor 3: resolved in rule, scheduled in fact.** The Sweep line covers UNVERIFIED, but no lock file is committed yet. See the Notes.
- **Round 1 Minor 4: fixed in `site.json` only.** The same claim survives elsewhere (Minor 2 below).
- **Round 1 Notes:** all applied.

## Minor
1. **`system-map.json` `n-concepts` (line 204):** "Every design run's Styles, Densities and Tiers" is shown as current.
   - On `main`, `design-concepts/README.md:3-12` says one-page mock-ups in three tiers, and only `2026-09-27-first-fitting` exists.
   - The node has no source of its own, so it is hashed against `main`'s `design-concepts/`.
   - Fix: say "Styles and Tiers (Densities from the 2026-09-29 run, on its branch)", or cite the branch README.
2. **`system-map.json` `n-ci` (line 349):** "The suite on every push to `main`" is wrong.
   - `.github/workflows/verify.yml:3-5` runs on every `push` and every `pull_request`.
   - Fix: copy the corrected wording from `site.json:468`.
3. **`change-review.json` status `note` (line 26):** "(my recommendation)" uses the session's own voice on a page that outlives the session.
   - Everywhere else the page calls the lead "Claude".
   - Fix: "(Claude's recommendation)".

## Notes
- **Sweep step:** `change-review` `close/sweep` `does` lists repo health but leaves out the new `Atlas` line (`development.md:90-92`), so the Atlas does not show its own sweep duty. The glossary `Session Sweep` row (`glossary.md:70`) also lists the places to look and has never included repo health or the `Atlas`.
- **`design-run` `draw.does[1]`:** "a portrait" is unconditional, but the branch file has it only when the idea needs one (`magazine-editor.md:149,171`).
- **`design-run` `decide.gate`:** "Not my style → `Anti-example`" drops "and wants it kept" (`idea-run/SKILL.md:133`).
- **`client-journey` `deliver`:** the branch source (`client-workflow.md:297`) has the "Delivered … Delete by" line written at `Export`, before sending. The page puts it after sending.
- **Codex entries:** `codex-reviewer` and `codex-image` present "both must pass", "two per page" and "no text" under "Approved by you". The branch review (`reviews/01.md` F5, open) says these are the lead's defaults, not the owner's decision.
- **`git:` citations:** they name local branches (`docs/idea-run-…`, `docs/codex-visual-tools`). In a fresh clone `check` would report them missing; `origin/<branch>` would be sturdier. When the run branch is deleted after its merge, all of them break, as the lead's disposition anticipates.
- **Status `ref`s:** both cite only "board: session-handoff". The repo records behind them (`git:…run.md`, `docs/work/travel-cv-01/reviews/01.md:39`) would make them checkable.
  - The set-aside decision ("On 2026-10-01 you set your pending decisions aside") is a session fact. The snapshot note's list of what was read does not mention it.
- **AGENTS.md row:** "`check` lists pages whose sources changed". It also lists UNVERIFIED pages.
- **Before integration:** stamp the pages and commit `atlas.lock.json`; otherwise the next `Session Sweep` fires straight away. Also commit or discard the stray `atlas.data.js` stamp change.

## Checks that passed
- **Privacy:** PASS. The client appears only as `client-2026-09-01`. There are no Greek or private names, and no `private/<name>` path.
- **Placement and terms:** OK.
  - The AGENTS.md row is in "Where things are".
  - The glossary `Atlas` row is well formed, says "Never the source of a rule" and marks the skill as "outside this repository".
  - The Sweep line fits its list.
- **Roster and system map against the repo:** they match. There are 7 agent files and 9 skills. Models, effort and tools match every agent file. The Codex claims (approved, not built, F1 `--ephemeral` and F2 `--ignore-user-config` open) match the branch.
- **Snapshot statements against run.md on the branch:** they match.
  - Three styles: Woodblock Road, Stamp Rally, Concourse.
  - Neither gate has run, the run is not integrated, and the cap is 10.
  - The "Line Diagram" quote is accurate.

Verdict: PASS
