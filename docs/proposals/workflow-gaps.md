---
id: P-0018
kind: proposal
status: pending
revision: 1
created: 2026-10-14
---

# Workflow gaps: what the sources leave to the owner

Origin: encoding the client journey as the `Workflow Model` (TASK-37,
`docs/workflow/`). Supporting document:
[`docs/workflow/GAPS.md`](../workflow/GAPS.md), which explains each
placeholder and inference the YAML holds.

## Problem

The guides, skills and code are silent on nine points the model needs.
The YAML holds a placeholder or an inference for each, marked as such, so
nothing renders as a fact the owner never decided.

## Smallest suggested change

Decide each item below. The model then replaces the placeholder with the
answer and cites this proposal; the prose follows in TASK-43.

| # | Decision requested | Recommendation | How to undo |
|---|---|---|---|
| 1a | Caps for four loops no source caps: draft corrections, library-note review, a failing render, example wording (`GAPS.md`, "Placeholder loop caps") | Keep what the YAML holds: one corrected `Text Draft` (the "one batch per round" rule), then the owner decides; 5 attended and 10 unattended for the library review, the render and the wording fixes (the general review cap) | Change the cap in the stage's YAML; nothing else reads it |
| 1b | Research rounds: no source caps them; a client has 0-3 `Deep Dive`s, an executive aiming at named companies up to 6 (a `Deep Dive` count, not a round count) | Keep the YAML's cap of 3 rounds for everyone (several `Deep Dive`s can run in one round); reaching it goes to `research.cap-reached`, where the owner decides whether an executive gets more. No second cap is encoded | Change `loop.research-rounds`' cap |
| 1c | The owner's own change rounds on a CV: no source caps them | Keep the YAML's cap of 5 as a check-in, not a stop: reaching it goes to `deliver.cap-reached`, where he decides whether to go on | Change `loop.owner-changes`' cap |
| 2 | A client who gives no consent: how often to ask again | Ask once more, then stop; a stopped client waits for the stall check and the owner's word to delete | Edit `intake.no-consent` |
| 3 | A second follow-up after the one batch | Only on the owner's word, and at most one | Edit `lead.update-facts` |
| 4 | The client's Backlog.md task: when it is created and what it is called | At `open.task-create`, once the `Alias` exists, titled `<Alias>: CV`, closed by `after.close` | Move or rename the step |
| 5 | The keep request's field in `envelope.json` | `"keep_requested": "YYYY-MM-DD"` (the day the client asked); the delete-by check skips a client who has it. `outputs.py` reads only the four identity fields, so no code changes | Remove the field; the delete-by date applies again |
| 6 | A stopped client: is it recorded? | A line `Stopped <date>: <reason>` in the `Envelope`'s `README.md`, so the stall check names the client once and the owner decides to delete or keep | Delete the line |
| 7 | The owner parks or rejects every concept for a client's CV | A new `Idea Run` with his reasons as the steer; he tells the client of the delay | Edit `design.record-other-answer` |

`Text Draft` corrections are taken into `facts.md` before the next number
(`text-draft.corrections`); that is an agent's call, listed in `GAPS.md`, not
asked here.

## Consequence

Each answer removes one "(placeholder cap)" or inference from the model and
becomes a rule the workflow tool checks and the docs render. Leaving an item
open keeps the placeholder, marked, in the YAML.

## Recommendation and decision requested

Approve the recommendations above, or answer item by item.
