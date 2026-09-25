#import "../../packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
#import "../../packages/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "../../packages/cv-framework/core/theme.typ": validate-theme
#validate-theme(theme)
#assert.eq(layout.hero.height, 77mm)
#assert.eq(layout.continuation-margin.bottom, 11mm)
#assert.eq(artwork.portrait-backdrop.width, 94mm)
