# Review round 2: Report Template, "figures are numbered, never lettered"

The R1-1 fix holds: a bare number as a figure id now renders. Every other invalid id is refused with a clear message, and nothing invalid reaches the page. I found two Minor issues and one Note, and no Blocking or Material ones.

Snapshot: worktree `C:\Github\cvgen\.worktrees\report-figure-numbers`, head db7af87 (clean). I read the delta b90678d..db7af87 and the full diff from 0dc93e7.
Lead lenses: 2 Correctness, 6 Loud failure
Coverage:
1. Wiring: the only caller of `refusal` and `build` is `main`. Both now get normalised data, and `build` normalises again.
2. Correctness: I probed 22 id values and 7 citation values. See Findings.
3. Data integrity: n/a. No candidate data; normalising only turns whole numbers into text.
4. Contracts: the README row and the code agree on 1 to 999, text or a whole number.
5. Tests: the new bare-number test fails on b90678d ("evidence: an item needs id") and passes on db7af87. The `1.0` and `0` refusal tests check the exact message.
6. Failure handling: every probe either rendered or exited 1 with no folder written. R2-1 is about how good one message is.
7. Simplicity: `normalise` is small and in the module that owns it, and it is safe to run twice (checked). `refusal` no longer changes its input (R1-2 closed).
8. Docs: the wording in `docs/preferences.md` is fine. The README guidance conflicts with the sample (R2-2).

## Findings

### R2-1 Minor: top-level JSON that is not an object loses its message
Anchor: `scripts/report.py:99`, `scripts/report.py:229`
- **Scenario:** a data file whose top level is `[]` or `"x"`.
- **Expected:** `report: the JSON file must hold one object`, which is what base 0dc93e7 printed (I reran it).
- **Actual:** `report: 'list' object has no attribute 'get'`, exit 1. `normalise` calls `data.get` before `refusal` checks the type. So the dedicated message can no longer be reached from the command line, and the docstring's claim that the function is type-guarded is not quite true.
- **Impact:** the run still fails loudly with no page, but the message is Python's own error. No test covers this case.
- **Smallest fix:** add `if not isinstance(data, dict): return data` at the top of `normalise`, and add a refusal case for `[]`.

### R2-2 Minor: the sample breaks the new numbering rule
Anchor: `studio/brand/report/README.md:38`, `studio/brand/report/sample.json:95,132,232`
- **Scenario:** db7af87 changed the README to "number them in the order the page first cites them".
- **Actual:** in the sample, card 2 ("How do we judge Essential?") cites Figure 2 alone, so Figure 2 is placed inside that card. Figure 1 is cited only later, by card 4 and a decision, and appears under Figures after it.
- **Impact:** the page reads Figure 2 before Figure 1. The sample is the worked example agents copy, so it should follow the rule it illustrates.
- **Smallest fix:** swap ids 1 and 2 in the sample's evidence and citations. No test depends on the sample's ids: the placement test uses its own data.

### R2-3 Note: small inconsistencies in how refused ids are quoted
- A bare `0`, `-1` or `1000` is reported after conversion to text, as `id '0'`, while `1.0` is reported as `id 1.0`.
- A list inside `figures` is reported as `cites Figure ['1']`.
- The meaning is clear in every case, so I don't ask for a change.

### R1-3
I accept the lead's disposition: "malformed" still covers the case.

### Probes against lens 2
- **Accepted:** the whole numbers `1` and `999`, and a whole-number citation such as `[1]` against id "1".
- **Refused** with "must be a number from 1 to 999":
  - floats: `1.0`, `1.5`, `inf`, `nan`;
  - true/false: `True`, `False`;
  - out of range: `0`, `-1`, `1000`;
  - text: `"01"`, `" 1"`, `"1\n"`, Arabic-Indic one, superscript one;
  - lists and objects: `[1]`, `[]`, `{"a":1}`, `{}`.
- **Refused** as "needs id": `None` and `""`.
- **Refused** as "cites Figure …, which the evidence does not hold": the citations `1.0`, `True`, `"01"`, `["1"]`, `{…}` and `None`.
- **Refused** as not a list of figure ids: `figures` set to `1`, `"1"` or `[]`.

## Checks rerun
- I ran the report checks on their own, through a driver in the scratchpad: exit 0, 52 checks. Output: `C:\Github\cvgen\.worktrees\report-figure-numbers\builds\review-r2-report-20261108-185240\` (`run.log`, `report\`).
- Pre-fix check: b90678d's script on the bare-number data gave `report: evidence: an item needs id`, exit 1.
- Top-level `[]`: db7af87 exits 1 with the Python error above. The base script exits 1 with "the JSON file must hold one object".
- Direct probes of `normalise` and `refusal`: script at `C:\Users\jimzord12\AppData\Local\Temp\claude\0bad7b43ffb974fe\bd07fd7a-826f-4da0-ace1-f4e996f70146\scratchpad\probe.py`. It writes no files.
- `ruff check`: I could not run it. Ruff is not on PATH and `python -m ruff` is not installed.

## Evidence inspected
- At db7af87: `scripts/report.py`, `tests/report.py`, `studio/brand/report/report.html` (how figure ids are used on the page), `README.md` and `sample.json` in `studio/brand/report/`, and `docs/preferences.md`.
- At 0dc93e7 and b90678d: `scripts/report.py`, via `git show`.
- The author's suite report, `builds\tests-20261108-183800-359372\report.json`: passed, 269 cases, including the three new report cases. It was written at 18:39:03, one second before the db7af87 commit.

## Limitations
- I did not run ruff (not available to me), so it rests on the author's run.
- I did not rerun the full suite; I rely on the author's report for that.
- I did not inspect the rendered page visually: the change does not alter the layout, only the id text.

## Verdict: PASS

**Next:** the lead records this report, and fixes R2-1 and R2-2 or records why they are deferred.
