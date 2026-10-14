## Review round 1: context-reviewer, 2026-10-14

Snapshot: `.worktrees/task-50`, head f5ef8c2 against merge-base 275038e.

Verdict: PASS. Recorded in substance (formatting condensed).

Lens 1: the 7 removed font files and 4 OFL.txt files are SHA-256 identical to the copies in packages/cv-framework/fonts/ and packages/cv-framework/licenses/; each removed family keeps exactly one OFL notice; design-concepts/fonts/ holds only alegreya, fira-sans and jost, each with its OFL.txt; brief SHA-256 values match the remaining files (first-fitting, concourse, stamp-rally, woodblock-road); no path into a removed family folder outside dated records; every documented compile passes --font-path packages/cv-framework/fonts (design-review server too); atlas check --strict ok; LF.
Lens 2: both profiles' "available without bringing one" list matches the Framework fonts plus Typst's built-ins; the "never copy one the Framework bundles" clause is a short restatement owned by design-concepts/README.md; design-reviewer.md:104 needs no change; nothing private.

Minor
1. design-concepts/README.md:25 contains a literal backslash-n ("shared between\nconcepts."); replace with a newline.
2. .claude/agents/magazine-editor.md:167 and .codex/agents/magazine-editor.toml:192 run to ~110 characters; rewrap.

Notes
3. design-concepts/2026-10-02-hanami-line/brief.md:44 says "`OFL.txt` beside it" for Sofia Sans Extra Condensed; the notice is packages/cv-framework/licenses/sofiasansextracondensed-OFL.txt (pre-existing).
4. TASK-50 title still says "the three fonts stored twice" (four families).
5. docs/git-workflow.md:116 still accurate.

The 14 concept compiles were not rerun (they write files); with byte-identical files on a font path the author's pixel comparison stands.

## Dispositions (lead)

- 1, 2, 3, 4 fixed by the lead (formatting and one path; no further round).
