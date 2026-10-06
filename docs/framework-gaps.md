# Framework gaps

Read this before planning framework work, and add to it whenever you go
around a component, template or contract to get a CV done (constitution
section 10). Newest at the bottom. Never delete an entry; mark it closed
when the gap is filled.

Each entry is a few lines:

```text
### YYYY-MM-DD  short title                          Status: open [, where it is planned] | closed by <ADR, PR or commit>
Needed:   what the owner or candidate required
Bypassed: which component, template or rule of the contract could not do it
Built:    what was done instead, and where (a private folder, an entry point, a one-off)
Lesson:   what the framework would need, in one sentence
```

A gap that appears a second time is a candidate for a component, a slot or
an extension. A third appearance makes it one (rule of three, ADR 0007).

## Entries

### 2026-09-12  Contract periods instead of service months          Status: open, roadmap item three (deck data support, marine domain)
Needed:   A deck officer's career recorded as one date range per contract, with
          a synopsis counting contracts, vessels and companies.
Bypassed: The candidate schema (no field for periods), the experience section
          (rows carry months), the synopsis (months, vessels, companies).
Built:    A custom composition in the candidate's private folder: a hand-made
          vessel, rank and period table, a hand-made synopsis, periods kept in
          a separate `presentation.json`. See `docs/guides/build-a-cv.md`
          section 8.
Lesson:   The schema needs contract periods, and the synopsis needs its metrics
          declared by data.

### 2026-09-12  Three-column certificate table                     Status: open, roadmap item three (deck data support, marine domain)
Needed:   An approved design with certificate, provider and date, no
          expiry column.
Bypassed: `certificate-table`, which renders four fixed cells per record.
Built:    A hand-made table in the private entry point.
Lesson:   The certificate table should take its columns from data or copy.

### 2026-09-12  Skills section inside the two-page layout           Status: open, roadmap item three (deck data support, marine domain)
Needed:   A professional skills block at the bottom of page one.
Bypassed: The `flagship` template, which has no slot for it; the section
          exists only as a standalone export.
Built:    Placed by hand in a custom composition.
Lesson:   The template needs a slot for optional sections per page.

### 2026-09-25  Legacy component signatures                         Status: open, remove when no custom composition imports them
Needed:   The ADR 0008 migration (ctx first) without breaking the two private
          custom compositions, which import lib.typ's component names with the
          old (data, theme, geometry) order and are never edited by an agent.
Bypassed: The contract itself: lib.typ exports the old names as thin wrappers
          (core/legacy.typ, templates/flagship/legacy.typ) instead of the
          ctx-first components.
Built:    One wrapper per exported component (32); the ctx-first components
          are exported as the modules core-components and flagship-components.
          tests/fixtures/legacy-parity.typ calls every wrapper and requires
          identical pixels from both APIs.
Lesson:   lib.typ needs a versioned public surface. Once the owner approves
          re-pointing the private entry points at the ctx-first components,
          delete both legacy.typ files and the flat names.

### 2026-09-25  Style blocks not yet applied                        Status: open, applied when a component is next touched
Needed:   ADR 0008's style block: each component groups its set and show
          rules at the top of its returned block.
Bypassed: The 2026-09-25 migration changed signatures only; most components
          still pass size, weight and fill inline on each text call.
Built:    Nothing; the rendering is unchanged and pixel-identical.
Lesson:   Move styling into style blocks one component at a time under the
          pixel gate, when a component is changed for another reason.

### 2026-09-25  A client whose domain does not exist yet           Status: open until the domain exists; the snapshot limit closed by task revision-snapshot (2026-09-27)
Needed:   A CV for a client outside marine (a tour guide) through
          `scripts/cv.py render`, `approve` and `export`, before the
          `Travel & Tourism` domain exists.
Bypassed: The domain level: the design is a one-off template in the
          client's Envelope. Until ADR 0012 an entry point importing
          `lib.typ` was checked against Flagship's marine schema; since
          then it imports `/packages/cv-framework/lib.typ`, which names no
          schema. A revision still snapshots only `cv.typ`,
          `candidate.json` and the portrait, so the design must fit in
          `cv.typ`.
Built:    The path in the client workflow (guide section 9); no client has
          used it yet.
Lesson:   The snapshot needs the sibling files an entry point reads, and a
          second client in the same career area is the moment to open its
          domain.
Update:   2026-09-27: a revision now copies the files `cv.typ` reads by a
          literal relative path (and its local helpers), so the design no
          longer has to fit in `cv.typ` (`build-a-cv.md` section 8).
Update:   2026-09-29: first used, by client-2026-09-01 (next entry).

### 2026-09-29  A bilingual one-off CV with no domain components   Status: open until the Travel & Tourism domain exists (task travel-domain)
Needed:   A two-page tour-leader CV for client-2026-09-01 in Greek and
          English from one design, with a page about the client's trips
          drawn as rail line diagrams.
Bypassed: Every template and domain component: the Framework offers
          `normalize-common`, `validate-common` and the page shell, but no
          component for a non-marine hero, experience list, sidebar or
          route diagram, and no language switch. Greek capitals are also
          avoided in the design, because nothing strips their accents
          (`scripts/text-draft.typ` has `caps-el`, which is not library code).
Built:    The one-off Template "Line Diagram" in the client's Envelope:
          `design.typ` (components and page plan), `text-el.typ` and
          `text-en.typ` (the signed-off text and its translation), chosen by
          `--input lang=el|en` on `scripts/cv.py render`; one revision per
          language.
Lesson:   The Travel & Tourism domain should start from this design: a
          language input with one text file per language, a route-diagram
          component, and a Greek-capitals helper in the Framework (where
          `label` in `core/primitives.typ` already upper-cases).

### 2026-10-02  A second one-off travel CV, in a chosen concept (Hanami Line 2)   Status: open until the Travel & Tourism domain exists (task travel-domain)
Needed:   The owner's chosen travel design (`design-concepts/2026-10-02-hanami-line-2/`, three palettes) built for client-2026-09-01 in Greek and English, with the client's portrait and a footer logo.
Bypassed: Every template and domain component again (no Travel & Tourism `Domain`): a one-off Template in the client's Envelope (`design-hanami.typ`, text slots in `text-hanami-*.typ`, generated SVG art in `assets/`), chosen by `--input design=hanami --input palette=pink|indigo|blue --input lang=el|en`.
Built:    Three font families the design needs (Sofia Sans Extra Condensed, M PLUS 1p, Kaisei Tokumin) moved into `packages/cv-framework/fonts/` because `scripts/cv.py` only searches that folder; a petal-layer script that lays out decoration against the text boxes of the compiled PDF and checks for collisions.
Lesson:   (1) A render needs `private/` to be a real folder in the checkout that runs it: both Python (`Path.resolve()`) and Typst (project-root check) refuse an Envelope reached through a junction, so a worktree cannot borrow another checkout's `private/`. (2) `typst query` is deprecated in 0.15.1 (`typst eval` replaces it). (3) A requested italic is silently drawn upright because the bundled Source Sans 3 has no italic file. (4) A language input with one text file per language, a route-diagram component and a Greek-capitals helper (the 2026-09-29 lesson) are still the first things the Travel & Tourism domain needs; the petal-layer script could become a Framework decoration tool.
