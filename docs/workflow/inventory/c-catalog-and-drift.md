# C - Shared catalog and drift report: CVgen client workflow

Repo: `/home/user/cvgen` at `1e684eb` (main, 2026-10-04). Read-only inventory; nothing was edited.
`private/` was not read. A client appears only as `<alias>` / `client-2026-09-01`.
Abbreviations for anchors: `CW` = `docs/guides/client-workflow.md`, `BC` = `docs/guides/build-a-cv.md`,
`NCL` = `.claude/skills/new-client/SKILL.md`, `NCV` = `.claude/skills/new-cv/SKILL.md`,
`ATL` = `.atlas/src/pages/client-journey.json`, `SITE` = `.atlas/src/site.json`, `GL` = `docs/glossary.md`,
`PDF` = `docs/pdf-workflow.md`, `CVW` = `packages/cv-workflow/cv_workflow/`, `PREF` = `docs/preferences.md`.
"(inferred)" marks anything not stated verbatim in a source.

---

## Part 1 - Catalog

### 1.1 Actors (`actor.*`)

| ID | Who | Takes part in a client job? | What it does there | Model / effort | Anchors |
|---|---|---|---|---|---|
| `actor.owner` | The owner (human) | Yes | Only one who talks to the client; names the client; relays questions/answers; picks Deep Dives; sends draft and saves Sign-off screenshot; picks Style/Tier/Density; runs `cv.py approve`; sends the PDF; deletes data | human | CW:9-10, CW:17-27, ATL:33-43, SITE:32-46, PREF:49-51, PREF:70-77 |
| `actor.client` | The client (human; code says "candidate") | Yes | Answers the question list / Intake Form, one follow-up, checks underlined facts, says OK (Sign-off) | human | GL:46, SITE:47-58, CW:316-318 |
| `actor.lead` | Main Claude Code session ("Claude", "the lead") | Yes | Writes envelope, questions, facts, Scout, decisions, Text Draft, cv.typ; runs render, stamps; briefs subagents; runs review loops; writes README.md bookkeeping | session model, no pin ("Today: Opus 5.5", SITE modelNotes) | SITE:60-73, CW:9-10, AGENTS.md:28-33 |
| `actor.general-purpose` | Claude Code built-in agent | Yes | Writes each Deep Dive (background, one per question); may run the Scout; stand-in for unloaded agent files | session model (SITE) | NCL:34-36, NCL:40-42, SITE roster `general-purpose`, `.claude/skills/idea-run/SKILL.md:87-92` |
| `actor.research-reviewer` | `.claude/agents/research-reviewer.md` | Yes | Fresh per round on each Deep Dive (text inline + SHA-256); also on Research Library notes; never reads `private/` | opus / high (`research-reviewer.md:5-6`) | CW:215-221, NCL:42-47, `research-reviewer.md:14-27` |
| `actor.design-reviewer` | `.claude/agents/design-reviewer.md` | Yes | Fresh per round on a client CV's preview PDFs under `builds/`; Batch Test, Three-Second Test, Flagship Parity; also reviews the idea-run concepts for the client's Domain | opus / high (`design-reviewer.md:5-6`) | NCV:66-80, `design-reviewer.md:33-42`, ATL:396-431 |
| `actor.magazine-editor` | `.claude/agents/magazine-editor.md` | Yes, only when the client's Domain has no Template | Draws 18 mock-ups (3 Styles x 2 Densities x 3 Tiers) on fictional data for the client's Domain/specialty/role | opus / high (`magazine-editor.md:5-6`) | NCV:61-65, CW:291-295, ATL:356-377 |
| `actor.code-reviewer` | `.claude/agents/code-reviewer.md` | Indirectly (inferred) | Reviews public changes a client job causes (e.g. `docs/framework-gaps.md` entry, domain code); no client-specific step names it | opus / high | AGENTS.md "Every change gets an independent review round"; not named in CW/NCL/NCV |
| `actor.context-reviewer` | `.claude/agents/context-reviewer.md` | Indirectly (inferred) | Only if a client job changes agent context (e.g. glossary term added) | opus / high | `context-reviewer.md:1-6` |
| `actor.context-maintainer` | `.claude/agents/context-maintainer.md` | No (inferred) | Points at CW/BC as owner of client rules (`context-maintainer.md:44`), but no client step calls it | opus / high | `context-maintainer.md:44`, `:99-101` |
| `actor.ceo` / `actor.ceo-reviewer` | `.claude/agents/ceo*.md` | No | Product idea runs only | opus / high | `ceo.md:1-7`, `ceo-reviewer.md:1-7` |
| `actor.repo-auditor-lite` | `.claude/agents/repo-auditor-lite.md` | No | Repo-maintenance audits | `inherit` / medium | `repo-auditor-lite.md:1-6` |
| `actor.codex.*` | `.codex/agents/{ceo,ceo-reviewer,code-reviewer,design-reviewer,magazine-editor,repo-auditor-lite,research-reviewer}.toml` | No (Codex is not the implementation harness; CLAUDE.md, AGENTS.md:30-33) | Counterparts of the Claude agents; no model line, only `model_reasoning_effort` (high; repo-auditor-lite medium) and `sandbox_mode` | effort only | `.codex/agents/*.toml:2-5`; no counterpart for context-maintainer/context-reviewer |
| `actor.codex-visual-reviewer` | planned external | No (planned, not built) | Second visual reviewer in each design round | GPT-6 Astra / high (planned) | SITE roster `codex-reviewer` (status planned) |
| `actor.codex-image` | planned external | No (planned) | Raster images for client designs | GPT-6 Sol / high (planned) | SITE roster `codex-image` |

Services that act as channels (not actors, listed for completeness): `svc.chat` (Viber/WhatsApp/email, CW:81-84, SITE `chat`), `svc.google` (Forms, Sheets, Apps Script project in the owner's account, CW:91-128), `svc.trello` (client task cards use the Alias only, CW:65-67, `.claude/skills/trello/SKILL.md:1-3`), `svc.design-review-app` (see `cmd.design-review`).

### 1.2 Skills (`skill.*`)

| ID | Covers | Entry condition (as stated) | Exit condition (as stated) | Used in client workflow | Anchors |
|---|---|---|---|---|---|
| `skill.new-client` | Envelope, Relay intake in Greek, Facts, Scout, CV decisions, Deep Dives, one follow-up, Text Draft, Sign-off, Handover; plus stall/delete-by report every run | "the owner says a new client has arrived or asks to start, continue or check a client's intake or research" | "signed-off facts ... then hand over to new-cv" (step 9 also writes the Export/delivery bookkeeping) | Yes (core) | NCL:1-9, NCL:13-76, NCL:93-105 |
| `skill.new-cv` | Private workspace, data file, entry point, page plan, client design loop (Idea Run + design-reviewer), render, evidence | "create, set up or render a CV for a person, or add a new example"; for a real client "starts after the new-client skill" | "For a real person, stop at the render. Approval ... is the owner's act" | Yes (core) | NCV:1-3, NCV:11-15, NCV:104-106, NCV:107-114 |
| `skill.idea-run` | Closed loop magazine-editor + research-reviewer + design-reviewer; owner's answer -> concept state `chosen` | "a client needs a design" (cadence) | owner's answer mapped to states; `chosen` -> "the client's CV follows" | Yes, when Domain has no Template | `.claude/skills/idea-run/SKILL.md:19-21`, `:41-42`, `:125-134` |
| `skill.verify-cv` | Suite run; hand-render of a client revision page to PNG | "after any change under packages/, examples/ or tests/" | report with command, last line, evidence path | Partly (render a client revision page by hand) | `.claude/skills/verify-cv/SKILL.md:1-3`, `:62-71` |
| `skill.trello` | Card for a client task (Alias only) | orientation and every task state change | - | Yes (inferred; card `travel-cv-01` exists as `docs/work/travel-cv-01/`) | `.claude/skills/trello/SKILL.md:1-3`, CW:65-67 |
| `skill.new-theme` | Theme / artwork pack | "new look, colour scheme..." | - | No (inferred) | `.claude/skills/new-theme/SKILL.md:1-5` |
| `skill.repo-maintenance`, `skill.start-night-shift`, `skill.do-night-shift-follow-up` | - | - | - | No | SKILL.md headers |

### 1.3 Commands (`cmd.*`)

Exit codes for `cv.py` (scripts/cv.py:8-9, :90-94): 0 done; 1 render or checks failed (revision kept); 2 refused (`REFUSED: <reason>` on stderr) or bad arguments (argparse). Warnings (`WARNING:`/`NOTE:` on stderr) never change the code (scripts/cv.py:26-36).

| ID | Exact invocation | Args (from argparse) | Exit / effect | Run by | Anchors |
|---|---|---|---|---|---|
| `cmd.cv-render` | `python scripts/cv.py render <workspace> [--pages N] [--input KEY=VALUE]... [--typst PATH] [--reference-date YYYY-MM-DD]` | `workspace` (pos); `--pages` int, default 2; `--input` repeatable, passed to `typst --input` (`lang=xx` also sets the Meta File `lang`, render.py:404-407); `--typst` default `typst`; `--reference-date` ISO date | 0/1/2; creates `revisions/<id>/` (inputs/, render.log, render.json, checks.json, cv.pdf, cv.meta.json status `render`); refuses before writing without `candidate.json`, `cv.typ` (workspace.py:82-84), `envelope.json` (outputs.py:230-247), invalid record (validate.py:154-174), missing portrait, bad literal reads, no Typst | lead | scripts/cv.py:43-49, :67-78; render.py:308-420 |
| `cmd.cv-approve` | `python scripts/cv.py approve <workspace> <revision> --approver "<name>" --sha256 <12+ hex> [--test-only]` | `--approver` required; `--sha256` required (prefix >= 12, workspace.py:18, :59-64); `--test-only` refused under `private/` | 0 (also when already approved, `already_approved: true`); 2 refused; writes `cv.approval.json`, re-stamps Meta File `approved` (never downgrades `delivered`) | owner only for a real client | scripts/cv.py:51-56; approve.py:6-45 |
| `cmd.cv-export` | `python scripts/cv.py export <workspace> <revision>` | positional only | 0 / 2; copies cv.pdf + cv.approval.json to `exports/<revision>/` via `.partial-<id>-<hex>`; idempotent; never compiles | not stated (atlas says lead; inferred lead after owner's approval) | scripts/cv.py:58-60; export.py:53-98 |
| `cmd.cv-status` | `python scripts/cv.py status <workspace>` | positional only | 0; JSON list: revision, state (`incomplete`, `corrupt`, `failed`, `changed`, `checks-failed`, `rendered`, `approved`, `exported`, `export-conflict`), sha256[:12], warnings; `partial_exports` | lead / owner | scripts/cv.py:62-63, :85-89; __init__.py:9-26; workspace.py:178-218 |
| `cmd.outputs-stamp` | `python scripts/outputs.py stamp <pdf> status=<status> [key=value ...]` | `pdf` path; `fields` key=value (`pages` parsed as int) | 0 prints Meta File; 2 `REFUSED` (outside a home, invalid against schema, missing/invalid envelope.json for client kinds) | lead (draft `sent`/`signed-off`/`superseded`; revision `delivered`) | scripts/outputs.py:24-43; outputs.py:275-312 |
| `cmd.outputs-check` | `python scripts/outputs.py check [--private]` | `--private` adds `private/*/draft/draft-*.pdf`, `revisions/*/cv.pdf`, `reference.pdf` | 0 none, 1 any problem; prints `FAIL <pdf>: <reason>` | lead (not named in any client step) | scripts/outputs.py:27-28, :44-48; outputs.py:338-366 |
| `cmd.typst-compile-draft` | `typst compile --root . --font-path packages/cv-framework/fonts private/<envelope>/draft/draft-NN.typ private/<envelope>/draft/draft-NN.pdf` | - | Typst exit code | lead | CW:258-261, ATL:306-308 |
| `cmd.typst-compile-example` | `typst compile --root . --font-path packages/cv-framework/fonts <entry> builds/<name>-01.pdf` | - | public examples only | lead | NCV:91-92, AGENTS.md:123 |
| `cmd.typst-watch-preview` | `typst watch --root . --font-path packages/cv-framework/fonts private/<envelope>/cv.typ builds/<name>-preview.pdf` | - | live preview, not a Revision | lead | BC:151-159 |
| `cmd.typst-compile-design-preview` | (no exact command) "compile the previews into `builds/design-review-input-<timestamp>/`" | - | client pages outside `private/`; must be cleared by path afterwards | lead | NCV:69-80 |
| `cmd.text-check-wording` | `python -c "import pymupdf,sys; ... print([w for w in ('fictional','illustrative','flagship') if w in t])" private/<envelope>/revisions/<id>/cv.pdf` | - | prints `[]` when clean | lead | BC:103-113, NCV:96-101 |
| `cmd.page-png` | pymupdf `doc[i].get_pixmap(dpi=96).save("builds/<new-folder>/cv-pN.png")` | - | visual evidence | lead / design-reviewer (`builds/design-review-<timestamp>/`) | `.claude/skills/verify-cv/SKILL.md:62-71`, NCV:96-97, `design-reviewer.md:46-48` |
| `cmd.intake-form-run` | `createIntakeForm` in a script.google.com project named after the Alias (file = `intake/form-NN.gs`) | FORM block only | prints answer link, edit link, Sheet link | owner | `scripts/intake-form.gs:1-21`, `:78`; CW:100-108; ATL:132-137 |
| `cmd.design-review` | `python scripts/design_review/server.py [--repo PATH] [--port 8765] [--no-browser] [--no-private]` | as listed | local app on 127.0.0.1; indexes client drafts and revisions unless `--no-private` | owner | `scripts/design_review/server.py:1-12`, `:357-362`; AGENTS.md:129 |
| `cmd.suite` | `python tests/run.py [--typst PATH]` | - | PASS / failure; only for public changes a client job makes | lead | AGENTS.md:122, `verify-cv/SKILL.md:9-16` |
| `cmd.build-release` | `./scripts/build.ps1 [-HideVesselDurations] [-Release]` | - | public examples only; not part of a client job | lead (Release needs owner's go) | AGENTS.md:119-121, NCV:26-31 |
| `cmd.sha256-draft` | (no command given) "write its SHA-256 in the Envelope's README.md" when a draft is sent | - | - | lead | CW:272-275, NCL:65-67 |

### 1.4 Schemas and contracts (`schema.*`)

| ID | File / location | Validates | Where validation runs | Anchors |
|---|---|---|---|---|
| `schema.marine-candidate` | `packages/domains/marine/schema/candidate.schema.json` (Draft 2020-12, `additionalProperties:false`, required identity, companies) | `candidate.json` when cv.typ imports a marine domain path with no template and not `lib.typ` (rare) | `CVW/validate.py:113-136` (`schema_for`), `:154-174` (`validate_record`), called by `render.py:328`; tests `tests/run.py:83-85` ($defs equal to flagship-input) | file :1-12 |
| `schema.flagship-input` | `packages/domains/marine/templates/flagship/schema/flagship-input.schema.json` | `candidate.json` (+ `copy`) for any cv.typ importing `/packages/domains/marine/lib.typ` or a flagship template path | same; the usual marine case; tests `tests/run.py:45-66`, `tests/workflow.py:74-85, :227` | file :1-12; validate.py:108-109 |
| `schema.none-oneoff` | (no schema) one-off Template importing only `/packages/cv-framework/lib.typ` | nothing; `schema: null`; Typst-side `normalize-common`/`validate-common` recommended | validate.py:160-162; NCV:46-49; CW:286-288 | `packages/cv-framework/core/data.typ:14, :29` |
| `schema.typst-candidate-asserts` | `normalize-candidate` / `validate-candidate` (Typst) | totals and shape at compile time | `packages/domains/marine/data.typ:33, :75-76`; `flagship.typ:22` | NCV:44-45 |
| `schema.meta-file` | `packages/cv-workflow/cv_workflow/output.schema.json` (`$id cvgen.output/1`) | every `<pdf-stem>.meta.json`: kinds `concept`, `text-draft`, `example`, `client-cv`, `client-draft`; client kinds require `alias`; status enums per kind | `CVW/outputs.py:259-266` (`validate`), used by `stamp` (:308-310), `load`/`scan` (:315-366); `scripts/outputs.py`; `tests/run.py`; Design Review app | output.schema.json:1-40; PDF:115-156 |
| `schema.envelope` | No file. Code only: `ENVELOPE_FIELDS = ('alias','domain','candidate','rank')` non-empty strings, each value checked against the matching property of `output.schema.json` (alias `^client-\d{4}-\d{2}-\d{2}(-\d+)?$`, domain `^[a-z][a-z0-9-]*$`) | `private/<envelope>/envelope.json` | `CVW/outputs.py:193, :230-247`; called by `render.py:324`, `approve.py:18`, `stamp` for client kinds (`outputs.py:295-300`); not by export | CW:69-77, BC:28-35 |
| `schema.output-homes` | Code only: `home_of()` path rules | where each kind of PDF may live: `private/<env>/draft/draft-\d+.pdf` -> `client-draft`; `private/<env>/revisions/<id>/cv.pdf` -> `client-cv`; `private/<env>/reference.pdf` -> `client-cv`; plus concept/example homes | `CVW/outputs.py:204-227` | PDF:123-129 |
| `schema.render-record` | Code only: `render.json` shape (revision, candidate = folder name, created_at, status, exit_code, engine, compiler, inputs{entry,candidate{schema},assets,files,compiler_inputs}, settings, pdf{path,sha256,bytes}) | read back by approve/export/status | written `render.py:372-392`; read `workspace.py:134-150`, `:192-218` | `packages/cv-workflow/README.md:33-43` |
| `schema.checks-record` | Code only: `checks.json` (pdf_sha256, passed, errors, certificates{...}) | gate for approve/export | written `render.py:393-403`, `checks.py`; read `workspace.py:152-162` | README.md:41 |
| `schema.approval-receipt` | Code only: `cv.approval.json` {revision, candidate, sha256, bytes, approver, approved_at, scope `owner`/`test-only`} | export gate; state | written `approve.py:34-43`; read `workspace.py:164-176`; copied/compared `export.py:88-98` | PDF:166-170 |
| `schema.intake-form-spec` | Code only: the `FORM` block of `scripts/intake-form.gs`, item kinds page/section/consent/short/long/choice/checks/dropdown/scale/grid/date | per-client `intake/form-NN.gs` | `checkForm_` in `scripts/intake-form.gs:117-160` (runs in Apps Script) | intake-form.gs:20-40 |
| `schema.text-draft-params` | Code only: `text-draft.with(title, client:(name, greeting, label), draft, date, samples, lang, check-lang, copy)` and `#fact[...]` | `draft/draft-NN.typ` | Typst asserts in `scripts/text-draft.typ`; tests `tests/run.py:330-359` (Check Page overflow, missing house copy) | text-draft.typ:1-26 |
| `schema.research-note` | Doc only: Research Library note header (Checked / Recheck after / Question / Review), numbered claims `[S#]` | `docs/research/<scope>-<topic>.md` | none (reviewed by research-reviewer) | `docs/research/README.md:8-24` |

### 1.5 Glossary terms naming workflow entities

| Term | Summary | Entity type | GL anchor |
|---|---|---|---|
| `Client` | Person the CV is for; code says "candidate" | actor | GL:46 |
| `Envelope` | One client's folder `private/<envelope>/` with `envelope.json` and drawers | artifact (container) | GL:47 |
| `Alias` | `client-<yyyy>-<mm>-<nn>`, neutral name outside `private/` | artifact (identifier) | GL:48 |
| `Drawer` | `intake/`, `research/`, `draft/` | artifact (folder) | GL:49 |
| `Intake` | Collecting facts and goals before research | stage | GL:50 |
| `Relay` | Intake method: Claude writes, owner passes on and brings back | action (method) | GL:51 |
| `Intake Form` | Optional Google Form made by a per-form Apps Script | artifact | GL:52 |
| `Research Library` | Shared dated notes in `docs/research/`, no client data | artifact (store) | GL:53 |
| `Scout` | Wide shallow first search; `research/scout.md` | step | GL:54 |
| `CV Decisions` | Choices the CV must make; `research/decisions.md` | step + artifact | GL:55 |
| `Deep Dive` | One agent on one open question; `research/deep-dive-<topic>.md` | step + artifact | GL:56 |
| `Text Draft` | Content PDF in house design First Fitting; `draft/draft-NN.pdf` | artifact | GL:57 |
| `Check Page` | Page 1 of a Text Draft | artifact (part) | GL:58 |
| `House Copy` | Fixed Greek wording of the Check Page | artifact (part) | GL:59 |
| `Fact Mark` | Copper underline `#fact[...]` | artifact (part) | GL:60 |
| `Sign-off` | Client's OK on the Text Draft; `draft/sign-off-NN.png` | gate | GL:61 |
| `Revision` | One render folder `revisions/<id>/` | artifact | GL:62 |
| `Approval` | Owner's act bound to SHA-256; `cv.approval.json` | gate + action | GL:63 |
| `Export` | Verified copy in `exports/` | action + artifact | GL:64 |
| `Release` | Public example PDFs (not client) | artifact (out of client scope) | GL:65 |
| `Output Contract` | Every shown PDF in its home with a Meta File | rule / gate | GL:66 |
| `Meta File` | `<pdf-stem>.meta.json` | artifact | GL:67 |
| `Framework Gap` | Recorded bypass (one-off client Template) | artifact | GL:69 |
| `Certificate Warning` | WARNING line at render; never blocks | check (non-blocking gate) | GL:73 |
| `Live Read` | Render read a live private file; fails checks | check (gate) | GL:74 |
| `Batch Test`, `Three-Second Test`, `Flagship Parity` | Design tests for a client design | gate | GL:75, :76, :78 |
| `Style`, `Design Tier`, `Density` | Selection keys the owner picks for a client design | artifact attributes / owner choice | GL:77, :79, :81 |
| `Design Review` | Owner's local app | tool | GL:84 (row 82) |
| `Idea Run` | Closed loop idea agent + reviewers | stage (sub-flow) | GL:83 |
| `Domain`, `Rank`, `Template` | Envelope fields / design target | data attributes | GL:38, :41, :42 |
| `Atlas` | Picture book; never source of a rule | documentation | GL:84 |

Terms used for workflow entities but NOT in the glossary: "facts" / `facts.md` and "gap list" (CW:165-172), "follow-up" (CW:231), "Handover" (CW:278), "consent" (CW:158; ATL step `consent`), "delete-by date" (CW:297-305), "First Fitting" (CW:251), "design run" (ATL page `design-run`, `idea-run/SKILL.md:26`), "lead" (SITE:60), "draft fingerprint" (CW:37), "stall" (SITE notes), "candidate workspace" (GL:47 mentions it as a doc synonym).

### 1.6 Envelope layout (`private/<envelope>/`)

| Sub-path | What | Written by | Anchors |
|---|---|---|---|
| `README.md` | alias + intake date (top), decisions, draft SHA-256 fingerprints, Google links, evidence paths, "Delivered <date>. Delete by <date+12m>" | lead | CW:37-38, CW:63-67, CW:107-108, CW:272-275, CW:297; NCL:15-16, :73-75; BC:17 |
| `envelope.json` | `{alias, domain, candidate, rank}` | lead | CW:39, :69-77; BC:18, :28-35; NCL:17-20; code outputs.py:230-247 |
| `intake/messages.md` | every answer as received | owner (chat copy, CW:87-88); lead (form answers copied in, CW:121-122) | CW:41, ATL:116 |
| `intake/documents/` | photos and files from the client | owner | CW:42, CW:88-89 |
| `intake/facts.md` | extracted facts + gap list | lead | CW:43, :167-172; NCL:31-33 |
| `intake/form-NN.gs` | per-form Apps Script copy | lead | CW:44, :94-96; NCL:27-29 |
| `intake/answers-NN.csv` | downloaded form answers | owner | CW:45, :114-121 |
| `research/scout.md` | Scout findings | lead (or general-purpose) | CW:47, :183-184; NCL:34-36 |
| `research/decisions.md` | CV decisions | lead | CW:48, :188; NCL:37 |
| `research/deep-dive-<topic>.md` | Deep Dive text | lead saves what general-purpose returns | CW:49, :213; NCL:41-42 |
| `research/reviews/<topic>-NN.md` | research-reviewer reports per Deep Dive and round | lead | CW:50, :219-221; NCL:46 |
| `draft/draft-NN.typ`, `draft/draft-NN.pdf` | Text Draft source and PDF | lead | CW:52, :250-252; NCL:58 |
| `draft/draft-NN.meta.json` | Meta File: `sent` -> `signed-off` / `superseded` | lead via `outputs.py stamp` | CW:53, :263-267; NCL:62-69 |
| `draft/sign-off-NN.png` | client's OK screenshot | owner provides, lead files (NCL:67-68 "His screenshot ... goes in draft/") | CW:54, :275-276 |
| `candidate.json` | facts record | lead | CW:55; BC:20; NCV:19-20 |
| `cv.typ` | entry point | lead | CW:55; BC:21 |
| `portrait.<ext>` | authorised photo | owner supplies (inferred), lead places | BC:22; NCV:20 |
| `assets/` | optional prepared portrait / one-off art | lead | PDF:80-81; `docs/framework-gaps.md:116` |
| `presentation.json`, local `.typ` helpers, images | one-off/custom data read by cv.typ | lead | BC:23, :262-273; CW:288-290; PREF:65 |
| `reviews/design-NN.md` | design-reviewer reports on the client CV | lead | CW:56; NCV:77-78 |
| `reviews/text-NN.md` | "review reports on the CV's ... text" | nobody (no step writes it) | CW:56 only |
| `revisions/<id>/inputs/{cv.typ,candidate.json,assets/,<files>}` | snapshot | `cv.py render` | render.py:340-359; PDF:83-86 |
| `revisions/<id>/render.log`, `render.json`, `checks.json`, `cv.pdf` | render outputs | `cv.py render` | workspace.py:126-131; render.py:369-403 |
| `revisions/<id>/cv.meta.json` | Meta File `render` -> `approved` -> `delivered` | `cv.py render`, `cv.py approve`, lead (`delivered`) | render.py:405-407; approve.py:31,44; BC:203-204 |
| `revisions/<id>/cv.approval.json` | approval receipt | `cv.py approve` (owner) | approve.py:34-43 |
| `exports/<id>/cv.pdf`, `exports/<id>/cv.approval.json` | verified copies | `cv.py export` | export.py:69-85 |
| `exports/.partial-<id>-<hex>/` | in-progress export | `cv.py export` | workspace.py:16-17, export.py:70 |
| `reference.pdf` (+ `reference.meta.json`) | a CV delivered before `cv.py` | historical / lead stamps | outputs.py:225-226, :348-349; PDF:129; `docs/proposals/output-contract.md:15` |

Outside the Envelope but holding client material: `builds/design-review-input-<timestamp>/` (NCV:69, cleared at loop end NCV:79-80), `builds/design-review-<timestamp>/` (design-reviewer's own renders, `design-reviewer.md:47`), `builds/<new-folder>/cv-pN.png` (`verify-cv/SKILL.md:69-70`), `builds/<name>-preview.pdf` (BC:155), Google Form/Sheet/script project in the owner's Drive (CW:127-128), `docs/work/research-<topic>/reviews/` (client-free Library reviews, CW:226-227).

---

## Part 2 - Drift report

Judged by code first, then by the more specific/most recent source.

1. **Envelope placeholder has six spellings.** CW:259 / ATL:65 / GL:47 `private/<envelope>/`; NCL:13, NCV:20, ATL:60 `private/<name>-<rank>/`; `scripts/cv.py:3-6`, AGENTS.md:124-126, PDF:72 `private/<candidate>/`; `packages/cv-workflow/README.md:24` `private/<name>`; `docs/reference/candidate-schema.md:45` `<candidate-folder>`; BC:16 `jane-doe-second-engineer`. Code has no naming rule (workspace.py:75-89). Resolution: use `<envelope>` everywhere as the placeholder; keep the naming rule (`<name>-<rank>`) only in CW §1.
2. **"Workspace"/"candidate workspace" vs `Envelope`.** Code and CLI say workspace (workspace.py:72-73, cv.py:1, AGENTS.md:105); GL:47 lists it as a doc synonym, GL rule 1 (GL:11-13) says the term wins in prose. Resolution: prose says `Envelope`; code keeps `Workspace` until renamed.
3. **Atlas says the Intake Form replaces the chat message.** ATL:92 "Optional: a designed Google `Intake Form` instead." vs CW:91-93 "Beside the chat message" and `docs/proposals/client-workflow.md:76-80` "beside the Relay message, never instead of it". Resolution: CW/proposal decision is right; fix ATL.
4. **When "Delivered <date>" is written.** CW:297 and NCL:73-75 write it "At `Export`" (before sending); ATL:525-529 writes it at the "Send it" step after the owner sends; the Meta status `delivered` comes only after sending (BC:202-204). Resolution: write the README line when the owner confirms sending (same moment as `status=delivered`), so the delete-by date counts from delivery as the consent text says (CW:133-136).
5. **`status=sent` is stamped before the draft is sent.** CW:258-261 and NCL:62-63 stamp `status=sent` right after compiling; the owner sends later (NCL:65-66 "When he sends it, write its SHA-256"). Schema has no pre-send status (output.schema.json client-draft enum `sent, signed-off, superseded`). Resolution: owner decision needed; either stamp at send time or add a `ready` status to the schema (code change).
6. **Meta-file kind `text-draft` is not a `Text Draft`.** Schema kind `text-draft` (output.schema.json:376, :398-399) means a design-concept direction under `design-concepts/` (PDF:126); a client's `Text Draft` is kind `client-draft` (PDF:128, outputs.py:221-222). One word, two things (violates GL rule 3). Resolution: rename the concept kind (e.g. `text-draft-concept`) in code and schema, or add it to GL "Words with two meanings".
7. **Two state vocabularies for a Revision.** `cv.py status` states `incomplete/corrupt/failed/changed/checks-failed/rendered/approved/exported/export-conflict` (workspace.py:178-218) vs Meta File status `render/approved/delivered` (output.schema.json:402-403). `rendered` vs `render`; `exported` has no Meta status; `delivered` has no cv.py state. No doc maps them. Resolution: code is right on both; document the mapping in PDF Lifecycle (and later the YAML model).
8. **`delivered` and `signed-off` have no guard in code.** `outputs.py stamp ... status=delivered` succeeds on any revision, approved or not (outputs.py:275-312 checks only schema); `signed-off` needs no `sign-off-NN.png`. Docs imply order (BC:202-204, CW:265-276). Resolution: docs are the intent; add code checks or state the gap.
9. **Design-reviewer renders client pages to a folder nobody clears.** NCV:69, :79-80 clear only `builds/design-review-input-*`; `design-reviewer.md:46-48` renders into `builds/design-review-<timestamp>/`; `verify-cv/SKILL.md:69-70` saves client page PNGs to `builds/<new-folder>/`. Client data outside `private/` with no clearing rule. Resolution: NCV should clear `builds/design-review-*` too and verify-cv should send client PNGs to the same cleared folder (privacy rule CW:313-315).
10. **One-off Template: "one cv.typ" vs helper files.** NCL:71-72 "a one-off `Template` in one `cv.typ`"; CW:288-290 and BC:265-273 allow files beside `cv.typ`; code copies them (render.py:272-305); `docs/framework-gaps.md:116` records helpers and `assets/`. Resolution: code and CW are right; fix NCL.
11. **Who writes `intake/messages.md` and the other intake files is inconsistent with the permission list.** CW:87-88 owner copies chat; CW:121-122 Claude copies form answers; ATL:116 owner only; PREF:63-66 lets agents edit `intake/facts.md`, `research/`, `draft/`, `README.md`, `envelope.json`, `candidate.json`, `cv.typ`, `presentation.json` but not `intake/messages.md`, `intake/form-NN.gs` or `reviews/`. Resolution: extend PREF's list to the files CW says Claude writes.
12. **`reviews/text-NN.md` is a phantom artifact.** Listed in CW:56; no step, skill, agent or code writes it; no text reviewer exists. Resolution: remove from CW or define the text review step.
13. **`intake/answers-NN.csv` missing from the skill and atlas.** CW:45, :114-121; GL:52 lists it; NCL:27-30 and ATL:94-96/:128-131 omit it. Resolution: add to NCL step 2 and ATL `relay` outputs.
14. **`reference.pdf` is a code home but not in any Envelope layout.** outputs.py:225-226, :348-349; PDF:129; missing from CW:35-57, BC:15-26, NCV:18-25. Resolution: add to the CW tree as a legacy item, or retire it in code.
15. **`assets/` and portrait location differ.** PDF:80-81 lists an optional `assets/` folder; BC:22 and NCV:20 put `portrait.<ext>` at the root; render.py:336-338 refuses a cv.typ read of `assets/<portrait name>` that is not the portrait. Resolution: code allows either; list both in the CW tree.
16. **Package README omits the Meta File and `envelope.json`.** `packages/cv-workflow/README.md:33-43` "What each step writes" has no `cv.meta.json`; its refusal rules (:50-59) do not mention the `envelope.json` refusal (render.py:324, approve.py:18). Resolution: code is right; update the README.
17. **`approve` also requires `envelope.json`; only render is documented.** approve.py:18 vs BC:28-30, CW:70-71, NCL:19-20 ("cv.py render refuses without it"). Export does not check it (export.py:60-64). Resolution: document approve's refusal.
18. **`--input` (and `lang=` -> Meta File `lang`) is undocumented in the guides.** scripts/cv.py:46, render.py:404-407; only `docs/framework-gaps.md:116` shows `--input design=... --input lang=el|en`; BC and NCV document only `--pages`. Resolution: add `--input`, `--typst`, `--reference-date` (BC:149 has the last) to BC §3.
19. **Guide's flow line and table stop short of the atlas flow.** CW:12-15 flow omits Envelope, Facts, the design stage (Idea Run, pick, design-reviewer), Render and Deliver; CW table (CW:17-27) ends at "9. Handover". ATL has 7 phases / 19 steps (open, intake, research, text, design, deliver, after). Resolution: one stage list; CW is the rule owner, so it should name every stage the atlas shows (atlas is "never the source of a rule", GL:84).
20. **Atlas lets a marine client skip design review; new-cv puts the design-reviewer loop under the no-Template branch.** ATL:333-339 branches marine Sign-off -> `build-cv` (which carries a design-reviewer gate, ATL:408-418); NCV:61-80 introduces the design-reviewer loop inside "A client whose `Domain` has no `Template` yet". Whether a marine Flagship CV gets a design-reviewer round is ambiguous. Resolution: owner decision; then state it in NCV step 3.
21. **Export actor unnamed.** ATL:498 actor `lead`; BC:191-199 and NCV:104-105 ("export follows it") name nobody; PREF:73-74 (overwriting exports needs his go) does not cover creating one. Resolution: state in BC §6 that the lead runs export after the owner's approval (inferred intent).
22. **Stall rule wording differs.** CW:300-302 "three months pass without progress since the intake date"; NCL:96-97 and ATL:43 "no `Export` three months after intake". Resolution: NCL wording (checkable from README dates) is the operational one; align CW.
23. **Deep Dive chosen "after the Scout" vs after CV decisions.** GL:56 "chosen by the owner after the `Scout`"; CW:204 and NCL:37-39 the owner picks from open CV decisions (step 5). Resolution: GL should say after `CV Decisions`.
24. **Research Library review path.** CW:226-227 `docs/work/research-<topic>/reviews/`; `docs/research/README.md:28-30` `docs/work/<task or client-free id>/reviews/`. On disk: `docs/work/research-greece-japan-tour-leaders/reviews/`. Resolution: CW form matches disk; align README.
25. **Two names for the same sub-flow: `Idea Run` vs "design run".** GL:83 `Idea Run`; ATL page id `design-run` and step "A design run for this client" (ATL:357-358); `idea-run/SKILL.md:26` "A design run". Resolution: use `Idea Run`, or add "Design Run" to GL as a kind of Idea Run.
26. **Alias pattern.** GL:48 and CW:63-64 `client-<yyyy>-<mm>-<nn>`; code accepts an optional `-N` suffix (`output.schema.json:379`). Resolution: document the suffix or drop it from the schema.
27. **`domain` ids not enforced.** GL:38 "a new `Domain` gets its id here first" (ids `marine`, `travel`); code accepts any `^[a-z][a-z0-9-]*$` (output.schema.json:377); `tests/run.py:70` uses `travel-and-tourism` as a domain path. Resolution: fine as long as docs say "lowercase id"; note the test name differs from the glossary id `travel`.
28. **Envelope README content described two ways.** CW:37-38 (alias, intake date, decisions, fingerprints, dates, Google links) vs BC:17 and NCV:22-23 ("how to build, what was decided, where the evidence is"). Resolution: union, owned by CW.
29. **AGENTS.md Envelope summary incomplete.** AGENTS.md:112 lists `envelope.json, intake/, research/, draft/, candidate.json, cv.typ, revisions/, exports/`; omits `README.md`, `reviews/`, portrait. Resolution: minor; point to CW §1 instead of listing.
30. **Client review loops not in `docs/review.md`.** AGENTS says reviews follow `docs/review.md`; the Deep Dive and client-design loops (caps 5/10, storage in the Envelope) live only in CW:215-221, NCL:42-47, NCV:66-80; `docs/review.md` mentions clients only at :96 (privacy lens). Resolution: acceptable (skills own the loop), but a link from review.md would remove the gap.
31. **`cv.py` record check named as "the Flagship input schema" only.** NCV:40-43 vs code that picks among template schema, Flagship schema, domain `candidate.schema.json` or none (validate.py:113-136). Resolution: code is right; NCV is a simplification, acceptable.
32. **Proposal body still says "No web form" and "plain text draft".** `docs/proposals/client-workflow.md:33`, `:41` vs later decisions in the same file (:70-84). Not wrong (decisions amend) but a reader of the body alone gets the old rule. Resolution: none needed if the model treats CW as owner; note only.
33. **`outputs.py check --private` is never part of a client step.** It is the only command that lists unstamped or stale client PDFs (outputs.py:338-349) but CW/NCL/NCV never call it. Resolution: add it to the end of NCL step 8 and NCV step 4 (suggested).
34. **Roster claims every agent runs Opus/high.** SITE roster tldr (`roster.json:9`) vs `repo-auditor-lite.md` `model: inherit`, `effort: medium`; Codex agents carry no model at all. Not client-workflow critical. Resolution: fix the roster sentence.

Referenced files and commands verified to exist: all 23 paths checked (examples/candidates/{engineer,captain,chief-officer}-example.json, flagship themes/artwork/layouts incl. `flagship-one-page.typ`, roles deck/engine, docs/reference/{layout-and-pagination,candidate-schema,skills-component}.md, `docs/research/cv-intake-practice.md`, `brand/forms/intake-header.png`, `scripts/{intake-form.gs,text-draft.typ,build.ps1}`, `docs/work/research-greece-japan-tour-leaders/`). Every `cv.py` subcommand and flag named in the docs exists in argparse. No reference to a missing file or command was found. `python .atlas/_kit/atlas.py check` reports all five pages "ok, verified 2026-10-04"; spot-checked ATL line anchors resolve to the right passages (minor: ATL:463 cites `NCV:104-114` for the render step, which is the approval/report section; render is NCV:89-92).

---

## Part 3 - Statistics: how many places describe each stage

Places counted: CW, NCL, NCV, BC, ATL, SITE (glossary/actor copy), GL, `docs/proposals/client-workflow.md` (PROP), PDF, `packages/cv-workflow/README.md` (PKG), AGENTS.md, PREF, agent files, other skills, code. Lines are approximate prose lines devoted to the stage.

| Stage | Places | Where (approx. lines) | ~Lines total |
|---|---|---|---|
| Envelope (open, layout, alias, envelope.json) | 11 | CW 49 (§1) + 11 (table/rules); NCL 8; NCV 16; BC 26; ATL 50; system-map 50; GL 3; PDF 26; AGENTS 1; PREF 3; code (outputs.py envelope 18) | ~260 |
| Intake (Relay, question list, consent, Intake Form) | 7 | CW 85; NCL 10; ATL 85; GL 3; PROP 3+10; `scripts/intake-form.gs` header 21; `docs/research/cv-intake-practice.md` (question set) | ~220 |
| Facts + gap list | 4 | CW 8; NCL 3; ATL 20; PREF 1 | ~32 |
| Scout | 6 | CW 11; NCL 3+14 (brief); ATL 20; GL 1; PROP 1; `docs/research/README.md` 39 (shared with Deep Dive) | ~60 (+39 shared) |
| CV Decisions | 4 | CW 21; NCL 3; ATL 20; GL 1 | ~45 |
| Deep Dives (+ research-reviewer loop, Library) | 7 | CW 22; NCL 13; ATL 33; GL 1; PROP 2; `research-reviewer.md` 14; `docs/research/README.md` | ~120 |
| One follow-up | 5 | CW 15; NCL 5; ATL 21; PROP 1+5; GL (Relay) 1 | ~48 |
| Text Draft | 8 | CW 30; NCL 12; ATL 22; GL 4 (Text Draft, Check Page, House Copy, Fact Mark); PDF 2; `scripts/text-draft.typ` header 26; AGENTS 1; schema 1 | ~100 |
| Sign-off | 7 | CW 5; NCL 3; ATL 35; GL 1; PROP 3; PDF 1; NCV 3 | ~50 |
| Design (Idea Run for client, pick, design-reviewer loop) | 7 | CW 11; NCV 24; ATL 80; `idea-run/SKILL.md` 5; `design-reviewer.md` 10; `magazine-editor.md` (general); `docs/framework-gaps.md` 25 | ~160 |
| Build the CV (candidate.json, cv.typ, page plan, one-off) | 6 | BC 160 (§1, §2, §4, §8); NCV 50; CW 15 (§9); ATL 35; system-map 10; framework-gaps | ~270 |
| Render a Revision | 8 | BC 45; NCV 6; ATL 26; PDF 30; PKG 50; AGENTS 2; system-map 10; code render.py 214 + workspace.py | ~170 prose + ~430 code |
| Approval | 8 | BC 9; NCV 3; ATL 26; GL 1; PDF 6; PKG 6; AGENTS 3; PREF 2; code approve.py 45 | ~56 prose + 45 code |
| Export | 7 | BC 11; ATL 22; GL 1; PDF 6; PKG 7; AGENTS 1; code export.py 52 | ~48 prose + 52 code |
| Delivery (send, re-stamp, Delivered line) | 5 | CW 4; NCL 3; BC 3; ATL 21; PDF 4 | ~35 |
| Retention / stall / delete | 5 | CW 9; NCL 13 (report section); ATL 20; PREF 3; consent text CW 4 | ~50 |

Summary: every stage from Envelope to Sign-off is described in 4-8 places; the guide, the skill and the atlas each restate all of them (CW 318 lines, NCL 105, NCV 114, BC 280, ATL 563 JSON lines), so the workflow text exists roughly three times over, plus the code for Render/Approve/Export (cv.py 98 + cv_workflow ~920 lines) which is the only enforced source.
