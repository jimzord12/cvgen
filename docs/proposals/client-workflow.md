---
kind: proposal
status: approved
revision: 1
---

# Client workflow: from a new client to signed-off facts

Origin: owner and lead, design discussion of 2026-09-25 (Claude Code
session). Supersedes [candidate-intake](rejected/candidate-intake.md).
Supporting documents in scope: [the guide](../guides/client-workflow.md),
the `new-client` skill, the [Research Library](../research/README.md) and
its first note, [cv-intake-practice](../research/cv-intake-practice.md).

## Problem

CVgen's build guide starts at "fill the data": it assumes every fact is
already known. A real client arrives with an old CV, photos of
certificates and a goal. Nothing says how to ask them the right questions,
how much research their target needs, or when the facts are settled enough
to start designing. The owner wants the process straightforward and
repeatable by hand now, and automatable later.

## Smallest suggested change

A hand-run workflow the owner steers in the main Claude Code session, with
no new agent profiles:

1. **Envelope.** The existing client folder under `private/` gains three
   drawers: `intake/`, `research/`, `draft/`.
2. **Intake by Relay.** Claude writes a 13-item question list (grounded in
   the reviewed intake research) in simple Greek; the owner pastes it into
   the client's chat app and brings the answers back. No web form: clients
   are not expected to be tech-savvy. A consent line comes first.
3. **Scout.** The shared Research Library first, the web for the rest.
4. **CV decisions.** A list of what the CV must decide, each with a sourced
   answer or a stated judgement. Research is enough when none is open.
5. **Deep Dives.** 0-3 per client (up to 6 for executives), chosen by the
   owner, each checked by a `research-reviewer` loop.
6. **One follow-up.** One batch: aim for 5 questions, never more than 10.
7. **Sign-off.** A plain text draft PDF with a Greek check page; the
   client's "OK" message is the Sign-off, before any design work.
8. **Handover** to `new-cv`; a client whose `Domain` does not exist gets a
   one-off `Template` in the `Envelope` and a `Framework Gap` entry.

Rules: no client name or identifying combination in web searches; client
data never leaves `private/`; the Research Library is public, dated,
rechecked after six months, and holds no client data.

## Consequence

A new client follows one path from first message to signed-off facts, and
the questions and research are reused rather than reinvented. The cost is
the owner's time relaying messages (a few minutes per round). Automation
(an agent on the client's chat app, for example Hermes Agent on WhatsApp
and email) is deferred until relaying becomes the bottleneck, roughly
beyond three clients a month.

## Recommendation

Approve and apply.

## Decision requested

Approve the workflow as above?

## Decisions

- 2026-09-25, owner, in the design session: approved point by point.
  Research split between the Library and the `Envelope`: yes. Follow-up
  cap: "make it a hard 10 but try to keep at 5". Sign-off before design:
  yes, made "super easy" because clients in Greece are often not
  tech-savvy. Relay now, Hermes later ("I am over-engineering again").
  Keep `private/` and call each client folder an `Envelope`: yes. A guide
  plus a checklist skill, no new agent profiles: yes. Supersede
  candidate-intake: yes. Decoupling the `Framework` from the `Domain`s is
  approved in the same session and tracked separately (card
  framework-split).
