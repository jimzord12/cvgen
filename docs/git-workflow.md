# Git workflow

Read this before committing, pushing, branching, integrating or tagging.

## Ownership

The working agent manages Git by default and chooses useful commit/push
checkpoints. Claude owns implementation Git; Codex can manage its own authorized
design/documentation changes. If the owner explicitly says they will handle Git
for a session, leave Git mutations to them until they hand it back. This is a
session override, not a permanent repository preference.

The owner's 2026-09-16 instruction replaced mandatory PRs and individual merge
approval; his 2026-09-25 instruction extends that to every routine Git
operation, including history edits on unpublished or feature work and branch,
tag and worktree cleanup. The authoritative list of what agents do without
asking, and the few operations that still need his go, is in
[preferences.md](preferences.md#what-he-decides-and-what-agents-decide).
None of this approves a pending product design.

## Branches

- `main` is always releasable: the suite passes and the PDFs in
  `exports/` match the code. If a merge changes what `exports/` would
  contain, refreshing them needs the owner's go; until then record the
  mismatch on the handoff card.
- Small, low-risk, verified fixes and documentation can go directly to `main`.
  Choose a feature branch for new features, migrations, significant changes,
  or work whose readiness is uncertain.
- Prefer short-lived branches named `<type>/<topic>`:
  `feat/chief-engineer-artwork`, `fix/duration-wrap`,
  `refactor/agent-ready-layout`, `docs/adr-frozen-v11`.
- One topic per branch. A branch that grows a second topic gets split.
- Respect the harness prefix when required (for example, Codex uses `codex/`).
  Do not move existing work merely to satisfy a new naming convention.
- A larger feature may need a longer-lived integration branch. Record its parent
  and completion boundary in the owning task, integrate useful complete pieces
  when possible, and bring in relevant `main` fixes at milestones.
- Child branches are useful for independent parallel tasks or isolated experiments.
  Use separate worktrees and one writer per checkout; routine fixes to the same
  feature can stay on its branch. Feature-specific fixes target the feature;
  fixes to existing `main` behavior should reach `main` and then the feature.

## Commits

- Conventional Commits as in `conventions.md`. Small, coherent, each one
  compiles.
- Stage the intended changes explicitly and inspect the staged diff. Do not sweep
  unrelated local work, real candidate data, secrets, or local preferences into a
  commit. Check the current branch, remote and upstream before publication.
- Commit at coherent checkpoints and push at useful milestones or handoffs.
  Branch checkpoints can be unfinished overall if their limitations are clear;
  unfinished or unverified work does not belong on `main`.
- Amend, rebase, reset, force-push of a feature branch (`--force-with-lease`),
  branch deletion and deleting tags other than `archive/*` are agent
  decisions. Never rewrite or force-push published `main`, and never delete
  or move an `archive/*` tag; those stay with the owner.
- Clear `builds/` by path. Never run `git clean -x` or `-X`: they also wipe
  the ignored `private/` and `.local/` folders.

## Integration without PRs

- No pull requests for now. Preserve applicable review and verification in the
  task/commit evidence; a PR is not the review itself. Follow the review policy
  actually adopted for the task, not an unapproved proposal.
- Run required checks before pushing to `main`; inspect visual evidence when
  needed. CI runs after a push and cannot prevent that first publication.
- Fetch before integrating, inspect new upstream commits, and preserve others'
  work. Prefer fast-forward updates or ordinary merges; never force a push to
  resolve divergence. Recheck the combined result after integration changes it.
- If a remote advances before the push, fetch and reconcile again. The
  operations reserved for the owner (preferences.md) still apply. Do not
  bypass remote protections or hooks to make the no-PR policy work.
- Observe the push-triggered CI result for the published commit:
  `gh run list --commit <pushed sha> --limit 1` (repeat until the run is
  listed; `--branch` alone can return the previous commit's run), then
  `gh run watch <run-id> --exit-status`. Keep the task awaiting verification
  if it is unavailable; investigate failure before claiming completion.
  Report commit/target and any outstanding issue briefly.
- A feature task may integrate into its named parent branch. That completion is
  distinct from the whole feature reaching `main`; record the intended target.

The existing [commit conventions](conventions.md#commits) follow
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).
The [Git branching guide](https://git-scm.com/book/en/v2/Git-Branching-Branching-Workflows)
describes both topic and integration branches; our preference for a shallow
branch structure is a proportionate choice for this small project.

## Tags

- `archive/<name>` marks a snapshot before a large removal. Files deleted
  from the tree remain reachable there.
- `reference/<name>` tags are meant to mark the commit that produced a frozen
  reference render. None exists yet; the v11 reference predates the
  convention.
- Release tags follow `vMAJOR.MINOR.PATCH` and match `packages/cv-engine/typst.toml`.

## What is committed

| Committed | Ignored |
|---|---|
| Source, themes, artwork, layouts, examples, fictional JSON | `private/` with real candidate data |
| Bundled fonts and licence notices | `builds/` with every build and test output |
| The current deliverable PDFs in `exports/` | Scratch PDFs and PNGs at the repo root |
| The frozen reference PDF and hash manifest | `__pycache__/` |
| Design studies with their review renders | Anything under `previews/` or `exports/review/` from earlier sessions |
| Preview PNGs used by the README | |
| Template concepts in `design-concepts/` (PDF, one PNG per page, shared OFL fonts in `fonts/<family>/`); a rejected concept's folder is removed | |

`.gitattributes` stores and checks out every text file with LF on every
platform, so the hashes in `tests/baseline.json` match on Windows, macOS,
Linux and CI. Binary files are marked there too. A CV PDF with an embedded
portrait is about 2.8 MB, so do not add renders casually. Replace, do not accumulate.

## Releasing a new render

Replacing an approved deliverable in `exports/` needs the owner's go
(preferences.md); get it before step 3.

1. Choose a branch appropriate to the change. Run `python tests/run.py`.
2. Build with `./scripts/build.ps1`, inspect both pages of every changed
   example.
3. Copy the new PDF into `exports/` with the next version number and remove
   the old one. Refresh the changed deliverable's page PNGs in `docs/images/`
   at 96 dpi (one per page).
4. If the engineer look changed on purpose, write an ADR, replace the frozen
   reference, regenerate `tests/baseline.json`, and tag the commit.
5. Commit with the evidence folder named, integrate and push under the workflow
   above, then confirm the published commit's CI result. Approval of a changed
   look or reference is the owner's.
