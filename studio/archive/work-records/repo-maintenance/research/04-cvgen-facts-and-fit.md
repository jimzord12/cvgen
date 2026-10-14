# 04. CVgen: verified facts, conflicts, and how this fits

**Read this before you trust `install/.claude/repo-maintenance.md`.** It was written from three sources that partly disagree.
The rule for the agent that adopts it: **the live tree and the live documents win.** Verify every line marked VERIFY.

## Where the facts came from

| Source | What it is | Reliability |
| --- | --- | --- |
| **A. GitHub `main`** | `https://github.com/jimzord12/cvgen` is public. Raw files read 2026-09-30 through a fetcher that summarises with a small model: AGENTS.md, CLAUDE.md, README.md, docs/constitution.md, docs/review.md, docs/glossary.md, scripts/outputs.py, .claude/agents/code-reviewer.md, plus the repository page's top-level listing. GitHub folder pages are blocked to that fetcher, so folder contents below the top level are unseen. | Good for what it quotes; summaries can drop detail |
| **B. Third-party review** | `docs/third-party-review.md` in this bundle. It inspected a local checkout at commit `e489cc5` on branch `docs/idea-run-2026-09-29-editor`. | Detailed, but of one branch; two claims conflict with A |
| **C. The owner's original brief** | Named `context-maintainer`, `context-reviewer`, `scripts/outputs.py`, `<stem>.meta.json`, `docs/glossary.md`, `docs/conventions.md`, `docs/constitution.md`, `docs/review.md`, `tests/run.py`, Trello. | Second-hand from the owner's memory of the repo |

## Facts, with status

| Fact | Status |
| --- | --- |
| `AGENTS.md` is "the single map of this repository"; `CLAUDE.md` tells Claude Code to read it first | Confirmed on main (A) |
| Roles: Claude Code owns implementation, testing and review gates; Codex owns discussion, research, proposals and design decisions, with no implementation authority | Confirmed on main (A) |
| Constitution: ten immutable rules. Relevant: 1 frozen references are contracts (pixel-identical, tests enforce); **2 every script and test writes into a new timestamped folder under `builds/` and refuses to run if it exists**; 3 public content is fictional, real data lives in ignored `private/`; 5 evidence before "done" (`python tests/run.py` passes, evidence folder named, visual change has a rendered page someone looked at) | Confirmed on main (A) |
| Review protocol: every change is reviewed independently except truly trivial ones (pure spelling, comments, mechanical formatting, a glossary term row). Scope explicitly includes **skills and agent definitions**, AGENTS.md, CLAUDE.md, proposals. Missing required evidence is INCOMPLETE, never a clean PASS | Confirmed on main (A) |
| `.claude/agents/code-reviewer.md`: `tools: Read, Grep, Glob, Bash, PowerShell`, `model: opus`, `effort: high`; source-read-only, shell only for rerunning vetted checks that write under `builds/`; severities **Blocking, Material, Minor, Note**; verdicts PASS, FINDINGS, INCOMPLETE | Confirmed on main (A) |
| `scripts/outputs.py` exists: `python scripts/outputs.py stamp <pdf> status=proposed [k=v ...]` and `python scripts/outputs.py check [--private]`; `check` prints `FAIL <path>: <reason>` and a summary line, exit 1 on any problem | **Confirmed on main (A). Conflicts with B**, which found it absent in its checkout. Probably a branch difference. Check your checkout |
| The glossary defines `Output Contract` ("every PDF lives in a home folder with a `Meta File`") and `Meta File` ("JSON beside the PDF: kind, Domain, candidate, status, pages, SHA-256") | Confirmed on main (A). Conflicts with B's "rule not present" |
| `.claude/agents/context-maintainer.md` and `context-reviewer.md` | **404 on main (A); absent in B's checkout. C says they exist.** They may be local, on another branch, or planned. Check your checkout. The adapter does not depend on them |
| AGENTS.md lists repo skills in `.claude/skills/`: `new-client`, `new-cv`, `verify-cv`, `new-theme`, `trello`, `idea-run` | Confirmed on main (A). **A repo skill under `.claude/skills/` is precedent** |
| Top-level on main: folders `.claude`, `.github/workflows`, `.night-shift/history`, `archive/design-studies`, `brand`, `builds`, `design-concepts`, `docs`, `examples`, `packages`, `scripts`, `tests`; files `.gitattributes`, `.gitignore`, `AGENTS.md`, `CLAUDE.md`, `LICENSE`, `README.md` | Confirmed on main (A, repository page) |
| A root `exports/` folder for public released PDFs | B only. **Not in main's top level (A).** VERIFY; where `Release` and `Export` PDFs live is the Output Contract's business |
| Frozen Reference lives in `.../flagship/tests/approved/`; B gives the full path `packages/domains/marine/templates/flagship/tests/approved/`; `tests/baseline.json` is the hash manifest | Approved-folder and baseline confirmed (A, in shortened form); full path from B. VERIFY |
| README quick start is `./scripts/build.ps1` (PowerShell); verification is `python tests/run.py` (needs `pymupdf`, `pillow`, `jsonschema`; 44 cases) | Confirmed on main (A). **The owner's machine is Windows-style** |
| Glossary "Avoid" entries: `Domain` not "Web address"; `Rank` not "role" for a job title; `Client` not "candidate"; `Approval` is not "Frozen Reference"; `Export` not "release"; `Frozen Reference` not "approved" for templates; dropped term `Field` becomes `Domain` | Confirmed on main (A) |
| `Session Sweep` = the pre-session-end checklist (unreviewed commits, proposals, cards, Night Shift, Git, CI, `builds/`) | Confirmed on main (A, glossary) |
| Task record: Trello via the `trello` skill; `docs/development.md` describes stages and task records | Confirmed on main (A, AGENTS.md) |
| `Revision` folders hold `render.json`, `checks.json`, `cv.approval.json`; an `Export` holds verified copies of the PDF and approval receipt | B only. Not used by the adapter |
| `.night-shift/history` | Exists on main (A). Purpose not read. Protected until the owner says otherwise |

## How this fits CVgen (what is already there, so it is not duplicated)

| Need | What CVgen already has | What this bundle does |
| --- | --- | --- |
| Where PDFs live and their `Meta File` | `scripts/outputs.py check`, the `Output Contract` | Runs it as a declared check. Never re-implements it, never moves or stamps a PDF |
| Frozen references, pixel identity | `tests/run.py`, `tests/baseline.json`, constitution rule 1 | Protects them; runs the suite to verify a change |
| Independent review of changes | `code-reviewer`, `docs/review.md` | Feeds it (evidence, small diffs). Never issues a verdict |
| End of session hygiene | `Session Sweep` | Proposes one added line: run `/repo-maintenance quick` |
| Task record | Trello (`trello` skill) | Each Decide item ends with a card-ready title. No second backlog |
| Term consistency | `docs/glossary.md` Avoid column | Uses it as review prompts. The script's T1 handles only words that are wrong everywhere |
| Process change intake | `docs/proposals/` | Adoption starts as a proposal |
| Outputs never overwritten | Constitution rule 2, `builds/` | The script writes nothing; a saved report goes to a new folder under `builds/` |

## Recommended fit for CVgen (my judgement; change it if the live repo argues otherwise)

- **Install project-level** in `.claude/skills/repo-maintenance/` and `.claude/agents/`, committed. CVgen already keeps its skills and its reviewer there, and the review protocol treats skills and agents as reviewed repo changes.
- **Use `repo-auditor-lite`** (no shell). It matches the smallest boundary, avoids the Windows shell question for the hook, and the working agent runs the script. Install `repo-auditor` (guarded Bash) only if you want the auditor to re-run checks itself, and then set the hook command's interpreter and path.
- **No commit hook.** Add one line to the `Session Sweep` instead.
- **Adapter as shipped, after verification.** Keep it short; it points at documents, it does not copy them.
- **Reports to chat**, saved only on request into a new `builds/` folder.
- **Report words** Blocking, Material, Minor, Note, mapped as the adapter says.

## Verification checklist for the adopting agent

Run in the live checkout and fix the adapter to match. Use `git ls-files <path>` or your shell's listing; both work on Windows.

1. Does each path in `protected`, `context_files`, `allow_*` and `entry_points` exist? Remove or correct those that do not; do not leave dead globs.
2. `scripts/outputs.py` present? If not, delete it from `checks`. Is `--private` documented as reading real client data? Never pass it.
3. Do `.claude/agents/context-maintainer.md` or `context-reviewer.md` exist? If yes, read their remit, set `owners`, and reconcile with `docs/review.md`.
4. What is `.night-shift/`? What is in `exports/`, if it exists? Decide protected or not with the owner.
5. Open `docs/conventions.md`: any file-placement, naming or "frozen" rule the adapter should point at? (Its text was not readable to the fetcher.)
6. Open `docs/development.md` and `docs/proposals/README.md`: how is a process change proposed, decided, implemented, reviewed?
7. Which Python launcher works here: `python`, `python3` or `py -3`? Update `allowed-tools` and the hook command if needed.
8. Run `python tests/selftest.py` from the bundle, then `python .claude/skills/repo-maintenance/scripts/audit.py --mode audit` in the repo, and triage the first run before trusting the counts.
