---
kind: reference
---

# CEO idea run, 2026-09-25

First run of the `ceo` agent, unattended overnight. Started by the lead as a
`general-purpose` agent told to act as `.claude/agents/ceo.md` (the file was
new and not yet loaded by the harness). Cap: 3 ideas. Owner context given by
the lead: a first real client is waiting, field not yet decided; roadmap
item 2 (travel and tourism) is next; tonight other agents tidy components
(item 4), add candidate-record validation and build the idea agents. Item 1
(domains, roles, templates) is done, merged 2026-09-21, although
`docs/vision.md` still lists it.

The lead appends rounds and verdicts below the final list.

## What was read

`docs/vision.md`, `docs/framework-gaps.md`, `docs/history.md`,
`docs/decisions/README.md`, every file in `docs/proposals/` (`rejected/` is
empty), the board (12 cards: Handoff 1, Queued 1, Active 3, Review 1,
Done 6), `exports/` and `docs/images/`, `docs/pdf-workflow.md`,
`docs/guides/build-a-cv.md`, `docs/reference/candidate-schema.md`,
`packages/cv-workflow/cv_workflow/checks.py` and `render.py`, the example
candidate records and `archive/design-studies/content/example.json`. No
earlier idea run exists under `docs/work/idea-runs/`.

## Market research

All URLs accessed 2026-09-25. [F] primary source (regulation, a company's own
page about its own requirements, prices or process). [O] opinion: vendor
marketing about the market, blogs, reviews, news commentary. [Own] a test run
on this repository.

### Who hires, and what they ask for

1. **Crew managers ask for vessel particulars, not just vessel names.**
   Marlow Navigation's seafarer application page asks for "vessel name, type
   & IMO number; gross tonnage; engine kilowatts & manufacturer (applicable
   for engine crew); date of embarkation and disembarkation; and company you
   worked for", plus "Certificate of Competence (name of grade & STCW
   regulation)" and "Valid visas". It accepts the candidate's own CV "if the
   essential information is documented".
   https://marlow-navigation.com/en/seafarer-application.asp [F]
2. **Marlow's size**: founded 1982, offices in 14 countries, over 1,300
   shore staff, 16,300 crew on board, 26,000+ active seafarers.
   https://marlow-navigation.com/en/company-profile.asp [F, company's own figures]
3. **Why tonnage and power matter**: STCW certificate grades are defined by
   them. Regulation III/2 covers chief and second engineers "on ships powered
   by main propulsion machinery of 3,000 kW propulsion power or more"; III/3
   covers 750 kW to 3,000 kW. Regulation II/2 separates masters and chief
   mates on ships of 3,000 GT or more from those on 500 to 3,000 GT.
   https://www.kustcodex.be/kustcodex-consult/plainWettekstServlet?wettekstId=51700&lang=nl [F, STCW text, Belgian official legal database]
   https://www.kustcodex.be/kustcodex-consult/plainWettekstServlet?wettekstId=51694&lang=nl [F, same]
4. **Certificates expire on a fixed clock.** STCW Regulation I/9: "Medical
   certificates shall remain valid for a maximum period of two years unless
   the seafarer is under the age of 18, in which case the maximum period of
   validity shall be one year."
   https://www.kustcodex.be/kustcodex-consult/plainWettekstServlet?lang=nl&wettekstId=51687 [F]
   Regulation I/11: masters and officers must, "at intervals not exceeding
   five years", meet the medical standard and establish continued
   professional competence; the same five-year interval applies to tanker
   competence.
   https://www.kustcodex.be/kustcodex-consult/plainWettekstServlet?wettekstId=51689&lang=nl [F]
5. **Hotel groups recruit through applicant tracking systems** (software
   that stores and often parses uploaded CVs). Hilton's job search runs on
   Oracle Taleo and Oracle Cloud career sites.
   https://hilton.taleo.net/careersection/hww_cs_internal_global/moresearch.ftl [F, page loads as Hilton's advanced job search; the platform name is in the host only]
   https://efet.fa.us2.oraclecloud.com/hcmUI/CandidateExperience/en/sites/CX_1009/jobs [F, listed by search as "Search Jobs - Hilton Careers"; not opened]
6. **Greek tourism hiring (background for item 2).** France 24 (AFP),
   2025-06-20: the Research Institute for Tourism (ITEP) put the sector's
   shortage at 54,000 workers; hotel staff earn on average 950 to 1,000 euros
   a month plus bonuses; nearly half of hoteliers planned to recruit from
   outside the EU for more than 28,000 jobs, mostly unskilled.
   https://www.france24.com/en/live-news/20250620-staff-shortages-bite-as-greeks-shun-low-paid-tourism-jobs [F, news agency report of a research institute's figure; 15 months old]

### What CV services offer and charge

7. **TopResume** (large US service): resume writing "starting at $179"; a
   job-search package "starting at $2,495"; add-ons include cover letter and
   LinkedIn. https://topresume.com/plans [F, own prices]
8. **TopResume's process** starts with a questionnaire ("your current
   resume, job listings that interest you, and details like your key
   strengths, major accomplishments"), first draft within seven business
   days, up to two revisions.
   https://topresume.com/career-advice/professional-resume-rewrite-process [F, own process; page dated 2024-08-13, so treat as indicative]
9. **The Writique** sends a questionnaire after payment ("This information
   will help us create your document(s)"); turnaround 7 to 10 days. It
   quotes "1% of the client's salary" as an industry pricing norm.
   https://thewritique.com/process [F for its own process; the 1% norm is O]
10. **Premium services lean on a structured intake interview**: Let's Eat,
    Grandma lists 30-minute consultations (two 60-minute ones for
    executives) and describes ResumeSpice's intake as a phone interview.
    https://www.letseatgrandma.com/best-resume-writing-services-for-managers-in-2026/ [O, vendor ranking itself first, 2026-08-06]
11. **Maritime CV services exist and are cheap.** Sea & Beyond (India): CV
    evaluation from ₹999, CV preparation from ₹3,599, video CV from ₹6,999.
    https://www.seaandbeyond.com/cvs [F, own prices]
    Martide offers a free seafarer resume builder ("free ... and we promise
    it always will be"). https://www.martide.com/en/seafarer-resumes [F, own statement]
12. seafarer-cv.com (a Ukrainian maritime CV service) returned HTTP 522 and
    could not be read.

### What recruiters say

13. Ladders' 2018 eye-tracking study (30 recruiters): 7.4 seconds initial
    screen; recruiters look at current title and company, then dates, then
    education. https://www.hrdive.com/news/eye-tracking-study-shows-recruiters-look-at-resumes-for-7-seconds/541582/ [O, vendor study, 2018, historical only; nothing below rests on it]
14. ATS advice sites claim two-column layouts scramble parsed text, e.g.
    https://cvwiser.com/blog/two-column-resume-ats [O, vendor blog]. Checked
    against our own PDF instead (item 15).

### Own evidence

15. [Own] Plain text extraction (PyMuPDF) of `exports/Marine-Engineer-CV-v12.pdf`:
    reading order is clean (contacts, name, profile, then each company with
    its vessels, rank and months in order; totals; certificates). One flaw:
    the letter-spaced rank under the name extracts as
    "S E C O N D E N G I N E E R". The rank also appears unspaced in the
    contacts, so a keyword search still finds it.
16. [Own] The Flagship CV shows an "Expires / review" column; the example
    records hold dates as text such as "14 Jul 2029" beside free text such
    as "As required". Nothing checks those dates.
17. [Own] Flagship's vessel rows carry name, rank and months only. The
    earlier design studies carried the engine plant ("MAN B&W 6S50ME-B /
    9,480 kW", `archive/design-studies/content/example.json`); Flagship
    dropped it.
18. [Own] Span positions on page 1 of the v12 engineer PDF: vessel names
    start at x = 161.6 pt, ranks at 377.0 pt, so the name column is about
    208 pt; "MV North Passage" at 10.5 pt is 80 pt wide. A 9 pt suffix of
    about 20 characters ("· MAN B&W · 9,480 kW") adds roughly 90 pt and fits.

### What this means

- Crewing readers check facts CVgen cannot hold today (tonnage, engine power
  and make) and facts it holds but never checks (certificate dates). Both
  are domain facts, which is exactly the niche: "each domain keeps the facts
  and wording its field actually uses".
- Cheap and free maritime CV options exist (items 11, 12). A premium service
  wins on getting the field's facts right and on the look, not on price.
- The paid services checked (TopResume, The Writique) start with a
  questionnaire (items 8 and 9; item 10 is opinion). CVgen has none; the guide assumes the facts are already at hand.
- Hotel wages in Greece are low (item 6), so premium CVs in travel and
  tourism will sell to management, chefs and guest-facing leads, not to
  seasonal entry staff. An input for item 2, not a proposal.

## Candidates considered

| Idea | Decision |
|---|---|
| Certificate dates checked at render | **Kept** -> `certificate-validity-check` |
| Vessel particulars (GT, engine make, kW) on the marine CV | **Kept** -> `vessel-particulars` |
| Candidate intake questionnaire before the web app | **Kept** -> `candidate-intake` |
| ATS reading-order check in the suite | Dropped: own test (15) shows the order is already clean; the letter-spaced rank is a small fix for the hero component, handed to the lead as an observation |
| Cover letter from the same record | Dropped: no primary source found that crewing agencies ask for one (Marlow asks for CV, application form and consent form); revisit for travel and tourism |
| Periods (contract dates, hotel seasons) as one shared facts shape for items 2 and 3 | Dropped as a proposal: it is a design choice for when the owner opens item 2 or 3, not a new capability; noted for that design |
| Theme contact sheet so a client picks a look | Dropped: no evidence clients ask to choose; fits under item 7 anyway |
| Video CV (Sea & Beyond sells one) | Dropped: outside a Typst PDF product and the premium print niche |
| Autofill a crew manager's own application form from the record | Dropped: every agency has its own form; too broad for days of work |
| Certificate renewal reminders to past clients | Dropped for now: needs contact storage and scheduling, belongs with item 8 |
| DOCX export for ATS | Dropped: conflicts with ADR 0006 (Typst stays), and own test shows the PDF text is clean |
| Visa field (Marlow asks "valid visas") | Dropped: the contacts list can already carry a "Visas" entry |

## Final list

1. [`certificate-validity-check`](../../../proposals/certificate-validity-check.md):
   a CV that shows an expired certificate fails its render checks, so it
   cannot be approved or exported; ones expiring within six months warn.
2. [`vessel-particulars`](../../../proposals/vessel-particulars.md):
   optional tonnage, engine maker and engine power per vessel, in the unit
   the candidate's documents use, shown on the experience rows, because
   Marlow asks every applicant for these (GT and kW; the crewdata.com form
   asks DWT and BHP).
3. [`candidate-intake`](../../../proposals/candidate-intake.md): a one-document
   intake questionnaire that collects every fact the CV needs before a
   client's CV is started (marine now if the first client is marine,
   otherwise with item 2), the paper precursor of item 8's intake form.

## Observation for the lead

The rank under the name in the Flagship hero is set with letter spacing, and
text extraction reads it as separate letters (research item 15). A parser
matching "Second Engineer" still finds the unspaced rank in the contacts
column, so this is minor; it may be worth a look during the component work.

## Rounds

(Appended by the lead.)

- Research gate: PASS round 1 (reviews/01-research-reviewer.md)
- Quality gate round 1: FINDINGS (reviews/02-ceo-reviewer.md)
- Quality gate round 2: PASS, all three proposals (reviews/03-ceo-reviewer.md); its two Notes applied by the lead (width sum 177 pt; `sources/` added to the workspace tree step).
