# Optimal-condition checklist

35 checks in 12 groups. "Run by": S = `scripts/audit.py`, A = the auditor (judgement), T = external tool if
installed, D = deep mode. A check that was not run is NOT_CHECKED. Thresholds marked † are defaults; a repo
layer may override them. Severity is the default; a repo layer may change it, and may map the words to its own
(for example Blocking, Material, Minor, Note; mapping in SKILL.md). A check can be marked not applicable with a
reason; do not force a finding. Every finding needs a practical consequence, otherwise it is Info or dropped.

| ID | Check | Test | Severity | Run by |
| --- | --- | --- | --- | --- |
| N1 | One naming style per directory | In a directory with 4+ files, tracked names share one case style; list the minority | Low | S |
| N2 | Names say what the file is | No final, new, copy, old, tmp, backup, untitled, "(1)", spaces, bare v2 suffix | Medium | S |
| N3 | Shallow, narrow tree | Depth ≤ 5†, ≤ 12† visible top-level entries, ≤ 25† entries per directory | Low | S |
| N4 | Every top-level directory has a stated purpose | Each name appears with a description in the map file (AGENTS.md, CLAUDE.md, README) | Medium | S, A |
| H1 | One home per kind of file | Declared `homes` rules hold. Undeclared: same extension in 4+ top-level directories is a candidate only | High declared, Low inferred | S |
| H2 | Health files in one place | LICENSE, SECURITY, CODEOWNERS, CONTRIBUTING, CODE_OF_CONDUCT each in at most one of root, .github/, docs/ | Low | S |
| H3 | One canonical doc per topic | No topic explained in two docs without one pointing to the other as the source | Medium | A |
| D1 | No exact duplicates | No two tracked files of 64+ bytes share a SHA-256 unless declared | Medium | S |
| D2 | No leftovers | No tracked .bak .orig .rej .swp ~ .DS_Store Thumbs.db | Medium | S |
| D3 | No orphan docs | Every .md doc is mentioned by another tracked file or is a declared entry point | Low | S |
| D4 | No unreferenced code or assets | knip, vulture, deptry, cargo-machete if configured; else a name-grep lead. Result is "review", never "delete" | Low | T, A |
| L1 | No broken relative links | Every relative Markdown link resolves; `lychee --offline` when installed | High | S, T |
| L2 | No dead path mentions | Backticked paths in docs exist (root- or doc-relative). Lead | Medium | S |
| L3 | Docs newer than what they describe | Doc older than 90 days† and a path it names changed after it. Lead | Medium | S |
| L4 | Owner and review date | Only where the repo uses doc front matter | Low | A |
| R1 | README answers four questions | What it is (description < 120 characters), how to run, how to test, where docs live | Medium | S, A |
| R2 | README commands work | Quickstart runs in a clean worktree | Medium | D |
| R3 | One short agent map | CLAUDE.md and AGENTS.md ≤ 200 lines each; if both exist, one imports the other with `@AGENTS.md` | Medium | S |
| G1 | No generated output tracked | No dist, build, out, target, node_modules, __pycache__, .venv, .next, coverage, *.pyc | High | S |
| G2 | Generated files are labelled | Files with a "generated" or "do not edit" banner are declared generated | Low | S |
| C1 | One tool, one config | No two live configs for one tool; ≤ 12† config files at the root | Medium | S |
| C2 | One lockfile per ecosystem | Not two of package-lock.json, yarn.lock, pnpm-lock.yaml, bun.lock(b); not two of poetry.lock, uv.lock, Pipfile.lock, pdm.lock | Medium | S |
| P1 | Declared equals used | knip, deptry, cargo-machete report nothing; else NOT_CHECKED | Medium | T |
| P2 | Updates are automated | Dependabot or Renovate config exists | Low | S |
| I1 | Nothing tracked is ignored | `git ls-files -c -i --exclude-standard` is empty | Medium | S |
| I2 | No lingering untracked files | `git ls-files -o --exclude-standard` is empty. Report only | Medium | S |
| I3 | No secrets tracked | No tracked .env, *.pem, id_rsa*, *.key; gitleaks if installed. Never print content | Critical | S, T |
| B1 | Large files | ≥ 1 MiB† Low, ≥ 10 MiB† Medium, ≥ 50 MiB High (GitHub warns at 50, blocks above 100) | Low to High | S |
| B2 | Binary artifacts | No tracked .exe .dll .so .dylib .jar .class .o .whl | Medium | S |
| T1 | Same word, same meaning | Declared forbidden terms occur 0 times; no glossary term defined twice | Medium | S, A |
| T2 | Spelling variants | A term is not written in two of hyphenated, spaced, joined | Low | S |
| X1 | Newcomer test | 3 questions answered within 3 file reads from README and map | Medium | A |
| X2 | Big folders explain themselves | 8+ files: README/index present or named in the map | Low | S |
| X3 | Tests pass | The declared test command exits 0 | High | D |
| X4 | Contract checks pass | Every repo-declared check exits 0 | High | D |

## Judgement rules for the auditor

- **H3.** List topics that two or more docs explain (same heading text or same defined term). A pair is fine if one links to the other as the primary source. Otherwise report both paths and name the likelier primary.
- **N4 / R1.** A folder is "explained" only if a human could tell from the description what belongs in it. "Misc" or a bare name does not count.
- **L2 / L3 / D3 / D4 leads.** Open the file. L2: is there exactly one likely successor path (same basename, or `git log --follow` shows a rename)? Then tier A. L3: does the changed path actually make a sentence in the doc false? If not, drop it.
- **X1.** Record which files you read for each answer. If you needed more than 3, or guessed, it is a finding, and the smallest fix is usually one line in the map.
- **T1.** The glossary itself may list the wrong terms as "not this"; do not flag it.
- Protected paths: report as tier C and propose no change.
- Large files (B1): the thresholds are defaults for a first pass. For each hit ask what it is (source asset, frozen
  reference, release, accidental output) and declare the intentional ones in `allow_large`; do not treat size alone as a defect.
- Dead code or assets (D3, D4): a lack of references is a lead. Check runtime, dynamic, generated, archival and
  external consumers before calling anything dead; the outcome is "review", never "delete".
