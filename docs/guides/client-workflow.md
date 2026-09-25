# Client workflow: from a new client to signed-off facts

Read this when a new client arrives, before `build-a-cv.md`. The checklist
version is the `new-client` skill (`.claude/skills/new-client/`); the
decisions behind it are in
[the client-workflow proposal](../proposals/client-workflow.md). Terms are
in the [glossary](../glossary.md).

The owner steers the main Claude Code session. Claude does the writing and
research; the owner is the only one who talks to the client.

```text
Intake (Relay) -> Scout -> CV decisions -> Deep Dives -> one follow-up
  -> text draft -> Sign-off -> new-cv -> Approval -> Export
```

| Step | Owner | Claude |
|---|---|---|
| 1. Envelope | names the client | creates the folder and its alias |
| 2. Intake | pastes the questions, brings the answers back | writes the questions in simple Greek |
| 3. Facts | - | turns answers into facts and a gap list |
| 4. Scout | - | Research Library first, then the web |
| 5. CV decisions | picks which open ones get a Deep Dive | lists the decisions and what answers them |
| 6. Deep Dives | - | one agent per question, sources checked |
| 7. Follow-up | pastes the questions, brings the answers back | one batch, 5 questions (never more than 10) |
| 8. Sign-off | sends the text draft, saves the client's OK | writes the draft PDF |
| 9. Handover | - | `new-cv` builds the CV |

## 1. Open the Envelope

One folder per client under `private/` (ignored by Git), named after the
person and their `Rank`, as in `build-a-cv.md`. The workflow adds three
drawers to it:

```text
private/eleni-example-tour-guide/
  README.md          alias, intake date, decisions, draft fingerprints, delivery and delete-by dates
  intake/
    messages.md      every answer as received, dated, in the client's words
    documents/       the photos and files the client sent
    facts.md         the facts Claude extracted, with the gap list
  research/
    scout.md         the Scout's findings, each with its source
    decisions.md     the CV decisions and what answers each one
    deep-dive-<topic>.md
    reviews/         research-reviewer reports: <topic>-NN.md per Deep Dive and round
  draft/
    draft-01.typ, draft-01.pdf   the text draft (a new number per version)
    sign-off-01.png              the client's OK, as a screenshot
  candidate.json, cv.typ, portrait, revisions/, exports/   added by new-cv
```

`scripts/cv.py render` copies only `cv.typ`, `candidate.json` and the
portrait into a `Revision`; the drawers never enter one.

**The folder name is client data.** Claude gives each client an alias,
`client-<yyyy>-<mm>-<nn>` (for example `client-2026-09-01`), written at the
top of the `Envelope`'s `README.md` with the date intake started. Outside `private/` (Trello cards,
commit messages, briefs to agents, anything public) the client is only ever
the alias.

## 2. Intake by Relay

Claude writes the question list below in simple, friendly Greek, adapted to
the client's `Domain`, as one message. The owner pastes it into the chat
app the client already uses (Viber, WhatsApp, email). The client answers
in any order, in text or voice messages, over a few days.

Claude reads text only. Voice messages need a transcript first: the phone's
own transcription, or the owner typing the gist. The owner copies the chat
text into `intake/messages.md` (a WhatsApp "Export chat" file works as is)
and saves photos into `intake/documents/`.

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

**Nothing after this step starts before the client's "I agree" is in
`intake/messages.md`**: Claude does not read the documents, write facts or
research until then. Without consent the owner decides whether to ask again
or stop. The consent text is plain wording, not reviewed by a lawyer; the
owner may change it and the retention period. Claude never opens a client's
LinkedIn page; the PDF export is enough.

## 3. Facts and the gap list

Claude writes `intake/facts.md`: identity, target, each job with its
scope and results, certificates, education, languages, what may be shown.
Every fact names the message or document it came from; nothing is
invented, and calendar dates are never turned into service time
(constitution section 6). What is missing or vague goes into a gap list at
the end. The gap list waits for step 7, so the client is asked once.

## 4. Scout

A wide, shallow search for this client's target: CV norms in the country,
what the target employers and the `Rank` expect, how CVs are sent (agency
portal, applicant tracking system (ATS, software that screens CVs), email).

1. Read `docs/research/` first. A note past its "Recheck after" date is
   used only after its load-bearing claims are checked again.
2. Search the web for what the library lacks.
3. Write `research/scout.md`: numbered findings, each with a source and
   its date, and the open questions.

## 5. CV decisions

Claude writes `research/decisions.md`, one line per decision the CV must
make, each with its answer and source, "judgement" with the reason, or
"open":

| Decision | Example answer |
|---|---|
| Target title, word for word | "Licensed Tour Guide, Japan" (from 2 of 3 job ads) |
| Length | two pages |
| Photo, date of birth, nationality | photo yes, date of birth no (country norm, client allows) |
| Language(s) of the CV | English |
| `Domain` and `Template` | no `Travel & Tourism` `Domain` yet: a one-off `Template` in the `Envelope` (step 9) |
| Achievements that lead | the three with numbers |
| Keywords | from the job ads |
| Gaps and short jobs | how each is shown |
| How it is sent | email PDF / agency portal / ATS |

The owner picks which open decisions get a Deep Dive. Research is enough
when every decision has a sourced answer or a stated judgement; a new
source that changes no decision is the signal to stop.

## 6. Deep Dives

One agent per chosen question: 0-3 per client, up to 6 for an executive
aiming at named companies. Each author gets the `Alias`, never the
`Envelope` path, and returns its text: numbered, sourced claims and
nothing about the client. Claude saves it as `research/deep-dive-<topic>.md`.

A fresh `research-reviewer` checks each one until PASS (cap: 5 rounds while
the owner watches, 10 unattended; at the cap it goes to the owner marked
unresolved). The reviewer never reads `private/`, so Claude first checks
the Deep Dive for client details, then passes its text inline, with its
SHA-256 as the snapshot and the question it answers. Reports on a Deep Dive
that stays with the client go in the `Envelope`'s
`research/reviews/<topic>-NN.md`.

A finding about a country, a `Domain` or a `Rank`, with nothing about the
client, is also written to the `Research Library` (`docs/research/`,
public) in the same session. The library note is written first, free of
client detail, and reviewed on its own text and hash; its reports go under
`docs/work/research-<topic>/reviews/`, never under a client's name. A
finding about one employer stays in the `Envelope`; it moves to the
library when a second client targets the same employer.

## 7. One follow-up

The gap list plus any question the research raised, as one batch: aim for
5 questions, never more than 10. Claude writes them in simple Greek; the
owner pastes them; the answers go into `intake/messages.md`, and Claude
updates `facts.md`. Anything still missing after this round is left out
of the CV or marked as not supplied; the client is not asked again unless
the owner decides to.

## 8. Text draft and Sign-off

Claude writes the CV's content as a plain document, no design, in the CV's
language, sized for the `Template` (two pages by default): `draft/draft-01.typ`
using `scripts/text-draft.typ`, compiled to `draft/draft-01.pdf`:

```powershell
typst compile --root . --font-path packages/cv-framework/fonts private/<envelope>/draft/draft-01.typ private/<envelope>/draft/draft-01.pdf
```

Its first page, the check page, in Greek, asks the client to check only
names, dates, numbers and titles, because the wording is our job. When the
owner sends a draft, Claude writes its SHA-256 in the `Envelope`'s
`README.md`; a sent draft is never compiled again, and corrections make
the next number (`draft-02`). The client's "OK" is the `Sign-off`, saved as
`draft/sign-off-NN.png` next to the draft it answers.

## 9. Handover to new-cv

`new-cv` builds the CV from `intake/facts.md` and the signed-off draft. If
the facts do not fit the `Domain`'s `Template`, it builds a one-off
`Template` in the `Envelope` and records a `Framework Gap` (`build-a-cv.md`
section 8).

A client whose `Domain` does not exist yet (a tour guide, today) gets a
one-off `Template` in the `Envelope`: its `cv.typ` imports
`/packages/cv-framework/lib.typ` only (ADR 0012), so `scripts/cv.py render`
checks no schema, and it holds the whole design in that one file, because a
`Revision` copies only `cv.typ`, `candidate.json` and the portrait
(`docs/framework-gaps.md`; card revision-snapshot). Record the `Framework
Gap` for that client's design.

At `Export`, Claude writes "Delivered <date>. Delete by <date + 12 months>"
in the `Envelope`'s `README.md` and names the delete-by date in its report
to the owner. A client who never reaches `Export` (no consent, dropped out)
is named to the owner, by `Alias`, once three months pass without progress
since the intake date: the `new-client` skill checks the intake dates every
time it runs. Deleting anything under `private/` stays the
owner's act.

## Rules

- **Privacy in searches.** A web search never contains the client's name,
  contact details, or a combination that identifies them (their employer
  with their `Rank` and dates, a vessel with its crew position). Search for
  "chief officers applying to Norwegian shipowners", never the person.
- **Client data stays in the `Envelope`.** Research Library notes, review
  reports outside the `Envelope`, commit messages, cards and public
  documents never contain it; they use the alias.
- **One batch per round.** Up to `Sign-off`, the client gets three
  messages from us: the question list, one follow-up, the text draft
  (plus a corrected draft if they asked for changes).
