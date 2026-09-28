// Header image for the Intake Form (Google Forms: 1600 x 400 px, 4:1).
// House design First Fitting (scripts/text-draft.typ): warm paper, one copper thread.
// No words beyond the wordmark: Google Forms shows the header at phone width,
// where any extra text would be too small to read.
//   typst compile --root . --font-path packages/cv-framework/fonts --ppi 144 \
//     brand/forms/intake-header.typ builds/<folder>/intake-header.png
#let paper = rgb("#F3EEE3")
#let copper = rgb("#B0602B") // Forms theme colour: #B0602B
#set page(width: 800pt, height: 200pt, margin: 0pt, fill: paper)
#let w = 1.3pt
#let stitch = (paint: copper, thickness: w, dash: (w * 5.5, w * 3.2), cap: "round")

// A faint weave, like the paper of the Text Draft's tag card.
#place(top + left, box(width: 100%, height: 100%, clip: true,
  for i in range(0, 90) {
    place(top + left, dx: i * 9pt, line(start: (0pt, 0pt), end: (0pt, 200pt), stroke: 0.25pt + rgb("#E9E1D2")))
  }))

// The wordmark, centred.
#place(center + horizon, dy: -4pt, image("/brand/logos/cvgen-wordmark.svg", height: 92pt))

// One short running stitch under it, as on the Text Draft's facts.
#place(left + bottom, dy: -40pt, line(start: (272pt, 0pt), end: (528pt, 0pt), stroke: stitch))
