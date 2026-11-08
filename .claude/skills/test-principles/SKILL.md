---
name: test-principles
description: What makes a test worth having, and how to judge a test change. Holds the ten-question test rubric, the patterns that make a test useless or harmful, probes that test a test (a deliberate fault, a refactor), how to find missing tests and when a test may be removed. Use when writing, changing, deleting or reviewing tests, and as the rubric a tests-reviewer applies. Generic; the repository's own rules say how its suite runs, how a probe is run there and which gate reviews tests.
---

# Test principles

A test earns its place when it fails for a real defect and passes through a
change that keeps the behaviour. Many tests do neither. One that passes
whatever the code does gives false confidence; one that fails whenever the
code moves teaches people to update expectations without reading them. Both
cost more than no test. The number of tests is not a goal, and neither is
coverage: what counts is which faults the suite would catch.

Agents are prone to a particular failure: writing tests to have tests, and
bending tests to make them pass (an assertion weakened, an expected value
copied from the new output, a skip). This skill is for whoever writes a test
and for whoever reviews it; both read the same rubric.

Read the repository's own rules first (its agent map, `AGENTS.md` or
`CLAUDE.md`, says where): its testing conventions, how its suite runs, how
a probe is run there, and which gate reviews a test change. They take
precedence over anything generic here.

## The rubric

Ask each question of every test a change adds, edits or deletes.

1. **Behavioural.** It goes through an entry point the code's users use (a
   command, a render, a public function, an API) and asserts on what they
   observe: output, saved state, an error and its message. Not on private
   helpers, call counts or internal structure.
2. **Can fail.** A plausible fault in that behaviour makes it fail. Proven
   by a fault probe (below) where one can run.
3. **Structure-insensitive.** It survives a refactor that keeps the
   behaviour. Proven by a refactor probe where one can run.
4. **Specific.** Its failure names the case and points at the cause.
   Expected values are written as facts, not computed by the logic under
   test or a copy of it.
5. **Deterministic and isolated.** Same result on every run, in any order,
   on every machine the repository supports. No shared mutable state; a
   clock, network or random source only behind a fixed value.
6. **Honest change.** No assertion deleted or weakened, no skip, no expected
   value, fixture or golden file updated to match new output, unless the
   change's own purpose requires it and the change says why.
7. **Not duplicated.** It catches some fault no other test catches.
8. **Nothing missing.** Every behaviour the change adds or alters has a
   test for its likely faults ("Finding missing tests").
9. **Removed with a reason** ("Removing a test").
10. **Worth its cost.** Its run time, flakiness and upkeep buy something; a
    slow test that catches what a fast one catches goes.

## Patterns that make a test useless or harmful

| Pattern | What it looks like | Why it fails the rubric |
|---|---|---|
| Tautology | Asserts what it just set up; asserts a stub returns what it was told; asserts only that nothing raised | Cannot fail (2) |
| Expected value from the code | The expected result is computed by the function under test, or by a copy of its logic | A wrong rule gives a wrong expectation that agrees (2, 4) |
| Self-refreshing golden | Compares with a snapshot that the test, a flag or the author's last run rewrites | Agrees with whatever the code now does (2, 6) |
| Testing the double | The subject itself, or everything it touches, is replaced by mocks | Tests the mocks, not the code (1, 2) |
| Interaction check | Asserts that a private function was called, how often, with which arguments | Breaks on every refactor; misses wrong output (1, 3) |
| Change detector | Mirrors the implementation line for line, or pins incidental text or layout | Fails on any change, so failures get rubber-stamped (3) |
| Echo | Asserts that a constant or a config value equals its own literal | Restates the code (2, 7) |
| Weak assertion | `is not None`, a length above zero, a substring that any output contains, a broad `try` that swallows the failure | Passes for most faults (2, 4) |
| Logic in the test | Branches, or a loop that may run zero times, decide what is asserted | Can assert nothing and pass (2, 4) |
| Silent skip | Skipped or expected to fail without a reason, or passes when its precondition is missing | Reports green for code that never ran (5, 6) |
| Coverage padding | Calls code and asserts nothing about the result | Raises coverage, catches nothing (2) |
| Hidden dependency | Relies on run order, the clock, the network or another test's leftovers | Flaky; failures stop being believed (5) |

These are the common shapes, not all of them: anything with the same effect
fails the same questions.

## Testing a test: probes

A probe changes the code, not the test, and watches what the test does. A
mutation-testing tool does this at scale with random small changes; a probe
is one change aimed at what a test claims to guard.

- **Where:** a throwaway copy of the repository at the reviewed commit, never
  the author's checkout or a branch. Each probe is one commit in the copy,
  recorded as its diff; return the copy to the reviewed commit before the
  next probe, so probes never stack.
- **First, a clean run:** read no outcome until the copy passes in full in
  that environment. A failure that was already there reads as a caught or
  masked probe.
- **Fault probe:** the smallest change that breaks the behaviour the way a
  real defect would (an off-by-one, a dropped branch, a wrong default, a
  swallowed error). Outcomes:
  - **caught:** the probed test fails, by name, on that fault;
  - **survived:** everything passes, or, in a run that stops at its first
    failure, the first failure comes after the probed test, so it ran and
    missed the fault;
  - **masked by X:** another check fails first. When X is built to fail on
    any change (a pinned hash, a frozen reference), update X in the copy and
    rerun. Otherwise the two checks overlap for this one fault; that alone
    is no reason to remove either.
- **Refactor probe:** change the shape and keep the behaviour (rename or
  inline a private helper, split a function, reorder independent steps). It
  counts only on a full pass: when the probed test fails first, the test is
  structure-sensitive; when another check fails first, the refactor changed
  behaviour, so it is invalid and redone, not evidence against the test.
- **Decides nothing:** a skipped case, a crash, a missing module or tool.
- **Checks that fail on any change by design** (a pinned hash, a frozen
  reference, an assertion that the tree is clean) are judged on whether they
  pin the right things, never by a refactor probe.
- **Where no probe reaches,** judge by reading and say which test and why.

## Finding missing tests

For each behaviour the change adds or alters, list its likely faults: the
boundaries, empty, missing, repeated and malformed input, each error path,
and for a bug fix the bug itself. Name the test that would catch each one. A
fault with no test is a missing test, reported with the fault it must catch
and the entry point it should go through. Ask for the fewest tests that
catch those faults, not one test per function.

## Removing a test

A test goes only with a reason, stated in the change:

- it cannot fail for any plausible fault (a fault probe survived, or it
  asserts nothing about behaviour);
- another named test catches the same faults, shown across the faults this
  test claims, not for one probe;
- the behaviour it guards no longer exists;
- it costs more than it returns and a cheaper test catches what it catches.

Fix before removing: a test that guards real behaviour through the wrong
door (private calls, incidental text) is rewritten through the entry point,
not deleted. A frozen or pinned reference is never removed this way; the
repository's rules say who changes it.

## The owner's conventions

Conventions the owner sets for tests in every project go here. None are
recorded yet; a repository's own testing conventions stay in that
repository's documents.

## Sources

Kent Beck, "Test Desiderata" (2019). Software Engineering at Google,
chapter 12, "Unit Testing" (test through public APIs, test state not
interactions, test behaviours not methods, no logic in tests, clear failure
messages), and chapter 13, "Test Doubles". Google Testing Blog, "Change-Detector
Tests Considered Harmful" (2015-01) and "Only Verify State-Changing Method
Calls" (2017-12). Mutation testing as the check that a suite catches faults,
including practitioners' accounts of using it to keep coding agents' tests
honest (2025-2026).
