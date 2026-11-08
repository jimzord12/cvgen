// Hanami essential: the travel Domain's first `scan-first` Template Variation (P-0019 section 9,
// TASK-79). One A4 page a recruiter scans in seconds: the name block in a shallow Hanami band, the
// profile row, each role's title, employer and dates on the left with education at the column's
// foot, and the languages, destinations and know-how on a rail. When the roles do not fit, the most
// recent ones stay in full and the older ones become one summary with the domain's totals; when even
// the newest role does not fit, the compile fails (no shrinking, no second page: constitution 4).
#import "../../domain.typ": domain
#import "components/art.typ": at, tokens
#import "components/hero.typ": footer
#import "components/essential.typ" as parts

// Experience and education, with `k` roles in full and the rest summarised.
#let career(ctx, d, k) = {
  let full = d.experience.slice(0, k)
  let older = d.experience.slice(k)
  parts.section(ctx, "01", ctx.copy.experience)
  for (i, j) in full.enumerate() {
    if i > 0 { v(4.6mm); v(1fr) }
    parts.role(ctx, j)
  }
  if older.len() > 0 {
    v(4.6mm)
    v(0.6fr)
    parts.earlier(ctx, (domain.experience-totals)(older), older)
  }
  if d.education.len() > 0 {
    v(6.4mm)
    v(1.2fr)
    parts.section(ctx, "02", ctx.copy.education)
    parts.education(ctx, d.education)
  }
}

#let rail(ctx, d, totals) = {
  let gap = v(7mm)
  let parts-list = ()
  if d.availability != none { parts-list.push(parts.availability(ctx, d.availability)) }
  if d.languages.len() > 0 { parts-list.push({ parts.rail-title(ctx, ctx.copy.languages); parts.languages(ctx, d.languages) }) }
  if d.destinations != none { parts-list.push({ parts.rail-title(ctx, ctx.copy.destinations); parts.destinations(ctx, d.destinations, totals) }) }
  if d.practical != none { parts-list.push({ parts.rail-title(ctx, ctx.copy.practical); parts.practical(ctx, d.practical) }) }
  if d.references != none { parts-list.push({ parts.rail-title(ctx, ctx.copy.references); text(size: 9.2pt, d.references) }) }
  parts-list.join(gap)
}

// Called by hanami() after the record, theme and words are checked; `d` is the normalised record.
#let essential(ctx, d) = {
  let P = tokens(ctx)
  let L = ctx.layout
  let totals = if d.destinations == none { none } else { (domain.totals)(d.destinations) }
  parts.band(ctx, d)

  // The profile row: the lead and availability, then the highlights. The fields below start at a fixed
  // place, so the row must end 5 mm above it.
  // The profile row: the lead statement, then the highlights. The fields below start at a fixed place,
  // so the row must end 5 mm above it.
  let has-profile = d.profile != "" or d.highlights.len() > 0
  let row = block(width: 178mm, {
    if d.profile != "" { parts.lead(ctx, d.profile) }
    if d.profile != "" and d.highlights.len() > 0 { v(3.4mm) }
    if d.highlights.len() > 0 { parts.highlights(ctx, d.highlights) }
  })
  if has-profile { at(L.main.x, L.profile.y, row) }
  let top = if has-profile { L.main.y } else { L.profile.y }

  // the rail's quiet panel, from the fields' top to the footer
  at(L.rail.panel, top - 4mm, rect(width: 210mm - L.rail.panel, height: L.rail.bottom - top + 4mm, fill: P.wash))

  context {
    assert(not has-profile or L.profile.y + measure(row).height + 5mm <= L.main.y, message: "Hanami essential: the profile row overflows ("
      + repr(measure(row).height) + "); shorten the lead statement or a highlight")

    let H = L.main.bottom - top
    let fits(k) = measure(block(width: L.main.width, career(ctx, d, k))).height <= H
    let n = d.experience.len()
    let k = range(n, 0, step: -1).find(fits)
    assert(k != none, message: "Hanami essential: even the newest role alone overflows the career column; shorten its bullets or its support cases")
    if k < n {
      let key(v) = int(v.slice(3)) * 12 + int(v.slice(0, 2))
      let starts = d.experience.map(j => key(j.from))
      assert(starts == starts.sorted().rev(),
        message: "Hanami essential: older roles are summarised, so the experience must be listed newest first")
    }
    at(L.main.x, top, block(width: L.main.width, height: H, career(ctx, d, k)))

    let R = L.rail.bottom - top
    let content = rail(ctx, d, totals)
    let m = measure(block(width: L.rail.width, content))
    assert(m.height <= R, message: "Hanami essential: the rail overflows (" + repr(m.height) + " > " + repr(R)
      + "); shorten the availability, a language note, a trip's stops or the practical know-how")
    at(L.rail.x, top, block(width: L.rail.width, height: R, content))
  }
  footer(ctx, d, 1, 1)
}
