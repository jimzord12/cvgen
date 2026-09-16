#import "../../packages/cv-engine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/cv-engine/templates/flagship/layouts/flagship-v11.typ": layout
#import "../../packages/cv-engine/templates/flagship/artwork/engineer.typ": artwork
#import "../../packages/cv-engine/core/theme.typ": validate-theme
#validate-theme(theme)
#assert.eq(layout.hero.height, 77mm)
#assert.eq(layout.continuation-margin.bottom, 11mm)
#assert.eq(artwork.portrait-backdrop.width, 94mm)
