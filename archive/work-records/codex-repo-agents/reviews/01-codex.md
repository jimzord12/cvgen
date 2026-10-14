# Advisory configuration review round 1: pc3a0vY1

Snapshot: HEAD `8551dae8270f4976a96b42b7305690731953a20a`, plus the eight files identified by `builds/codex-agents-20261002-161646/snapshot.json`. All eight SHA-256 hashes match.

Lead lenses: contracts/compatibility; repository/documentation.

## Eight-lens coverage

1. **Product fit and wiring:** Seven Codex definitions match the seven Claude roles. Native loader evidence establishes discovery of repository agent files.
2. **Correctness and edge cases:** All TOML files parse; names are unique and match their filenames. Body comparisons show preserved role briefs, rubrics and outputs, with narrow Codex adaptations.
3. **Data and document integrity:** Fictional-content rules, service-time restrictions, `Meta File` stamping and owner-only real `Approval` remain intact.
4. **Contracts, access and privacy:** Private-data restrictions, prohibited external actions and no-delegation boundaries remain explicit. Read-only shell fallbacks preserve reads without authorizing measurements or writes. Sandbox limitations are accurately disclosed.
5. **Tests and visible evidence:** Independent parsing/hash checks pass. Inspected native positive/negative loader evidence supports discovery; prompt-input name mentions alone were correctly excluded as proof. Visual evidence is n/a for configuration.
6. **Failure handling and recovery:** Missing dependencies, unavailable inspection and missing evidence must be reported. Instructions prohibit installation or weakened permissions as workarounds. Duplicate names produce a native warning.
7. **Simplicity and ownership:** Scope stays within `.codex/`. Existing `.claude/skills/` workflows are reused directly. Canonical rules remain in their existing documents; role synchronization is documented.
8. **Repository and documentation:** Seven-role parity, nine existing skill paths and LF-only new files confirmed. README explains invocation, permissions, inherited models and the remaining Claude review gate.

## Findings

No Blocking, Material or Minor configuration findings.

**N1 — Note: invocation remains untested.**
Anchor: `.codex/README.md`, “Use”. Loader evidence demonstrates file discovery and successful initialization, rather than model-driven delegation or role behavior. Record this distinction in the author evidence; no source correction is required.

## Checks actually performed

Read all seven Claude counterparts and Codex definitions; independently parsed TOML, compared role bodies, verified manifest hashes, compared role names, inspected line endings and checked Git state. All passed; these read-only checks created no artifacts.

Also verified both isolated loader fixtures preserve all eight snapshot files byte-for-byte, and the negative fixture’s additional `duplicate.toml` exactly matches `ceo.toml`.

## Evidence inspected

- `builds/codex-discovery-20261002-161704/prompt.json`
- `builds/codex-native-loader-20261002-162159/transcript.json`
- `builds/codex-thread-loader-20261002-162122/transcript.json`

The native transcript shows valid initialization without agent-role warnings, followed by a duplicate-role warning for the negative fixture. Main-checkout initialization also reports no agent-role warning. The existing Sanity configuration warning is unrelated.

## Limitations

Native loader probes were author-run and inspected, not personally rerun. No model-driven invocation, CV render or full suite was run; this change only adds agent configuration/documentation. Broad inherited permissions remain governed by role instructions.

## Verdict: advisory PASS

This is independent configuration feedback. It does not satisfy or replace the Claude review gate required by `docs/review.md`.

That’s all I had to say.
