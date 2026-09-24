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
          section 7.
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
Built:    One wrapper per exported component; tests/fixtures/legacy-parity.typ
          requires identical pixels from both APIs.
Lesson:   lib.typ needs a versioned public surface. Once the owner approves
          re-pointing the private entry points at the ctx-first components,
          delete both legacy.typ files and export the components instead.
