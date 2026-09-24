---
kind: reference
---

# Research behind the idea agents, 2026-09-25

Targeted research done before writing the idea agents and their reviewers
(card `idea-agents`). Two research agents gathered it; a research-reviewer
round checked it (see `reviews/`). All URLs accessed 2026-09-25. [F] fact or
primary source, [O] opinion, practitioner or vendor source. Not legal advice.
Market and trend research is deliberately not here: the agents do it on each
run, so it never goes stale inside their instructions.

## 1. Claude Code subagent format

Source: https://code.claude.com/docs/en/sub-agents.md [F]

- A subagent is a Markdown file in `.claude/agents/` with YAML frontmatter;
  the body is its system prompt. Required: `name`, `description`. Used here:
  `tools` (allow-list; omitted means inherit), `model` (`opus`, `sonnet`,
  `haiku`, `fable`, a full id, or `inherit`), `effort` (`low` to `max`).
- `WebSearch` and `WebFetch` can be granted by name. A subagent cannot spawn
  further subagents unless `Agent(...)` is granted, so the lead runs the
  review loops, not the author.
- `description` drives automatic delegation; details belong in the body,
  which loads only when the subagent runs. CLAUDE.md loads too; conversation
  history does not. The parent sees only the final message.

## 2. Briefs that produce sharp, non-generic work

1. Brief like a new expert hire and say why each constraint exists.
   https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices [F]
2. A one-line role statement helps. Same source [F].
3. Every brief states objective, output format, tool guidance and task
   boundaries; vague briefs caused duplicated or misread work.
   https://www.anthropic.com/engineering/multi-agent-research-system [F]
4. Models converge on generic, "on distribution" output unless the defaults
   are named and ruled out (fonts, layouts, cookie-cutter design). Same
   Claude source [F]. Hence an explicit cliché list for the editor.
5. A few diverse examples help; too many cause overfitting, so examples go
   with explicit instructions. https://ai.google.dev/gemini-api/docs/prompting-strategies [F]
6. Say what to do, with a fixed output shape and a cap.
   https://developers.openai.com/cookbook/examples/gpt-5/gpt-5_prompting_guide [F]
7. Evaluator-optimizer loops pay off when evaluation criteria are clear and
   refinement adds measurable value.
   https://www.anthropic.com/engineering/building-effective-agents [F]
8. Define success criteria before tuning prompts.
   https://platform.claude.com/docs/en/test-and-evaluate/develop-tests [F]

Calibrated reviewers:

- Explicit rubric, fixed output, binary pass/fail per criterion with a
  written reason; scores like 3 of 5 are hard to act on.
  https://hamel.dev/blog/posts/llm-judge/ [O]; develop-tests source [F]
- Approve work that clearly improves things even if not perfect; label
  polish as a non-blocking nit; facts overrule opinions.
  https://google.github.io/eng-practices/review/reviewer/standard.html [F, Google policy]
- Blocking vs non-blocking labels. https://conventionalcomments.org/ [O]
- LLM judges favour longer answers, certain positions and their own model's
  output; mitigate with a fresh context per round and a fixed rubric.
  https://arxiv.org/abs/2306.05685 [F, research]

## 3. Fonts

- SIL OFL 1.1: use, embed, modify, redistribute, sell with software; not
  sold alone; keep copyright notice and licence with every copy; Reserved
  Font Names; documents made with the font are not covered.
  https://openfontlicense.org/open-font-license-official-text/ [F];
  FAQ 1.2, 1.13: https://openfontlicense.org/ofl-faq/ [F]
- Google Fonts: mostly OFL, some Apache 2.0 and the Ubuntu Font Licence;
  read each family's licence. https://github.com/google/fonts [F]
- Avoid "free for personal use" fonts, Adobe Fonts (no passing font files
  on), and commercial desktop EULAs (no server or generated-document use).
  https://helpx.adobe.com/fonts/using/font-licensing.html [F, via search excerpt];
  https://www.thefoundrytypes.com/licensing/ [F]
- Typst reads `.ttf` and `.otf` (collections reported to work); WOFF is not
  documented, treat as unsupported. Font discovery: `--font-path`, system
  fonts, then fonts embedded in Typst. https://typst.app/docs/reference/text/text/ [F]
- Variable fonts are supported since Typst 0.15.0 (standard axes set
  automatically, `variations` for custom axes); render-test before relying
  on one. https://typst.app/docs/changelog/0.15.0/ [F]

## 4. Where an art director should look

Fonts In Use https://fontsinuse.com/ · TDC winner archive
https://tdc.org/winner-archive/ · SPD https://www.spd.org/spd-61-merit-winners ·
ADC https://www.oneclub.org/awards/adcawards/ · D&AD
https://www.dandad.org/en/d-ad-awards-pencil-winners/ (account for full
archive) · Letterform Archive https://oa.letterformarchive.org/ · Museum für
Gestaltung https://museum-gestaltung.ch/en/whats/digital · Cooper Hewitt
https://collection.cooperhewitt.org/ · Eye https://www.eyemagazine.com/ ·
AIGA Eye on Design https://eyeondesign.aiga.org/tag/editorial-design/ · Klim
specimens https://klim.co.nz/ · Google Fonts Knowledge
https://fonts.google.com/knowledge · Typewolf https://www.typewolf.com/ ·
Butterick, résumé chapter https://practicaltypography.com/resumes.html [O].

The market to be different from (contrast, never inspiration): Canva
https://www.canva.com/resumes/templates/, Enhancv https://enhancv.com/, Zety
https://zety.com/, Novorésumé https://novoresume.com/, Resume.io
https://resume.io/.

## 5. Inspiration, not copying

- Page layout and format as such are not copyrightable (US Compendium
  §906.5, https://www.copyright.gov/comp3/chap900/ch900-visual-art.pdf [F]);
  nor are ideas, methods or typeface designs as such
  (https://www.copyright.gov/circs/circ33.pdf [F]).
- Protected: specific artwork, photos, logos, distinctive copy, font
  software (https://en.wikipedia.org/wiki/Adobe_Systems,_Inc._v._Southern_Software,_Inc. [F]),
  EU-registered typeface designs
  (https://guidelines.euipo.europa.eu/2058424/2064948/designs-guidelines/5-3-9-typographic-typefaces [F]),
  and trade dress (https://www.inta.org/topics/trade-dress/ [F]).
- Working rules (synthesis): take principles (grid, scale, hierarchy,
  rhythm), never artifacts; at least three unrelated references per concept,
  none dominant; original SVG artwork and fictional content only; licensed
  fonts shipped unmodified with their licence; no brand or named designer in
  a concept name; a mock-up that could be mistaken for its source fails.
