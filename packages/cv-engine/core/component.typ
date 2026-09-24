// The component contract (ADR 0008): `ctx` first, then the data a component
// renders, then named props with defaults, then content slots. These helpers
// are conveniences; the shape is the contract.

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

// An assertion whose message says what to change.
#let require(condition, message) = assert(condition, message: message)

// A named slot, or its fallback when the caller left it out.
#let slot(value, fallback: none) = if value == none {fallback} else {value}

// Positional content arguments joined into one body; none when there are none.
#let children(slots) = {
  let body = slots.pos()
  if body.len() == 0 {none} else {body.join()}
}
