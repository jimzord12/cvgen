// Golden Blue: the original navy, teal and brass theme. Visual tokens only; geometry lives in layouts/.
#let theme = (
  name: "Golden Blue",
  colors: (ink: rgb("102f3a"), hero: rgb("102f3a"), accent: rgb("236a70"),
    metal: rgb("c8a579"), muted: rgb("546870"), surface: rgb("eef4f3"),
    paper: white, plate: rgb("f7f4ee"), rule: rgb("cfdddd"), on-hero: white),
  fonts: (body: "Source Sans 3", display: "Barlow"),
  art-colors: ("#619095": rgb("619095"), "#47747a": rgb("47747a"),
    "#b38e61": rgb("b38e61"), "#e6caa0": rgb("e6caa0"),
    "#98774f": rgb("98774f"), "#e4c79f": rgb("e4c79f")),
  sizes: (body: 10.5pt, label: 8pt, section-number: 28pt, section-title: 15pt,
    subtitle: 9pt, duration: 16pt, company: 15pt, vessel: 10.5pt, rank-row: 9pt,
    contact: 10pt, name: 34pt, rank: 11pt, metric: 25pt, metric-unit: 14pt,
    page-name: 23pt, page-caption: 9pt, footer: 7pt, certificate: 9.5pt,
    qualification: 12pt, institution: 10pt, note: 8pt, language: 11pt, proficiency: 9.5pt),
  tracking: (label: 1.1pt, rank: 2.2pt),
  leading: (initial: 0.55em, body: 0.6em, duration: 0.2em),
)
