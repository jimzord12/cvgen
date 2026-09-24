#import "../../packages/cv-engine/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/cv-engine/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
#import "../../packages/cv-engine/domains/marine/templates/flagship/components/certificates.typ": certificate-table
#import "../../packages/cv-engine/core/component.typ": make-ctx
#set text(font: theme.fonts.body, size: theme.sizes.body)
#set page(paper: "a4", margin: 16mm)
#let records = range(50).map(i => (title: "Certificate " + str(i+1), scope: "Illustrative training record", issued: "2024", review: "2029"))
#certificate-table(make-ctx(theme: theme, layout: layout, copy: (certificate-columns: ("Certificate", "Scope / record", "Issued", "Expires / review"))), records)
