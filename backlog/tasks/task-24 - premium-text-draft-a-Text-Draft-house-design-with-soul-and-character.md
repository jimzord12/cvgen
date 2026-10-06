---
id: TASK-24
title: 'premium-text-draft: a Text Draft house design with soul and character'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/AXarulyi'
ordinal: 24000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
**Goal.** One reusable house design for the `Text Draft` (the plain-text CV every client checks before `Sign-off`, client-workflow step 8). Not one per client. Purpose: brand trust. A client who receives something that feels custom-crafted and expensive trusts us before seeing the real CV.

**Owner's direction (2026-09-25, verbatim).**
- "It does not have a soul, character."
- "My vibe is more of a very alternative, sophisticated, not afraid to over do it kinda of an artist."
- "It also need to have a unique style."
- Earlier: "it should have style, feel unique and premium... this is most about brand awareness... quality and custom crafted things are very expensive."

**First attempt: rejected.** Branch `feat/premium-draft` (commit 2a5b337, pushed, NOT merged). Navy ink + one brass accent, GFS Didot display, Source Sans 3 body, dossier-style cover check page, running head and folio. Verdict: "bad... no soul, character." Too safe, too corporate-classic. Keep it only as a reference of what not to do.
- Branch: https://github.com/jimzord12/cvgen/tree/feat/premium-draft
- Commit: https://github.com/jimzord12/cvgen/commit/2a5b337

**What to aim for instead.**
- An artist's hand, not a law firm: bold, opinionated, maximal where it helps; a signature element someone would recognise without the name on it.
- Still must read easily on a phone for a non-tech-savvy Greek client (the check page is the part they act on).

**Constraints that survive.**
- Greek must set correctly. Of the bundled fonts only GFS Didot and Source Sans 3 cover Greek; a new face needs Greek coverage and an OFL licence.
- Greek capitals drop their accents (the `caps()` helper on the branch does this).
- Client-facing words (name, role, check text, labels) stay per-client parameters; the design itself is fixed.
- Fictional content only in the fixture; suite (`python tests/run.py`) must pass.

**Suggested route.** Run it through the `Idea Run` loop first: `magazine-editor` proposes two or three directions with mock-up PDFs, `design-reviewer` checks them, owner picks one. Then build on a fresh branch from `main` (take the font/caps plumbing from `feat/premium-draft`).

**Done when.** Owner picks a direction, it is built into `scripts/text-draft.typ`, suite passes, one rendered preview shown, owner says yes.
<!-- SECTION:DESCRIPTION:END -->
