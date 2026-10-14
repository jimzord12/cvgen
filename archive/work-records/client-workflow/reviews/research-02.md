# Research review round 2: client intake for premium CV writing

Snapshot: C:\Users\JIMZOR~1\AppData\Local\Temp\claude\C--Users-jimzord12-Documents-GitHub-cvgen\ab15b261-2127-4402-acd9-1b5dc058dff1\scratchpad\intake-research.md. The SHA-256 f36916443d89ac8d0eaac446ca6da853b23eaa06de95af0e049b02d7d9a2827f is as the lead gave it. I confirmed the line count: 313.

Claims checked: 31 load-bearing, 29 confirmed, 2 unreachable. The two are S5 (renders empty) and S10 (403). The research already labels both unverified, and neither carries a conclusion on its own.

## Round-1 findings
- **R1 resolved.** The Jobscan page splits its data in two:
  - a survey of 384 recruiters, February–March 2025;
  - "over 2.5 million job applications" from its tools, with no period given.
  - The 10.6x figure comes from the tool data.
- **R2 resolved.** HR Dive gives 7.4 s (6 s in 2012) and the layout findings. It gives no sample size and no gaze order, and the research now marks those unverified.
- **R3 resolved.** The S33 page matches the research:
  - 1,500 US hiring managers, 4–6 June 2026, Pollfish;
  - job-hopping 65% ("the leading candidate red flag"), AI-generated 49%, gap 43%, vague descriptions 42%;
  - no figures on length or measurable achievements;
  - published 2026-07-30, updated 2026-08-21.
  - The S24 figures (January 2024, n=625, 44%, 54%) are confirmed and marked 2024.
- **R4 resolved.** The Briefcase Coach quote is exact. The call length appears only in a testimonial, and the page does not mention a questionnaire.
- **R5 resolved**, except the leftover in R9.
- **R6 resolved.**
  - I read the S29 PDF. Nationality, date of birth and gender are each marked "(optional)", the photo is "if requested (optional)", and it is © 2002–2010.
  - S34 says "add a professional photograph of yourself" and gives no guidance on optional fields.
  - The Cuza Crewing page (2025-08-18) is confirmed.
- **R7 resolved.**
  - The Robin Ryan quotes are on robinryan.com, which says the piece first ran in Forbes (the 2024/12/03 URL).
  - Zuko does not publish its sample size.
  - The Jobscan dates are now stated.

## Wise disagreement: the author is right
Source: https://wiseresumewriters.com/wp-json/wp/v2/pages?slug=resume-questionnaire (the site's own WordPress JSON, which keeps the form HTML).
- Says: exactly four inputs carry `aria-required="true"`: `your-name`, `mobile`, `your-email` and `link-2`.
- `Link-1`, `Link-3` and the "Summarize your experience" textarea are not required.
- The page says: "Not all questions may apply to you. If they do not apply, mark them N/A."
- The fetch summaries gave inconsistent counts (3 to 5). The tags copied out verbatim show four.
- I withdraw my round-1 count of six.
- The per-role fields ("Title of person you report to", "Number of people you supervise", actual and working title) are present, so claim 17 stands.

## Findings
### R8 Note: Toffolo quote paraphrased (claim 27)
Source: https://www.jobscan.co/blog/dont-need-numbers-accomplishments-resume/ - Says: "When did I earn them and why did I earn them?" (about promotions) - Fix: quote it exactly, or drop the quotation marks.

### R9 Note: Summary lines 9 and 15 stretch S1
Source: https://careerprocanada.ca/client-intake-process-development-optimization-resume-writing-services/ - Says: it recommends a questionnaire before the consultation, and it reports that "Many practitioners require payment IN FULL". It does not advise it. Only NRWA (S11) says "Many writers use some combination…". - Fix: "NRWA says many writers combine…; CPC recommends a form before the consultation" and "reports that many practitioners require payment in full".

### R10 Note: superlatives in the draft question table
Question 7 says "Core of every premium intake" and question 8 says outcomes are "the most-forgotten item". Both rest on practitioner opinion (S12, S20), not data. Fix: "asked in every intake reviewed"; "practitioners say outcomes are most often missing".

### R11 Note: age of the Jobscan survey
February–March 2025 is about 18 months ago. It is still the latest edition (I found no 2026 one) and the text dates it. Re-check it before reuse.

## Coverage check
- "Jobscan State of the Job Search 2026": no newer edition exists, so 33a is the current data.
- "Resume Genius 2025 hiring survey": a January 2025 survey (n=1,000) names AI content as the top red flag (53%). I found nothing newer on measurable achievements or length that would change a conclusion.
- The Make it in Germany page is still a bot check, as the Gaps section says.

## Verdict: PASS
