Verdict: PASS. No Blocking or Material findings. There are two Minor findings with a one-line fix that covers both, plus three Notes.

What I checked:
- The change is uncommitted in the atlas worktree (against HEAD 7f341f9). The vendored `.atlas/_kit/atlas.py` is byte-identical to `skills/atlas/scripts/atlas.py`.
- `src_hash` has three callers: `validate` (only checks that a hash is not None, and `dir1:` is never None), `staleness` (`check`/`build`) and `cmd_stamp`. All three compare the same `key -> hash` map, so they stay consistent.
- `git:` sources and file sources go through untouched branches.
- Nothing else reads the `dir:` format: no hit in `atlas.js`, the skill folder or PROTOCOL. The lock now holds 15 `dir1:` entries and 0 `dir:` entries.
- `python .atlas/_kit/atlas.py check` gives 5/5 ok, exit 0.
- All 15 folder sources in use are clean forward-slash paths with a trailing `/`. `clean_src` strips that slash, so `docs` and `docs/` hash the same (I tested both).
- Outside a repo, or with git missing, `git()` returns None and the code falls back to `os.listdir`. An empty folder or one with no tracked files returns `""` and hashes to a constant. No crash in any of these cases.

Findings

1. Minor. `.atlas/_kit/atlas.py:108-111`: children with quoted names are invisible.
   - Cause: with the default `core.quotePath`, `git ls-files` prints non-ASCII or unusual names in quotes, e.g. `"docs/caf\303\251.md"`. The leading `"` fails `l.startswith(pre)`, so that child is dropped.
   - Proof: in a scratch repo, `docs/café.md` tracked, untracked and tracked again gave the same `dir1:5d85…` hash every time. Adding or removing such a child never marks the page STALE.
   - Worse case: if the cited folder's own name is non-ASCII, every line is quoted and the hash is a constant.
   - Today's exposure: 0 of 453 tracked paths in CVgen are quoted. It matters for the generic skill (e.g. Greek file names).
   - Fix: see the shared fix below. Don't switch to `-z` with `quotePath=false`: `git()` decodes with the locale codepage (cp1252 here, Python 3.11, utf8_mode 0). UTF-8 bytes like 0x8F (e.g. Greek "Ώ" is CE 8F) would raise UnicodeDecodeError.

2. Minor. Same lines: a source spelling that isn't a canonical repo-relative path now silently vouches for nothing.
   - The prefix match only works when `key` is exactly a repo-relative forward-slash path. Measured:
     - `./docs`, `docs\work`, `.` and `Docs` (case mismatch on Windows) all pass `os.path.isdir` and `validate`.
     - Each then hashes to `dir1:da39a3…`, which is sha1 of the empty string.
   - Result: such a page can never go STALE through that source, and nothing warns.
   - The old `ls-files -s -- key` treated these as pathspecs, so it worked. This is a regression for those spellings. No current CVgen source uses them, but agent-written sources in other repos plausibly could (`./x/`).
   - Fix: see the shared fix below.

Shared fix for 1 and 2 (smallest): list relative to the folder itself and strip the quotes.
```python
listing = git(p, "ls-files")
...
names = sorted({l.strip('"').split("/")[0] for l in listing.splitlines()})
```
- `git -C <folder> ls-files` prints paths relative to that folder (verified: `"caf\303\251.md"`, `sub/y.md`).
- That covers `./`, backslashes, `.`, case and a quoted folder name.
- The escaped form of a quoted name is still deterministic and still uses `/`.
- Once `pre` is gone, the `l.startswith(pre)` filter goes with it.

3. Note. A folder whose contents are all untracked or ignored hashes to a constant while git is available, so it never goes STALE. That matches the settled "tracked children" decision. The PROTOCOL sentence says "files and subfolders added or removed" but not "tracked"; adding "tracked" would make it exact. Optional.

4. Note. The no-git fallback hashes a different set from the git path: `os.listdir` includes untracked files and skips dotfiles, while git includes tracked dotfiles. A lock stamped on a machine with git and checked on one without (or the reverse) shows every folder source as STALE. This mismatch already existed before the change. Acceptable.

5. Note. The `dir1:` prefix makes every old folder stamp STALE once, as intended. The lock in the worktree has already been re-stamped. The PROTOCOL sentence at `skills/atlas/PROTOCOL.md:119-121` is otherwise accurate and sits in the right place.

Files: `C:\Users\jimzord12\Documents\GitHub\cvgen.worktrees\atlas\.atlas\_kit\atlas.py` (lines 85-114), `C:\Users\jimzord12\.claude-personal\skills\atlas\scripts\atlas.py` (same), `C:\Users\jimzord12\.claude-personal\skills\atlas\PROTOCOL.md:119-121`. I edited no files; the only thing created was a throwaway test repo under the scratchpad (`scratchpad\q`).

---

## Dispositions (lead, 2026-10-01)

- Minor 1 (quoted names invisible) and Minor 2 (non-canonical spellings vouch for nothing): fixed with the suggested shared fix, `git -C <folder> ls-files` with the quotes stripped. The probes rerun: a file added deep under `docs/work/` leaves system-map ok, a file added directly under `docs/` marks it STALE, and the cleanup restores ok. Existing stamps still match.
- Note 3: applied; PROTOCOL now says "tracked files and subfolders".
- Notes 4 and 5: accepted as described.
