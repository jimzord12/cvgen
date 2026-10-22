# Client workflow: reference

The client workflow, from a client's first message to the deletion of his
data, is the `Workflow Model` in [`docs/workflow/`](../workflow/README.md):
every step with its ID, who does it, what it reads and writes, its gates
and loops, and the judgement each stage needs, one README per stage. **This
file describes no step.** It holds the reference detail some steps point at
and the model does not hold: the `Envelope` tree, the question list, the
`Intake Form`'s clicks, what `CV Decisions` look like, and the commands that
erase an `Envelope`. Each section names the steps that use it. The
checklists an agent follows are the `new-client` and `new-cv` skills; the
decisions behind the workflow are in
[the client-workflow proposal](../proposals/client-workflow.md) and
[P-0017](../proposals/workflow-model.md). Terms are in the
[glossary](../glossary.md).

## 1. The Envelope tree

Used by `open.envelope` and by every step that writes into the `Envelope`.

One folder per client under `private/` (ignored by this repository, tracked by the
private one: `docs/git-workflow.md`, "The private repository"), named after the
person and their `Rank`. Every `Envelope` has the same tree (owner,
2026-10-06): only three files at its root (plus, for a CV delivered before
`scripts/cv.py`, its `reference.pdf` and `reference.meta.json`, below),
everything else in a `Drawer` where things that belong together live
together. This section owns the layout; the guides and skills point here.

```text
private/eleni-example-tour-guide/
  README.md          alias, intake date, decisions, draft fingerprints, Export and delete-by dates,
                     Google links (Intake Form, Sheet, script project),
                     "Stopped <date>: <reason>" for a client who stopped
  envelope.json      who the client is, once: alias, domain, candidate, rank;
                     keep_requested once he asks to keep his data
  candidate.json     the candidate record (added by new-cv); the workflow reads it here
  intake/
    messages.md      every answer as received, dated, in the client's words
    documents/       the photos and files the client sent
    facts.md         the facts Claude extracted, with the gap list
    form-NN.gs       an Intake Form's script copy (optional)
    answers-NN.csv   that form's downloaded answers
  research/
    scout.md         the Scout's findings, each with its source
    decisions.md     the CV decisions and what answers each one
    deep-dive-<topic>.md
    reviews/         research-reviewer reports: <topic>-NN.md per Deep Dive and round
  draft/
    draft-01.typ, draft-01.pdf   the text draft (a new number per version)
    draft-01.meta.json           its Meta File: ready, sent, then signed-off or superseded
    sign-off-01.png              the client's OK, as a screenshot
  typst/             the CV's Typst sources (added by new-cv)
    cv.typ           the entry point scripts/cv.py renders
    presentation.json   data a design reads that the schema cannot hold (optional)
    designs/         design variants and the shared design code cv.typ imports
    text/            the CV's wording as Typst, one file per language or variant
    art/             the design's own SVGs, the scripts that generate them, and generated images
  images/
    portrait/        the authorised photograph(s), jpg or png
  reviews/           design-NN.md: design-reviewer reports on the CV's design, and
                     design-NN-codex.md: the codex-visual-reviewer's (an older
                     Envelope may also hold text-NN.md; it is kept as is)
  revisions/         one folder per render, written by scripts/cv.py
  exports/           one folder per exported revision, written by scripts/cv.py
```

`typst/cv.typ` reads every file by a path relative to itself:
`json("../candidate.json")`, `image("../images/portrait/portrait.jpg")`,
`#import "designs/hanami.typ"`, `image("art/fuji.svg")`. `scripts/cv.py`
(which calls the `Envelope` a workspace)
refuses a workspace whose `cv.typ` still sits at the root (the layout
before 2026-10-14) and names the whole move, made with `git mv` inside
`private/`: `cv.typ` to `typst/`, with the data and `.typ` helpers it
reads (design code to `typst/designs/`, wording to `typst/text/`, SVGs to
`typst/art/`), the portrait to `images/portrait/` with `identity.portrait`
in `candidate.json`, and `../` added to `cv.typ`'s reads of files outside
`typst/`. A CV delivered before
`scripts/cv.py` existed keeps its `reference.pdf` and `reference.meta.json`
at the root, left in place (the `Output Contract`, `../pdf-workflow.md`).
A `Revision` written before the move keeps its flat `inputs/`; nothing in
`revisions/` or `exports/` is ever moved.

`scripts/cv.py render` copies `typst/cv.typ`, `candidate.json`, the
portrait and the files `cv.typ` reads into a `Revision`, at the same
places under its `inputs/`; `intake/`, `research/` and `draft/` enter one
only if `cv.typ` reads from them, which it should not.

**`envelope.json`** says who the client is, once. Every `Meta File` in the
`Envelope` copies it (the `Output Contract`, `../pdf-workflow.md`), and
`scripts/cv.py render` refuses to run without it. `alias` is the client's
`Alias`, `client-<yyyy>-<mm>-<nn>` (`output.schema.json` also accepts a `-<n>` suffix); `domain` is an id from the glossary's
`Domain` row (`travel` for a tour guide); `candidate` is the client's
display name, which never leaves `private/`:

```json
{"alias": "client-2026-09-01", "domain": "travel", "candidate": "Eleni Example", "rank": "Tour Guide"}
```

A client who asks to keep his data beyond the delete-by date gets one more
field, `"keep_requested": "YYYY-MM-DD"`, the day he asked
(`after.keep-record`; P-0018 item 5); `after.delete-by-check` skips him.
Nothing else reads it: the `Meta File`s copy only the four fields above.

## 2. The question list

Used by `intake.questions`, which adapts it to the client's `Domain` and
target, and by `after.keep-request` (question 1 offers to keep his data).
The master list, in English (why each question matters:
[research note](../research/cv-intake-practice.md), "Draft question set"):

1. Consent, first: "We use AI tools and web research to write your CV.
   Your details stay in our private files, are never published, and are
   deleted 12 months after delivery unless you ask us to keep them. Reply
   'I agree' to continue."
2. Which job are you applying for next, and at what level?
3. In which country or countries, and with what kind of employer (for
   example a crewing agency, a shipowner, a hotel group, a tour operator)?
4. Send 1-3 real job ads you would apply to, or the companies you want.
5. Send your current CV and any older ones. If you use LinkedIn, send its
   PDF (on your profile: More, then Save to PDF).
6. Send photos of what proves your record: certificates, service record or
   discharge book, references, appraisals, awards.
7. For your last 2-3 jobs: exact title, dates (month and year), employer,
   and what you were responsible for (team size, who you reported to,
   budget, equipment, vessel type).
8. For each of those jobs, 2-3 things you are proud of: what was the
   problem, what did you do, what changed?
9. Did any of that save money or time, cut problems or downtime, pass an
   inspection, or grow something? Rough numbers are fine.
10. What do your managers or colleagues always say you are good at?
11. Anything we should handle carefully: a gap, short jobs, a career
    change, something to leave out?
12. Where can you work, from when, and do you need a visa?
13. What may your CV show: a photo, your date of birth, your nationality?

The consent text is plain wording, not reviewed by a lawyer; the owner may
change it and the retention period.

## 3. The Intake Form

Used by `intake.form-script` to `intake.form-copy` and by
`research.follow-up-form-script` (owner, 2026-09-28).

**The script.** A filled copy of `scripts/intake-form.gs` per form,
`intake/form-NN.gs`, in which only the `FORM` block changes: title, intro,
consent, questions. A form is designed, not a list of text boxes: pages by
topic, and the question type that is quickest to answer (a choice, tick
boxes, a drop-down, a grid, a date; free text only where a story is
wanted), in the polite plural of the `Text Draft`. It has no upload
questions (they force a Google sign-in), so photos and documents still
come by chat. For the follow-up, the form's cap is effort, not a count,
because most questions there are one tap: at most about 15 minutes, and at
most 5 questions that need typing (an optional "Other" box does not
count); its intro states Claude's time estimate.

**Running it (the owner).** Paste it into a new project at
script.google.com, name the project after the `Alias`, and run
`createIntakeForm` once; the log prints the link to send, the form's edit
link and a Google Sheet that collects the answers. The first run asks for
permission and Google warns that the app is unverified (Advanced, then Go
to the project); that is normal for the owner's own script. He passes the
three links and the project's link back, and Claude lists them under
"Google" in the `Envelope`'s `README.md`. The form, its Sheet and the
script project live in his Google account until `after.delete-google`.

**The house theme**, before sending the link (the palette icon in the
form's editor; about a minute): Header, upload
`studio/brand/forms/intake-header.png`; Color, custom, `#B0602B`;
Background, the swatch closest to the header's warm paper (usually the
lightest); Text style, Header "Bona Nova" (under More fonts), Question and
Text "Source Sans 3"; a font the menu does not offer stays at the default.

**A test answer** the owner makes is deleted in both places before the
client answers: the form's Responses tab (Individual, the bin icon) and its
row in the Sheet (right-click the row number, Delete row), which the form
does not remove.

**The answers.** A client can edit an answer only through the edit link
shown once, after sending, so the owner downloads the answers when the
client says he is done: in the answers Sheet, with the "Form Responses 1"
tab open, File, Download, Comma-separated values, which gives that tab as a
plain CSV (first run, 2026-09-28), saved as `intake/answers-NN.csv`: one
column per question and one per grid row, dates in the Sheet's locale
(month/day/year on the first run; read an ambiguous date such as 3/4 with
care), a skipped page's questions empty.

## 4. CV Decisions: what the lines look like

Used by `research.decisions` and `research.decisions-update`. One line per
decision the CV must make, each with its answer and source, "judgement"
with the reason, or "open":

| Decision | Example answer |
|---|---|
| Target title, word for word | "Licensed Tour Guide, Japan" (from 2 of 3 job ads) |
| Length | two pages |
| Photo, date of birth, nationality | photo yes, date of birth no (country norm, client allows) |
| Language(s) of the CV | English |
| `Domain` and `Template` | no `Travel & Tourism` `Domain` yet: a one-off `Template` in the `Envelope` |
| Achievements that lead | the three with numbers |
| Keywords | from the job ads |
| Gaps and short jobs | how each is shown |
| How it is sent | email PDF / agency portal / ATS (applicant tracking system, software that screens CVs) |

## 5. Erasing an Envelope from the private repository

Used by `after.erase-commands` (Claude fills in the folder name) and
`after.erase-envelope` (the owner runs it; Claude never does).

Deleting the folder is not enough: the private Git repository keeps it in its
history. The commands erase the `Envelope` from
that history and overwrite GitHub's copy. First, in
`private/`, `git status` and `git log origin/main..` must both print nothing
(commit and push everything else); the erase then runs in a fresh clone, so no
working copy is touched:

```powershell
git clone https://github.com/jimzord12/cvgen-private.git $env:TEMP\cvgen-private-erase
cd $env:TEMP\cvgen-private-erase
git filter-repo --path <envelope>/ --invert-paths
git remote add origin https://github.com/jimzord12/cvgen-private.git
git push --force --all origin
git push --force --tags origin
```

(`git filter-repo` is a separate install, `pip install git-filter-repo`; it
removes the `origin` remote, hence the re-add.) Then delete that temporary
folder and every clone of the private repository, `private/` included, and
clone it again. GitHub may keep the erased commits reachable by their hash
until its own clean-up runs; full erasure means asking GitHub Support.
