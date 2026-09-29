---
# CVgen repo layer for the repo-maintenance skill. Read AFTER the generic pass.
# Adopted 2026-09-30 from the owner's research bundle; every path below was checked against the live tree that day.

context_files:
  - AGENTS.md
  - CLAUDE.md
  - docs/glossary.md
  - docs/conventions.md
  - docs/constitution.md
  - docs/review.md
  - docs/development.md
  - docs/git-workflow.md
  - docs/architecture.md

glossary:
  - docs/glossary.md

# Docs that are reached by process, not by links from other docs.
entry_points:
  - "docs/decisions/**"           # ADRs are cited by number
  - "docs/work/**"                # task records and review reports
  - "docs/research/**"            # Research Library
  - "docs/proposals/**"

# Dated records: never link-fixed or re-worded. `ignore` leaves them out of EVERY check (secrets, size and
# stray-file checks too); accepted, since they are reviewed text; the Output Contract and the suite still cover them.
ignore:
  - "docs/work/**"
  - "docs/decisions/**"
  - docs/history.md
  - docs/now.md                     # retired snapshot (AGENTS.md)
  - ".night-shift/history/**"

# Never moved, edited or proposed for deletion. The owner's call only.
protected:
  - docs/constitution.md
  - "packages/domains/marine/templates/flagship/tests/approved/**"   # the Frozen Reference
  - tests/baseline.json                                              # hash manifest of frozen references
  - "archive/**"                                                     # frozen design studies and Anti-examples
  - "examples/**/*.pdf"                                              # the Release: replaced only by build.ps1 -Release with the owner's go
  - "examples/**/*.meta.json"                                        # its Meta Files (Output Contract)
  - "design-concepts/**/*.meta.json"                                 # stamped by scripts/outputs.py, never by hand
  - "docs/work/**/reviews/**"                                        # independent review reports are records
  - ".night-shift/**"                                                # Night Shift tool: its committed history of nights
  - "private/**"                                                     # ignored, real client data; never inspected
  - ".local/**"                                                      # ignored, local preferences

# The Output Contract (every PDF has one home and a Meta File) is owned by scripts/outputs.py.
# Do not re-implement it here; run it as a check. No `homes` rules on purpose.

# Intentional duplicates and big files.
allow_duplicates:
  - "**/tests/approved/**"        # a Frozen Reference may equal a Release PDF byte for byte
  - "docs/images/**"              # README images may equal the archived study renders
allow_large:
  - "packages/cv-framework/fonts/**"
  - "**/tests/approved/**"
  - "examples/**"
  - "brand/**"
  - "archive/**"
  - "design-concepts/fonts/**"

# Versioned on purpose: the Frozen Reference and its layout (conventions.md).
allow_names:
  - "**/tests/approved/*-v??.pdf"
  - "**/layouts/flagship-v??.typ"

max_top_level: 18                 # 18 entries on 2026-09-30, dotfiles included
doc_stale_days: 60                # the docs move fast (hundreds of commits)

# Commands that prove the repo is healthy. `python` is what the README uses; use `py -3` if that is the local launcher.
checks:
  - "python tests/run.py"
  - "python scripts/outputs.py check"   # never add --private: that reads real client data

newcomer_questions:
  - "How do I build the example PDFs, and in which folder do they appear?"
  - "How do I run the tests, and where is the evidence?"
  - "Where do I change the theme, the artwork pack or the person of an example?"
  - "Where does a real client's data live, and what must never be committed?"

# Reports are shown in chat. Only when the owner asks for a saved report (or `apply` needs its baseline JSON)
# does it go in a NEW timestamped folder here, never overwritten (constitution rule 2).
report_home: "builds/repo-health-<UTC yyyymmdd-hhmmss>/"

# Agent-context files have an owner: findings about them are handed off, not edited here.
owners:
  - "AGENTS.md, CLAUDE.md, docs/*.md, docs/guides/**, docs/reference/**, .claude/skills/**, .claude/agents/** => context-maintainer (review: context-reviewer); until both agents are on main, the working agent, reviewed per docs/review.md"
  - "scripts/outputs.py, *.meta.json => the Output Contract (docs/pdf-workflow.md); run it, never re-implement it"
---

# CVgen rules for repo maintenance

This file points at CVgen's own rules. If it ever disagrees with `AGENTS.md`, `docs/constitution.md`,
`docs/conventions.md` or `docs/review.md`, those win, and the disagreement is a finding against this file.

**Language.** Everything the agent writes into this repository is in English. Use the official terms from
`docs/glossary.md` in reports and file text (for example `Revision`, `Export`, `Release`, `Frozen Reference`,
`Envelope`, `Output Contract`, `Meta File`). Say `Release` (never "export") for the public PDFs, `Client` for a
real person we serve, `Rank` for a job title; the glossary's "Words with two meanings" and "Dropped" lists are the
authority.

**Who does what.** `AGENTS.md` gives Claude Code the implementation, testing and review gates, and Codex the
discussion, research, proposals and design decisions with no implementation authority. Codex proposes adopting or changing this
capability in `docs/proposals/`; Claude Code implements after the owner's decision. `AGENTS.md` is the single map:
any new folder or agent must be added there, and that edit is reviewed like any other.

**Review.** `docs/review.md` requires an independent `code-reviewer` round for every change except truly trivial ones
(pure spelling, comments, mechanical formatting, a glossary term row), and it names skills and agent definitions
explicitly. So installing or changing this capability, and every `apply` branch, goes through that gate with evidence.
Missing required evidence is INCOMPLETE, never a clean PASS. This audit finds drift; it never issues a review verdict.

**Outputs are sacred.** Constitution rule 2: every script and test writes into a new timestamped folder under `builds/`
and refuses to run if the folder exists. So maintenance never moves, renames, overwrites, clears or stamps a PDF or
its `Meta File`. `python scripts/outputs.py check` (prints `FAIL <path>: <reason>`, exit 1 on any problem) is the
authority on the Output Contract. A failure is High and goes to the owner. The audit script itself writes nothing.

**Frozen things.** The `Frozen Reference`, `tests/baseline.json`, its pinned inputs, `archive/design-studies/`, `Release`
and `Export` PDFs and review reports are protected. A moved file or a changed hash is never "cosmetic". After any applied
change, `python tests/run.py` must pass, the new evidence folder must be named, and a visual change needs a rendered page
someone looked at (constitution rule 5).

**Private data.** `private/` (one `Envelope` per real client) and `.local/` are ignored and never inspected, listed, moved
or cleared. Real candidate data never appears in a report or in a public file (constitution rule 3).

**Typst and script references.** Typst resolves a relative path from the file that contains it, and a leading `/` from
the project root. When a `.typ` file, image, font, JSON, schema or bibliography moves, search every `.typ` file for the
basename (`#import`, `#include`, `image(`, `read(`, `csv(`, `json(`, `bibliography(`), plus Python (`packages/cv-workflow/`,
`scripts/`, `tests/`), `scripts/build.ps1`, `tests/baseline.json`, JSON schemas, Markdown links and the workflow
files in `.github/workflows/`. The map in `AGENTS.md` also names paths; those sentences are handed to whoever edits `AGENTS.md`.

**Records.** The task record is Trello, through the `trello` skill (`docs/development.md`). Each Decide item in a report ends
with a one-line card-ready title. The agent creates no second status file or backlog.

**`apply` in CVgen's Git.** The floor's rules hold (never the default branch, a new folder per output); only the names
follow CVgen, and that is not a conflict to stop on: the branch is `chore/maintenance-<topic>` (`docs/git-workflow.md`, `<type>/<topic>`); the pure-move commit is
`chore: move <what> to <where>` and the reference commit `chore: update references to <where>` (`docs/conventions.md`);
the baseline JSON goes in a new `builds/repo-health-<UTC yyyymmdd-hhmmss>/` (inside the repo, ignored); after the review
gate passes, the agent integrates per `docs/git-workflow.md` (agent-owned merge), with nothing left for the owner to do.

**Cadence fit.** CVgen already has a `Session Sweep` (the pre-session-end checklist). Prefer adding one line to it,
"run `/repo-maintenance quick`", over adding a hook. That edit is a process change: proposal, owner decision, review.

**Severity words.** Reports use `Blocking`, `Material`, `Minor`, `Note`, as `code-reviewer` does. Mapping: Critical to
Blocking; High to Material, or Blocking if it touches a protected contract or private data; Medium to Material when it
misleads work, otherwise Minor; Low to Minor; Info to Note.

**Agent-context owners.** `context-maintainer` and `context-reviewer` exist on branch `docs/codex-visual-tools`
(2026-09-30), not yet on `main`. Until they are, findings about `AGENTS.md`, `CLAUDE.md`, the glossary, conventions and
the constitution go to the working agent and through the normal review; afterwards, to them (`owners` above).

**Mentions that look dead but are not.** Docs name paths inside a client's `Envelope` relative to it (`intake/facts.md`,
`draft/`, `revisions/`), and abbreviate the engine as `W/` and `M/` (AGENTS.md's key). The audit script already skips
ignored areas (`private/`, `.local/`, `builds/`); these remaining L2 leads are confirmed by reading, never fixed blindly.
