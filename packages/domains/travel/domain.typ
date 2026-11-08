// The travel domain (Travel & Tourism, P-0013): what every travel template can rely on.
#import "data.typ": destination-totals

#let domain = (
  id: "travel",
  meta: (title: "CVgen", author: "CVgen"),
  // Wording that belongs to the field, not to one design.
  copy: (
    experience: "Experience", education-languages: "Education and languages", references: "References",
    present: "present", trip: "trip", trips: "trips", days: "days", from: "From", to: "To",
    areas: "Regions", known: "Knows well", passed: "Stop on the route", practical: "Practical know-how",
    // A trip's role (contract version 2), and a licence's validity.
    role-led: "Led the group", role-organised: "Organised", role-travelled: "Travelled",
    licence: "Licence", valid-until: "Valid until",
  ),
  // The totals rule (constitution 6): computed once from the full record.
  totals: destination-totals,
)
