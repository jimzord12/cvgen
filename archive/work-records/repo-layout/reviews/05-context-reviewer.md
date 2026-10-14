## Review round 3 (context): context-reviewer, 2026-10-14

Snapshot: `414a38e..8bbda11`. Lenses: 1 M1 and the rewraps; 2 the moved anchors.

Verdict: FINDINGS. Recorded in substance.

Clean: M1 fixed (`new-cv/SKILL.md:65-69` `layout: flagship-layouts.one-page(candidate)`, matching the guide and deck-cadet); rewraps clean (`.toml` parses with `tomllib`, two-space indent inside `developer_instructions`); 16 repointed anchors sampled, each covers the same passage; Atlas citations hold; `bun run check` and `atlas check --strict` pass; LF; no client.

Material
- M1 `docs/workflow/05-design/stage.yaml:150` (`design.entry-point`) and `:572` (`lead.write-flagship-entry`) still cite `new-cv/SKILL.md:54-67`, which now stops before the `layout:` line; `--fix` moves shifted spans but does not widen spans containing the edit. Fix: `54-69`.
- M2 stage-level sources at `05-design/stage.yaml:4` cite `8-95`, cutting step 3's "Replace the example wording" sentence. Fix: `8-97`.

Notes
- `design-run.json:111` `88-211` ends mid-sentence as the old `88-210` did; `88-213` closes it. Optional.
- `docs/workflow/inventory/b-stages-5-7.md` is a dated snapshot; left alone correctly.

## Dispositions (lead)

- M1, M2: fixed (54-69 twice, 8-97). Note 1: applied (88-213). Lesson for the lead: an EDITED span from `bun run anchors` must be widened by hand when the edit added lines inside it.
