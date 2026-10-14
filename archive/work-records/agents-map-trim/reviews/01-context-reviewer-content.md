## Review round 1, lens A (context): context-reviewer, 2026-10-14

Snapshot: head 9e7e6e1, base 2626907. Lens A: nothing lost, one owner per rule.

Verdict: FINDINGS. Recorded in substance.

Checked: the base AGENTS.md sentence by sentence against its stated owner. Present with equal or stronger wording: roles, orientation, improving the process, author checks (`docs/development.md`); the private repository, `Alias`-only commit messages, never edit another session's worktree (`docs/git-workflow.md`); local profile ("never copy") and approve/`--test-only` (`docs/preferences.md`); the owner's go for the `Release`; the "what he decides" and "explicit go" lists unchanged; Output Contract stamping, Framework boundary and colour-literal rules, glossary rules, `form-NN.gs`, `typst/cv.typ`, Atlas never edited by hand, idea-run "the owner decides", fixes approved by ID; `scripts/build.ps1:33` refuses `-HideVesselDurations` with `-Release`; LF; no client.

Material
1. `AGENTS.md:12-13`, `CLAUDE.md:11-13`: the six rules that never change no longer reach every agent; the only trigger is "before anything irreversible", which editing a layout, template or output-writing script is not; `CLAUDE.md:11-13` still promises AGENTS.md holds "what is frozen ... and the rules that never change". Fix: one line naming the six by title with the constitution as owner, or widen the trigger; reword CLAUDE.md to match.
2. `.claude/repo-maintenance.md:107` "any new folder or agent must be added there" contradicts the map no longer listing agents (`AGENTS.md:84-86`). Fix: top-level folders only; agents and skills are found in their folders.

Minor
3. `docs/development.md:216-221` "Author checks" reads as if review follows code changes only; the base said every change, docs included. Fix the bridge sentence.
4. `AGENTS.md:39` says the `studio/` folders each have a README; `studio/archive/` has none.

Notes
5. "A bypass is a lesson, not a fault" appears nowhere now (tone).
6. `.codex/README.md:63` "remain in AGENTS.md": true as pointers; acceptable.
7. The `docs/history.md` claim "Nothing was dropped" holds apart from finding 1.

## Dispositions (lead)

- 1: fix (one line naming the six rules by title, the constitution owning them; CLAUDE.md reworded). 2, 3, 4: fix. 5: restore the sentence in `docs/framework-gaps.md`'s intro or the development.md author checks where the bypass rule now lives. 6, 7: accepted.
