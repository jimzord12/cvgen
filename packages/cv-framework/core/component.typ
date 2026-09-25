// The component contract (ADR 0008): `ctx` first, then the data a component
// renders, then named props with defaults, then content slots. The shape is the
// contract; this file holds only the helpers a component actually needs.

// Built once by a template and passed through untouched. `layout` is the whole
// layout profile (each component reads its own slice), `artwork` the pack,
// `copy` the composed wording, `options` the switches (show-vessel-durations).
#let make-ctx(theme: none, layout: (:), artwork: (:), copy: (:), options: (:)) = {
  assert(type(theme) == dictionary, message: "make-ctx needs a theme: import one from the template's themes/")
  for (name, value) in (layout: layout, artwork: artwork, copy: copy, options: options) {
    assert(type(value) == dictionary, message: "make-ctx: " + name + " must be a dictionary, got " + str(type(value)))
  }
  (theme: theme, layout: layout, artwork: artwork, copy: copy, options: options)
}
