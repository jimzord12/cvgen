# Design review round 1: Hanami `essential` (scan-first Template Variation), 2026-11-08

**Verdict: FINDINGS.** All seven renders are blocked by the same two shared defects, and the two long-career renders have a third. All three have small fixes. The design itself is sound: it reads as Hanami, it passes the Scan Test on every render, and its craft is level with the Flagship.

Snapshot: `C:\Github\cvgen\.worktrees\hanami-essential\builds\hanami-essential-r1-20261108-125152\` (7 PDFs and their 144 dpi PNGs), source `packages/domains/travel/templates/hanami/` (`essential.typ`, `layouts/essential.typ`, `components/essential.typ`).

Batch sheets: `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-1300\batch-{twin,no-portrait,long-career,long-career-greek,greek,indigo,sky}.png`. Each sheet puts one render among eight plain one-page CVs set in Typst (`plain.typ` / `plain.pdf`), about 150 px wide per page.

## Shared judgement (applies to all seven unless noted)

- **Scan Test: passes everywhere.**
  - Name: under 1 s (31 pt condensed in the band).
  - Each job: about 1 s. Bold 12.5 pt title on the left, employer in tracked capitals under it, Barlow dates aligned right on the title line.
  - Education ("02"): about 3 s on the twin, about 5 s on long-career.
  - Earlier roles (long-career): about 4 s. One line each, with the span shown.
- **Batch Test (craft and order): passes.**
  - The pink and sky bands, the cream paper and the washed rail pull the eye away from the plain white pages.
  - Indigo is the weakest of the three. On its sheet it sits closest to the plain "dark header with photo" page; the blossom branch and the cream rail still set it apart. This is a Note only.
- **Flagship Parity (craft): passes.** Clean grid, a disciplined pair of type families, numbered sections in metal, tracked labels, and a portrait ring that matches the Flagship's finish.
- **Feels like Hanami: yes.** The things that carry it over:
  - the palette and the cream paper
  - the sakura branch
  - 添乗員 beside the rank
  - Barlow figures and the 01/02 numerals
  - the 24/7 support box
  - the filled and open destination dots

  What it loses from the showcase is the cream name plate with its red tab. I suggest one way to bring it back under D2.
- **Anti-examples: no match.** Its organising idea is close to neither Stoichedon nor Two Inks.
- **Contrast I measured (all fine):**
  - rank and labels on the band: 5.5 to 6.1:1
  - employer: 5.2 to 6.1:1
  - muted rail text: 4.9 to 5.3:1

## Findings shared by several renders

- **D1 Blocking (criterion 6, spacing and rhythm): twin, no-portrait, greek, indigo, sky.**
  - What happens: spare height in the career column goes into `v(1fr)` between roles and `v(1.2fr)` before Education.
  - Result on the twin: the gap from the 24/7 box to the intern role is about 14.5 mm, and the gap from the intern role to "02 Education" is about 19 mm. Long-career has about 7 mm between roles, so the twin's gaps are two to three times that.
  - Effect: the intern role floats on its own, Education (a first-scan field) is pushed away from the rest of the column, and the spacing changes from record to record.
  - **Fix:** cap the flexible gaps, for example at 8 mm between roles and 10 mm before a section, and leave whatever space remains at the foot of the column.
- **D2 Blocking (criterion 6, contrast; criterion 5, a key fact): all seven.**
  - The specialty ("JAPAN SPECIALIST", "JAPAN AND KOREA") is set in accent red on the band, at 8.4 pt.
  - Measured contrast: pink 2.5:1, indigo 2.6:1, sky 2.9:1. In black and white it becomes mid grey on mid grey.
  - **Fix:** set the specialty in `hero-text` and keep red only on the "·" separator.
  - Alternative that also strengthens the Hanami look: put "TOUR LEADER 添乗員" on the showcase's red tab with white text.
- **D3 Blocking (criterion 6, balance): long-career and long-career-greek.**
  - The rail's content ends after References, about 83 mm above the footer, so about 40% of the washed panel is empty. At arm's length it reads as unfinished. Meanwhile the career column on the left is full and summarises four roles.
  - **Fix (preferred):** when the rail's spare height is at least Education's height plus a gap, set Education at the rail's foot. Then measure `k` again: the freed column height lets more roles stay in full. Education still sits at the foot of a column, so it is still found within seconds.
  - **Alternative:** end the wash at the rail's content plus 6 mm, and draw Hanami's data stamp ("Japan · N trips") there, small. Research (claim 110) asks for one motif only, so the first fix is better.
- **D4 Note (craft): education dates.** Author-flagged. Education dates are in the body face at 9.4/600 weight, and spelled out ("October 2023 – March 2024"), while role dates use Barlow MM/YYYY. **Fix:** set the education note in `fonts.figures` at about 10.5 pt in `P.date`, as the earlier-role years are, and give education `from`/`to` fields so the template can format them as MM/YYYY.
- **D5 Nit (hierarchy): figures in Earlier roles.** In the Earlier roles block each row's years are 10.5 pt bold navy Barlow, as heavy as the span above them, so a column of bold figures outweighs the titles. **Fix:** 9.6 pt in `P.muted`, or the span only.
- **D6 Nit (copy): repeated word.** "Earlier roles · 4 roles" and "Παλαιότερες θέσεις · 4 θέσεις" say the word twice. **Fix:** "Earlier roles · 4".
- **D7 Nit (scan): employer size.** The employer, at 7.6 pt tracked capitals, is the smallest of the first-scan fields. Consider 8 pt.

## twin: FINDINGS
First impression: a pink band, the blossom, a bold name, then a dense and orderly two-column page.
Scan Test: name, then role 1, then role 2 (late, after the gap), then Education at about 3 s.
- D1 Blocking and D2 Blocking (above). D4, D5 and D7 apply.

## no-portrait: FINDINGS
First impression: the same as the twin; the band reads lighter on the right.
Scan Test: the same as the twin.
- D1 Blocking and D2 Blocking.
- D8 Note (craft): author-flagged. The band's lower right, about 75 × 25 mm below the branch, is plain pink, and the name block keeps the twin's width. **Fix:** when there is no portrait, use a larger canopy (wider than 104 mm) so the blossoms reach the band's lower edge. Alternative: set the availability headline in that corner (a first-scan knockout fact, research claim 111).

## long-career (Indigo, eight roles, four summarised): FINDINGS
First impression: a navy band and a full, even career column; the right panel looks hollow at the bottom.
Scan Test: four full roles at about 1 s each, then the earlier-roles summary at about 4 s, then Education at about 5 s. Pass. The summary shows the role count and the span from the domain totals, and it holds up well.
- D2 Blocking and D3 Blocking. D5 and D6 apply.

## long-career-greek: FINDINGS
First impression: the same as long-career, in pink.
Scan Test: the same as long-career.
- D2 Blocking and D3 Blocking.
- Greek typography is correct: rail titles in capitals without accents (ΓΛΩΣΣΕΣ, ΠΡΟΟΡΙΣΜΟΙ, ΣΥΣΤΑΣΕΙΣ), "Σπουδές" correctly accented, and the Greek glyphs share the headings' face.

## greek: FINDINGS
First impression: the same as the twin.
Scan Test: the same as the twin.
- D1 Blocking and D2 Blocking.
- D9 Note (robustness): the fixture leaves the record's own text in English, which is data rather than template:
  - the band labels and the rank
  - the availability headline
  - "FOR EXAMPLE"

  So nothing yet proves that Greek tracked capitals fit the three-column contact grid; "ΗΜΕΡΟΜΗΝΙΑ ΓΕΝΝΗΣΗΣ" is much wider than "DATE OF BIRTH". **Fix:** translate those fields in the Greek fixture and render again.

## indigo: FINDINGS
First impression: navy band, gold labels, the blossom; calm and confident.
Scan Test: the same as the twin.
- D1 Blocking and D2 Blocking. The batch-sheet Note above applies.

## sky: FINDINGS
First impression: a light, fresh band; the best palette for a calm page.
Scan Test: the same as the twin.
- D1 Blocking and D2 Blocking.

## Renders made
In `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-1300\`:
- `<render>-96dpi.png` and `<render>-200dpi.png` for all seven
- the batch sheets `batch-*.png`
- detail crops `crop-*.png`
- `plain.typ`, `plain.pdf`, and `sheets.py`, which renders the pages and makes the sheets using the pymupdf in `C:\Github\cvgen\.venv`, writing only to this folder

## Verdict: FINDINGS
Smallest path to PASS:
1. Cap the flexible gaps (D1).
2. Recolour the specialty or put the rank on a tab (D2).
3. Give the long-career rail's spare height to Education (D3).
4. Render again, including a Greek fixture with Greek labels (D9).
