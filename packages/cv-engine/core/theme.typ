#let validate-theme(theme) = {
  for key in ("ink", "hero", "accent", "metal", "muted", "surface", "paper", "plate", "rule", "on-hero") {
    assert(key in theme.colors, message: "Missing theme color: " + key)
    assert(type(theme.colors.at(key)) == color, message: "Theme color must be a color: " + key)
  }
  for key in ("body", "display") {
    assert(key in theme.fonts and type(theme.fonts.at(key)) == str, message: "Missing font family: " + key)
  }
}
