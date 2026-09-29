# Glossary

Read this before writing to the owner, a proposal or a document. It is the
one list of CVgen's official terms. A term means exactly what its line says;
the code name column is where it lives today. Agents keep this list
(owner, 2026-09-25): they add, rename and drop terms themselves and tell the
owner afterwards.

## Rules

1. **Use the official term, never a synonym.** If the owner, a document and
   the code use different words for one thing, the term below wins in prose;
   code keeps its name until a task renames it.
2. **Backticks in replies to the owner.** Every official term in a reply is
   wrapped in backticks: `Domain`, `Envelope`, `Sign-off`. Documents may do
   the same where it helps the reader; they are not required to.
3. **Agents own the vocabulary.** Add, rename or drop a term without asking
   when you notice: a concept that has come up twice without a name; two
   words used for one thing (the owner says one, the repo another); one
   word used for two things; or a new term the owner coins. Write the
   meaning in one line, where it lives, and the date. An agent that may not
   write this file (the idea agents) returns the term to the lead, who adds
   it. A term that exists only in an undecided proposal or concept gets
   "pending: <path>" as its code name and is dropped if the idea is
   rejected. A rename or drop updates the prose that uses the term in the
   same change, or the change records the prose update still owed.
4. **Tell the owner afterwards.** Name every term you added, renamed or
   dropped in your next report or Recap to him ("New terms: `Scout`,
   `Deep Dive`"). If he dislikes one, it changes then; no approval step.
5. **Dropped terms stay listed** so nobody brings them back.

## Terms

| Term | Meaning | Code name today | Added |
|---|---|---|---|
| `CVgen` | The product: premium, hand-crafted CVs built with AI on our own Typst `Framework` (owner's words, also in `docs/vision.md`) | the repository | 2026-09-25 |
| `Framework` | The shared Typst core every CV is built on: page frame, headings, data merge and checks. Knows no `Domain` | `packages/cv-framework/` (core, fonts; its `lib.typ` exports core names only; docs say "core" for `core/`). Each `Domain`'s `lib.typ` re-exports it (ADR 0012) | 2026-09-25 |
| `Domain` | A career area with its own facts shape, wording, artwork and rules: `Marine`, `Travel & Tourism`, `Software Development`. Not a web address | `packages/domains/<id>/`, each with its own `lib.typ`; only `marine` exists. Ids, as `domain` in a `Meta File` and `envelope.json`: `marine`, `travel` (Travel & Tourism, no package yet); a new `Domain` gets its id here first | 2026-09-25, owner; ids 2026-09-30 |
| `Surface` | A package's `lib.typ`: the one file entry points import. The `Framework`'s holds core names only; each `Domain`'s adds its own | `packages/cv-framework/lib.typ`, `packages/domains/<id>/lib.typ` | 2026-09-25 |
| `Role` | One specialisation inside a `Domain`, never a fork of it: `Deck` and `Engine` in `Marine` | `domains/marine/roles/deck`, `roles/engine` | 2026-09-25 |
| `Rank` | The client's job title: second engineer, chief officer, captain, tour guide; inside a `Role` where the `Domain` has roles | `identity.rank` in the marine facts; folder and file names say "role" for it (`jane-doe-second-engineer`) | 2026-09-25 |
| `Template` | A named CV design. Belongs to a `Domain`, or lives in one `Envelope` as a one-off for a single client | `templates/flagship/` (`Flagship`); a one-off is a "custom composition" in `private/<envelope>/cv.typ` | 2026-09-25 |
| `Theme` | A `Template`'s colours, fonts and sizes only | `templates/<t>/themes/` | 2026-09-25 |
| `Artwork Pack` | Which illustration goes in which slot of a `Template` | `templates/<t>/artwork/` | 2026-09-25 |
| `Layout` | Margins, gaps and which content lands on which page | `templates/<t>/layouts/`; docs also say "layout profile" | 2026-09-25 |
| `Client` | The person a CV is for, who also pays for it | the code and the data contract say "candidate" (`candidate.json`) | 2026-09-25 |
| `Envelope` | One `Client`'s folder: their facts, portrait, their own `Template` tweaks, every `Revision` and `Export` | `private/<envelope>/` with `envelope.json` (who the `Client` is: `alias`, `domain`, `candidate`, `rank`) and the drawers `intake/`, `research/`, `draft/`; docs also say "candidate workspace" | 2026-09-25, owner |
| `Alias` | The neutral name for a `Client` outside `private/`: `client-<yyyy>-<mm>-<nn>`, written in the `Envelope`'s `README.md` and its `envelope.json`. The `Envelope` folder name is client data | `docs/guides/client-workflow.md` step 1; `alias` in `envelope.json` and a client's `Meta File` | 2026-09-25 |
| `Drawer` | One of the `Envelope`'s workflow folders: `intake/`, `research/`, `draft/` | `docs/guides/client-workflow.md` step 1 | 2026-09-25 |
| `Intake` | Collecting a `Client`'s facts and goals before research: a question list sent by chat, answers kept in the `Envelope` | `docs/guides/client-workflow.md` step 2, `new-client` skill, `intake/` | 2026-09-25 |
| `Relay` | The `Intake` method: Claude Code writes the questions and follow-ups, the owner passes them to the `Client` by chat and brings the answers back | `docs/guides/client-workflow.md` steps 2 and 7 | 2026-09-25, owner |
| `Intake Form` | The `Relay` questions (or the follow-up) as an optional, designed Google Form, made by the owner running a per-form Apps Script; its answers land in a Google Sheet in his Drive | `scripts/intake-form.gs`, `intake/form-NN.gs`, `intake/answers-NN.csv`; `docs/guides/client-workflow.md` step 2 | 2026-09-28, owner |
| `Research Library` | Shared, dated research notes about a country, a `Domain` or a `Rank`, reused across `Client`s and rechecked after 6 months. No client data | `docs/research/` | 2026-09-25 |
| `Scout` | A wide, shallow first search for one `Client`: the `Research Library` first, the web for what is missing | `docs/guides/client-workflow.md` step 4, `research/scout.md` | 2026-09-25 |
| `CV Decisions` | The list of choices a CV must make (title wording, length, photo, language, `Template`, what leads), each with a sourced answer, a judgement or "open" | `research/decisions.md`, `docs/guides/client-workflow.md` step 5 | 2026-09-25 |
| `Deep Dive` | One agent researching one open question the CV must answer, chosen by the owner after the `Scout` | `docs/guides/client-workflow.md` step 6, `research/deep-dive-<topic>.md` | 2026-09-25 |
| `Text Draft` | The CV's content as a PDF in one fixed house design (First Fitting, not the CV's own design) that the `Client` checks before design starts; every fact to check carries a `Fact Mark`; a sent draft is never recompiled | `scripts/text-draft.typ`, `draft/draft-NN.pdf` | 2026-09-25, design 2026-09-28 |
| `Check Page` | The first page of a `Text Draft`, in the `Client`'s language (house copy in Greek): check only the underlined facts (names, dates, numbers, titles), reply OK | `client:` and `samples:` in `scripts/text-draft.typ` | 2026-09-25 |
| `House Copy` | The fixed wording of the `Check Page` (headline, intro, ask, reply lines, tag labels), in Greek; a client's draft overrides a line only through `copy:` | `house-copy` in `scripts/text-draft.typ` | 2026-09-28 |
| `Fact Mark` | The copper stitch under a fact the `Client` must check in a `Text Draft`; anything without it is our wording | `#fact[...]` in `scripts/text-draft.typ` | 2026-09-28 |
| `Sign-off` | The `Client`'s "OK, the facts are correct" on the text draft, before design starts; usually a chat message whose screenshot goes into the `Envelope`. Not a signature | `docs/guides/client-workflow.md` step 8, `draft/sign-off-NN.png`; the draft uses `scripts/text-draft.typ` | 2026-09-25, owner |
| `Revision` | One render of a CV in its own folder, never overwritten | `private/<envelope>/revisions/<id>/` | 2026-09-25 |
| `Approval` | The owner's act on one exact PDF, bound to its SHA-256. Agents never approve a real `Client`'s PDF | `scripts/cv.py approve`, `cv.approval.json` | 2026-09-25 |
| `Export` | The verified copy of a `Client`'s approved PDF, ready to deliver | `scripts/cv.py export`, `private/<envelope>/exports/` | 2026-09-25 |
| `Release` | The public example PDFs that show the product, with fictional people | `examples/<domain>/<template>/<name>.pdf` beside each entry point, written by `scripts/build.ps1 -Release` (root `exports/` until 2026-09-30) | 2026-09-25 |
| `Output Contract` | The rule that every PDF we show sits in the one home its kind has and carries a `Meta File`; the suite and the `Design Review` app list any PDF that breaks it | `docs/pdf-workflow.md`, "Output Contract"; `packages/cv-workflow/cv_workflow/outputs.py`, `scripts/outputs.py` | 2026-09-30 |
| `Meta File` | The small JSON file beside a PDF that says what it is (kind, `Domain`, candidate, status, pages) and holds its SHA-256; stale once the PDF changes without a re-stamp | `<pdf-stem>.meta.json`, written by `scripts/outputs.py stamp`; schema `output.schema.json` in `packages/cv-workflow/cv_workflow/` | 2026-09-30 |
| `Frozen Reference` | The PDF a `Template`'s public example must reproduce pixel for pixel | `templates/<t>/tests/approved/` | 2026-09-25 |
| `Framework Gap` | A recorded case of going around the `Framework`, a `Domain` or a `Template` to deliver a CV | `docs/framework-gaps.md` | 2026-09-25 |
| `Session Sweep` | The check for loose ends before a session ends: unreviewed commits, approved proposals, open cards, Night Shift items, Git leftovers, CI, `builds/`. A list of places to look, never of what is open | `docs/development.md`, "Ending a session" | 2026-09-28 |
| `Capacity Rule` | The count that says whether a record fits the one-page `Layout`: 3 per company, 1 per vessel row, 1 per certificate row (plus extra groups and wrapped lines); 14 or less fits on the cadet record, a longer profile or more education lowers it | `docs/reference/layout-and-pagination.md`, "Choosing a profile" | 2026-09-28 |
| `Vessel Particulars` | A vessel's size, main engine maker and engine power, printed on its vessel row in the unit the `Client`'s documents use, never converted | `ships[].tonnage`, `engine`, `power` in the marine facts | 2026-09-27 |
| `Certificate Warning` | A `WARNING:` line at render, repeated by `status`, saying a certificate on the CV has expired or expires within 180 days; it never fails the render or blocks `Approval` (owner, 2026-09-25) | `check_certificates` in `packages/cv-workflow`, `certificates` in `checks.json`, `WARNING:` lines from `scripts/cv.py` | 2026-09-27 |
| `Live Read` | A file an `Envelope` or `private/` holds that a render read directly instead of the `Revision`'s own copy; a `Revision` with one fails its checks and cannot be approved | `live_reads` in `packages/cv-workflow/cv_workflow/render.py` | 2026-09-27 |
| `Batch Test` | The first design test: in an HR batch of 100 to 200 CVs, ours cannot be skipped, even by someone trying to | `docs/vision.md`, "Design is the product"; `design-reviewer` | 2026-09-29 |
| `Three-Second Test` | The second design test: before a word is read, the page shouts its `Domain`, specialty and role (travel, Japan, tour escort) | `docs/vision.md`, "Design is the product"; `design-reviewer` | 2026-09-29 |
| `Style` | One idea of a `magazine-editor` run, drawn in both `Density`s and three `Design Tier`s each; a run has three very distinct ones. Its folder and its README row are still called a concept (a concept folder, a concept row), as are earlier runs' one-page proposals | `design-concepts/<date>-<slug>/` | 2026-09-29 |
| `Flagship Parity` | The third design test: side by side with the Marine Flagship, a CV looks as confident, crafted and premium | `docs/vision.md`, "Design is the product"; `design-reviewer` | 2026-09-29 |
| `Design Tier` | One of the three variations the `magazine-editor` draws of each `Style`, in each `Density`: Safe (calm, never generic), Stylish (Flagship territory), Creative (editorial, style to the maximum) | `.claude/agents/magazine-editor.md`; `<density>/<tier>/` in a concept folder | 2026-09-29 |
| `Density` | How much room a `Style`'s design takes (not a `Layout`), one of two: Condensed (one dense A4 page) or Spacious (the same `Style`, `Design Tier` and facts with more room: larger type, more air, bigger artwork; 1 to 3 pages as the person's facts need, every page carrying the `Style`, never a plain continuation sheet). A run draws 3 `Style`s × 2 `Density`s × 3 `Design Tier`s = 18 designs; a client's design is picked by `Style`, `Design Tier` and `Density` | `condensed/` and `spacious/` in a concept folder; `.claude/agents/magazine-editor.md` | 2026-09-29, owner |
| `Design Review` | The owner's local app for looking through designs and recording his verdicts: the Board shows a run in its `Style` × `Density` × `Design Tier` shape, the Loupe one design at full size; it shows only PDFs with a valid `Meta File`; his verdicts and notes are in `.local/design-review/state.json` | `scripts/design_review/` | 2026-09-29 |
| `Idea Run` | One closed loop of an idea agent (ceo or magazine-editor) and its reviewers | `.claude/skills/idea-run/`, `docs/work/idea-runs/` | 2026-09-25 |

## Words with two meanings

Say the term on the right instead.

| Word | Say instead |
|---|---|
| "approved" | `Approval` for a `Client`'s PDF; `Frozen Reference` for a `Template`'s locked look; plain "approved" only for an owner-approved proposal or design |
| "engine" | `Framework` for the shared core; the `Engine` `Role` for marine engineers; "the engine" only for the `Framework` and the `Domain`s together; a ship's main engine only inside `Vessel Particulars` (the `engine` field holds its maker) |
| "role" for a job title | `Rank` |
| "export" for the public PDFs | `Release` |
| "release" for a version tag | "version tag" (`v0.1.0`) |
| "candidate" for the person | `Client` |

## Dropped

| Term | Dropped | Use instead |
|---|---|---|
| `Field` | 2026-09-25, owner: `Domain` fits better, and "field" already means a data field in `candidate.json` | `Domain` |
