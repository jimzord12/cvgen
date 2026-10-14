# Design review round 1: 2026-09-28

Snapshot: brand/forms/intake-header.png (1600 x 400), source brand/forms/intake-header.typ. It is byte-identical to builds/intake-header-20260928-211651/intake-header.png. This is a production brand asset, not an idea-run concept.

Rubric scope: criterion 1 (reads as a CV) and criterion 5 (schema, month totals, template path) do not apply. Criterion 4 applies only in part: the artwork is original, the wordmark's letters are OFL outlines documented in brand/README.md, and it holds no data. Criteria 2 (premium and distinct) and 3 (craft) apply in full.

## brand/forms/intake-header: PASS
First impression: the black "CV" with its copper thread, centred on warm paper, with one short running stitch beneath it. It is quiet and deliberate, the opposite of a rushed job.

- D1 Note (craft, colour): the thread and "gen" in the wordmark are #B7713D, while the stitch and the Forms theme bar are #B0602B. The difference is ΔE ≈ 8, which shows side by side. Up close the stitch looks redder and heavier than the thread, and the theme bar right below will repeat that. Fix: recolour the SVG only inside the header: `image(bytes(read("/brand/logos/cvgen-wordmark.svg").replace("#B7713D", "#B0602B")), format: "svg", height: 92pt)`. Record the two-copper split as an open brand item in brand/README.md.
- D2 Note (craft, weave): the "weave" is 90 vertical 0.25 pt lines in #E9E1D2 on a 9 pt pitch. At full size it reads as pinstripe or ticking, not as weave. At phone width it becomes a faint banding that could pass for a compression artefact. The source comment is also wrong: the Text Draft's tag card is plain #FBF8F1 with no weave. Fix: delete the weave; the plain paper matches the house style. If you want texture, make it a real crosshatch at about 0.3 pt, #E8E0D0, with 6 pt pitch both ways, and check it again at 1080 px.
- D3 Note (fit next to Google's chrome): the paper #F3EEE3 is yellower than the pinkish "lightest tint" Forms will likely generate from #B0602B. The header could then look like a slightly off-colour strip above the page. Fix: after setting the theme, sample the live form background. Either set `paper` to that value, or accept the difference knowingly; the header then reads as a card.
- D4 Nit (balance): the content block runs from y 100 to 321 px, so its centre sits about 10 px below the middle. Optical centre wants it a little above. Fix: change the wordmark `dy: -4pt` to `-9pt` and the stitch `dy: -40pt` to `-45pt`.
- D5 Nit (alignment): the stitch spans x 544–1056 px, while the wordmark spans 534–1065 px. That is a near miss of about 10 px at each end, which reads as unintended. Fix: either match the wordmark exactly (`start: (267pt, 0pt)`, `end: (533pt, 0pt)`) or commit to a clearly shorter stitch centred under "CV" (about 180 pt).
- D6 Nit (stitch at phone width): the dash formula is identical to the Text Draft's `stitch(w)`: w 1.3 pt, dash 5.5w / 3.2w, round caps. At 360 CSS px on a 1x screen it thins to a pale dotted rule, while at 3x (1080 device px) it still reads as a stitch. Most clients' phones are 2–3x, so this is acceptable. If you want margin, set `w = 1.6pt`.

Checked and fine:
- **Wordmark legibility:** at 360 CSS px the "CV" is about 40 px tall and "gen" has an x-height of about 9 px. Both read at 3x. The needle's eye survives at 3x and is lost at 1x, as the README predicts.
- **Distinctness:** the copper thread is not the stock white-dashed patch look.
- **Restraint:** leaving out all words is the right call.

## Renders made
- builds/design-review-20260928-2130/header-360.png, header-412.png, header-640.png (phone and tablet widths)
- builds/design-review-20260928-2130/header-360-zoom3x.png
- builds/design-review-20260928-2130/header-1080-dpr3.png (a 360 CSS px phone at 3x)
- builds/design-review-20260928-2130/phone-mock-3x.png (a rough mock-up under Forms' chrome with the copper bar)
- builds/design-review-20260928-2130/weave-crop-2x.png
- builds/design-review-20260928-2130/stitch-crop-2x.png

## Verdict: PASS
There are no Blocking findings. D1 and D2 are the two I would apply before the owner sees it: each is a one-line change and together they remove the only two things a designer's eye will catch.

## Dispositions (lead, 2026-09-28)
- D1 applied: the header recolours #B7713D to #B0602B when it reads the wordmark; the brand files are unchanged (open brand item noted in brand/README.md).
- D2 applied: weave removed.
- D3 applied: the guide's theme step picks the background swatch closest to the header's paper.
- D4 applied: dy -9pt and -45pt.
- D5 applied: stitch 267pt–533pt, matching the wordmark.
- D6 applied in part: w = 1.5pt.
New render: builds/intake-header-20260928-211942/intake-header.png, copied to brand/forms/.
