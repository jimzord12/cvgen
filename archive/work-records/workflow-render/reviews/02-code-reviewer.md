## Review round 1 (code): code-reviewer, 2026-10-14

Snapshot: `origin/main...e9a6acb` (12 commits, 25 files). Lenses: correctness and test strength; wiring.

Verdict: FINDINGS. Recorded in substance.

Coverage: suite case and CI step (`check`, `render --check`, `render.log` uploaded) correct; all-or-nothing write confirmed; Mermaid subset enforced, `nodeId` injective (kebab IDs cannot contain `--`); messages give file:line, STALE names each file, exit codes 0/1/2; render reuses `deriveGraph`/`placeholderCap` (no second graph); docs accurate except "never touched" (F2).

Material
- F1 AC #2 "diagrams render on GitHub" has no inspectable evidence: only a one-off Mermaid 11.4.1 parse under happy-dom in a scratchpad, no log kept, nobody viewed the diagrams on GitHub. Fix: view the READMEs at the pushed head and record it in the task notes.

Minor
- F2 `tools/workflow/src/render.ts:53-73`: marker lines inside a code fence count as real markers (a fenced example holding the only `steps` pair gets replaced; with the real block present render fails "appears twice"); contradicts "never touched"; TASK-40 may quote markers. Fix: skip markers inside ```/~~~ fences, one test.
- F3 `render.ts:177-192, 302`; `test/render.test.ts:90-107`: the optional-step exception has no correctness test (the fixture's only `when` step is entered through a cut edge; `reduce(edges)` without the optional set leaves all assertions green). Fix: a case where the only implying path goes through a `when` step.

Notes
- N1 gate branches count as paths in the reduction; 17 arrows dropped in the real model, 6 implied only through a gate branch, all along drawn control flow; none hides a needed edge.
- N2 `code()` cells do not escape `|` (`render.ts:93, 342`).
- N3 actors sorted with `localeCompare` (`render.ts:239`); code-unit order avoids ICU.

Checks rerun (builds/review-task39-r1-20261014-132218/): `bun test` 88 pass; `render --check` OK; scratch copy with one README deleted and one CRLF, rendered twice: 1 changed then 0, byte-identical (CRLF one kept CRLF); probes: text between and after blocks survives; fence case as F2. Limitations: GitHub not viewed, CI not inspected, suite not rerun, Atlas only by stat.

## Dispositions (lead)

- F1: fixed by the lead: viewed `docs/workflow/05-design/README.md` (the largest diagram, 33 nodes) on github.com at the pushed head in a browser; it draws; the author's `gh api` HTML check found the mermaid container in the top README, 01-open and 05-design. Recorded in the task notes.
- F2, F3: fix. N2, N3: fix (cheap). N1: accepted.
