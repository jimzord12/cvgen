# Review round 1: test-evidence-folders

Stored as returned by the `code-reviewer`; the lead's dispositions follow at
the end.

# Review round 1: test-evidence-folders

**Verdict: FINDINGS.** There is one Material finding: the CI artifact upload still looks for the old flat compile logs. There are also two Minor findings and one Note.

Snapshot: `f7a6996..9f690d5` (one commit), branch `feat/test-evidence-folders`. HEAD is 9f690d5 and the working tree was clean when I ran checks.
Lead lenses: (1) wiring, (5) tests and evidence
Coverage:
1. Wiring: I traced every consumer of the output paths (see F1). Covered in depth.
2. Correctness: all 48 case names are unique. `mkdir(exist_ok=False)` now turns a duplicate case name into a hard error, where before the PDF and log were silently overwritten. The `workflow` collision is covered in F4a.
3. Data integrity: n/a. Candidate data, revisions and approvals are untouched, and `tests/workflow.py` is unchanged.
4. Contracts and privacy: `report.json` gains a `folder` key and no key is removed (see F3). The hand-render example in the skill points at `private/` and writes into `builds/`, which is git-ignored. Fine.
5. Tests and evidence: the exact v11 check still runs against the reference and still asserts (`run.py:163-164`). `diff-N.png` lands in `<case>/check/`. `exact_reference` in `report.json` is still the engineer result. PNGs are rendered before the assert, so a failing case keeps its pages. Covered in depth.
6. Failure handling: a case that must fail keeps only `compile.log` (checked on `overflow/`). The shadowing trap is in F2.
7. Simplicity: one small `check` helper in the file that owns it. No scope creep.
8. Repo and docs: all 5 files are LF, the ADR has its index row, and the docs match the code except F3. No glossary term covers "evidence folder"; not flagged.

## Findings

### F1 Material: CI still uploads the old flat compile logs
Anchor: `.github/workflows/verify.yml:39` (not changed in this commit)
- **Scenario:** CI runs `python tests/run.py --output builds/ci` and uploads `builds/ci/*.log`.
- **Expected:** the brief says nothing still reads the old flat paths, CI included.
- **Actual:** logs now live at `builds/ci/<case>/compile.log`, so the glob matches nothing. `if-no-files-found: ignore` hides this. The `**/result.json` and `**/diff-*.png` globs still match. The suite-rendered page PNGs are not uploaded either.
- **Impact:** CI's evidence artifact silently loses every compile log. The Python traceback still prints the failing case's stderr to the console, so diagnostics degrade rather than vanish.
- **Smallest fix:** change the glob to `builds/ci/**/compile.log`. Optionally add `builds/ci/**/page-*.png`.

### F2 Minor: the new `check` helper is overwritten later in the same function
Anchor: `tests/run.py:138`, rebound at `:329` (`check = doc[0].get_text()`) and at `:357` (`for check in run_workflow(...)`). Both rebinds were already there before this commit.
- **Scenario:** a future visually checked case added after the text-draft block calls `check(...)`.
- **Actual:** it crashes with `TypeError: 'str' object is not callable`. It fails loudly, but misleadingly.
- **Today:** harmless, because the last `check(` call is at `:308`.
- **Fix:** rename the helper (for example `check_case`) or the two local variables.

### F3 Minor: "report.json names each case's folder" is not quite true
Anchor: ADR 0013, Decision section; `run.py:135`
- **Actual:** 14 of the 61 `cases` entries have no `folder` key: `example-records-match-schema` and the 13 `workflow-*` entries.
- **Impact:** a reader or tool that follows the ADR finds no folder for those entries.
- **Fix:** reword to "names each compiled case's folder, and workflow checks live under `workflow/`", or add `'folder': 'workflow'` to those entries.

### F4 Note
- (a) **Unguarded `workflow` name.** `run_workflow` creates `out/workflow/fictional-engineer` with `parents=True`. A future `compile_case('workflow', ...)` would therefore share that folder silently instead of failing. No such case exists today.
- (b) **Skill wording.** The skill says "Render by hand only a PDF the suite does not produce". But the suite does produce `text-draft`, `legacy-api` and other PDFs that it never renders as PNGs, under the settled decision. "does not render" would be exact.

## Checks rerun
- `python tests/run.py` at 9f690d5 with Typst 0.15.1: exit 0, "PASS: 61 compilation cases". Output: `C:\Users\jimzord12\Documents\GitHub\cvgen\builds\tests-20260928-164405-875623`. `report.json` has 61 cases and `exact_reference.passed` is true for `engineer\engineer.pdf`.
- Mismatch path: `python tests/verify.py --actual <that run>/captain/captain.pdf --reference .../Marine-Engineer-CV-v11.pdf --output builds/review-test-evidence-folders-r1-<ts>/captain/check`. Exit 1, and it wrote `diff-1.png`, `diff-2.png` and `result.json` into the given folder. This exercises the unchanged `verify()`, which `run.py` now points at `<case>/check`.

## Evidence inspected
- `git diff f7a6996 9f690d5`, plus `tests/run.py`, `tests/verify.py` and `tests/workflow.py` at 9f690d5.
- `.github/workflows/verify.yml`, `scripts/`, `.claude/skills/*`, `.claude/agents/*`, `AGENTS.md`, `docs/git-workflow.md`.
- Author run `builds\tests-20260928-164116-101806`: 48 case folders, `workflow/` and `report.json`. 17 folders hold both `page-N.png` and `check/`, and no folder has one without the other. `overflow/` holds only `compile.log`.
- My run's `deck-cadet\page-1.png`, which renders correctly at 110 dpi.

## Limitations
- The brief gave no Trello card URL, so I did not read the task record.
- I cannot tie the author's run folder to 9f690d5 directly. My own rerun at 9f690d5 is the proof.
- The CI finding comes from reading the workflow file; I did not run CI.

## Verdict: FINDINGS

## Dispositions (lead)
- F1 fixed: verify.yml uploads `builds/ci/**/compile.log` and `builds/ci/**/page-*.png`.
- F2 fixed: the helper is `check_case`.
- F3 fixed: workflow entries carry `'folder': 'workflow'`, and the schema check entry has no folder; the ADR says "names the folder of each case that has one".
- F4a fixed: `compile_case` refuses the name `workflow`. F4b fixed ("does not render").
