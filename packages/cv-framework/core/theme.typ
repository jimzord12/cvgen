// Theme checks. `require-colors` fails on the first named colour a theme lacks or holds as
// something other than a colour; a template calls it with the colours its own parts paint.
#let require-colors(theme, keys) = {
  for key in keys {
    assert(key in theme.colors, message: "Missing theme color: " + key)
    assert(type(theme.colors.at(key)) == color, message: "Theme color must be a color: " + key)
  }
}

// What every template needs: the colours and fonts the core's own components and page shell read.
// The shell's optional band also paints `hero`; a template that asks for a band checks that colour
// itself, as Flagship does with the rest of its palette (flagship.typ).
#let validate-theme(theme) = {
  require-colors(theme, ("ink", "accent", "metal", "muted", "paper"))
  for key in ("body", "display") {
    assert(key in theme.fonts and type(theme.fonts.at(key)) == str, message: "Missing font family: " + key)
  }
}
