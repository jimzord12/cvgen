# Idea run: magazine-editor, 2026-09-27 (Text Draft directions)

Second run of the `magazine-editor`, unattended overnight in Night Shift
2026-09-27-a. Round cap per gate tonight: 5 (the owner's instruction for
this night, stricter than the skill's 10 unattended). The named agents ran
directly (`magazine-editor`, then fresh `research-reviewer` and
`design-reviewer` per round), in the worktree `cvgen-idea-editor` on
branch `docs/idea-run-2026-09-27-editor`.

## Brief given

Subject: the `Text Draft` house design (card premium-text-draft), not a CV
template. Two or three bold directions, each a two-page mock-up: page 1 the
`Check Page` in Greek, page 2 the first CV-content page in English. Owner's
direction on the card ("no soul, character"; "very alternative,
sophisticated, not afraid to over do it kinda of an artist"; "unique
style"; brand trust) and his brand mood (answer 13, 2026-09-25):
"Alternative, sophisticated, unafraid of excess: an artist, not a law
firm." The rejected first attempt (navy + brass, GFS Didot, dossier cover)
was named as what not to do. Constraints: Greek coverage and OFL fonts,
Greek capitals without accents, per-client words as parameters, a Check
Page readable on a phone, fictional content, `scripts/text-draft.typ`
untouched.

## Directions delivered

| Folder | Idea | Font |
|---|---|---|
| `design-concepts/2026-09-27-first-fitting/` | Tacked, not sewn: the draft as a tailor's first fitting; a copper thread from a tailor's ticket loops the headline; facts carry a running stitch | Bona Nova (OFL) |
| `design-concepts/2026-09-27-stoichedon/` | Every letter placed: the Athenian inscription grid, one capital per cell; facts in red ochre | GFS Neohellenic (OFL) |
| `design-concepts/2026-09-27-two-inks/` | Black over orange: a two-ink small-press poster; facts print on an orange slab off register; a giant OK | Syne (OFL) |

Fictional record: `examples/candidates/chief-officer-example.json` (Eleni
Markou, with an invented Greek spelling of the name).

Author's known limits: the three share one mechanism (mark the facts) with
different looks; experience tables are heavily marked; facts inside running
prose need hand marking; First Fitting's thread is drawn for its fixed
headline; Stoichedon needs a row allocator and runs longer; Two Inks needs
hand line breaks in wide Greek headlines. Proposed term: `Fact Mark`.

## Rounds

Reports in `reviews/`.

| Report | Gate | Verdict |
|---|---|---|
| 01 | research round 1 | PASS, Notes applied to the briefs |
| 02 | research round 2 | PASS |
| 03 | design round 1 | FINDINGS: First Fitting PASS; Stoichedon (D5) and Two Inks (D9) Blocking, fixed |
| 04 | research round 3 | PASS |
| 05 | design round 2 | FINDINGS: Stoichedon and Two Inks PASS; First Fitting D13 Blocking (headline collides with itself at 0.08em leading), fix applied |
| 06 | research round 4 | PASS, Notes R15 and R16 applied (9679aad) |

The night (2026-09-27-a) was interrupted before a third design round. D13
was superseded rather than re-reviewed: the owner asked for a smaller
headline and new wording, and the built version went through its own
design review (card premium-text-draft).

## What reaches the owner

The three directions were shown to the owner on 2026-09-28 (PDFs opened
on his screen). **Decision (owner, 2026-09-28): First Fitting**, with
changes: "the font is a bit loud. I would make it smaller, make the
triangles bigger and more special and be more generous with the spacing,
its a digital doc not a read one." And on wording: "'Ώρα για πρόβα.' is
very bad wording. It feels like you are trolling the client. We want to
sound professional and trustworthy." Built on branch
`feat/text-draft-first-fitting` into `scripts/text-draft.typ`. Stoichedon
and Two Inks were not picked and stay as inspiration. Run closed.
