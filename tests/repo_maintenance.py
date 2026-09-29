#!/usr/bin/env python3
"""The repo-maintenance skill's audit script and agent files (adopted from the owner's research bundle,
2026-09-30; its self-test, pointed at this repository's .claude/). Standard library + git only:

    python tests/repo_maintenance.py      (also run by tests/run.py)

It builds throwaway git repositories in a temp folder, seeds them with known problems, runs the audit script
(and the Bash guard when it is installed; CVgen does not install it) and lints the frontmatter of the shipped files. It never touches the repository you run it from.
Exit code 0 = all passed. Print the output as evidence when adopting the bundle.
"""
import json, os, re, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
INSTALL = os.path.join(os.path.dirname(HERE), ".claude")
SKILL = os.path.join(INSTALL, "skills", "repo-maintenance")
AUDIT = os.path.join(SKILL, "scripts", "audit.py")
GUARD = os.path.join(SKILL, "scripts", "readonly_guard.py")
ADAPTER = os.path.join(INSTALL, "repo-maintenance.md")

passed, failed = [], []


def check(name, ok, detail=""):
    (passed if ok else failed).append(name)
    print(("PASS  " if ok else "FAIL  ") + name + ("" if ok else "   -> " + detail))


def git(cwd, *args):
    return subprocess.run(["git", "-c", "user.email=t@t", "-c", "user.name=t", "-c", "commit.gpgsign=false", *args],
                          cwd=cwd, capture_output=True, text=True)


def write(root, rel, text="x\n", binary=None):
    p = os.path.join(root, *rel.split("/"))
    os.makedirs(os.path.dirname(p), exist_ok=True)
    if binary is not None:
        open(p, "wb").write(binary)
    else:
        open(p, "w", encoding="utf-8", newline="\n").write(text)


def audit(root, *args):
    r = subprocess.run([sys.executable, AUDIT, "--root", root, "--json", *args], capture_output=True, text=True)
    try:
        return json.loads(r.stdout), r
    except ValueError:
        return None, r


def ids(data, sev=None):
    return {f["id"] for f in data["findings"] if sev is None or f["severity"] == sev}


def frontmatter(path):
    text = open(path, encoding="utf-8").read()
    m = re.match(r"^---\r?\n(.*?)\r?\n---", text, re.S)
    if not m:
        return None, text
    fm = {}
    for line in m.group(1).splitlines():
        kv = re.match(r"^([A-Za-z_][A-Za-z0-9_-]*):\s*(.*)$", line)
        if kv:
            fm[kv.group(1)] = kv.group(2).strip()
    return fm, text


def seeded_generic(tmp):
    r = os.path.join(tmp, "seeded")
    os.makedirs(r)
    git(r, "init", "-q", ".")
    write(r, "README.md", "# Demo\nShort.\n\n## Layout\nSee [guide](docs/guide.md) and [missing](docs/nope.md). `src/gone/old.py`\n")
    write(r, "docs/guide.md", "# Guide\nfront-end and frontend and front end. front-end, frontend, front end again.\n")
    write(r, "docs/lonely.md", "# Lonely\nnothing links here\n")
    for n in ("helper_one", "helperTwo", "helper-three", "HelperFour", "helper_five"):
        write(r, "src/utils/%s.py" % n, "x = 1\n")
    body = "same content here, more than sixty-four bytes so that it counts as a duplicate file, yes\n"
    write(r, "assets/a.txt", body)
    write(r, "assets/a_copy.txt", body)
    write(r, "dist/bundle.js", "cached\n")
    write(r, "notes.bak", "junk\n")
    write(r, ".env", "SECRET=1\n")
    write(r, "src/gen.py", "# auto-generated, do not edit\nx = 1\n")
    write(r, "assets/big.bin", binary=b"\0" * (2 * 1024 * 1024))
    write(r, ".gitignore", "*.log\n")
    write(r, "tracked.log", "hi\n")
    write(r, "tool.exe", binary=b"MZ")
    write(r, "package.json", "{}\n")
    write(r, "package-lock.json", "{}\n")
    write(r, "yarn.lock", "x\n")
    write(r, ".eslintrc.json", "{}\n")
    write(r, "eslint.config.js", "module.exports = {}\n")
    write(r, "LICENSE", "MIT\n")
    write(r, ".github/LICENSE", "MIT\n")
    write(r, "AGENTS.md", "# map\n")
    write(r, "CLAUDE.md", "\n".join("line %d" % i for i in range(230)) + "\n")
    for i in range(1, 10):
        write(r, "big/f%d.txt" % i, "%d\n" % i)
    git(r, "add", "-A")
    git(r, "add", "-f", "tracked.log")
    git(r, "commit", "-qm", "seed")
    write(r, "stray.txt", "untracked\n")
    return r


def main():
    print("python:", sys.version.split()[0], "| git:", subprocess.run(["git", "--version"], capture_output=True, text=True).stdout.strip())
    with tempfile.TemporaryDirectory() as tmp:
        # 1. every deterministic check fires on a seeded repo
        r = seeded_generic(tmp)
        d, proc = audit(r, "--mode", "audit", "--config", "none.md")
        check("audit.py runs and prints JSON", d is not None, proc.stderr[-300:])
        if d:
            want = {"I3", "G1", "L1", "L2", "D1", "D2", "D3", "I1", "I2", "N1", "N2", "N3", "N4", "R1", "R3", "B1", "B2",
                    "C1", "C2", "P2", "H2", "G2", "T2", "X2"}
            got = ids(d)
            check("seeded repo fires %d expected checks" % len(want), want <= got, "missing: %s" % sorted(want - got))
            check("secret file is Critical and tier C", any(f["id"] == "I3" and f["severity"] == "Critical" and f["tier"] == "C" for f in d["findings"]))
            check("untracked file is reported tier C, never a fix", any(f["id"] == "I2" and f["tier"] == "C" for f in d["findings"]))
            check("generic-only run says so", d["layer"] == "generic only")
            check("NOT_CHECKED is used, not silent passes", len(d["not_checked"]) >= 5)
        dq, _ = audit(r, "--mode", "quick", "--config", "none.md")
        check("quick mode runs a subset", dq is not None and ids(dq) <= ids(d) and "N1" not in ids(dq) and "L1" in ids(dq))
        base = os.path.join(tmp, "base.json")
        open(base, "w").write(json.dumps(d))
        write(r, "notes.bak", "junk changed\n")
        d2, _ = audit(r, "--mode", "audit", "--config", "none.md", "--baseline", base)
        check("--baseline reports new/resolved counts", d2 is not None and d2["new"] == 0 and d2["resolved"] == 0, str(d2 and (d2["new"], d2["resolved"])))
        p = subprocess.run([sys.executable, AUDIT, "--root", r, "--mode", "quick", "--config", "none.md", "--fail-on", "High", "--fail-code", "2"],
                           capture_output=True, text=True)
        check("--fail-on High --fail-code 2 exits 2 on a High finding", p.returncode == 2, str(p.returncode))
        write(r, "docs/guide.md", "# Guide\nclean\n")
        git(r, "commit", "-qam", "edit guide")
        ds, _ = audit(r, "--mode", "quick", "--config", "none.md", "--since", "HEAD~1")
        check("--since limits file findings to changed files", ds is not None and "G1" not in ids(ds) and "I1" not in ids(ds), str(ds and sorted(ids(ds))))

        # 2. the shipped CVgen adapter parses and its protections work
        c = os.path.join(tmp, "cvgen")
        os.makedirs(c)
        git(c, "init", "-q", ".")
        os.makedirs(os.path.join(c, ".claude"))
        with open(ADAPTER, encoding="utf-8") as f, open(os.path.join(c, ".claude", "repo-maintenance.md"), "w", encoding="utf-8", newline="\n") as g:
            g.write(f.read().replace("\nprotected:\n", "\nprotected:   # a comment on the key line must not empty the list\n", 1))
        pdf = b"%PDF-1.7\n" + os.urandom(1024 * 1024 + 10)
        write(c, "packages/domains/marine/templates/flagship/tests/approved/Marine-Engineer-CV-v11.pdf", binary=pdf)
        write(c, "packages/domains/marine/templates/flagship/layouts/flagship-v11.typ", "// layout\n")
        write(c, "examples/marine/flagship/release.pdf", binary=pdf)
        write(c, "docs/constitution.md", "# Constitution\nSee [gone](docs/missing.md)\n")
        write(c, "README.md", "# CVgen\n")
        git(c, "add", "-A")
        git(c, "commit", "-qm", "mini cvgen")
        dc, _ = audit(c, "--mode", "audit")
        check("CVgen adapter is read as the repo layer", dc is not None and dc["layer"].startswith("generic + "), str(dc and dc["layer"]))
        if dc:
            check("allow_large / allow_duplicates suppress intentional PDFs", "B1" not in ids(dc) and "D1" not in ids(dc), str(sorted(ids(dc))))
            l1 = [f for f in dc["findings"] if f["id"] == "L1"]
            check("broken link in protected constitution is tier C", bool(l1) and l1[0]["tier"] == "C" and l1[0]["protected"], str(l1))
            check("declared checks are listed for the agent to run", any("outputs.py check" in n for n in dc["not_checked"]))
            check("allow_names keeps the versioned Frozen Reference and layout out of N2", "N2" not in ids(dc),
                  str([f["evidence"] for f in dc["findings"] if f["id"] == "N2"]))

        # 3. edge cases
        e = os.path.join(tmp, "empty")
        os.makedirs(e)
        git(e, "init", "-q", ".")
        de, pe = audit(e)
        check("empty repository does not crash", de is not None, pe.stderr[-200:])
        p = subprocess.run([sys.executable, AUDIT, "--root", tmp, "--mode", "quick"], capture_output=True, text=True)
        check("outside a git repository it stops with a message", p.returncode != 0 and "git" in (p.stderr + p.stdout).lower())

    # CVgen change: --since never passes an option to git
    with tempfile.TemporaryDirectory() as tmp:
        r = os.path.join(tmp, "since")
        os.makedirs(r)
        git(r, "init", "-q"); write(r, "README.md", "# R\n"); git(r, "add", "-A"); git(r, "commit", "-q", "-m", "seed")
        p = subprocess.run([sys.executable, AUDIT, "--root", r, "--mode", "quick", "--since", "--output=x"], capture_output=True, text=True)
        check("--since refuses an option-like value and writes nothing",
              p.returncode != 0 and not any(n.startswith("x") for n in os.listdir(r)), p.stderr[-200:])

    # CVgen change: a mention of a Git-ignored area (private/, .local/) is not a dead path; a missing one still is.
    with tempfile.TemporaryDirectory() as tmp:
        r = os.path.join(tmp, "ign")
        os.makedirs(r)
        git(r, "init", "-q")
        write(r, ".gitignore", "private/\nstate/*\n!state/history/\n")
        write(r, "README.md", "# R\n\nClients live in `private/notes.md`; the log is `state/history/2030.md`; old notes were in `gone/notes.md`.\n")
        git(r, "add", "-A"); git(r, "commit", "-q", "-m", "seed")
        d, proc = audit(r, "--mode", "audit", "--config", "none.md")
        dead = [e for f in (d or {}).get("findings", []) if f["id"] == "L2" for e in f["evidence"]]
        check("L2 skips mentions of ignored areas, keeps real dead paths",
              any("gone/notes.md" in e for e in dead) and not any("private/" in e for e in dead)
              and any("state/history/2030.md" in e for e in dead), str(dead))   # tracked subfolder: still dead

    # 4. Bash guard: (command, should_pass). CVgen installs only the no-shell auditor, so no guard.
    if not os.path.isfile(GUARD):
        return finish()
    cases = [
        ("git status --porcelain", True), ("git -C /x ls-files -o --exclude-standard | wc -l", True),
        ("git grep -n -F old/path", True), ("git log --follow -- a/b.md", True),
        ("python skills/repo-maintenance/scripts/audit.py --mode audit", True), ("lychee --offline docs", True),
        ("find . -name '*.bak'", True), ("git mv a b", False), ("git clean -fd", False), ("git diff --output=x.txt", False),
        ("rm -rf dist", False), ("ls; rm foo", False), ("cat a > b", False), ("echo $(rm x)", False), ("python evil.py", False),
        ("find . -name '*.bak' -delete", False), ("lychee docs", False), ("rg --pre ./x foo", False), ("FOO=1 ls", False),
        ("git -c core.pager=x log", False), ("git grep -Oless foo", False), ("sort -o out.txt in.txt", False),
        ("git checkout -- .", False), ("git reset --hard", False), ("git stash drop", False), ("git rm a", False),
    ]
    bad = []
    for cmd, ok in cases:
        p = subprocess.run([sys.executable, GUARD], input=json.dumps({"tool_name": "Bash", "tool_input": {"command": cmd}}),
                           capture_output=True, text=True)
        if (p.returncode == 0) != ok:
            bad.append((cmd, p.returncode))
    check("readonly_guard.py allows/blocks %d commands as expected" % len(cases), not bad, str(bad))
    p = subprocess.run([sys.executable, GUARD], input=json.dumps({"tool_name": "Read", "tool_input": {}}), capture_output=True, text=True)
    check("guard ignores non-Bash tools", p.returncode == 0)

    return finish()


def finish():
    # 5. frontmatter lint
    fm, text = frontmatter(os.path.join(SKILL, "SKILL.md"))
    check("SKILL.md has frontmatter with name, description", bool(fm) and fm.get("name") == "repo-maintenance" and "description" in fm)
    check("SKILL.md description <= 1024 chars and body < 500 lines", bool(fm) and len(fm["description"]) <= 1024 and len(text.splitlines()) < 500)
    for name, must_have, must_not in (("repo-auditor-lite", ["Read", "Glob", "Grep"], ["Write", "Edit", "Bash", "PowerShell"]),):
        fm, _ = frontmatter(os.path.join(INSTALL, "agents", name + ".md"))
        tools = [t.strip() for t in (fm or {}).get("tools", "").split(",") if t.strip()]
        check("%s: name matches file, tools are read-only" % name,
              bool(fm) and fm.get("name") == name and all(t in tools for t in must_have) and not any(t in tools for t in must_not), str(tools))
    fm, _ = frontmatter(ADAPTER)
    check("adapter has front matter", fm is not None)
    for rel in ("checklist.md", "scripts/audit.py"):
        check("file present: " + rel, os.path.isfile(os.path.join(SKILL, *rel.split("/"))))

    print("\n%d passed, %d failed" % (len(passed), len(failed)))
    return not failed


def run_repo_maintenance():
    """For tests/run.py: the passed check names, or AssertionError with the failures."""
    passed.clear(); failed.clear()
    assert main(), failed
    return list(passed)


if __name__ == "__main__":
    sys.exit(0 if main() else 1)
