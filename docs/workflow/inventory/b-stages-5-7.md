# Inventory B: client journey stages 5-7 (`design`, `deliver`, `after`)

Repo state read: `main` at `1e684eb`, 2026-10-04. Read-only pass; no `private/` folder exists in this checkout, so every
Envelope path below comes from docs and code, not from a real Envelope. Line anchors are `file:line` in the
repository. "(inferred)" marks what is not stated by a source but follows from it.

Placeholders: `<alias>` stands for the Envelope folder (`private/<alias>/`; docs write it as `<name>-<rank>` or
`<envelope>`, see conflict 12), `<revision>` for a revision id (`YYYYMMDD-HHMMSS-<6 hex>`, `workspace.py:37-38`),
`<run>` for an idea-run folder (`<date>-editor[-N]`), `<date>-<slug>` for a concept folder, `NN` for a two-digit round
or draft number.

Entry condition from stage 4 (inventory A): the client's `Sign-off` is saved (`private/<alias>/draft/sign-off-NN.png`,
the draft re-stamped `status=signed-off`; `.claude/skills/new-client/SKILL.md:65-69`).

---

## 1. Steps per stage

### Stage `design`

| ID | name | actor | action(s) | inputs | outputs | next / branches | anchor | notes |
|---|---|---|---|---|---|---|---|---|
| `design.handover` | Handover to new-cv | actor.lead | skill.new-cv | art.facts-md, art.draft-pdf, art.sign-off-png, art.envelope-json | (none) | -> `design.route` | docs/guides/client-workflow.md:278-283; .claude/skills/new-client/SKILL.md:69-76; .claude/skills/new-cv/SKILL.md:11-15; docs/guides/build-a-cv.md:6-8 | Facts from `intake/facts.md`, wording from the signed-off draft; never re-ask the client, never reword beyond fitting the page (new-cv:13-15). |
| `design.route` | Does the client's Domain have a Template? does the data fit it? | actor.lead | skill.new-cv | art.envelope-json (domain), art.facts-md | (none) | gate.domain-has-template: yes -> `design.workspace` (marine, Flagship); no -> `design.run-ask`. gate.template-fits: no -> custom composition in `design.entry-point` + `design.framework-gap` | .claude/skills/new-cv/SKILL.md:62-66, 81-85; docs/guides/client-workflow.md:280-295; .atlas/src/pages/client-journey.json:333-340 | Not a named step in any source; the branch is stated in prose (new-cv) and as an Atlas `branch` on `sign-off`. (inferred as a step) |
| `design.run-ask` | Owner/lead starts a design run for the client | actor.owner, actor.lead | skill.idea-run | art.envelope-json (Domain only), decisions (inferred: `research/decisions.md`) | (none) | -> `design.run-branch` | .claude/skills/new-cv/SKILL.md:62-66; .claude/skills/idea-run/SKILL.md:19-21; .atlas/src/pages/design-run.json:33-53 | idea-run cadence: "whenever ... a client needs a design" (idea-run:19-21). Atlas puts the request with the owner; new-cv makes it automatic for a Domain without a Template. |
| `design.run-branch` | Branch and run record | actor.lead | cmd.git-branch (routine Git, no exact command given) | (none) | art.run-md | -> `design.run-brief` | .claude/skills/idea-run/SKILL.md:32-35; .atlas/src/pages/design-run.json:54-66 | Branch `docs/idea-run-<date>-editor`, worktree if other work runs. |
| `design.run-brief` | Brief: Domain, specialty, role, Spacious page count, fictional data only | actor.lead | skill.idea-run | art.envelope-json (domain, rank only; inferred) | art.run-md (brief recorded) | -> `design.run-draw` | .claude/skills/idea-run/SKILL.md:36-49; .claude/skills/new-cv/SKILL.md:63-64; .atlas/src/pages/design-run.json:67-80 | "Client data never goes into a brief: a run for a client's design gets the steer and fictional data only" (idea-run:41-42). Same three facts + page count go to every design-reviewer. |
| `design.run-draw` | Draw 3 Styles x 2 Densities x 3 Design Tiers (18 designs) | actor.magazine-editor | agent.magazine-editor; cmd.outputs-stamp (`status=proposed`) | brief (inline) | art.concept-brief, art.concept-sample-json, art.concept-typ, art.concept-pdf, art.concept-png, art.concept-meta | -> `design.run-research-gate` | .claude/skills/idea-run/SKILL.md:14-17; .atlas/src/pages/design-run.json:87-115; .claude/agents/magazine-editor.md:3,21,136,192 | Never reads `private/`; fictional record "never modelled on a real client" (magazine-editor.md:136). |
| `design.run-research-gate` | Research gate on each `brief.md`'s references | actor.research-reviewer | agent.research-reviewer | art.concept-brief (snapshot: commit or paths + SHA-256) | art.idea-run-review | gate.idea-research: PASS -> `design.run-design-gate`; FINDINGS -> `design.run-revise` (back to author) | .claude/skills/idea-run/SKILL.md:50-56; .atlas/src/pages/design-run.json:155-184 | Fresh reviewer per round; cap via gate.round-cap. |
| `design.run-design-gate` | Quality gate: design-reviewer on every page | actor.design-reviewer | agent.design-reviewer | art.concept-pdf, art.concept-png, earlier art.idea-run-review + author replies | art.idea-run-review | gate.idea-design: PASS -> `design.run-integrate`; FINDINGS -> `design.run-revise` | .claude/skills/idea-run/SKILL.md:57-61, 106-112; .atlas/src/pages/design-run.json:185-217 | Atlas adds a "planned" Codex reviewer not in the skill (conflict 23). |
| `design.run-revise` | Author revises (same agent id via SendMessage) | actor.magazine-editor | agent.magazine-editor | art.idea-run-review | art.concept-* (revised), art.concept-meta (re-stamped) | -> the gate that failed; at cap -> item marked `unresolved` (gate.round-cap) | .claude/skills/idea-run/SKILL.md:47-49, 62-71; .atlas/src/pages/design-run.json:218-237 | Edits after PASS: sourced claim -> research gate; idea/data change -> quality gate; layout/typo -> lead check noted in `run.md` (idea-run:66-71). |
| `design.run-integrate` | Integrate: outputs check, commit, merge to main, push | actor.lead | cmd.outputs-check; cmd.git-merge (routine Git) | art.concept-pdf, art.concept-meta, art.run-md, art.idea-run-review | art.concepts-readme (run rows) | gate.outputs-check: pass -> `design.run-message`; fail -> fix Meta Files | .claude/skills/idea-run/SKILL.md:72-85; .atlas/src/pages/design-run.json:245-264 | Concepts stay `proposed`. |
| `design.run-message` | Short message to the owner | actor.lead | skill.idea-run | art.concepts-readme, art.concept-pdf | (message in chat); handoff card lists waiting concepts | -> `design.pick` (and optional `design.own-look`) | .claude/skills/idea-run/SKILL.md:114-127; .atlas/src/pages/design-run.json:265-279 | Six PDFs per Style, dropped/`unresolved` items, rounds per gate. |
| `design.own-look` | Owner's own look in the Design Review app (optional, any time) | actor.owner | cmd.design-review-app | art.concept-pdf + art.concept-meta (any PDF with valid Meta File) | art.review-state, art.review-export (optional) | none (nothing waits for it) | .atlas/src/pages/design-run.json:122-148; scripts/design_review/server.py:1-12, 108-141, 235-236, 337-338 | Agents read verdicts from `.local/design-review/state.json` (AGENTS.md). |
| `design.pick` | Owner picks Style, Design Tier and Density | actor.owner | manual.pick-design | art.concept-pdf, art.concepts-readme | (decision in chat) | gate.owner-pick: chosen -> `design.record-choice` then `design.workspace`; parked/rejected/no answer -> no client build (inferred: new run or wait) | .claude/skills/new-cv/SKILL.md:64-66; docs/guides/client-workflow.md:292-295; .claude/skills/idea-run/SKILL.md:129-134; .atlas/src/pages/client-journey.json:378-394 | |
| `design.record-choice` | Record the answer: README decision row, re-stamp `chosen` | actor.lead | cmd.outputs-stamp (`status=chosen`, only the picked tier's PDFs) | owner's answer | art.concepts-readme (dated decision), art.concept-meta (`chosen`/`parked`/`rejected`) | -> `design.workspace` | .claude/skills/idea-run/SKILL.md:122-134; .atlas/src/pages/design-run.json:296-313 | Rejected: folder removed; "not my style, keep": to `archive/anti-examples/`. |
| `design.workspace` | Complete the Envelope for the build | actor.lead | skill.new-cv | art.envelope-json (must exist), art.portrait (from intake documents; inferred) | art.envelope-readme (decisions, evidence paths), art.portrait | -> `design.fill-data` | .claude/skills/new-cv/SKILL.md:17-26; docs/guides/build-a-cv.md:10-35; docs/guides/client-workflow.md:55 | `envelope.json` is written in stage 1; render refuses without it (outputs.py:56-73). |
| `design.fill-data` | Write `candidate.json` from the facts | actor.lead | skill.new-cv | art.facts-md, art.draft-pdf (signed-off wording), example records `examples/candidates/*-example.json` | art.candidate-json, art.presentation-json (custom path only) | -> `design.entry-point` | .claude/skills/new-cv/SKILL.md:37-47; docs/guides/build-a-cv.md:70-113, 262-264 | Replace `disclosure` (build-a-cv:84-95). Never invent months from calendar periods (build-a-cv:263-264). |
| `design.entry-point` | Write `cv.typ`: Flagship, one-off Template, or custom composition | actor.lead | skill.new-cv | art.candidate-json, theme/artwork/layout files in `packages/domains/marine/templates/flagship/` or `/packages/cv-framework/lib.typ` | art.cv-typ, art.local-helpers, art.presentation-json | -> `design.port-concept` (one-off from a concept) or `design.preview` | .claude/skills/new-cv/SKILL.md:48-61, 86-89; docs/guides/build-a-cv.md:37-68, 96-101, 215-273; docs/guides/client-workflow.md:285-291 | Three paths: (a) `flagship.with(...)` + `pages` override; (b) one-off importing only the Framework (no schema check, validate.py:57-62); (c) custom composition from marine `lib.typ` (build-a-cv §8). Copy wording `certificates-subtitle`, `brand` set in `cv.typ`. |
| `design.port-concept` | Port the chosen concept's Typst into the Envelope (implicit) | actor.lead | (none named) | art.concept-typ (chosen tier/density) | art.cv-typ, art.local-helpers (e.g. `design-hanami.typ`, `text-hanami-*.typ`, `assets/`) | -> `design.preview` | docs/framework-gaps.md:114-118 (only evidence) | Unnamed step (conflict 16). Here a font move into `packages/cv-framework/fonts/` happened too (framework-gaps.md:117). |
| `design.preview` | Preview renders while adjusting (not a Revision) | actor.lead | cmd.typst-watch / cmd.typst-compile-preview | art.cv-typ, art.candidate-json | art.preview-pdf; art.design-review-input (for the reviewer) | -> `design.client-review` (one-off/client design) or `deliver.render` | docs/guides/build-a-cv.md:151-159; .claude/skills/new-cv/SKILL.md:69-70 | "A preview is not a revision" (build-a-cv:158-159). |
| `design.client-review` | design-reviewer loop on the client's previews | actor.lead, actor.design-reviewer | agent.design-reviewer | art.design-review-input; brief: Alias, Domain, specialty, role, chosen concept folder, Tier, Density, "text is signed-off" | art.design-reviews-md | gate.client-design-review: PASS -> `design.clear-review-input`; FINDINGS -> lead fixes `cv.typ`, back to `design.preview`; cap -> reaches owner `unresolved` | .claude/skills/new-cv/SKILL.md:67-78; .claude/agents/design-reviewer.md:36-42, 66-71; .atlas/src/pages/client-journey.json:395-431 | Reports verbatim in the Envelope, never under `docs/work/` (new-cv:77-78). Scope (one-off only vs every client) is ambiguous (conflict 6). |
| `design.clear-review-input` | Clear `builds/design-review-input-*` by path | actor.lead | cmd.clear-review-input | art.design-review-input | (deleted) | -> `deliver.render` | .claude/skills/new-cv/SKILL.md:79-80; docs/preferences.md:62-63 | Those folders hold a real client's pages outside `private/`. |
| `design.framework-gap` | Record the bypass | actor.lead | skill.new-cv | (what was bypassed) | art.framework-gaps (new entry), art.envelope-readme (reason for custom composition) | (parallel to build; before "done") | .claude/skills/new-cv/SKILL.md:81-85; docs/guides/build-a-cv.md:274-280; docs/guides/client-workflow.md:281-283, 291; AGENTS.md rule 6 | Client-outside-domain entries: docs/framework-gaps.md:73-92, 94-112, 114-118. |

### Stage `deliver`

| ID | name | actor | action(s) | inputs | outputs | next / branches | anchor | notes |
|---|---|---|---|---|---|---|---|---|
| `deliver.render` | Render a Revision | actor.lead (runs), actor.script (does) | cmd.cv-render | art.envelope-json, art.candidate-json, art.cv-typ, art.portrait, art.local-helpers, art.presentation-json, schema file (validate.py:16-39) | art.revision-folder, art.inputs-cv-typ, art.inputs-candidate-json, art.inputs-assets, art.inputs-files, art.render-log, art.render-json, art.checks-json, art.cv-pdf, art.cv-meta-json (`render`) | gate.render-refusal (exit 2, nothing written) -> `deliver.fix`; gate.render-compile (exit 1, `failed`) -> `deliver.fix`; gate.render-checks (exit 1, checks failed incl. gate.live-read) -> `deliver.fix`; exit 0 -> `deliver.inspect`. gate.certificate-warning never blocks | scripts/cv.py:43-49, 67-78; packages/cv-workflow/cv_workflow/render.py:90-202; docs/guides/build-a-cv.md:115-149; .claude/skills/new-cv/SKILL.md:90-93; .atlas/src/pages/client-journey.json:439-466 | `--pages` default 2 (cv.py:45); `--input key=value` passed to Typst (cv.py:46, render.py:144-145). |
| `deliver.fix` | Fix inputs after a refusal, compile error, failed check or visual issue | actor.lead | skill.new-cv | refusal text, art.render-log, art.checks-json | art.candidate-json, art.cv-typ (edited) | -> `deliver.render` (always a new revision) | docs/guides/build-a-cv.md:132-138, 161-170, 175-178; .claude/skills/new-cv/SKILL.md:94-96 | Never shrink fonts (AGENTS.md rule 4). |
| `deliver.inspect` | Look at every page; example-wording check | actor.lead | cmd.png-render, cmd.wording-check | art.cv-pdf | art.page-png | gate.example-wording: `[]` -> `deliver.report`; hit -> `deliver.fix` | .claude/skills/new-cv/SKILL.md:97-102; docs/guides/build-a-cv.md:103-113, 172-178; .claude/skills/verify-cv/SKILL.md:174-185 | Wording check is manual, not in checks.py (conflict 7). |
| `deliver.report` | Report to owner: revision, hash, pages, per-page checks, every WARNING/NOTE verbatim | actor.lead | skill.new-cv | cmd.cv-render stdout/stderr, art.page-png | (chat report) | -> `deliver.owner-review` | .claude/skills/new-cv/SKILL.md:104-114; .atlas/src/pages/client-journey.json:447 | "For a real person, stop at the render" (new-cv:104). |
| `deliver.status` | List revisions and states (optional, any time) | actor.lead or actor.owner | cmd.cv-status | art.render-json, art.checks-json, art.approval-json, art.export-pdf, art.export-approval-json | stdout JSON | (informational) | scripts/cv.py:62-63, 85-89; packages/cv-workflow/cv_workflow/__init__.py:14-31; packages/cv-workflow/cv_workflow/workspace.py:178-218; docs/guides/build-a-cv.md:199 | States: incomplete, corrupt, failed, changed, checks-failed, rendered, approved, exported, export-conflict. No `delivered` (conflict 3). |
| `deliver.owner-review` | Owner reviews the revision's exact `cv.pdf` | actor.owner | manual.review-pdf; optional cmd.design-review-app | art.cv-pdf, art.cv-meta-json, art.checks-json warnings | (owner's hash prefix) | gate.owner-review: OK -> `deliver.approve`; changes -> `deliver.fix` | docs/pdf-workflow.md:164-165; docs/guides/build-a-cv.md:172-178; .atlas/src/pages/client-journey.json:472 | Design Review app indexes `revisions/*/cv.pdf` (outputs.py:171-175; server.py:67-79). |
| `deliver.approve` | Approval bound to revision id and SHA-256 | actor.owner | cmd.cv-approve | art.render-json, art.cv-pdf, art.checks-json, art.envelope-json | art.approval-json, art.cv-meta-json (`approved`) | gate.approval-preconditions: pass -> `deliver.export`; refused (exit 2) -> `deliver.fix` or re-review. gate.approval-owner-only | scripts/cv.py:51-56, 79-81; packages/cv-workflow/cv_workflow/approve.py:6-45; docs/guides/build-a-cv.md:180-189; docs/pdf-workflow.md:166-170; docs/preferences.md:49-51; .atlas/src/pages/client-journey.json:467-494 | Agents never approve a real client's PDF (new-cv:104-106; glossary:63). |
| `deliver.export` | Verified copy into `exports/<revision>/` | actor.lead per Atlas; unstated elsewhere | cmd.cv-export | art.render-json, art.cv-pdf, art.checks-json, art.approval-json | art.partial-export (transient), art.export-pdf, art.export-approval-json | gate.export-preconditions + gate.export-bundle: pass -> `deliver.record-delivery-date` / `deliver.send`; refused -> fix/inspect | scripts/cv.py:58-60, 82-84; packages/cv-workflow/cv_workflow/export.py:8-52; docs/guides/build-a-cv.md:191-200; docs/pdf-workflow.md:171-175; .atlas/src/pages/client-journey.json:495-517 | Never compiles; repeat returns the existing bundle. Actor conflict 2. |
| `deliver.record-delivery-date` | Write "Delivered <date>. Delete by <date + 12 months>" in README | actor.lead | skill.new-client / skill.new-cv (step 9 of new-client) | (dates) | art.envelope-readme | -> `deliver.send` / `deliver.report-delete-by` | docs/guides/client-workflow.md:297-299; .claude/skills/new-client/SKILL.md:73-75; .atlas/src/pages/client-journey.json:529 | Timing: "At Export" (guide, skill) vs after sending (Atlas) - conflict 1. |
| `deliver.send` | Owner sends the exported PDF to the client | actor.owner (with actor.client) | manual.send-pdf | art.export-pdf | (sent) | -> `deliver.stamp-delivered` | docs/guides/build-a-cv.md:202; docs/pdf-workflow.md:176-179; .atlas/src/pages/client-journey.json:518-526 | The receipt is internal, need not be sent (pdf-workflow:176-177). |
| `deliver.stamp-delivered` | Re-stamp the revision's Meta File `delivered` | actor.lead | cmd.outputs-stamp-delivered | art.cv-pdf, art.cv-meta-json, art.envelope-json | art.cv-meta-json (`delivered`) | -> `deliver.report-delete-by` | docs/guides/build-a-cv.md:202-204; docs/guides/client-workflow.md:298-299; docs/pdf-workflow.md:145-149; .atlas/src/pages/client-journey.json:527-533; scripts/outputs.py:33-46 | The revision's `cv.pdf` is stamped, not the export copy (exports are never indexed, pdf-workflow:155-156). |
| `deliver.report-delete-by` | Name the delete-by date (and Google items to delete with it) in the report | actor.lead | skill.new-client | art.envelope-readme | (chat report) | -> `after.delete-by-check` (later) | docs/guides/client-workflow.md:299-300; .claude/skills/new-client/SKILL.md:100-103 | |

### Stage `after`

| ID | name | actor | action(s) | inputs | outputs | next / branches | anchor | notes |
|---|---|---|---|---|---|---|---|---|
| `after.stall-check` | Name clients with no Export 3 months after intake | actor.lead | skill.new-client | art.envelope-readme (intake date), presence of `exports/` (inferred) | (chat report, by Alias) | gate.stall: stalled -> owner decides (inferred: `after.delete` or continue) | docs/guides/client-workflow.md:300-303; .claude/skills/new-client/SKILL.md:95-98; .atlas/src/pages/client-journey.json:43 | Runs only when new-client runs (conflict 21). Applies to clients that never reached Export, so it is not strictly post-delivery. |
| `after.delete-by-check` | Name passed delete-by dates with the Google links | actor.lead | skill.new-client | art.envelope-readme (delete-by date, Google links) | (chat report) | gate.delete-by: passed -> `after.delete`; not passed -> wait | .claude/skills/new-client/SKILL.md:95-98; .atlas/src/pages/client-journey.json:551-554 | No code computes or reads the date. |
| `after.keep-request` | Client asks to keep data beyond 12 months (implicit) | actor.client, actor.owner | (none named) | consent text | (nothing recorded) | skips `after.delete` | docs/guides/client-workflow.md:133-136; .atlas/src/pages/client-journey.json:549 | No artifact records the request (conflict 4). |
| `after.cleanup-revisions` | Failed or unapproved revisions as cleanup candidates | actor.owner (go), actor.lead (inferred) | manual.owner-go-delete | art.revision-folder (failed/unapproved) | (deleted) | - | docs/pdf-workflow.md:202-205; docs/preferences.md:68-75 | "not part of a general `builds/` cleanup". |
| `after.delete` | Delete the Envelope and the Google items, empty Drive Trash | actor.owner | manual.delete-envelope, manual.delete-google-items, manual.empty-drive-trash | art.envelope-readme (Google links) | (all `private/<alias>/` gone) | end | docs/guides/client-workflow.md:303-305, 127-128; docs/preferences.md:68-75; .atlas/src/pages/client-journey.json:545-559 | Deleting under `private/` needs the owner's explicit go; agents never do it alone. |
| `after.close-record` | Close the client's task record (missing) | (none) | (none) | Trello card, handoff card (inferred) | (none defined) | - | (no source) | No source defines closing the client's card or marking the Envelope closed (conflict 18). |

---

## 2. Artifacts

| ID | path pattern | format / schema | produced by | consumed by | public/private | anchor (write; doc) |
|---|---|---|---|---|---|---|
| art.envelope-json | `private/<alias>/envelope.json` | JSON `{alias, domain, candidate, rank}`; field rules from `packages/cv-workflow/cv_workflow/output.schema.json` (`alias` pattern line 13, `domain` line 11) | stage 1 (inventory A) | deliver.render, deliver.approve, deliver.stamp-delivered, every stamp in the Envelope | private | read: outputs.py:56-73, render.py:106, approve.py:18; doc: build-a-cv.md:28-35, client-workflow.md:69-77 |
| art.envelope-readme | `private/<alias>/README.md` | Markdown, free text (alias, intake date, decisions, draft hashes, Delivered/Delete-by, Google links) | stage 1; design.workspace, design.framework-gap, deliver.record-delivery-date | after.stall-check, after.delete-by-check, after.delete; Design Review app links it (server.py:72) | private | doc: client-workflow.md:37-38, 297; new-cv SKILL:22-23; no code writes it |
| art.facts-md | `private/<alias>/intake/facts.md` | Markdown | stage 3 | design.handover, design.fill-data | private | client-workflow.md:165-172 |
| art.draft-pdf | `private/<alias>/draft/draft-NN.pdf` (+ `.typ`, `.meta.json` `signed-off`) | PDF + Meta File `client-draft` | stage 4 | design.handover, design.fill-data | private | outputs.py:47-48; client-workflow.md:258-276 |
| art.sign-off-png | `private/<alias>/draft/sign-off-NN.png` | image | stage 4 | design.handover | private | client-workflow.md:275-276 |
| art.run-md | `docs/work/idea-runs/<run>/run.md` | Markdown | design.run-branch, design.run-brief, all run steps | design.run-integrate | public | idea-run SKILL:32-35 |
| art.idea-run-review | `docs/work/idea-runs/<run>/reviews/NN-<reviewer>.md` | Markdown report | design.run-research-gate, design.run-design-gate | design.run-revise, next gate round | public | idea-run SKILL:72 |
| art.concept-brief | `design-concepts/<date>-<slug>/brief.md` | Markdown | design.run-draw | design.run-research-gate; Design Review app (server.py:58) | public | idea-run SKILL:53-54; design-concepts/README.md |
| art.concept-sample-json | `design-concepts/<date>-<slug>/sample.json` | JSON, fictional | design.run-draw | concept Typst | public | AGENTS.md "design-concepts/" row |
| art.concept-typ | `design-concepts/<date>-<slug>/<density>/<tier>/<density>-<tier>.typ` | Typst | design.run-draw | design.port-concept | public | AGENTS.md "design-concepts/" row |
| art.concept-pdf | `design-concepts/<date>-<slug>/<density>/<tier>/<density>-<tier>.pdf` | PDF (`kind: concept`) | design.run-draw | design.run-design-gate, design.own-look, design.pick | public | home: outputs.py:37-40; pdf-workflow.md:125 |
| art.concept-png | `design-concepts/<date>-<slug>/<density>/<tier>/...png` (one per page) | PNG | design.run-draw | design.run-design-gate | public | AGENTS.md "design-concepts/" row |
| art.concept-meta | `design-concepts/<date>-<slug>/<density>/<tier>/<density>-<tier>.meta.json` | `output.schema.json`, status `proposed/chosen/parked/rejected/unresolved` (schema:30-31) | design.run-draw, design.run-revise, design.record-choice | design.run-integrate (check), Design Review app | public | outputs.py:101-138; idea-run SKILL:124-127 |
| art.concepts-readme | `design-concepts/README.md` | Markdown table (state, dated decision) | design.run-integrate, design.record-choice | design.run-message, design.pick | public | idea-run SKILL:73-77, 122-134 |
| art.review-state | `.local/design-review/state.json` | JSON `{id: {reviewed, verdict keep/maybe/reject, star, notes, updated}}` | design.own-look | agents reading verdicts | local, untracked | server.py:108-141, 235-236 |
| art.review-export | `.local/design-review/exports/review-<YYYYMMDD-HHMMSS>.md` | Markdown | design.own-look (Export button) | owner / agents | local, untracked | server.py:144-174, 337-338 |
| art.portrait | `private/<alias>/portrait.<ext>` (or `assets/`) | jpg/png | design.workspace | deliver.render (copied) | private | render.py:111-116; build-a-cv.md:22, 74-79; pdf-workflow.md:80-81 |
| art.candidate-json | `private/<alias>/candidate.json` | JSON; schema chosen from imports: `packages/domains/marine/templates/flagship/schema/flagship-input.schema.json` (marine lib), a domain `schema/candidate.schema.json`, or none (Framework only) | design.fill-data | deliver.render | private | required: workspace.py:82-84; validated: render.py:105-110, validate.py:16-39, 57-77 |
| art.presentation-json | `private/<alias>/presentation.json` | JSON, no schema | design.fill-data (custom/one-off path) | deliver.render (snapshotted when read by literal path) | private | build-a-cv.md:23, 262-266 |
| art.local-helpers | `private/<alias>/<path>` read by `cv.typ` by literal relative path (`.typ`, data, images) | any | design.entry-point, design.port-concept | deliver.render | private | render.py:54-87; build-a-cv.md:265-273 |
| art.cv-typ | `private/<alias>/cv.typ` | Typst entry point | design.entry-point | design.preview, deliver.render | private | required: workspace.py:82-84; build-a-cv.md:37-56 |
| art.preview-pdf | `builds/<name>-preview.pdf` | PDF, no Meta File | design.preview | lead's look | public tree, ignored | build-a-cv.md:151-156 |
| art.design-review-input | `builds/design-review-input-<timestamp>/` | PDFs (and PNGs, inferred) | design.preview | design.client-review; deleted by design.clear-review-input | public tree, ignored; holds client pages | new-cv SKILL:69-70, 79-80 |
| art.design-reviews-md | `private/<alias>/reviews/design-NN.md` | Markdown, reviewer report verbatim | design.client-review | owner, next round | private | new-cv SKILL:77-78; client-workflow.md:56 |
| art.text-reviews-md | `private/<alias>/reviews/text-NN.md` | Markdown | (no step defines it) | (none) | private | client-workflow.md:56 only (conflict 14) |
| art.framework-gaps | `docs/framework-gaps.md` | Markdown entry (Needed/Bypassed/Built/Lesson) | design.framework-gap | future framework work | public (Alias only) | framework-gaps.md:8-16 |
| art.revision-folder | `private/<alias>/revisions/<revision>/` | folder; id `YYYYMMDD-HHMMSS-<hex6>` | deliver.render | all deliver steps | private | workspace.py:37-38, 117-132; render.py:122-123 |
| art.inputs-cv-typ | `private/<alias>/revisions/<revision>/inputs/cv.typ` | Typst, verbatim | deliver.render | compile; reproduction | private | render.py:126 |
| art.inputs-candidate-json | `private/<alias>/revisions/<revision>/inputs/candidate.json` | JSON with `identity.portrait` repointed | deliver.render | compile; certificate check (render.py:184) | private | render.py:131, 134 |
| art.inputs-assets | `private/<alias>/revisions/<revision>/inputs/assets/<portrait-name>` | image | deliver.render | compile | private | render.py:123, 128-133 |
| art.inputs-files | `private/<alias>/revisions/<revision>/inputs/<relative path>` | any (hash in `render.json` `inputs.files`) | deliver.render | compile | private | render.py:136-141 |
| art.render-log | `private/<alias>/revisions/<revision>/render.log` | text (compiler stdout+stderr, UTF-8) | deliver.render | deliver.fix | private | render.py:151 |
| art.render-json | `private/<alias>/revisions/<revision>/render.json` | JSON (revision, candidate, created_at, status success/failed, exit_code, engine {packages, commit, uncommitted_changes}, compiler {version, command}, inputs {entry, candidate+schema, assets, files, compiler_inputs}, settings.expected_pages, pdf {path, sha256, bytes}\|null); no schema file | deliver.render | deliver.approve, deliver.export, deliver.status | private | render.py:154-174; workspace.py:134-150 |
| art.checks-json | `private/<alias>/revisions/<revision>/checks.json` | JSON (pdf_sha256, checked_at, expected_pages, pages, errors, passed, certificates {reference_date, window_days, date_checked, not_date_checked, warnings}); written only when the compile succeeded | deliver.render | deliver.approve, deliver.export, deliver.status | private | render.py:175-185; checks.py:15-52, 71-98; workspace.py:152-162 |
| art.cv-pdf | `private/<alias>/revisions/<revision>/cv.pdf` | PDF (home `client-cv`) | deliver.render (Typst) | deliver.inspect, deliver.owner-review, deliver.approve, deliver.export, deliver.stamp-delivered | private | render.py:143-152; outputs.py:49-50 |
| art.cv-meta-json | `private/<alias>/revisions/<revision>/cv.meta.json` | `output.schema.json`, kind `client-cv`, status `render` -> `approved` -> `delivered` (schema:36-37); fields from envelope + `variant`=revision id, `lang`, `source: cv.typ`, `producedBy` | deliver.render, deliver.approve, deliver.stamp-delivered | Design Review app, `outputs.py check --private` | private | render.py:186-189; approve.py:30-31, 44; scripts/outputs.py:33-46; pdf-workflow.md:131-149 |
| art.approval-json | `private/<alias>/revisions/<revision>/cv.approval.json` | JSON {revision, candidate (folder name), sha256, bytes, approver, approved_at, scope owner\|test-only}; no schema file | deliver.approve | deliver.export, deliver.status | private | approve.py:34-43; workspace.py:164-176 |
| art.partial-export | `private/<alias>/exports/.partial-<revision>-<hex6>/` | transient folder | deliver.export | renamed into art.export-*; left behind on rename failure; listed by status | private | export.py:24-37; workspace.py:16-17, 103-106 |
| art.export-pdf | `private/<alias>/exports/<revision>/cv.pdf` | PDF, byte copy; never indexed, no Meta File | deliver.export | deliver.send | private | export.py:28, 35; pdf-workflow.md:93-95, 155-156 |
| art.export-approval-json | `private/<alias>/exports/<revision>/cv.approval.json` | JSON, byte copy of receipt | deliver.export | internal only | private | export.py:29; pdf-workflow.md:95, 176-177 |
| art.page-png | `builds/<new-folder>/cv-p<N>.png` | PNG 96 dpi | deliver.inspect | lead's look, report | public tree, ignored; holds client pages (inferred) | new-cv SKILL:97-98; verify-cv SKILL:181-185 |
| art.reference-pdf | `private/<alias>/reference.pdf` (+ `reference.meta.json`) | PDF, kind `client-cv`, a CV delivered before `cv.py` | (no current step; legacy) | Design Review app (row "Delivered") | private | outputs.py:51-52, 174-175; server.py:76-77; pdf-workflow.md:129 |
| art.workflow-evidence | `builds/tests-<timestamp>/workflow/` (`fictional-engineer/`, `fictional-tour-guide/`, `commands.log`, `report.json`) | suite evidence | tests/workflow.py | verify-cv report | public tree, ignored | tests/workflow.py:41-50, 387-389 |

---

## 3. Actions

| ID | kind | exact invocation | reads | writes | refuses when | anchor |
|---|---|---|---|---|---|---|
| skill.new-cv | skill | `/new-cv` (Skill tool) | facts, signed-off draft, examples | Envelope build files | - | .claude/skills/new-cv/SKILL.md |
| skill.idea-run | skill | `/idea-run` (Skill tool) | owner steer | run folder, concepts | - | .claude/skills/idea-run/SKILL.md |
| skill.new-client | skill | `/new-client` (Skill tool) | every Envelope's `README.md` | README lines, chat report | - | .claude/skills/new-client/SKILL.md:69-76, 93-103 |
| agent.magazine-editor | agent | Agent `magazine-editor` (fallback: `general-purpose` acting as the file, idea-run:87-104) | brief, vision, anti-examples | `design-concepts/<date>-<slug>/...`, stamps | never reads `private/` | .claude/agents/magazine-editor.md |
| agent.research-reviewer | agent | Agent `research-reviewer`, fresh per round | `brief.md` references (snapshot) | report text (lead stores it) | - | idea-run SKILL:53-56 |
| agent.design-reviewer | agent | Agent `design-reviewer`, fresh per round | concept PDFs/PNGs, or client previews under `builds/` | report text; renders only under `builds/` | never reads `private/`, never runs git/Trello | .claude/agents/design-reviewer.md:3, 36-42 |
| cmd.cv-render | cmd | `python scripts/cv.py render private/<alias> [--pages N] [--input KEY=VALUE ...] [--typst PATH] [--reference-date YYYY-MM-DD]` | `candidate.json`, `cv.typ`, `envelope.json`, portrait, files `cv.typ` reads, schema, `git rev-parse HEAD`, `git status --porcelain -- packages/cv-framework packages/domains` | `revisions/<revision>/` with `inputs/`, `render.log`, `render.json`, `checks.json` (on compile success), `cv.pdf`, `cv.meta.json` (on compile success); stdout summary JSON; stderr `WARNING:`/`NOTE:` | exit 2 `REFUSED:` (nothing written): workspace outside repo; no `candidate.json`/`cv.typ`; invalid JSON / not an object; no or invalid `envelope.json`; record breaks schema (first 10 paths); portrait missing; root-absolute read into `private/`/workspace; read outside workspace; missing read file; file colliding with portrait in `inputs/assets/`; Typst not found; `jsonschema` missing. Exit 1: compile failed or checks failed (revision kept) | scripts/cv.py:3, 43-49, 67-78, 90-94; render.py:97-121; workspace.py:75-84; outputs.py:56-73; validate.py:57-77 |
| cmd.cv-approve | cmd | `python scripts/cv.py approve private/<alias> <revision> --approver "<name>" --sha256 <12+ hex of reviewed hash>` (`--test-only` fixtures only) | `envelope.json`, `render.json`, `cv.pdf`, `checks.json`, existing `cv.approval.json` | `cv.approval.json`; `cv.meta.json` `approved` (also heals a missed stamp, never downgrades `delivered`) | exit 2: empty approver; `--test-only` under `private/`; envelope missing/invalid; revision missing/incomplete/not success/no pdf; bytes changed; no/stale/failed/invalid checks; hash prefix <12, non-hex or mismatch; receipt exists for other bytes | scripts/cv.py:51-56, 79-81; approve.py:6-45; workspace.py:59-64, 134-162 |
| cmd.cv-export | cmd | `python scripts/cv.py export private/<alias> <revision>` | `render.json`, `cv.pdf`, `checks.json`, `cv.approval.json`, existing `exports/<revision>/` | `exports/.partial-<revision>-<hex>/` then `exports/<revision>/{cv.pdf, cv.approval.json}`; stdout `{revision, export, sha256, existing}` | exit 2: render/check preconditions as approve; no receipt; receipt for another revision or other bytes; existing export incomplete, different PDF or different receipt (never overwritten); rename race | scripts/cv.py:58-60, 82-84; export.py:8-52; workspace.py:164-176 |
| cmd.cv-status | cmd | `python scripts/cv.py status private/<alias>` | every revision's records, exports | stdout JSON `{workspace, revisions[{revision, state, sha256[:12], certificate_dates, warnings}], partial_exports}`; stderr `WARNING [<revision>]:` | exit 2: workspace outside repo or missing `candidate.json`/`cv.typ` | scripts/cv.py:62-63, 85-89; __init__.py:14-31; workspace.py:178-218 |
| cmd.outputs-stamp | cmd | `python scripts/outputs.py stamp <pdf> status=<status> [key=value ...]` | PDF, home from path, `envelope.json` for client homes, earlier Meta File | `<pdf-stem>.meta.json` | exit 2: PDF missing; not in a home; envelope missing/invalid; result invalid against schema (e.g. wrong status for kind) | scripts/outputs.py:33-46; outputs.py:101-138 |
| cmd.outputs-stamp-delivered | cmd | `python scripts/outputs.py stamp private/<alias>/revisions/<revision>/cv.pdf status=delivered` | as cmd.outputs-stamp | `cv.meta.json` `delivered` | as cmd.outputs-stamp; does NOT check approval or export (conflict 3) | build-a-cv.md:204; client-journey.json:532 |
| cmd.outputs-check | cmd | `python scripts/outputs.py check [--private]` | every PDF in `design-concepts/`, `examples/`, root `exports/`; with `--private` `draft/draft-*.pdf`, `revisions/*/cv.pdf`, `reference.pdf` | stdout `FAIL <path>: <reason>` lines, count | exit 1 on any problem | scripts/outputs.py:47-51; outputs.py:164-192 |
| cmd.typst-watch | cmd | `typst watch --root . --font-path packages/cv-framework/fonts private/<alias>/cv.typ builds/<name>-preview.pdf` | Envelope files (live) | preview PDF | Typst errors | build-a-cv.md:151-156 |
| cmd.typst-compile-preview | cmd | `typst compile --root . --font-path packages/cv-framework/fonts private/<alias>/cv.typ builds/design-review-input-<timestamp>/<name>.pdf` (inferred; new-cv gives the folder, not the command) | Envelope files (live) | preview PDF | Typst errors | new-cv SKILL:69-70 |
| cmd.png-render | cmd | `python -c "import pymupdf; doc=pymupdf.open('private/<alias>/revisions/<revision>/cv.pdf'); doc[0].get_pixmap(dpi=96).save('builds/<new-folder>/cv-p1.png')"` | `cv.pdf` | PNGs under `builds/` | - | verify-cv SKILL:181-185; new-cv SKILL:97-98 |
| cmd.wording-check | cmd | `python -c "import pymupdf,sys; t=''.join(p.get_text() for p in pymupdf.open(sys.argv[1])).lower(); print([w for w in ('fictional','illustrative','flagship') if w in t])" private/<alias>/revisions/<revision>/cv.pdf` | `cv.pdf` | stdout list | - (prints hits; `[]` is clean) | build-a-cv.md:103-113 |
| cmd.design-review-app | cmd | `python scripts/design_review/server.py [--port 8766] [--no-browser] [--no-private]` | every Meta File via `outputs.scan`, PDFs, `.local/design-review/state.json` | `.local/design-review/state.json`, `.local/design-review/cache/*.png`, `.local/design-review/exports/review-<ts>.md` | binds 127.0.0.1 only | scripts/design_review/server.py:1-12, 85-98, 233-243, 337-338, 362-364 |
| cmd.clear-review-input | cmd | delete `builds/design-review-input-<timestamp>/` by path (exact command not given; inferred `rm -r builds/design-review-input-<timestamp>`) | - | (removal) | never `git clean -x/-X` (preferences.md:62-63) | new-cv SKILL:79-80 |
| cmd.git-branch / cmd.git-merge | cmd | routine Git for the run branch `docs/idea-run-<date>-editor`; commit, merge to `main`, push (no exact commands given) | - | branch, commits | - | idea-run SKILL:32-35, 81-82 |
| manual.pick-design | manual | owner states Style, Design Tier, Density in chat | concepts | decision | - | new-cv SKILL:64-65; idea-run SKILL:129-134 |
| manual.review-pdf | manual | owner opens `revisions/<revision>/cv.pdf` | `cv.pdf` | hash prefix for approval | - | pdf-workflow.md:164-165 |
| manual.send-pdf | manual | owner sends `exports/<revision>/cv.pdf` by his own channel | export PDF | - | - | build-a-cv.md:202; pdf-workflow.md:176-179 |
| manual.owner-go-delete | manual | owner's explicit go on a shown command | - | - | - | preferences.md:68-75 |
| manual.delete-envelope | manual | owner deletes `private/<alias>/` | - | - | - | client-workflow.md:303-305 |
| manual.delete-google-items | manual | owner deletes the Intake Form, its Sheet and script project listed in README | README Google links | - | - | client-workflow.md:127-128, 303-305 |
| manual.empty-drive-trash | manual | owner empties Google Drive Trash (keeps files 30 days) | - | - | - | client-workflow.md:304-305 |

---

## 4. Gates

| ID | check | pass -> | fail -> | anchor |
|---|---|---|---|---|
| gate.domain-has-template | client's `Domain` already has a `Template` (today: marine/Flagship) | design.workspace | design.run-ask | new-cv SKILL:62-66; client-workflow.md:285-295; client-journey.json:333-340 |
| gate.template-fits | data fits `flagship` (no contract periods, 3-column certificates, skills block) | design.entry-point (Flagship path) | design.entry-point (custom composition, build-a-cv §8) + design.framework-gap | new-cv SKILL:81-85; build-a-cv.md:215-223 |
| gate.idea-research | fresh `research-reviewer` PASS on the references | design.run-design-gate | design.run-revise | idea-run SKILL:53-56 |
| gate.idea-design | fresh `design-reviewer` PASS (Batch Test, Three-Second Test, Flagship Parity blocking) | design.run-integrate | design.run-revise | idea-run SKILL:57-61, 106-112 |
| gate.round-cap | rounds per gate <= 5 attended / 10 unattended (owner may set another) | continue loop | item reaches owner marked `unresolved` with last reason; merges only as such | idea-run SKILL:62-65, 75-77; new-cv SKILL:74-76 |
| gate.outputs-check | `python scripts/outputs.py check` exit 0 | design.run-integrate commit | fix Meta Files | idea-run SKILL:78-81 |
| gate.owner-pick | owner answers: Build it -> `chosen` (with Tier, Density); Later -> `parked`; Reject -> `rejected`/anti-example; none -> `proposed` | design.record-choice -> design.workspace | no client build (inferred) | idea-run SKILL:129-134; client-journey.json:384-386 |
| gate.client-design-review | fresh `design-reviewer` PASS on the client previews in `builds/design-review-input-<ts>/` | design.clear-review-input | lead fixes -> design.preview; at cap -> owner, `unresolved` | new-cv SKILL:67-80; client-journey.json:408-418 |
| gate.render-refusal | inputs usable (see cmd.cv-render refusals) | revision created | exit 2, nothing written -> deliver.fix | render.py:97-121; build-a-cv.md:134-138 |
| gate.render-compile | Typst exit 0 and `cv.pdf` exists | checks run | exit 1, `render.json status: failed`, `pdf: null` -> deliver.fix | render.py:147-152, 158, 172; cv.py:76 |
| gate.render-checks | `checks.json passed`: page count == `--pages`, no empty page, text inside page, fonts embedded, no Live Read | deliver.inspect | exit 1, revision `checks-failed`, cannot be approved -> deliver.fix | checks.py:71-98; render.py:176-182 |
| gate.live-read | Typst `--deps` lists no file in the workspace or `private/` outside the revision | (part of render-checks) | check error -> revision unapprovable | render.py:36-51, 149-150, 178-181 |
| gate.certificate-warning | certificate expiry vs reference date (expired or <= 180 days) | never blocks | prints `WARNING:`; owner weighs before approving | checks.py:9, 15-52; cv.py:26-36; build-a-cv.md:141-149 |
| gate.example-wording | rendered text has none of "fictional", "illustrative", "flagship" (exception: client's own words with configured brand) | deliver.report | deliver.fix | build-a-cv.md:103-113; new-cv SKILL:97-102 (manual only) |
| gate.owner-review | owner's visual check of the exact `cv.pdf` | deliver.approve | deliver.fix (new revision) | pdf-workflow.md:164-165; build-a-cv.md:172-178 |
| gate.approval-preconditions | approver non-empty; render success; bytes == recorded hash; checks passed for these bytes; reviewed hash prefix >= 12 hex and matches; no receipt for other bytes; envelope valid | writes receipt, stamps `approved` | exit 2 | approve.py:13-33; workspace.py:59-64, 134-162 |
| gate.approval-owner-only | approval is the owner's act; `--test-only` refused under `private/` | owner runs it | agent must not run it (policy; not enforceable in code beyond `--test-only`) | approve.py:15-16; preferences.md:49-51; new-cv SKILL:104-106; AGENTS.md "Commands" |
| gate.export-preconditions | render + checks as approve; receipt exists, same revision id, same sha256 | copy and verify | exit 2 | export.py:15-19; workspace.py:164-176 |
| gate.export-bundle | existing `exports/<revision>/` complete and byte-identical (PDF and receipt) | return existing (`existing: true`) | exit 2, folder left untouched | export.py:20-22, 43-52 |
| gate.stamp-home | PDF in a home of the Output Contract and Meta File valid against `output.schema.json` | Meta File written | exit 2 | outputs.py:108-136 |
| gate.stall | no Export 3 months after the intake date | (keep going) | named to owner by Alias | client-workflow.md:300-303; new-client SKILL:95-98 |
| gate.delete-by | delete-by date (delivery + 12 months) passed | (wait) | named to owner -> after.delete | new-client SKILL:95-98; client-journey.json:551-554 |
| gate.owner-delete | owner's explicit go for any deletion under `private/` or of revisions/receipts/exports | deletion | nothing deleted | preferences.md:68-75; pdf-workflow.md:202-205 |

---

## 5. Actors used

| ID | who | anchor |
|---|---|---|
| actor.owner | Jim, the owner: picks the design, reviews, approves, sends, deletes | docs/preferences.md:44-51; client-workflow.md:9-10 |
| actor.client | the candidate; receives the PDF; may ask to keep data | client-workflow.md:133-136; client-journey.json:522-524 |
| actor.lead | the main Claude Code session (runs skills, render, stamps, reports) | client-workflow.md:9-10; idea-run SKILL:8-12 |
| actor.magazine-editor | design author subagent | .claude/agents/magazine-editor.md; idea-run SKILL:14-17 |
| actor.research-reviewer | reference checker subagent | .claude/agents/research-reviewer.md; idea-run SKILL:53-56 |
| actor.design-reviewer | design judge subagent (concepts and client previews) | .claude/agents/design-reviewer.md:3, 36-42, 66-71 |
| actor.script | `scripts/cv.py` + `packages/cv-workflow`, `scripts/outputs.py`, Typst, `scripts/design_review/server.py` | scripts/cv.py; packages/cv-workflow/cv_workflow/*.py |
| (actor.codex-reviewer) | listed by Atlas as "planned" second design reviewer; not in the skill | .atlas/src/pages/design-run.json:189-210 (conflict 23) |

---

## 6. What `tests/workflow.py` exercises

The suite runs it from `tests/run.py:360-362` on fictional workspaces under `builds/tests-<ts>/workflow/` (not under
`private/`), always with `--test-only` approval.

Exercised (with the assertion lines):

- `deliver.render`, Flagship path: envelope missing / invalid domain refused, nothing written (64-69); snapshot,
  records, `render.json` fields, `checks.json` bound to bytes, PDF pixel-identical to v11, `cv.meta.json` `render` with
  envelope fields, `variant`, `lang` (71-95); later revision (134-139); failing checks via `--pages 3` (160-164);
  compile failure retained with log, Greek data error in `render.log` (188-203); refusals for invalid JSON and missing
  portrait leave nothing (205-215); schema refusal naming paths (217-235); certificate warnings and NOTE, never
  blocking (278-318).
- `deliver.render`, one-off (Framework-only) path: sibling files and local helper snapshotted, `schema: null`, compiles
  from snapshot alone, refusals for root-absolute/outside/missing reads and portrait collision, Live Read fails checks
  (320-385).
- `deliver.approve` (scope `test-only` only): wrong hash, short prefix, `--test-only` under `private/` refused (97-103);
  receipt + `approved` stamp (104-108); heal missed stamp, never downgrade `delivered` (109-118); invalid alias in
  envelope refused before receipt (147-152); changed bytes (153-157); failed checks (163); stale/corrupt checks and
  render records (166-187); did-not-render (192); incomplete revision and empty approver (238-243); receipt for other
  bytes (244-251).
- `deliver.export`: without Typst on PATH, verified, repeatable without touching bundle (121-132); no receipt and
  transferred receipt refused (140-143); changed bytes (155-156); incomplete/different PDF/different receipt
  destinations, partial folder left (253-275).
- `deliver.status`: states `exported`, `changed`, `checks-failed`, `failed`, `incomplete`, `export-conflict`,
  `corrupt`, `approved`, partial exports, warnings and counts (131, 177, 184, 266-271, 304-315).
- Related, elsewhere: `tests/design_review.py:50-60, 132` stamps a fictional `private/` revision (`render`), draft
  (`signed-off`) and `reference.pdf` (`delivered`) through the `outputs.stamp` function and checks the app indexes
  them; `tests/run.py:363-367` runs `scan(include_private=False)` over public PDFs (concept Meta Files of
  `design.run-integrate`).

Not exercised by any test:

- every `design.*` step except the Meta File side of `design.run-draw`/`design.record-choice` (public concept stamps
  are validated by the output-contract scan only);
- `deliver.approve` with scope `owner` and any workflow command on a workspace under `private/`;
- `scripts/outputs.py` as a CLI (stamp or check); `deliver.stamp-delivered` on a revision's `cv.pdf`;
- `deliver.inspect` (PNG render, wording check), `deliver.report`, `deliver.owner-review`, `deliver.send`,
  `deliver.record-delivery-date`, `deliver.report-delete-by`;
- `--input` keys other than `lang` (`design`, `palette` used by the client, framework-gaps.md:116);
- all `after.*` steps (stall and delete-by checks, deletion, cleanup).

---

## 7. Conflicts and gaps

1. **When the delivery date is written.** "At `Export`, Claude writes 'Delivered <date>. Delete by <date + 12
   months>'" (docs/guides/client-workflow.md:297-298; .claude/skills/new-client/SKILL.md:73-75) vs. export is only
   "ready to deliver; sending ... is a separate, manual act" (docs/guides/build-a-cv.md:202; docs/pdf-workflow.md:176-179)
   and the Atlas writes it in the `deliver` step after the owner sends (.atlas/src/pages/client-journey.json:519-529).
   The delete-by date can be counted from export, not delivery.
2. **Who runs `export`.** Atlas: actor `lead` (client-journey.json:498). new-cv: "stop at the render ... export
   follows it" with no actor (.claude/skills/new-cv/SKILL.md:104-106). build-a-cv §6 names no actor
   (build-a-cv.md:191-200). preferences.md lists only approval as the owner's (preferences.md:49-51). The Atlas status
   note says "Approval, export and delivery happen on your machine" (client-journey.json:21).
3. **`delivered` exists only in the Meta File, and stamping is unguarded.** `cv.py status` states stop at
   `exported` (workspace.py:178-218); `delivered` is set by hand via `scripts/outputs.py stamp` (build-a-cv.md:204),
   which checks the home and schema but not that a receipt or an export exists (outputs.py:101-138; schema:36-37).
   So `status=approved` or `status=delivered` can be stamped on an unapproved revision. pdf-workflow.md:145-149 lists
   who stamps, but no code enforces the order.
4. **Retention rules disagree, and "keep" is not recorded.** pdf-workflow.md:202-205: "Retain approved revisions and
   their delivery copies" (no limit) vs. consent and guide: deleted 12 months after delivery unless the client asks to
   keep (client-workflow.md:133-136, 297-305; client-journey.json:549). No artifact or field records a keep request;
   the delete-by date is free text in `README.md` that no code reads.
5. **One-off Template "in one `cv.typ`".** new-client SKILL.md:70-72 says the one-off lives "in one `cv.typ`", but
   build-a-cv.md:265-273, client-workflow.md:288-290 and render.py:54-87 (sibling files snapshotted) allow files beside
   it, and the real builds used `design.typ`, `text-*.typ`, `design-hanami.typ`, `assets/` (framework-gaps.md:104-107,
   116). The 2026-09-25 gap entry's "Bypassed" text still says the snapshot holds only three files
   (framework-gaps.md:77-83), corrected only by its "Update" line (88-91).
6. **Scope of the client design-review loop.** In new-cv the preview -> design-reviewer loop sits inside the
   paragraph about a Domain with no Template (.claude/skills/new-cv/SKILL.md:62-80). The Atlas puts the loop on
   `build-cv` for every client, and the marine branch goes straight to `build-cv` (client-journey.json:333-340,
   395-431). new-cv:9-11 says every client CV must pass the Batch Test; whether a marine Flagship client gets the loop
   is not stated.
7. **The example-wording check is manual only.** build-a-cv.md:103-113 and new-cv:97-102 require it "before
   approving", but `check_pdf` does not include it (checks.py:71-98). A revision with the fictional footer passes
   `checks.json` and can be approved and exported.
8. **One-off record validation is not enforced.** new-cv:44-47 says a Framework-only one-off must keep
   `identity.name`/`portrait` and run `normalize-common` and `validate-common`. Render checks no schema there
   (validate.py:57-62, `schema: null`), and the suite's one-off fixture calls only `normalize-common`
   (tests/workflow.py:23-27).
9. **The Meta File drops render inputs other than `lang`.** render.py:186-189 stamps only `lang`. The client build used
   `--input design=hanami --input palette=pink|indigo|blue --input lang=el|en` (framework-gaps.md:116), so in the Design
   Review app the palette revisions differ only by revision id and `lang` (server.py:78-79). `render.json` keeps them in
   `inputs.compiler_inputs` (render.py:169).
10. **A revision whose checks failed is still stamped `render`.** render.py:175-189 stamps on every successful compile,
    including failed checks (page count, Live Read). The Design Review app shows these like any other render
    (outputs.py:171-175; server.py:77-79). pdf-workflow.md:162-163 says only "a new PDF gets its Meta File".
11. **The Envelope tree is drawn three ways.** build-a-cv.md:15-26 (no `reviews/`, portrait at root), pdf-workflow.md:72-95
    (`assets/` portrait, no `README.md`, `reviews/`, `presentation.json`), client-workflow.md:36-57 (has `reviews/`).
    The folder name is `<name>-<rank>` (new-cv:19-20, build-a-cv.md:12-16), `<candidate>` (pdf-workflow.md:72), or
    `<envelope>` (Atlas, client-workflow.md:259).
12. **Placeholder naming.** The code calls the record `candidate` the workspace folder name (render.py:156;
    approve.py:36), so `render.json` and `cv.approval.json` carry the Envelope folder name, which is client data per
    client-workflow.md:63, while the Meta File's `candidate` comes from `envelope.json` (outputs.py:125-126). The two
    "candidate" fields mean different things.
13. **The "agents never approve" rule is policy only.** approve.py refuses only `--test-only` under `private/`
    (approve.py:15-16); a non-test `approve` run by an agent with any `--approver` string succeeds.
    pdf-workflow.md:183-185 accepts this for local use.
14. **Orphan artifact `reviews/text-NN.md`.** It is named in the Envelope tree (client-workflow.md:56), but no skill,
    guide step or Atlas step produces or reads it.
15. **Legacy home `reference.pdf`.** It is a `client-cv` home (pdf-workflow.md:129; outputs.py:51-52) and the app's
    "Delivered" row (server.py:76-77), but no current step produces it.
16. **Implicit, unnamed steps in the one-off build.** (a) Porting the chosen concept's Typst into the Envelope
    (framework-gaps.md:114-117) is in no guide or skill. (b) Fonts the design needs were moved into the public
    `packages/cv-framework/fonts/`, because render passes only that `--font-path` (workspace.py:15; render.py:143;
    framework-gaps.md:117). That changes the public engine for one client, and no step or review gate for it appears
    in new-cv or client-workflow.
17. **Preview production for the reviewer is unspecified.** new-cv:69-70 gives the folder
    `builds/design-review-input-<timestamp>/` but no command, and does not say whether previews come from a Revision or
    a direct compile. `builds/` is outside the Output Contract (pdf-workflow.md:155-156), so the previews carry no Meta
    File. The client pages in `builds/` (also `art.page-png`, verify-cv:181-185) are cleared only by a lead act with no
    check.
18. **No step closes the client's record.** No source closes the client's Trello card, updates the handoff card at
    delivery, or marks the Envelope closed after deletion. The Atlas `after` phase has retention only
    (client-journey.json:541-561).
19. **The journey summary leaves out design and delivery.** client-workflow.md:12-15 draws "Sign-off -> new-cv ->
    Approval -> Export", with no design run, render, send or retention. The step table ends at "9. Handover"
    (client-workflow.md:17-27).
20. **Certificate checks assume the marine shape.** `check_certificates` reads `certificates` from any record
    (checks.py:24-35). A one-off record with a different shape gets its dates counted as unchecked (`NOTE:`), never
    validated.
21. **Stall and delete-by checks fire only when `new-client` runs.** new-client SKILL.md:95-98 runs them "every time
    this skill runs"; the Atlas shows them at `open.arrives` (client-journey.json:43). After delivery nothing schedules
    them: no routine or trigger is defined, and `new-cv` does not run them.
22. **Who asks for a client design run.** Atlas `design-run.ask`: the owner asks (design-run.json:33-53). new-cv:62-66
    makes the run the default path for a Domain with no Template, and the Atlas client journey gives
    `design.design-run` to the lead (client-journey.json:357-362).
23. **The Atlas adds a reviewer the skill lacks.** design-run.json:189-210 lists a "planned" `codex-reviewer` in the
    design gate ("a round passes only when both pass"). The idea-run skill's gates name only `research-reviewer` and
    `design-reviewer` (idea-run SKILL.md:14-17, 50-61).
24. **The client design-review cap and storage come from two sources.** new-cv:74-78 copies the idea-run cap but
    stores reports in `private/<alias>/reviews/design-NN.md`. idea-run stores reports in
    `docs/work/idea-runs/<run>/reviews/NN-<reviewer>.md` (idea-run:72). The two loops (concept gate and client-preview
    gate) are separate, which only new-cv states.
25. **`status` and `export` do not check `envelope.json`.** render and approve require it (render.py:106;
    approve.py:18); export and status do not (export.py:15-19; __init__.py:16). This is consistent with "export never
    stamps", but stage-wide preconditions differ per command.
