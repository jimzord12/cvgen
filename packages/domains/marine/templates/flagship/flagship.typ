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

// `candidate` is a candidate-facts record; the adapter turns it into Flagship input.
// `role` is a marine role marker (roles/<role>/role.typ) or none; Flagship serves every role of the domain.
#let flagship(body, candidate: none, role: none, theme: none, artwork: none, layout: none, show-vessel-durations: true, copy: (:)) = {
  assert(candidate != none and theme != none and artwork != none and layout != none,
    message: "flagship requires candidate, theme, artwork and layout")
  let d = normalize-candidate(to-flagship-input(candidate, role: role, copy: copy))
  validate-theme(theme)
  validate-candidate(d, show-vessel-durations)
  validate-pages(layout.pages, d, domain.experience)
  // Built once; every component reads its own slice and passes it on untouched (ADR 0008).
  let ctx = make-ctx(theme: theme, layout: layout, artwork: artwork, copy: d.copy,
    options: (show-vessel-durations: show-vessel-durations))
  document-shell(ctx, d, title: d.identity.name + " | " + d.identity.rank + " | " + domain.meta.title, author: domain.meta.author)[
    #for (i, page-plan) in layout.pages.enumerate() {
      let opening = i == 0
      if i > 0 {pagebreak()}
      set page(margin: if opening {layout.opening-margin} else {layout.continuation-margin})
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
      if page-plan.at("synopsis", default: false) {synopsis(ctx, (domain.experience.totals)(d.companies))}
      if page-plan.at("certificates", default: false) and d.certificates.len() > 0 {certificates-section(ctx, d.certificates)}
      if page-plan.at("education", default: false) and (d.education.len() + d.languages.len() > 0) {
        if layout.anchor-education {v(1fr)}
        education-languages-section(ctx, (education: d.education, languages: d.languages))
      }
      context assert.eq(counter(page).get().first(), i + 1,
        message: "Content overflow on planned page " + str(i + 1) + ": split company rows or allocate another page")
    }
    #body
  ]
}
