// Header image for the Intake Form (Google Forms: 1600 x 400 px, 4:1).
// House design First Fitting (scripts/text-draft.typ): warm paper, one copper thread.
// No words beyond the wordmark: Google Forms shows the header at phone width,
// where any extra text would be too small to read.
//   typst compile --root . --font-path packages/cv-framework/fonts --ppi 144 \
//     brand/forms/intake-header.typ builds/<folder>/intake-header.png
#let paper = rgb("#F3EEE3")
#let copper = rgb("#B0602B") // also the form's theme colour
#set page(width: 800pt, height: 200pt, margin: 0pt, fill: paper)
#let w = 1.5pt
#let stitch = (paint: copper, thickness: w, dash: (w * 5.5, w * 3.2), cap: "round")

// The wordmark, centred slightly above the middle. Its thread (#B7713D in the SVG) is
// recoloured to the house copper here only, so it matches the stitch and the theme bar.
#let wordmark = bytes(read("/brand/logos/cvgen-wordmark.svg").replace("#B7713D", "#B0602B"))
#place(center + horizon, dy: -9pt, image(wordmark, format: "svg", height: 92pt))

// One running stitch under it, as long as the wordmark.
#place(left + bottom, dy: -45pt, line(start: (267pt, 0pt), end: (533pt, 0pt), stroke: stitch))
