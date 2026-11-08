Context review, round 2. Report figures (1097d95..39e507d, worktree C:\Github\cvgen\.worktrees\report-figures)

**Round 1 findings, rechecked**

1. **Material, README table split: resolved.** The placement paragraph is now after the table, at C:\Github\cvgen\.worktrees\report-figures\studio\brand\report\README.md:44-52, and all ten rows sit together at :30-42.
2. **Minor, missing case and Figures position: resolved.** :45 says "one `needs_you` card alone cites", and :47 says "below the cards". Both match `placement()` in scripts/report.py:176-182: decisions count as citers, but only `needs_you` cards keep a picture. They also match report.html, where the Figures section comes straight after Needs you.
3. **Minor, preference narrower than the feedback: resolved.** docs/preferences.md:114-118 now reads "whatever he is asked or told about a look" and "several sections share".
4. **Minor, the principle stated twice: resolved.** README:3-7 keeps only the dated rule and the pointer to "Reports".
5. **Minor, verification item 19 not updated: resolved.** It now describes the placement assertion and lists the figure refusals, but two new defects came with it (findings 1 and 2 below).
6. **Note, glossary entry for "Figure": no change needed.**

**The README against the page's new behaviour.** Every claim matches the code:
- **In-card figure:** a figure that one card alone cites sits beside the options. The `.ask-body.with` grid puts the thumbnails in their own column next to the options.
- **Enlarge button and lightbox:** `thumb()` has a `data-enlarge` button, and the `#lightbox` dialog opens it. A comparison opens with its slider, through `visual()`, and the document-level `input` listener drives that slider inside the lightbox too.
- **Every other figure:** it goes under Figures, titled above the picture with back links (`shared()` puts `figcaption.head` before `visual(x)`; `back()` builds the links).
- **Arrows:** a card's link points ↓, a decision's link points ↑, and the back links read "Card N ↑" and "Decision ↓". All four point the way to scroll.
- **Refusals:** the script refuses an id with no picture and one item citing an id twice (report.py:138-143).
- **"the start of the caption"** is a fair description of the full caption cut off with an ellipsis.

No skill or agent needs a pointer change. All three files have LF line endings (0 CRLF).

## Minor

1. **C:\Github\cvgen\.worktrees\report-figures\docs\engine\verification.md:228 — "shared, cited twice" reads as refusing the case the feature exists for.**
   - **Two senses in one item:** at :222, "one shared under Figures" means a figure several items cite, which is valid and is what the sample shows. At :228, "a figure id … shared, cited twice" lists refusals.
   - **What the test actually refuses:** two figures with one id ("two figures share the id 'A'") and one item citing the same id twice (tests/report.py:92 and :96). A figure cited by two items is allowed.
   - **Why it matters:** a reader skimming the list could conclude that citing one figure from two sections is refused. The wording "shared" came from my own round-1 fix.
   - **Fix:** "a figure id missing or malformed, two figures with one id, one item citing an id twice or citing one that is absent".
2. **docs/engine/verification.md:222 — the line runs to 99 characters.** The surrounding text wraps at about 80 (:221, :223-227). Reflow :221-223. The long line at :229 was already there before this round.

Verdict: PASS
