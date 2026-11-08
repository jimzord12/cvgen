---
name: plan
description: Write, revise or review a plan before work starts. Use when the work spans more than one task, changes a contract or migrates data, is hard to undo, or the owner asks for a plan; when revising a plan after a plan review; and as the rubric a plan-reviewer applies. Holds the plan template, the impact map method and the plan checklist. Generic; the repository's own rules say where plans are stored and which gate reviews them.
---

# Plan

A plan is cheap to fix and code is not. Most plans fail the same way: the
author pictures the change at its centre and misses how far it reaches.
This skill is for the author of a plan and for whoever reviews it; both
read the same checklist, so the review finds what the author missed, not
what the author was never told.

Read the repository's own rules first (its agent map, `AGENTS.md` or
`CLAUDE.md`, says where): where a plan is stored, who reviews it, its
round limits, and the parts of that repository a change typically reaches.
They take precedence over anything generic here.

## When a plan is needed

The work spans more than one task, changes a contract (a schema, an API, a
file format, a rule other files rely on), migrates data, is hard to undo,
or the owner asks for one. A small, obvious change needs none: a few steps
in its task are enough.

## Write it

1. **Pin the outcome.** In the owner's words where they exist: what
   becomes possible, for whom, and what is deliberately left out.
2. **Read before you write.** Build the impact map (below) from the code
   and documents themselves, not from memory of them.
3. **Consider at least one alternative,** including "do less". Keep the
   simplest one that reaches the outcome.
4. **Write the plan** in the template below. Say what you know, what you
   assume, and what you will find out first.
5. **Check it yourself** against the checklist, then send it to review as
   the repository says. Store it as a file at a commit, so the reviewer
   reviews an exact version.

## The impact map

Start from the change and trace outward, one ring at a time. Grep; do not
guess. For each item, name the file and what happens to it.

| Ring | What to trace |
|---|---|
| The code itself | Every definition that changes; its callers and importers (grep the name, its string forms, dynamic uses) |
| Data and contracts | Schemas, file formats, configuration, stored records that pass through or depend on the change; their existing instances |
| Tests | Tests, fixtures, golden files, hashes or baselines that encode today's behaviour |
| Generated outputs | Anything built from the changed sources: docs, diagrams, release artifacts, indexes; their generators |
| Documentation and agent context | Manuals, guides, glossary, skills and agent files that describe or restate the behaviour |
| Tooling and CI | Scripts, build steps, linters and pipelines that run or check it |
| Work in flight | Open branches, worktrees and queued tasks that touch the same files or concepts |
| People and decisions | Records of earlier decisions it amends; choices that belong to the owner |

Count the map. A map with one ring filled is a guess, not a map.

## The template

```markdown
# Plan: <slug> - <outcome in one line>

## Outcome
<What becomes possible, for whom. Acceptance in observable terms.>

## Not in scope
<What this deliberately leaves out, and where it goes instead.>

## What exists
<The current behaviour and the files that own it, from reading them.>

## Impact map
<Ring by ring, file by file: what changes and why.>

## Approach and decisions
<The design. Each decision with its reason and who decides it.>

## Alternatives
<What else was considered, including doing less, and why not.>

## Compatibility and migration
<What existing data, users and outputs see; how they move.>

## Reversibility
<What cannot be undone; the rollback for what can.>

## Verification
<How we will know it works: the checks, and the evidence each step leaves.>

## Risks and unknowns
<What could go wrong; what to try small before committing.>

## Sequencing
<Order of steps; what must land first; collisions with work in flight.>

## Owner decisions
<Choices that are the owner's, raised with a recommendation; none assumed.>
```

## The plan checklist

The author's self-check and the reviewer's rubric. Each is a question the
plan must answer, not a heading it must have.

1. **Impact:** does the impact map cover every ring, and does the code
   confirm it? What does the change reach that the plan does not name?
2. **Fit:** does the outcome serve the product's stated direction, and does
   the plan respect the repository's rules that never change?
3. **Facts:** is every claim the plan makes about the code true (the file
   exists, the function does that, the test covers this)?
4. **Compatibility:** does every existing instance of changed data or
   behaviour keep working, or does the plan say how it moves?
5. **Reversibility:** is anything irreversible, and is that said and
   authorised?
6. **Verification:** is "done" observable, and does each step leave
   evidence a reviewer can inspect?
7. **Failure:** what happens on bad input, partial completion, a retry or a
   crash midway?
8. **Sequencing:** is the order right, and does it collide with work in
   flight?
9. **Unknowns:** is any load-bearing assumption untested where a small
   experiment would settle it?
10. **Decisions:** are the owner's choices raised, not assumed? Are the
    author's own decisions stated with their reasons?
11. **Proportion:** is there a simpler way to the same outcome? What does
    this make harder later? Does it work around a gap that should be fixed
    instead?
12. **Procedures:** walk every routine the plan leaves for people or
    agents, step by step, through each situation it will meet, such as a
    first run on empty state, two sessions or branches at once, a branch
    inside a feature branch, someone's uncommitted work, a stale or detached
    checkout, a rejected push, a run cut off midway, another operating
    system or shell, a missing tool, the owner's permission settings, a
    tool's options used together. Check what each command does in its help,
    not by its name. A situation with no instruction is a gap.
13. **Model fit:** when the plan introduces a model, schema, format or
    vocabulary, encode its hardest real cases in it by hand before
    building, such as a choice with more than two outcomes, a loop or an
    edit in place, an item with no inputs or outputs, a value that is
    optional, repeated or missing, one word used two ways in the sources,
    and any other the sources hold. Does every field it requires exist in
    the sources it will be filled from? A real case it cannot hold is a gap.
