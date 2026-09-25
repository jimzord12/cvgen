# Glossary

Read this before writing to the owner, a proposal or a document. It is the
one list of CVgen's official terms (owner, 2026-09-25). A term means exactly
what its line says; the code name column is where it lives today.

## Rules

1. **Use the official term, never a synonym.** If the owner, a document and
   the code use different words for one thing, the term below wins in prose;
   code keeps its name until a task renames it.
2. **Backticks in replies to the owner.** Every official term in a reply is
   wrapped in backticks: `Domain`, `Envelope`, `Sign-off`. Documents may do
   the same where it helps the reader; they are not required to.
3. **Spot candidates.** Add an entry under "Candidates" when you notice:
   a concept that has come up twice without a name; two words used for one
   thing (the owner says one, the repo another); one word used for two
   things; or a new term the owner coins. Give a one-line meaning and where
   it was seen, and name the candidate in your reply's Recap.
4. **The owner makes a term official.** Adding a candidate is agent work.
   Moving it into the table, renaming or dropping a term is the owner's
   decision (it is product vocabulary). Record the date with his answer.
5. **Dropped terms stay listed** so nobody brings them back.

## Terms

| Term | Meaning | Code name today |
|---|---|---|
| `CVgen` | The product: premium, hand-crafted CVs built with AI on our own Typst `Framework` | the repository |
| `Framework` | The shared Typst core every CV is built on: page frame, fonts, headings, data merge, checks. Knows no `Domain` | `packages/cv-engine/core/` and `lib.typ`; docs also say "engine" or "core" |
| `Domain` | A career area with its own facts shape, wording, artwork and rules: `Marine`, `Travel & Tourism`, `Software Development`. Not a web address | `packages/cv-engine/domains/<id>/`; only `marine` exists |
| `Role` | One specialisation inside a `Domain`, never a fork of it: `Deck` and `Engine` in `Marine` | `domains/marine/roles/deck`, `roles/engine` |
| `Template` | A named CV design. Belongs to a `Domain`, or lives in one `Envelope` as a one-off for a single client | `templates/flagship/` (`Flagship`); a one-off is a "custom composition" in `private/<client>/cv.typ` |
| `Theme` | A `Template`'s colours, fonts and sizes only | `templates/<t>/themes/` |
| `Artwork Pack` | Which illustration goes in which slot of a `Template` | `templates/<t>/artwork/` |
| `Layout` | Margins, gaps and which content lands on which page | `templates/<t>/layouts/`; docs also say "layout profile" |
| `Envelope` | One client's folder: their facts, portrait, their own `Template` tweaks, every `Revision` and `Export` | `private/<name>-<role>/`; docs also say "candidate workspace" |
| `Revision` | One render of a CV in its own folder, never overwritten | `private/<client>/revisions/<id>/` |
| `Sign-off` | The client's "OK, the facts are correct" on the text draft, before design starts; usually a chat message whose screenshot goes into the `Envelope`. Not a signature | not built |
| `Approval` | The owner's act on one exact PDF, bound to its SHA-256. Agents never approve a real client's PDF | `scripts/cv.py approve`, `cv.approval.json` |
| `Export` | The verified copy of an approved PDF, ready to deliver | `scripts/cv.py export`, `private/<client>/exports/` |
| `Frozen Reference` | The approved PDF a `Template`'s public example must reproduce pixel for pixel | `templates/<t>/tests/approved/` |
| `Framework Gap` | A recorded case of going around the `Framework` or a `Template` to deliver a CV | `docs/framework-gaps.md` |
| `Idea Run` | One closed loop of an idea agent (ceo or magazine-editor) and its reviewers | `.claude/skills/idea-run/`, `docs/work/idea-runs/` |

## Dropped

| Term | Dropped | Use instead |
|---|---|---|
| `Field` | 2026-09-25, owner: `Domain` fits better, and "field" already means a data field in `candidate.json` | `Domain` |

## Candidates

Proposed by agents, not official until the owner confirms.

| Candidate | Proposed meaning | Seen |
|---|---|---|
| `Client` vs `Candidate` | The owner says client, the repo says candidate, for the person the CV is for. Proposal: `Client` in prose, `candidate` stays in code and the data contract | 2026-09-25 workflow discussion |
| `Intake` | Collecting a client's facts and goals before research: a Greek question list sent by chat, answers relayed into the `Envelope` | 2026-09-25 workflow discussion, not built |
| `Relay` | The intake method where Claude Code writes the follow-up questions and the owner passes them to the client by chat | 2026-09-25 workflow discussion |
| `Research Library` | Shared, dated research notes about a country or `Role`, reused across clients and rechecked after 6 months | 2026-09-25 workflow discussion, not built |
| `Engine` (the `Role`) vs "engine" (the package) | One word, two meanings: the marine `Engine` `Role` and `packages/cv-engine`. Proposal: say `Framework` for the package | 2026-09-25 |
