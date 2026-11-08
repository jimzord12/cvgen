**Context review, round 2: docs/polish-rounds, 09aa035..1e4592f (fixes 6d30ed4..1e4592f)**

Verdict: PASS. Every round-1 finding is fixed and nothing Blocking or Material is left. There are two small Minor findings and two Notes.

**Principle (set before opening the diff).** Finish is not taste. A seamless join between header and body and premium artwork are blocking for every CV design in any `Domain`, and both judges catch them without the owner asking. Two polish rounds follow each pass. A before/after pair calibrates the bar. The rule must not leak into non-CV work, must not turn into perfectionism on taste, and must not hold up delivery.

**Round-1 findings: all fixed**
- **Material, Codex crops.** Fixed. `codex-visual-reviewer.md:39-45` now has Codex crop every page itself at 300 dpi: the header wherever it sits, every section transition and every artwork, plus any region the lead names. It never judges them itself. Line 28 now treats lead-named regions as optional, and no stale "beyond page 1" or "top 40%" text is left in live files. This also covers the sidebar-layout Note.
- **Retries per round.** Fixed. `idea-run/SKILL.md:90-95` caps them at two per `Polish Round`, then falls back to the last passing snapshot. A design is never sent `unresolved` because of polish.
- **Step 7 pointer.** Fixed at `idea-run/SKILL.md:87-89`.
- **new-cv ordering.** Fixed at `new-cv/SKILL.md:67-71`: the cap now reads "before any pass".
- **Template path.** Fixed at `new-cv/SKILL.md:71-73`: only entry-point and data changes, and the rest is listed in `README.md`.
- **`art.run-message`.** Fixed at `05-design/stage.yaml:314`. It matches `idea-run/SKILL.md:163-164` and `design-run.json:278`.
- **150 dpi.** Fixed at `reference-pairs/README.md:18-20`.
- **AGENTS.md wording.** Fixed at `AGENTS.md:43`.
- **Notes.**
  - Token cost: fixed. Codex now gets the latest three pairs by default (`codex-visual-reviewer.md:55-58`). The design-reviewer can still open them all, which is reasonable.
  - Zoom scope: fixed. It now reads "(CV pages)" in both `design-reviewer.md` and its `.toml` mirror.

**Checks**
- The `.codex` mirrors carry the new text. The only differences are the usual Codex adaptations.
- The stage.yaml anchors I spot-checked (`idea-run` 78-102, 144-153, 161-164, 171-176; `new-cv` 63-74, 75) match the current lines.
- LF only: 0 CRLF in every touched text file.
- No unrelated files. The round-1 report is stored, not edited.
- The fictional Nikos Kontos is the only name that appears.

**Minor**
- `.claude/skills/idea-run/SKILL.md:92-93`
  - "`run.md` lists the change it declined": the author did not decline the change; the design reverted it.
  - It is also unclear whether polish round 2 still runs after round 1 falls back.
  - A cold lead could read it either way. Fix: "...returns to its last passing snapshot, `run.md` lists the change taken back, and the next `Polish Round` (if any) starts from there."
- `.claude/skills/new-cv/SKILL.md:71`
  - "On a `Template` (the Flagship path)" ties the rule to marine, but `Hanami` is also a `Template` (`docs/glossary.md:43`; `gate.template-exists` names both).
  - The parenthetical narrows a rule that holds for any `Template`. Fix: drop "(the Flagship path)", or write "(the Flagship or Hanami)".

**Notes**
- `.atlas/src/pages/design-run.json:236` says "fresh judges must pass each round" but leaves out the two-retry fallback. That is acceptable for a picture book, but a reader could infer that polish can block delivery. One added clause would close it.
- The limit to entry-point and data changes lives only in the `new-cv` checklist. `docs/workflow/05-design/README.md`, which `new-cv:16-18` says owns the judgement, does not state it. That is acceptable for one sentence, but if it grows, move it there.

Files:
- `C:\Github\cvgen\.worktrees\polish-rounds\.claude\skills\idea-run\SKILL.md`
- `C:\Github\cvgen\.worktrees\polish-rounds\.claude\skills\new-cv\SKILL.md`
- `C:\Github\cvgen\.worktrees\polish-rounds\.claude\agents\codex-visual-reviewer.md`
- `C:\Github\cvgen\.worktrees\polish-rounds\.atlas\src\pages\design-run.json`

Verdict: PASS

**Next:** you decide whether to fix the two Minor findings before merging; neither one blocks the merge.
