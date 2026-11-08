// Hanami essential: the travel Domain's first `scan-first` Template Variation (P-0019 section 9,
// TASK-79). One A4 page a recruiter scans in seconds: the name block in a shallow Hanami band, the
// profile row, each role's title, employer and dates on the left with education at the column's
// foot, and the languages, destinations and know-how on a rail. When the roles do not fit, the most
// recent ones stay in full and the older ones become one summary with the domain's totals, and
// education moves to the rail if it has room; when even the newest role does not fit,
// the compile fails (no shrinking, no second page: constitution 4).
#import "../../domain.typ": domain
#import "components/art.typ": at, tokens
#import "components/hero.typ": footer
#import "components/essential.typ" as parts

// The gaps between the career column's parts: at least these, and at most `most`; the column's spare
// height above that stays at its foot, so no role floats away from the next.
#let least = (role: 4.6mm, section: 6.4mm, rail: 5mm)
#let most = (role: 8mm, section: 10mm, rail: 9mm)
// When the column would still end more than 25 mm short of its foot, the gaps may grow to these, so a
// record at a client's real length does not stop two thirds down the page. The role gap stays 5 mm
// under the section gap, so a role never reads as a new section; a page already under the warning's
// fill is not stretched at all (the stretch would only look padded there).
#let roomy = (role: 11mm, section: 16mm)

// Experience, with `k` roles in full and the rest summarised, then education unless the rail holds it.
#let career(ctx, d, k, edu, gaps) = {
  let full = d.experience.slice(0, k)
  let older = d.experience.slice(k)
  parts.section(ctx, "01", ctx.copy.experience)
  for (i, j) in full.enumerate() {
    if i > 0 { v(gaps.role) }
    parts.role(ctx, j)
  }
  if older.len() > 0 {
    v(gaps.role)
    parts.earlier(ctx, (domain.experience-totals)(older), older)
  }
  if edu and d.education.len() > 0 {
    v(gaps.section)
    parts.section(ctx, "02", ctx.copy.education)
    parts.education(ctx, d.education)
  }
}

// The rail's parts in order; education joins them, before the references, when the career needs
// the whole column.
#let rail-parts(ctx, d, totals, with-education, with-licences) = {
  let list = ()
  // the licences head the rail, above availability: the two red-ruled callouts as one group
  if with-licences and d.licences.len() > 0 { list.push(parts.licences(ctx, d.licences)) }
  if d.availability != none { list.push(parts.availability(ctx, d.availability)) }
  if d.languages.len() > 0 { list.push({ parts.rail-title(ctx, ctx.copy.languages); parts.languages(ctx, d.languages) }) }
  if d.destinations != none { list.push({ parts.rail-title(ctx, ctx.copy.destinations); parts.destinations(ctx, d.destinations, totals) }) }
  if d.practical != none { list.push({ parts.rail-title(ctx, ctx.copy.practical); parts.practical(ctx, d.practical) }) }
  if with-education and d.education.len() > 0 { list.push({ parts.rail-title(ctx, ctx.copy.education); parts.education(ctx, d.education, narrow: true) }) }
  if d.references != none { list.push({ parts.rail-title(ctx, ctx.copy.references); text(size: 9.2pt, d.references) }) }
  list
}
#let rail(list, gap) = list.join(v(gap))

// Called by hanami() after the record, theme and words are checked; `d` is the normalised record.
#let essential(ctx, d) = {
  let P = tokens(ctx)
  let L = ctx.layout
  let totals = if d.destinations == none { none } else { (domain.totals)(d.destinations) }

  // The profile row: the lead statement, then the highlights. One rule for every row: the fields start
  // 8 mm under it, so 4 mm of paper stays above the rail panel's 4 mm bleed and a short row leaves no
  // empty paper; at most at `latest`. The licences head the rail; only when the rail cannot hold them
  // do they sit beside the lead.
  let has-profile = d.profile != "" or d.highlights.len() > 0 or d.licences.len() > 0
  let row(with-licences) = block(width: 178mm, {
    let lead = if d.profile != "" { parts.lead(ctx, d.profile) }
    if with-licences and d.licences.len() > 0 {
      grid(columns: (L.main.width, 1fr), column-gutter: L.rail.x - L.main.x - L.main.width, lead, parts.licences(ctx, d.licences))
    } else { lead }
    if (d.profile != "" or (with-licences and d.licences.len() > 0)) and d.highlights.len() > 0 { v(3.4mm) }
    if d.highlights.len() > 0 { parts.highlights(ctx, d.highlights) }
  })

  context {
    // the band fits its name block; the profile row follows it, and the fields follow the row
    let B = parts.band-height(ctx, d)
    parts.band(ctx, d, B)
    let py = B + L.profile.gap
    // the fields follow the row: right under it, never lower than the layout allows
    let start(r, clear) = if has-profile { py + measure(r).height + clear } else { py }
    let rail-room(y) = L.rail.bottom - y - 4mm
    let rail-height(with-education, with-licences) = measure(block(width: L.rail.width,
      rail(rail-parts(ctx, d, totals, with-education, with-licences), least.rail))).height
    // the licences on the rail when it holds them, else beside the lead
    let on-rail = d.licences.len() == 0 or rail-height(false, true) <= rail-room(start(row(false), 8mm))
    let y0 = start(row(not on-rail), 8mm)
    if has-profile { place(top + left, dx: L.main.x, dy: py, row(not on-rail)) }
    assert(y0 <= L.main.latest, message: "Hanami essential: the profile row overflows ("
      + repr(measure(row(not on-rail)).height) + "); shorten the lead statement, a licence or a highlight")
    let H = L.main.bottom - y0
    // the rail's content ends 4 mm inside its panel, as the panel starts 4 mm above it
    let R = L.rail.bottom - y0 - 4mm
    let n = d.experience.len()
    let height(k, edu, gaps) = measure(block(width: L.main.width, career(ctx, d, k, edu, gaps))).height
    // the most roles in full that fit, with education in the column or not
    let most-roles(edu) = range(n, 0, step: -1).find(k => height(k, edu, least) <= H)
    let used = rail-height(false, on-rail)
    assert(used <= R, message: "Hanami essential: the rail overflows (" + repr(used) + " > " + repr(R)
      + "); shorten the availability, a language note, a trip's stops or the practical know-how")
    // Education moves to the rail, before the references, only when the roles do not all fit beside it
    // and the rail has the room; the column then keeps more roles in full.
    let k = most-roles(true)
    let edu = true
    if d.education.len() > 0 and (k == none or k < n) {
      let k2 = most-roles(false)
      if rail-height(true, on-rail) <= R and k2 != none and (k == none or k2 > k) { k = k2; edu = false }
    }
    if k == none {
      // Name the part that does not fit: the newest role alone, the summary of the older roles under it,
      // or Education kept in the column because the rail has no room for it.
      let newest = measure(block(width: L.main.width, career(ctx, (..d, experience: d.experience.slice(0, 1)), 1, false, least))).height
      assert(newest <= H, message: "Hanami essential: even the newest role alone overflows the career column; shorten its bullets or its support cases")
      assert(height(1, false, least) <= H, message: "Hanami essential: the summary of the " + str(n - 1)
        + " earlier roles overflows the career column under the newest role; leave the oldest roles out of the record")
      panic("Hanami essential: Education does not fit in the career column beside the newest role, and the rail has no room for it; shorten Education, or the rail's availability, languages or practical know-how")
    }
    if k < n {
      let key(v) = int(v.slice(3)) * 12 + int(v.slice(0, 2))
      let starts = d.experience.map(j => key(j.from))
      assert(starts == starts.sorted().rev(),
        message: "Hanami essential: older roles are summarised, so the experience must be listed newest first")
    }
    // the spare height widens each gap up to its cap; what is left stays at the column's foot
    let slots = (k - 1) + (if k < n { 1 } else { 0 }) + (if edu and d.education.len() > 0 { 1 } else { 0 })
    let share = if slots > 0 { (H - height(k, edu, least)) / slots } else { 0pt }
    let gaps = (role: calc.min(most.role, least.role + share), section: calc.min(most.section, least.section + share))
    let list = rail-parts(ctx, d, totals, not edu, on-rail)
    let rail-share = if list.len() > 1 { (R - rail-height(not edu, on-rail)) / (list.len() - 1) } else { 0pt }
    let rail-gap = calc.min(most.rail, least.rail + rail-share)
    // How full each column is at the ordinary caps, before any roomy growth: the warning judges the
    // record, never the stretch.
    let career-fill = height(k, edu, gaps) / H
    let rail-fill = measure(block(width: L.rail.width, rail(list, rail-gap))).height / R
    if slots > 0 and calc.min(career-fill, rail-fill) >= 0.8 and H - height(k, edu, gaps) > 25mm {
      gaps = (role: calc.min(roomy.role, least.role + share), section: calc.min(roomy.section, least.section + share))
    }
    // The rail's quiet panel starts 4 mm above the fields and runs to the footer, or, when both columns
    // end short, 8 mm below the longer one, so a short record shows no empty tinted column.
    let career-used = height(k, edu, gaps)
    let rail-used = measure(block(width: L.rail.width, rail(list, rail-gap))).height
    let foot = calc.min(L.rail.bottom, y0 + calc.max(career-used, rail-used) + 8mm)
    place(top + left, dx: L.rail.panel, dy: y0 - 4mm, rect(width: 210mm - L.rail.panel, height: foot - y0 + 4mm, fill: P.wash))
    at(L.main.x, y0, block(width: L.main.width, height: H, career(ctx, d, k, edu, gaps)))
    at(L.rail.x, y0, block(width: L.rail.width, height: R, rail(list, rail-gap)))
    // A thin page fails a reader as surely as a crowded one (research, claim 1): when either column is
    // under 80% filled, the render warns the operator (scripts/cv.py render reads <cvgen-warning>), so
    // the record is filled out before the owner sees it; a long rail never hides a short column. It
    // never stops the compile.
    // the thinner column is named, with what fills it
    if calc.min(career-fill, rail-fill) < 0.8 {
      let message = if career-fill <= rail-fill {
        "the career column is " + str(calc.round(career-fill * 100)) + "% filled; add bullets, a role or an education entry"
      } else {
        "the rail is " + str(calc.round(rail-fill * 100)) + "% filled; add availability, languages, destinations or practical know-how"
      }
      [#metadata("Hanami essential: " + message + " before the owner sees it") <cvgen-warning>]
    }
  }
  footer(ctx, d, 1, 1)
}
