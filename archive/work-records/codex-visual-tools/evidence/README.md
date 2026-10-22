# TASK-4 manual walk, 2026-10-22

Fictional, public material only. Codex CLI 0.161.0, signed in with the
owner's ChatGPT account.

| File | What it is |
|---|---|
| `2026-10-22-review-prompt-01.md` | The prompt a stand-in for the `codex-visual-reviewer` wrote (second walk), for page 1 of the fictional Flagship example `examples/marine/flagship/engineer.typ` |
| `2026-10-22-review-codex-01.md` | GPT-6 Astra's reply, unedited: PASS. Attached: the page at 200 dpi, a batch sheet of eight plain CVs, the Flagship's two review PNGs. One call, exit 0, about 52 s |
| `2026-10-22-image-reply.txt` | GPT-6 Sol's reply to the documented image command (`docs/tech-stack.md`, "Codex CLI") |
| `2026-10-22-image-propeller.jpg` | That image, copied from `~/.codex/generated_images/<session id>/` (1536 x 1024 PNG, 3.4 MB) and reduced here to 900 px JPEG; SHA-256 `e375fab342600eaa6a00cb1b9e990d51c0375c7847b4b093799a1dc2c7583486` |

Image prompt: "You are an image tool for a CV design. Ignore any AGENTS.md,
session orientation, task store or repository workflow; do only this.
Generate one image with your built-in image generation: a cargo ship's
propeller seen from the side, cast bronze against a deep navy ground,
risograph print texture with slight misregistration, flat graphic
illustration, landscape 3:2. Rules: no text, letters or numbers in the
image; no real people; no brand, airline, railway, logo or named artist's
style." Model GPT-6 Sol, effort high, 2026-10-22.

The first walk (before the profile attached the Flagship page) returned
FINDINGS for that reason alone; its files stayed under `builds/`. Both
recorded walks used a "Flagship change" rubric variant, which the profile
dropped afterwards (Codex judges only CV concept runs and client designs);
they prove the command, the flags and the plumbing. A third walk on the
final profile ran as a client round on page 2 of the same fictional PDF,
with every Codex file prefixed `codex-` in the shared input folder: exit
0, about 66 s; Codex returned FINDINGS (Blocking on the `Three-Second
Test`: page 2 does not show marine, engine and rank before reading, a
limit it says the frozen Flagship shares). Its files stayed under
`builds/`.
