---
id: TASK-24
title: 'premium-text-draft: a Text Draft house design with soul and character'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
updated_date: '2026-10-06 07:49'
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

## Comments

<!-- COMMENTS:BEGIN -->
author: Trello
created: 2026-10-06 07:49
---
Trello comment, 2026-09-27 22:05 UTC (migrated):

Owner, 2026-09-28: direction = **First Fitting** (design-concepts/2026-09-27-first-fitting on branch docs/idea-run-2026-09-27-editor). Changes he asked for, verbatim: "the font is a bit loud. I would make it smaller, make the triangles bigger and more special and be more generous with the spacing, its a digital doc not a read one. No trees will die for more spacing."
Reading: smaller display headline and bold headings (body stays phone-readable); the copper margin triangles become a bigger, more distinctive signature marker (tie to the thread/stitch); much more white space, more pages are fine. Open design finding D13 (headline leading) is superseded by the smaller headline; re-check in the build's design review.
---

author: Trello
created: 2026-10-06 07:49
---
Trello comment, 2026-09-27 22:07 UTC (migrated):

Owner, 2026-09-28, wording: "'Ώρα για πρόβα.' is very bad wording. It feels like you are trolling the client. We want to sound professional and trustworthy."
Rule for the build: the tailoring idea lives only in the visuals (thread, stitches, tag). All client-facing words are plain and professional: no fitting/sewing puns anywhere (headline, intro "πρόχειρα τρυπωμένο... πριν το ράψουμε", "χάλκινη βελονιά", tag labels "ΠΡΟΒΑ"). Proposed headline: "Το βιογραφικό σας, προς έλεγχο." Intro: "Ελένη, αυτό είναι το κείμενο του βιογραφικού σας, πριν ξεκινήσει ο σχεδιασμός." Instruction: "Ελέγξτε μόνο τα υπογραμμισμένα στοιχεία:". Tag: ΠΡΟΣΧΕΔΙΟ 01 instead of ΠΡΟΒΑ 01.
---

author: Trello
created: 2026-10-06 07:49
---
Trello comment, 2026-09-27 23:22 UTC (migrated):

Night Shift 2026-09-28: built and merged to main (72a1277, CI green). Owner's changes and wording applied; reviews code 3 rounds (PASS r3), design 2 rounds (PASS r2): https://github.com/jimzord12/cvgen/tree/main/docs/work/premium-text-draft/reviews
Script: https://github.com/jimzord12/cvgen/blob/main/scripts/text-draft.typ
Left for Done: the owner's yes on the look (pictures and PDF in the night's evidence).
Deferred notes: thread to the first needle (D22), slimmer needle (D23, owner's eye), half-dash stitch ends (D25), tag height guard (D29), headline-guard test (F12), missing greeting/date messages (F5).
---

author: Trello
created: 2026-10-06 07:49
---
Trello comment, 2026-09-28 06:56 UTC (migrated):

Owner, 2026-09-28: "This draft text is amazing we keep it!" Accepted. On main since 72a1277 (CI green). Done.
---
<!-- COMMENTS:END -->
