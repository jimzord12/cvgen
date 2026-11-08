// The travel domain (Travel & Tourism, P-0013): what every travel template can rely on.
#import "data.typ": destination-totals, experience-totals

#let domain = (
  id: "travel",
  meta: (title: "CVgen", author: "CVgen"),
  // Wording that belongs to the field, not to one design.
  copy: (
    experience: "Experience", education-languages: "Education and languages", references: "References",
    present: "present", trip: "trip", trips: "trips", days: "days", from: "From", to: "To",
    areas: "Regions", known: "Knows well", passed: "Stop on the route", practical: "Practical know-how",
  ),
  // The totals rule (constitution 6): computed once from the full record.
  totals: destination-totals,
  // The totals of the roles a page summarises (Hanami essential's earlier roles).
  experience-totals: experience-totals,
)
