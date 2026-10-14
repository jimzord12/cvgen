# Round 4 dispositions (lead)

Round 4 (focused on 3db25c2..9765962): **PASS**.

| Finding | Disposition |
|---|---|
| Minor 1: rebase refused over an uncommitted record edit | Fixed: `git pull --rebase --autostash origin main`, in the prose and the worktree block |
| Minor 2: no next step when more than the record commit is ahead | Fixed: do not push; treat it like the third case |
| Note: name the ahead count | Fixed: `git status -sb` must show `[ahead 1]` |

Reviewed in round 5, the last round under the cap.
