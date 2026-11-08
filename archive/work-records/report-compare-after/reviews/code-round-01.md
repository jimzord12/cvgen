# Review round 1: fix/report-compare-after (commit 97f5024)

**Verdict: PASS.** No Blocking or Material findings. There is one Minor finding on test strength and three Notes.

Snapshot: `git diff 711effe 97f5024` (3 files) in C:\Github\cvgen\.worktrees\report-compare-after. The working tree was clean when I examined it.
Lead lenses: (1) every comparison path opens on the new version, and the grip stays visible and draggable at 8%; (2) the test means something, and the comment and README are accurate.
Coverage:
1. Product fit and wiring: there are three comparison paths. The card thumbnail (report.html:268) is a fixed `--x:0%`, so it shows only the new page. The shared figure under Figures (274 → `visual` → `compare`) opens at CSS `--x:8%` (186) with the input at `value="8"` (245), so the two agree. The lightbox rebuilds a fresh `compare(x)` on every open (318), so it also opens at 8%, and the shared input listener (311-313) still drives it. Cards never hold a live slider, only thumbnails. No other comparison slider exists in the repo (searched for `top-image`, `value="65"`, `--x:`).
2. Correctness and edge cases: grip geometry. The grip's left edge is 0.08W − 22px, which stays at or above 0 while the comparison box is at least 275px wide. The narrowest real boxes are:
   - Figures column at a 320px viewport: 288px wide (min(280px,100%) minus 16px page padding each side), edge at about 1px.
   - Mobile lightbox at 320px: 312px wide, edge at about 3px.
   - Desktop lightbox: about 972px wide, edge at 56px.
   
   Below about 307px of viewport, a pixel or two of the grip is clipped. It still drags, because the invisible range input covers the whole box (190).
3. Data and document integrity: n/a, presentation only.
4. Contracts, access and privacy: the evidence schema is unchanged (scripts/report.py:46). Nothing private is involved.
5. Tests and visible evidence: see m1. No rendered screenshot was supplied. For a 3-value CSS/JS default I judged the geometry check enough rather than an evidence gap.
6. Failure handling and recovery: n/a, no new failure path.
7. Simplicity and ownership: the change stays inside the owning template. See N3.
8. Repository and documentation: `git diff --check` is clean and all three files are LF. The README sentence (README.md:50-53) matches the behaviour. See N2 for the comment.

## Findings
### m1 Minor: the assertion matches template source text, and the sample never renders the thumbnail comparison
Anchor: tests/report.py:44; studio/brand/report/sample.json:246-260
- **Scenario:** the sample's only comparison (Figure 2) is placed under Figures, so a comparison thumbnail is never built from the data. `'style="--x:0%"' in page` passes only because the JS template text is embedded in the page.
- **Expected:** a check tied to the comparison markup.
- **Actual:** three bare substrings. They do fail on the reported defect: the old template carried `--x:65%`, `value="65"` and `--x:50%`, so all three would miss. So this is a real regression guard, but a literal one, and the repo has no browser harness for a behavioural check.
- **Impact:** low.
- **Smallest fix:** anchor each string to its context, for example `'<input type="range" min="0" max="100" value="8"'`, `'<span class="compare" style="--x:0%">'` and `'.compare{position:relative;--x:8%;'`. Optionally, cite Figure 2 from one card in a test fixture so the thumbnail path also renders.

### N1 Note: the "before" label now sits on the new page
Anchor: report.html:194-195, 247
At 8% the left label ("Classic" in the sample) at `left:8px` lies mostly or wholly over the new page; on a 288px column the sliver is only about 23px wide. The lightbox bar still reads "Left: Classic · Right: Silver", so the side legend is correct. Optional: no change, or move the left label to sit beside the grip.

### N2 Note: the comment's quotation is not the owner's words
Anchor: report.html:242
The comment says the slider "read as \"no change\"". The owner said "it seems the same as before". Quote him exactly or drop the quotation marks.

### N3 Note: the thumbnail still carries a fully clipped old image
Anchor: report.html:268
At `--x:0%`, the top image is fully clipped and `::after` draws a 2px thread-coloured line at the left edge. A plain `<img src="${x.after}">` would be simpler. Optional.

## Checks rerun
- `run_report` from tests/report.py, called directly into a fresh folder, C:\Github\cvgen\.worktrees\report-compare-after\builds\review-report-compare-20261108-221959: exit 0, 54 checks, including "a comparison opens on the new version".
- `ruff check`: not run, because ruff is not on PATH in my shell and not installed as a Python module. The author reports ruff clean; I did not verify it.
- Full suite: not rerun. I inspected the author's C:\Github\cvgen\.worktrees\report-compare-after\builds\tests-20261108-221728-589055\report.json: `passed: true`, and it contains the new check.

## Evidence inspected
At 97f5024:
- C:\Github\cvgen\.worktrees\report-compare-after\studio\brand\report\report.html (CSS 148-195, JS 240-322)
- C:\Github\cvgen\.worktrees\report-compare-after\studio\brand\report\README.md
- C:\Github\cvgen\.worktrees\report-compare-after\tests\report.py
- C:\Github\cvgen\.worktrees\report-compare-after\studio\brand\report\sample.json
- C:\Github\cvgen\.worktrees\report-compare-after\scripts\report.py:46
- C:\Github\cvgen\.worktrees\report-compare-after\tests\run.py:199-240

## Limitations
- No browser was available, so the grip's visibility and dragging come from reading the CSS and working out the widths by hand, not from a rendered screenshot.
- The native range thumb's position differs slightly from the drawn grip; that was already so before this change and is outside its scope.
- ruff was not rerun.

## Verdict: PASS

**Next:** the lead stores this report under archive/work-records/, records the dispositions for m1 and N1-N3, and merges.
