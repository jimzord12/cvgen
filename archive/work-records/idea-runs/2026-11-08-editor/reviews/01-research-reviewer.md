# Research review round 1: idea run 2026-11-08 (editor), five style briefs

Snapshot: commit e3be504 on branch docs/idea-run-2026-11-08-editor

Claims checked: 30 load-bearing (21 references, 9 font licences). 27 confirmed, 3 unreachable (the three the author flagged).

**Per brief:** Rhumb Lines PASS · Airmail PASS · Timetable PASS · Poster Sun PASS · Guilloche PASS (with an advisory on the passport question).

## Findings

### R1 Note (Airmail): the claim drops "U.S."
Source: https://postalmuseum.si.edu/exhibition/fad-to-fundamental-airmail-in-america-airmail-object-showcase-stamps-and-covers/us-1 returns 403. My own search snippet quotes the page word for word: the border "marked **U.S.** airmail stationery for most of the 20th century". This is the only source for the brief's central principle. The citation is acceptable: the page exists, the wording matches, and the convention is widely known. But the brief generalises the claim beyond the U.S. Fix: write "U.S. airmail stationery".

### R2 Note (Rhumb Lines): when portolan charts reached 32 directions
Source: https://en.wikipedia.org/wiki/Portolan_chart says the lines marked 16 headings at first and 32 "around 1450". The Compass rose article gives 32 winds in the 14th century. The colour code (black, green, red) is quoted correctly. Fix: say "16, later 32, directions".

### R3 Note (Timetable): the Grid Systems principle
https://draw-down.com/products/grid-systems-in-graphic-design returns 429. A shop listing can only show that the book exists; it cannot back "bands and hairlines instead of boxes", which is the author's reading. Nothing else rests on it. Fix: cite the book itself (ISBN) and mark the principle as interpretation. Ref 2 is confirmed: the 1844 Bradshaw full text has `*`, `§`, day initials and numbered keys explained in notes.

### R4 Note (Poster Sun): the Library of Congress poster collection
loc.gov returns 403. My search confirms the collection holds 907 posters from 1936 to 1943, mostly silkscreens, with travel among its subjects (for example Dux's "See America"). The "travel poster grammar" principle is design reading, not a sourced fact. That is acceptable, but mark it as interpretation. The Federal Art Project quote ("widespread adoption of the silkscreen process") is exact.

### R5 Note (Guilloche): the geometric lathe
Source: https://en.wikipedia.org/wiki/Geometric_lathe. The article says the machine makes "intersecting and interlacing patterns of fine lines" for banknote plates. It does not say "from a few parameters". Fix: drop the parameters claim from the attribution or keep it as the author's own point.

### R6 Note (Guilloche): how close it comes to a passport
Source: https://en.wikipedia.org/wiki/Machine-readable_passport. A passport's MRZ starts with "P". However, "C" is a valid first character for ICAO ID-1 and ID-2 cards, so "CV" is not wholly outside the real code space.

The brief keeps clear of copying a real passport:
- no emblem and no country name;
- the MRZ breaks the TD3 field layout: line 2 positions 1–13 are not a document number or nationality, and there are no check digits;
- Plex Mono, not OCR-B.

It still stacks four features of real documents: a two-line, 44-character TD3 zone, a ghost portrait, rainbow tint and guilloche. EUIPO lists the last two as anti-counterfeiting features. The brief already flags this under "Known weaknesses" for the owner. Smallest fix: break the 2×44 geometry (different line count or length), or start with a code that is not a valid ICAO first letter, so no reader can take it for an imitation.

No reference makes any style a copy of one existing work. The RMG rose, Gooden's design and Bradshaw supply principles only, drawn generically.

## Confirmed
- **Rhumb Lines:** Compass rose quote; RMG NAV0243 (32 points, western hemisphere at the centre); Science Museum Adams card (inner ring "divided in 128 equal parts"); Cormorant (Thalmann, OFL).
- **Airmail:** Airmail etiquette quote; perforation gauge 11–14; Courier Prime (2013, crisper serifs, darker bold, OFL).
- **Timetable:** Science Museum Bradshaw 1843; IBM Plex (OFL 1.1, has Sans Condensed and Mono).
- **Poster Sun:** Linocut is relief printing; Jost (keeps Futura's "attitude", larger x-height).
- **Guilloche:** EUIPO wording; Gooden 1954, Bank of England Museum; MRZ (2×44 characters, A–Z, 0–9, `<`).
- **Font licences:** the Google Fonts `OFL.txt` files for Jost, Courier Prime, IBM Plex Sans Condensed, IBM Plex Mono, Alegreya and Fira Sans all say SIL OFL 1.1. The bundled Cormorant Garamond, Source Sans 3 and Sofia Sans Extra Condensed each have an OFL file in `C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\packages\cv-framework\licenses\`.

## Coverage check
- "airmail envelope red and blue border history": confirmed the Smithsonian wording, with a U.S. scope (R1). No contrary fact.
- "Library of Congress WPA Poster Collection": confirmed the count, the silkscreen majority and travel posters (R4).
- I checked the 1844 Bradshaw full text directly (confirmed).

Neither search changes a conclusion.

## Verdict: PASS (all five briefs, Notes only)
