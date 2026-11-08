// Two blank A4 pages with one word each, placed by the suite on a known petal of Hanami's petal layer
// (page millimetres from --input x1, y1, x2, y2): the petal check must report both words.
#set page(paper: "a4", margin: 0mm)
#let at(key) = float(sys.inputs.at(key)) * 1mm
#place(top + left, dx: at("x1"), dy: at("y1"), text(size: 9pt)[Probe])
#pagebreak()
#place(top + left, dx: at("x2"), dy: at("y2"), text(size: 9pt)[Probe])
