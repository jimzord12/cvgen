// The Flagship composition: page loop, section order, overflow check.
#import "../../data.typ": normalize-candidate, validate-candidate
#import "../../domain.typ": domain
#import "../../../../cv-framework/core/component.typ": make-ctx
#import "../../../../cv-framework/core/theme.typ": validate-theme
#import "../../../../cv-framework/core/page.typ": document-shell, page-header
#import "../../../../cv-framework/core/pagination.typ": validate-pages, company-fragment
#import "adapter/adapter.typ": to-flagship-input
#import "components/hero.typ": hero
#import "components/experience.typ": experience-section
#import "components/sections.typ": profile-summary, section-heading, synopsis
#import "components/certificates.typ": certificates-section
#import "components/education.typ": education-languages-section

// Flagship's page plan: the core's grammar (every vessel row once, in order), then
// Flagship's own closing sections: exactly one synopsis, on the last Experience page,
// and certificates and education at most once each, on or after it, whenever the
// candidate has them.
#let validate-plan(pages, d, model) = {
  validate-pages(pages, d, model)
  let synopsis-pages = pages.enumerate().filter(((i, p)) => p.at("synopsis", default: false))
  assert.eq(synopsis-pages.len(), 1, message: "Page plan requires exactly one synopsis")
  let final-experience = pages.enumerate().filter(((i, p)) => p.companies.len() > 0)
  assert(final-experience.len() > 0, message: "Experience requires at least one vessel")
  assert.eq(synopsis-pages.first().at(0), final-experience.last().at(0), message: "Synopsis must follow the final Experience page")
  for (key, required) in (("certificates", d.certificates.len() > 0), ("education", d.education.len() + d.languages.len() > 0)) {
    let assigned = pages.enumerate().filter(((i, p)) => p.at(key, default: false))
    assert(assigned.len() <= 1, message: "Section assigned more than once: " + key)
    if required {
      assert.eq(assigned.len(), 1, message: "Missing page assignment: " + key)
      assert(assigned.first().at(0) >= final-experience.last().at(0), message: "Credentials must follow Experience")
    }
  }
}

// Keys a layout profile set before TASK-45 and the shell now owns. A layout that still
// sets one fails here instead of being silently ignored on page 1. Also called by the
// deprecated document-shell wrapper (legacy.typ), so older compositions fail the same way.
#let check-layout(layout) = {
  assert("opening-margin" not in layout,
    message: "layout.opening-margin is retired: set the first page's margin as shell.margin, e.g. (..base, shell: (..base.shell, margin: (x: 16mm, top: 12mm, bottom: 15mm)))")
  assert(type(layout.at("hero", default: none)) != dictionary or "band-height" not in layout.hero,
    message: "layout.hero.band-height is retired: set the hero band's height as shell.band, e.g. (..base, shell: (..base.shell, band: 83mm))")
}

// `candidate` is a candidate-facts record; the adapter turns it into Flagship input.
// `role` is a marine role marker (roles/<role>/role.typ) or none; Flagship serves every role of the domain.
#let flagship(body, candidate: none, role: none, theme: none, artwork: none, layout: none, show-vessel-durations: true, copy: (:)) = {
  assert(candidate != none and theme != none and artwork != none and layout != none,
    message: "flagship requires candidate, theme, artwork and layout")
  let d = normalize-candidate(to-flagship-input(candidate, role: role, copy: copy))
  validate-theme(theme)
  validate-candidate(d, show-vessel-durations)
  check-layout(layout)
  validate-plan(layout.pages, d, domain.experience)
  // Built once; every component reads its own slice and passes it on untouched (ADR 0008).
  let ctx = make-ctx(theme: theme, layout: layout, artwork: artwork, copy: d.copy,
    options: (show-vessel-durations: show-vessel-durations))
  document-shell(ctx, d, title: d.identity.name + " | " + d.identity.rank + " | " + domain.meta.title, author: domain.meta.author)[
    #for (i, page-plan) in layout.pages.enumerate() {
      let opening = i == 0
      if i > 0 {pagebreak()}
      set page(margin: if opening {layout.shell.margin} else {layout.continuation-margin})
      if opening {hero(ctx, d)}
      set par(spacing: 0pt, leading: theme.leading.body)
      if not opening {page-header(ctx, (name: d.identity.name, headline: d.identity.rank), caption: d.copy.page-caption)}
      if opening {profile-summary(ctx, d.profile)}
      if page-plan.companies.len() > 0 {
        section-heading(ctx, d.copy.experience, number: "01",
          spacing: if opening {layout.headings.opening} else {layout.headings.continuation},
          subtitle: if opening {d.copy.experience-subtitle} else {d.copy.continuation})
        experience-section(ctx, page-plan.companies.map(ref => company-fragment(ref, d.companies, domain.experience)),
          spacing: if opening {layout.experience.opening} else {layout.experience.continuation})
      }
      // `spread` (one-page profile): with both certificates and education on the page, the free
      // space is shared equally above each instead of all above education; a heading's own gap
      // collapses next to flexible space, so it is restated as the minimum. With one of them
      // missing, the blocks stack from the top with the wider `stack-gap` between them and the free
      // space falls at the bottom (owner).
      let spread = layout.at("spread", default: false)
      let has-certificates = page-plan.at("certificates", default: false) and d.certificates.len() > 0
      let has-education = page-plan.at("education", default: false) and (d.education.len() + d.languages.len() > 0)
      let shared = spread and has-certificates and has-education
      let stacked = spread and not shared
      if page-plan.at("synopsis", default: false) {
        if stacked {v(layout.stack-gap)}
        synopsis(ctx, (domain.experience.totals)(d.companies))
      }
      if has-certificates {
        if shared {v(1fr); v(layout.headings.certificates.above)}
        if stacked {v(layout.stack-gap)}
        certificates-section(ctx, d.certificates)
      }
      if has-education {
        if layout.anchor-education and (shared or not spread) {v(1fr)}
        if shared {v(layout.headings.education.above)}
        if stacked {v(layout.stack-gap)}
        education-languages-section(ctx, (education: d.education, languages: d.languages))
      }
      context assert.eq(counter(page).get().first(), i + 1,
        message: "Content overflow on planned page " + str(i + 1) + ": split company rows or allocate another page")
    }
    #body
  ]
}
