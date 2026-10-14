// Flagship's themes as one module. lib.typ exports it as `flagship-themes`, so an entry point picks a
// look by name (`flagship-themes.golden-blue`) without importing the theme file (TASK-55).
#import "themes/golden-blue.typ": theme as golden-blue
#import "themes/silver-bridge.typ": theme as silver-bridge
