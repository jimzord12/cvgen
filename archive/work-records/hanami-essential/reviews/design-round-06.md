# Design review round 6: Hanami `essential` after the owner's feedback, 2026-11-08

**Verdict: FINDINGS.** Eleven of the twelve renders pass. One is Blocking: the generic render, which is supposed to show what the client's page will look like, leaves its bottom quarter empty.

Snapshot: `C:\Github\cvgen\.worktrees\hanami-essential\builds\hanami-essential-owner1-20261108-170806\` (head 665df97). Bar: `scan-first`. The exception is showcase-monochrome, which I judged against the full bar because it is the showcase.

Batch sheets are in `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-1720\`: `batch-{twin,monochrome,generic,no-portrait,long-career,long-career-greek,greek,indigo,sky,no-licence,sparse,showcase-monochrome-p1,showcase-monochrome-p2}.png`. Each page sits among eight plain Typst CVs (`plain.pdf`, set in round 5).

## Your four questions

**1. Do the bullets scan, and is Practical know-how scannable? Yes.**
- In Travel Consultant, the five bold lead-ins (Private trips, End to end, Suppliers, Trip books, Client care) now read as a column of labels. The role scans in about 2 s without reading the rest.
- Practical know-how now has one bold label per line (Rail, Transport cards, Luggage, Stays, Emergencies). It scans the same way, even though most items wrap to two lines in the narrow rail.
- Two catches: D24 and D25.

**2. Is Monochrome good-looking, premium, and still Hanami? Yes. It is not a greyscale filter.** I put it beside a greyscale filter of the twin (`twin-grey-96dpi.png`):
- The filter turns the band a muddy mid grey and the tab dull grey.
- Monochrome uses a warm pale band and a true black tab, so the black name and tab hold the page. The sakura is redrawn as line art with white petals instead of grey blobs, and the day counts and rules are in ink.
- It reads as Hanami through the band, the sakura, the tab with 添乗員, Barlow for names and figures, the numbered sections and the rail wash.
- What it loses is presence (D26). Showcase-monochrome also works, and the black stamps look like real rubber stamps. Its one problem is D29.

**3. Is "generic" truly generic and professional? Mostly yes.**
- Generic: no sakura, no kanji. The tab reads "TOUR LEADER · GROUP AND PRIVATE TRAVEL". The places cover Europe and East Asia.
- Professional: the craft and hierarchy are at the twin's level, and the bullets are the best on the run.
- It does not pass as rendered, because the page stops at two thirds (D23). On the batch sheet the empty bottom is what the eye lands on, and against the Flagship it looks unfinished.

**4. Can the band take a portrait well?** Yes. The twin, indigo and sky renders show that a 35 mm disc in a ring at the band's right sits well, and the band grows to fit it. For a client in Monochrome on the plain pack, three things are unproven:
- **The plate is pure white** (`plate: ffffff`). A cut-out portrait in a white or light shirt will merge into it, and only the grey ring will mark the edge. A pale grey plate (about `d9d9d6`) or a soft grey gradient would hold the figure better.
- **The route arc beside a portrait** is narrowed to 58 mm and ends at the ring. Its left end then reaches about x 97 mm, near the tab line. With the twin's rank line ("JAPAN SPECIALIST | TOUR LEADER COURSE · TTI · 2024" runs to about 133 mm), it would cross the tab line.
- **Colour or grey portrait:** a colour face on a grey page can look premium, or out of place. The owner should choose, not us.

For round 7 I need:
- (a) generic in Monochrome on the plain pack, at the client's real length, with a fictional transparent cut-out portrait (the twin's AI portrait with its background removed is fine) on the theme's plate, once in colour and once greyscale;
- (b) the same with the longest likely rank line, to prove the arc clears it;
- (c) a 200 dpi crop of the portrait edge, to check for a fringe around the cut-out;
- (d) a greyscale print check.

## twin: PASS
First impression: pink band, black name, portrait; then the bold lead-in column.
Scan Test: name under 1 s; Travel Consultant / Meltemi / 03/2022 about 1 s; Intern about 1 s; Education about 3 s; licence beside the profile row about 2 s.
- D24 Note (6): "Basic knowledge: typhoon and snow seasons" is a bullet under "Confident with", which contradicts the heading. Fix: set it as its own line under the list, as the showcase does, or drop "Confident with" because the labels already carry the section.
- D16 Note (open, agreed): stops listed twice.

## no-portrait, indigo, sky, greek, no-licence: PASS
Same as the twin: the lead-ins are present and the Greek capitals are correct ("ΑΔΕΙΑ · ΙΣΧΥΕΙ ΕΩΣ 31 ΜΑΡ 2029"). D24 and D16 apply. No regressions from round 5.

## long-career, long-career-greek, sparse: PASS
Scan Test as in round 5: five roles, then "Earlier roles · 3" at about 4 s.
- D25 Note (8): these records have no "Lead: rest" bullets, so they show none of the bold the owner asked for. The rule also silently ignores a lead longer than 5 words or 40 characters. Fix: rewrite these fixtures' bullets with lead-ins, so the suite shows the look on a dense career. In the guide and the `Text Draft`, ask for lead-ins on all of a role's bullets or none. Optionally warn when a role mixes the two, or when a lead is too long to be bolded.
- Sparse is still not a deliverable (round 5).

## monochrome: PASS
First impression: the black name and black tab, then the colour portrait. The band barely registers at thumbnail size.
Scan Test: the same as the twin.
- D26 Note (1, taste): the band (`ebeae6` on `fcfcfb`) almost disappears at thumbnail size. It passes the `scan-first` bar. If the owner wants more presence, offer an ink band: charcoal, white name, white tab. Indigo already shows that a dark band works.
- Nit: the red accents all became the same ink. The licence and availability labels now differ from the other rail labels only by their black bar.

## generic: FINDINGS
First impression: a heavy black name and black tab over a pale band, then the empty lower third.
Scan Test: name under 1 s; each role about 1 s; Education about 2 s; availability on the rail about 2 s.
- **D23 Blocking (1, 3, 6):** measured at 200 dpi, the main column ends at about 200 mm and the rail wash at about 240 mm. That leaves a 40 mm empty strip across the full width above the footer at about 280 mm, plus an 80 mm empty block under Education. On the batch sheet it reads as an unfinished page. Next to the twin and the Flagship (which fill to about 85%), it falls below Flagship Parity. The thin-page warning (under 60%) did not catch it.
  - Fix: give the fixture the length of the client's real record. Add the four-highlight row under the profile (it carries much of the twin's order), a licence if the client holds one, and a third role or more bullets.
  - Also raise the operator warning to about 80% column fill, so a page like this is flagged before it reaches the owner.
- D28 Note (1): without a portrait, the route arc (a thin dotted mid grey) cannot be seen at thumbnail size or at arm's length, and the band's right 40% reads as empty. Fix: if no-portrait plain is offered, set the arc in the label grey with heavier dots and the destination ring in ink.
- Nit: "In short" under "Skills & travel experience" is filler; drop it.
- D16 applies ("Knows well" repeats the stops).

## showcase-monochrome, page 1: PASS
First impression: the grey torii framing the portrait, the black stamp, SKG → FUK.
Three-Second Test:
- Domain, travel: the tour group, the plane and SKG → FUK.
- Specialty, Japan: the torii, Fuji, 添乗員 and the 日本 stamp.
- Rank, tour leader: the "TOUR LEADER 添乗員" tab and the flag-bearer leading the group.

Findings:
- D29 Note (6): the blurred drifting petals turn grey in Monochrome and read as smudges or toner spots (left margin at about 95 mm and 175 mm, and right of the profile row). Fix: in Monochrome, drop the out-of-focus petals and keep only the crisp outlined ones.

## showcase-monochrome, page 2: PASS
It is clearly the same CV as page 1: the mini band with the group, torii, Fuji and SKG → FUK; the black stamps; the line-art sakura. D29 applies (e.g. right of "18 days"). Know-how here is still the run-in list, but the showcase is approved and frozen, so I leave it.

## Renders made
In `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-1720\`:
- `<render>-96dpi.png` and `<render>-200dpi.png` for all twelve renders (showcase as `-p1` and `-p2`)
- the batch sheets `batch-*.png`
- `{generic,monochrome,twin}-grey-96dpi.png` (black-and-white checks)
- the detail crops `crop-*.png`
- `plain.pdf` and `sheets.py`

## Verdict: FINDINGS
To fix before round 7: D23, by rendering generic at the client's real length. The Notes to bring to the owner are D24–D26, D28 and D29. Round 7 also needs the portrait proof listed under question 4.
