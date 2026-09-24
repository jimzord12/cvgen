# Documentation audit, 2026-09-25

Two read-only auditors ran at `422f150` (clean tree): one over agent-facing
docs (AGENTS.md, CLAUDE.md, `.claude/`, governance docs, proposals), one over
product and reference docs (README, vision, architecture, reference, guides,
ADRs, history). Findings below are theirs, verified against the tree; ids are
stable so the fix commits and the review can cite them. Card:
`docs-audit` on the CVgen board.

Checked clean by both: every relative link and anchor, every script flag,
skill and agent name, no pre-restructure paths, the 38-case count (29 compile
cases plus 9 workflow checks), proposal frontmatter, the three open framework
gaps, README entry-point imports, theme keys, artwork slots, the
`cv-workflow` README.

## Agent-facing docs

### High
- **A-H1** `docs/preferences.md:36-38` said the owner decides merges into
  `main`, contradicting AGENTS.md, git-workflow.md and development.md.
  Fixed in `2439af7` (authority update).
- **A-H2** Three rules for skipping independent review: AGENTS.md ("every
  non-trivial change of any kind"), `development.md:26-28` ("small
  behaviour-preserving edits may skip"), `review.md:14-18` (only spelling,
  comments, mechanical formatting; rendering always reviewed). Fix: keep
  review.md as the one rule; the other two link to it.

### Medium
- **A-M1** `framework-gaps.md:30-31` cites build-a-cv.md "section 7"; the
  custom path is section 8.
- **A-M2** `constitution.md:45-46` says two private entry points still use
  pre-migration imports; both now import current paths. Delete the clause.
- **A-M3** `constitution.md:24-25` says `tests/baseline.json` pins "every ...
  example JSON"; `chief-officer-example.json` is not pinned. Say exactly what
  is pinned; state that new packs/examples are not pinned (new-theme and
  new-cv skills are silent on it).
- **A-M4** `development.md:25` names Cancelled as a side state; the board
  has no list, label or recipe for it. Define it.
- **A-M5** `git-workflow.md:106` "the two preview PNGs"; there are eight.
- **A-M6** `trello/recipes.md:28-30` read-back expects a
  `**Written:** yyyy-MM-dd` line that `development.md` "Ending a session"
  never defines.

### Low
- **A-L1** `recipes.md:54-59` board-setup recipe creates `'Marine CV'`
  without the Handoff list.
- **A-L2** `development.md:86`, `trello/SKILL.md:3`: "five stages" lists;
  the board has Handoff plus five.
- **A-L3** `development.md:14` bracket text with no link target.
- **A-L4** `AGENTS.md:62` "Layout per ADR 0010"; domains come from 0011.
- **A-L5** `AGENTS.md:84` "Eight-line entry points"; chief-officer has 10.
- **A-L6** `git-workflow.md:80-81` documents `reference/v11` tags; none
  exist.
- **A-L7** `git-workflow.md:97` "each CV PDF is about 2.8 MB"; only those
  with a portrait.
- **A-L8** Done needs a confirmed CI result; no doc says how to observe it
  (`gh run watch`).
- **A-L9** `.local/` is kept out of Git only by `.git/info/exclude`; add
  `/.local/` to `.gitignore`.
- **A-L10** verify-cv skill misses `Text mismatch on page N`,
  `core/<f> imports outside core` and workflow-check failures.
- **A-L11** `proposals/work-records.md:16-19` and
  `development-protocol.md:47-48` lack a dated "superseded" note.
- **A-L12** `docs/now.md` is retired dead weight; its link points into
  ignored `builds/`. Move into history or delete.

## Product and reference docs

### High
- **P-H1** `guides/build-a-cv.md`: a real CV built by following the guide
  ships fictional wording. Missing `disclosure` defaults to "FICTIONAL
  CANDIDATE & AI PORTRAIT / DESIGN STUDY" (`core/data.typ:23`); the
  engineer and captain examples the guide says to copy have no
  `disclosure`. The certificate subtitle defaults to "Illustrative register
  - dates and credentials are fictional" (`flagship/adapter/adapter.typ:11`),
  the footer brand to "FLAGSHIP", PDF metadata to "Marine CV Studio"
  (`domains/marine/domain.typ:7`). Fix: a guide step that sets
  `disclosure` and `copy` (`certificates-subtitle`, `brand`); metadata
  wording is an owner decision (parked on the handoff card).

### Medium
- **P-M2** `reference/candidate-schema.md:65-67`: "roadmap item one" is
  item 3; "section 7" is section 8.
- **P-M3** `vision.md:87-90` lists the finished restructure as open.
- **P-M4** `history.md:155-167` stops at the plan; the 2026-09-21 landing
  and `archive/pre-domains` are unrecorded.
- **P-M5** `decisions/README.md:30,35,38` index rows miss amendments that
  the ADR Status lines state (0002 by 0011; 0007 by 0010, 0011; 0010 by
  0011).
- **P-M6** `reference/artwork-pack.md:49-51` same over-claim as A-M3.
- **P-M7** `README.md:60`, `tech-stack.md:8` call the JSON Schema a
  validation; nothing runs it. Call it an editor aid (or add validation as
  separate, owner-approved work).
- **P-M8** `build-a-cv.md:149-159` section 8 snippet uses `theme`,
  `artwork`, `layout` without importing them.
- **P-M9** `reference/domains-and-roles.md:62-72` "Adding a field" omits
  the wiring (lib.typ exports, `tests/run.py` compile list, baseline,
  `build.ps1`), and prescribes `normalize-candidate`/`validate-candidate`
  names that `lib.typ:9` already exports flat for marine. Needs a
  checklist and a naming rule before travel and tourism.
- **P-M10** `tech-stack.md:33` icons "in the template's assets/"; they are
  in the domain's `assets/`.

### Low
- **P-L11** `reference/verification.md:53,55` two items numbered 8.
- **P-L12** `architecture.md:50-51`, `layout-and-pagination.md:14`:
  certificates and education sections receive the whole `layout`.
- **P-L13** ADR 0011:44-46 stale present tense about the adapter's `+`.
- **P-L14** ADRs 0001 and 0008 prescribe paths that no longer exist; add
  "paths amended by 0010/0011" to their Status.
- **P-L15** Workspace layouts differ: `pdf-workflow.md:64-70` vs
  `build-a-cv.md:10-19`.
- **P-L16** `layout-and-pagination.md:70-76` error table misses four
  `validate-pages` messages (`core/pagination.typ:9-49`).
- **P-L17** `build-a-cv.md:68-75`: run from repo root; exit code 2 means
  REFUSED.
- **P-L18** `candidate-schema.md:72-73` missing blank line before
  `## Wording`.
- **P-L19** `vision.md:33,44-45` presents the one-page layout as existing.
- **P-L20** `archive/design-studies/README.md:24-25` contradicts :41-45.
- **P-L21** No index of reference docs outside AGENTS.md; README links only
  candidate-schema.
- **P-L22** `vision.md:15-17` precedence note is stale after ADR 0011
  rewrote the sections below.
