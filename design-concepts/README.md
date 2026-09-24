# Design concepts

Proposals for new CV templates, each drawn as a real one-page mock-up on
fictional data. Produced by the `magazine-editor` agent through the `idea-run`
skill. Not library code: nothing here is imported by `packages/`, and a concept
becomes a template only after the owner keeps it and a build task is agreed.

Each folder holds `concept.typ` (self-contained), `concept.pdf`, `page-1.png`
(96 dpi) and `brief.md` (idea, references, fonts with source and SHA-256,
data, weaknesses). Downloaded font families live once in `fonts/<family>/`
with their licence and are shared between concepts. Compile from the repository root:

```powershell
typst compile --root . --ignore-system-fonts --font-path packages/cv-engine/fonts --font-path design-concepts/fonts design-concepts/<folder>/concept.typ builds/<name>.pdf
```

| Concept | Idea | Date | Status | PDF |
|---|---|---|---|---|
| Measured in Months | The career drawn to scale: one bar per vessel, length = service months; marine and travel variants | 2026-09-25 | proposed | [marine](2026-09-25-measured-in-months/concept.pdf) · [travel](2026-09-25-measured-in-months/concept-travel.pdf) |
| Feature Opener | The CV as a magazine feature opener: headline name, standfirst, contents list, pull-quote; marine and travel variants | 2026-09-25 | proposed | [marine](2026-09-25-feature-opener/concept.pdf) · [travel](2026-09-25-feature-opener/concept-travel.pdf) |
| Fleet in Signs | Isotype count of the fleet: one sign per vessel, silhouette = class, colour = rank | 2026-09-25 | proposed | [marine](2026-09-25-fleet-in-signs/concept.pdf) |
