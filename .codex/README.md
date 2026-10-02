# CVgen's Codex agents

Native, repository-scoped counterparts of every agent in `.claude/agents/`.
Codex discovers the seven standalone TOML files in `.codex/agents/`; no global
configuration or project `config.toml` is needed. Open a fresh Codex session in
this repository after adding them. The installed CLI used for verification is
0.160.0. See the [official custom-agent format](https://learn.chatgpt.com/docs/agent-configuration/subagents#custom-agents).

## Roles

| Agent | Job | Permitted writes |
| --- | --- | --- |
| `ceo` | Up to three researched, roadmap-aware product proposals | The lead's idea-run folder only |
| `ceo-reviewer` | Review product proposals against five criteria | None |
| `magazine-editor` | Three Styles, two Densities, three Design Tiers: eighteen fictional Typst concepts | Concept folders, their README rows, licensed concept fonts, fresh builds/ artifacts |
| `design-reviewer` | Inspect every page; Batch Test, Three-Second Test, Flagship Parity and craft | Fresh builds/ renders and batch sheets only |
| `research-reviewer` | Verify load-bearing claims and current primary sources | None |
| `repo-auditor-lite` | Confirm repo-maintenance leads and judgement checks | None |
| `code-reviewer` | Advisory snapshot review under docs/review.md | Vetted checks into fresh builds/ folders only |

## Use

Ask Codex to delegate to a role by name. For example:

```text
Use the research-reviewer agent to check this research note. Give it the
question, file path and SHA-256, round number, and any previous reports.
```

```text
Run a magazine-editor Idea Run for the travel-and-tourism Domain, Japan
specialty, tour escort Rank. Use fictional facts. Follow the repo's idea-run
skill, including fresh research-reviewer and design-reviewer agents per round.
```

The lead owns delegation, Git, Trello, report persistence and round limits.
Reviewers return reports; the lead saves them unchanged. Give each agent the
exact snapshot and the minimum context its role requires. No role delegates.

## Shared workflows and deliberate adaptations

All nine repo skills were inspected. They remain in `.claude/skills/`: new-client,
new-cv, verify-cv, new-theme, trello, repo-maintenance, idea-run, start-night-shift
and do-night-shift-follow-up. Read their SKILL.md files directly when relevant;
they have not been installed into Codex's skill selector. Read the associated
references or run vetted helpers by their existing paths. Translate Claude's
Agent/SendMessage and slash-command mechanics into the available Codex tools;
follow current owner instructions if a shared skill's older permissions differ.

The TOML prompts preserve each source agent's substantive brief, rubrics,
outputs and boundaries. Claude model names and tool-list frontmatter are not
Codex configuration. Models inherit from the parent session; reasoning effort
matches the source (high, except repo-auditor-lite at medium). Claude's no-shell
roles may use a shell strictly to read/list/search repository files when no
file tools are available. This permits their original reads, not new side effects.

Read-only roles request a read-only sandbox. Authors and evidence-producing
reviewers request workspace-write, with narrower paths enforced by their role
instructions. These are not Claude-style tool allowlists: inherited tools,
connectors and parent runtime permission overrides can still be broader. Keep
role restrictions in the delegation brief and inspect the returned report.

The owner's live safety checkpoints govern overwrites, removals, cleanup and
destructive Git, including an author's revisions and dropped concepts. Real
Client data stays private; no agent approves a real PDF. Product and design
proposals still need the owner's decision.

AGENTS.md and docs/review.md still reserve implementation and its review gate
for Claude. Creating code-reviewer here does not change that policy: a Codex
verdict is advisory and cannot discharge the Claude gate. This setup changes
agent configuration only.

The Claude and Codex prompts are separate harness adaptations. When a Claude
role changes, compare its matching TOML prompt; keep changing rules in their
canonical docs instead of adding another policy here. Shared skills are reused
rather than mirrored.
