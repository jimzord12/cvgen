#!/usr/bin/env python3
"""audit.py - deterministic checks for the repo-maintenance skill.

Stdlib only (Python 3.8+) plus git. Read-only: never writes into the repository.
Check IDs match checklist.md. Findings are leads for a human or agent to judge.

Usage:
  python3 audit.py [--mode quick|audit|deep] [--since REF] [--json]
                   [--config .claude/repo-maintenance.md] [--baseline prev.json]
                   [--fail-on High [--fail-code 2]] [--max-evidence 6] [--root .]
"""
import argparse, collections, datetime, hashlib, json, os, posixpath, re, shutil, subprocess, sys, time
from urllib.parse import unquote

SEV = ["Info", "Low", "Medium", "High", "Critical"]
# Checks that are cheap enough for every commit / end of feature.
QUICK = {"N2", "N3", "D2", "G1", "I1", "I2", "I3", "B1", "B2", "L1", "C2", "H2", "R3"}
TEXT_EXT = {".md", ".txt", ".rst", ".py", ".js", ".ts", ".tsx", ".jsx", ".mjs", ".cjs", ".json", ".yml",
            ".yaml", ".toml", ".cfg", ".ini", ".sh", ".typ", ".html", ".css", ".scss", ".go", ".rs",
            ".java", ".kt", ".swift", ".rb", ".php", ".c", ".h", ".cpp", ".cs", ".sql", ".xml", ".svg"}
MAX_TEXT = 512 * 1024
MIB = 1024 * 1024


# ---------- helpers ----------
def git(root, *args):
    r = subprocess.run(["git", "-C", root, "-c", "core.quotepath=off", *args],
                       capture_output=True, text=True, errors="replace")
    return r.stdout if r.returncode == 0 else ""


def zlist(root, *args):
    return [p for p in git(root, *args).split("\0") if p]


def glob_re(g):
    g = g.strip()
    if g.startswith("./"):
        g = g[2:]
    if g.endswith("/"):
        g += "**"
    if "/" not in g:
        g = "**/" + g            # gitignore-like: bare pattern matches at any depth
    out, i = "", 0
    while i < len(g):
        if g.startswith("**/", i):
            out += "(?:.*/)?"; i += 3
        elif g.startswith("**", i):
            out += ".*"; i += 2
        elif g[i] == "*":
            out += "[^/]*"; i += 1
        elif g[i] == "?":
            out += "[^/]"; i += 1
        else:
            out += re.escape(g[i]); i += 1
    return re.compile("^" + out + "$")


class Globs:
    def __init__(self, patterns):
        self.res = [glob_re(g) for g in patterns]

    def __call__(self, path):
        return any(r.match(path) for r in self.res)


def clean_item(v):
    v = v.strip()
    if v[:1] in "\"'":
        end = v.find(v[0], 1)
        return v[1:end] if end > 0 else v[1:]
    return re.split(r"\s+#", v)[0].strip()


def load_config(root, rel):
    p = os.path.join(root, rel)
    if not os.path.isfile(p):
        return None
    text = open(p, encoding="utf-8", errors="replace").read()
    m = re.match(r"^---\r?\n(.*?)\r?\n---", text, re.S)
    cfg, key = {}, None
    if not m:
        return cfg
    for line in m.group(1).splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        li = re.match(r"^\s+-\s+(.*)$", line)
        if li and key is not None and isinstance(cfg.get(key), list):
            cfg[key].append(clean_item(li.group(1)))
            continue
        kv = re.match(r"^([A-Za-z_][A-Za-z0-9_]*):\s*(.*)$", line)
        if kv:
            key, v = kv.group(1), kv.group(2).strip()
            cfg[key] = clean_item(v) if v else []
    return cfg


def as_list(cfg, k):
    v = cfg.get(k, [])
    return v if isinstance(v, list) else [v]


def as_num(cfg, k, default):
    try:
        return float(cfg.get(k, default))
    except (TypeError, ValueError):
        return default


def strip_code(text):
    text = re.sub(r"(?ms)^(```|~~~).*?^\1[^\n]*$", "", text)     # fenced blocks
    return text


def case_style(stem):
    if re.fullmatch(r"[a-z0-9]+(-[a-z0-9]+)+", stem): return "kebab"
    if re.fullmatch(r"[a-z0-9]+(_[a-z0-9]+)+", stem): return "snake"
    if re.fullmatch(r"[a-z][a-z0-9]*([A-Z][a-z0-9]*)+", stem): return "camel"
    if re.fullmatch(r"([A-Z][a-z0-9]+){2,}", stem): return "pascal"
    return None                                                   # neutral: single word, ALLCAPS, mixed


# ---------- audit ----------
class Audit:
    def __init__(self, args):
        self.a = args
        top = git(args.root, "rev-parse", "--show-toplevel").strip()
        if not top:
            sys.exit("audit.py: not inside a git repository")
        self.root = top
        self.name = os.path.basename(top)
        self.sha = git(top, "rev-parse", "--short", "HEAD").strip() or "no-commits"
        self.tracked = zlist(top, "ls-files", "-z")
        self.tset = set(self.tracked)
        self.cfg = load_config(top, args.config)
        self.C = self.cfg or {}
        self.protected = Globs(as_list(self.C, "protected"))
        self.skip = Globs(as_list(self.C, "ignore"))
        self.entry = Globs(as_list(self.C, "entry_points"))
        self.findings, self.not_checked = [], []
        self.cache = {}
        self.changed = None
        if args.since:
            ch = set(git(top, "diff", "--name-only", args.since + "...HEAD").splitlines())
            ch |= {l[3:].strip('"') for l in git(top, "status", "--porcelain").splitlines()}
            self.changed = ch
        self.now = time.time()

    # -- io
    def read(self, p):
        if p not in self.cache:
            fp = os.path.join(self.root, p)
            txt = None
            try:
                if (os.path.splitext(p)[1].lower() in TEXT_EXT and os.path.isfile(fp)
                        and not os.path.islink(fp) and os.path.getsize(fp) <= MAX_TEXT):
                    txt = open(fp, encoding="utf-8", errors="replace").read()
            except OSError:
                txt = None
            self.cache[p] = txt
        return self.cache[p]

    def git_ignored(self, path):
        """True when Git ignores the path (CVgen change): it may exist only on some machines, like private/."""
        cache = self.__dict__.setdefault("_ignored", {})
        if path not in cache:
            r = subprocess.run(["git", "-C", self.root, "check-ignore", "-q", "--no-index", path.lstrip("/")],
                               capture_output=True)
            cache[path] = r.returncode == 0
        return cache[path]

    def live(self):
        return [p for p in self.tracked if not self.skip(p) and os.path.lexists(os.path.join(self.root, p))]

    def on(self, cid):
        return self.a.mode != "quick" or cid in QUICK

    def add(self, cid, sev, title, paths, fix, tier, evidence=None, scope="file"):
        paths = sorted(set(paths))
        if (not paths and scope == "file") or (scope == "global" and not evidence):
            return
        prot = bool(paths) and all(self.protected(p) for p in paths)
        if self.changed is not None and scope == "file" and not any(p in self.changed for p in paths):
            return
        self.findings.append(dict(id=cid, severity=sev, title=title, paths=paths, count=len(paths),
                                  evidence=evidence if evidence is not None else paths, fix=fix,
                                  tier="C" if prot else tier, protected=prot))

    def nc(self, msg):
        self.not_checked.append(msg)

    # -- checks
    def naming(self):
        live = self.live()
        if self.on("N1"):
            bydir = collections.defaultdict(list)
            for p in live:
                bydir[os.path.dirname(p)].append(p)
            for d, files in bydir.items():
                if len(files) < 4:
                    continue
                styles = collections.defaultdict(list)
                for p in files:
                    base = os.path.basename(p)
                    if base.startswith("."):
                        continue
                    st = case_style(base.split(".")[0])
                    if st:
                        styles[st].append(p)
                if len(styles) > 1:
                    top = max(styles, key=lambda s: len(styles[s]))
                    minority = [p for s, ps in styles.items() if s != top for p in ps]
                    self.add("N1", "Low", "Mixed naming styles in %s (majority %s)" % (d or ".", top), minority,
                             "Rename the minority files to %s in one move commit (owner approves)." % top, "B")
        if self.on("N2"):
            bad = []
            allow = Globs(as_list(self.C, "allow_names"))
            for p in live:
                b = os.path.basename(p)
                stem = b.split(".")[0].lower()
                toks = re.split(r"[-_ ]+", stem)
                if allow(p):
                    continue
                if (set(toks) & {"final", "new", "copy", "old", "tmp", "temp", "backup", "untitled", "bak"}
                        or " " in b or re.search(r"\(\d+\)", b) or re.search(r"[-_]v\d+$", stem)):
                    bad.append(p)
            self.add("N2", "Medium", "Names that do not say what the file is", bad,
                     "Propose a descriptive name per file; rename in a move commit.", "B")
        if self.on("N3"):
            maxd = int(as_num(self.C, "max_depth", 5))
            maxt = int(as_num(self.C, "max_top_level", 12))
            maxe = int(as_num(self.C, "max_dir_entries", 25))
            deep = [p for p in live if p.count("/") > maxd]
            self.add("N3", "Low", "Paths deeper than %d levels" % maxd, deep,
                     "Flatten or regroup; ask the owner which folders to merge.", "B")
            tops = {p.split("/")[0] for p in live if not p.startswith(".")}
            if len(tops) > maxt:
                self.add("N3", "Low", "%d visible top-level entries (limit %d)" % (len(tops), maxt), [],
                         "Group related top-level folders under a few homes.", "B", sorted(tops), scope="global")
            kids = collections.defaultdict(set)
            for p in live:
                parts = p.split("/")
                for i in range(len(parts)):
                    kids["/".join(parts[:i])].add(parts[i])
            wide = ["%s (%d entries)" % (d or ".", len(v)) for d, v in kids.items() if len(v) > maxe]
            if wide:
                self.add("N3", "Low", "Directories with more than %d entries" % maxe, [],
                         "Split by kind or purpose.", "B", wide, scope="global")

    def structure(self):
        live = self.live()
        tops = sorted({p.split("/")[0] for p in live if "/" in p and not p.startswith(".")})
        mp = [m for m in ("AGENTS.md", "CLAUDE.md", "README.md", "README") if m in self.tset]
        if self.on("N4"):
            if not mp:
                self.nc("N4 top-level purposes: no map file (AGENTS.md, CLAUDE.md, README.md) found")
            else:
                text = "\n".join(self.read(m) or "" for m in mp)
                miss = [d for d in tops if not re.search(r"(?<![\w-])" + re.escape(d) + r"(?![\w-])", text)]
                self.add("N4", "Medium", "Top-level folders missing from the map file (%s)" % ", ".join(mp),
                         [], "Add one line per folder to the map (context-maintainer owns that text).", "B",
                         miss, scope="global")
        homes = as_list(self.C, "homes")
        if self.on("H1"):
            for rule in homes:
                if "=>" not in rule:
                    continue
                kind, home = [s.strip() for s in rule.split("=>", 1)]
                k, h = Globs([kind]), Globs([home])
                bad = [p for p in live if k(p) and not h(p)]
                self.add("H1", "High", "Files outside their declared home (%s => %s)" % (kind, home), bad,
                         "Move each to its home (owner approves; a move commit, then a reference-fix commit).", "B")
            if not homes:
                byext = collections.defaultdict(lambda: collections.defaultdict(list))
                for p in live:
                    ext = os.path.splitext(p)[1].lower()
                    if "/" in p and ext and ext not in {".md", ".json", ".yml", ".yaml", ".toml", ".txt", ".lock", ".cfg", ".ini"}:
                        byext[ext][p.split("/")[0]].append(p)
                for ext, dirs in byext.items():
                    if len(dirs) >= 4:
                        self.add("H1", "Low", "%s files spread over %d top-level folders (candidate for one home)" % (ext, len(dirs)),
                                 [], "Ask the owner whether %s files should have one home." % ext, "B",
                                 ["%s: %d files" % (d, len(v)) for d, v in sorted(dirs.items())], scope="global")
                self.nc("H1 one home per kind: no `homes` declared, only inferred candidates")
        if self.on("H2"):
            for f in ("LICENSE", "LICENSE.md", "SECURITY.md", "CODEOWNERS", "CONTRIBUTING.md", "CODE_OF_CONDUCT.md"):
                where = [d + f if d else f for d in ("", ".github/", "docs/") if (d + f) in self.tset]
                if len(where) > 1:
                    self.add("H2", "Low", "%s exists in %d places" % (f, len(where)), where,
                             "Keep one (GitHub reads .github/, then root, then docs/).", "B")
        if self.on("X2"):
            kids = collections.defaultdict(list)
            for p in live:
                kids[os.path.dirname(p)].append(p)
            text = "\n".join(self.read(m) or "" for m in mp)
            lonely = []
            for d, fs in kids.items():
                if d and len(fs) >= int(as_num(self.C, "big_folder", 8)):
                    has = any(os.path.basename(f).lower().split(".")[0] in ("readme", "index") for f in fs)
                    if not has and d not in text and not self.protected(d + "/x"):
                        lonely.append(d)
            self.add("X2", "Low", "Big folders with no README/index and not named in the map", lonely,
                     "Add a two-line README or a map entry.", "B")

    def junk(self):
        live = self.live()
        if self.on("D2"):
            pat = re.compile(r"(\.bak|\.orig|\.rej|\.swp|~)$|(^|/)(\.DS_Store|Thumbs\.db)$")
            self.add("D2", "Medium", "Leftover files tracked", [p for p in live if pat.search(p)],
                     "git rm after owner approval; add the pattern to .gitignore.", "B")
        if self.on("D1"):
            allow = Globs(as_list(self.C, "allow_duplicates"))
            by_size = collections.defaultdict(list)
            for p in live:
                fp = os.path.join(self.root, p)
                try:
                    sz = os.path.getsize(fp)
                except OSError:
                    continue
                if 64 <= sz <= 50 * MIB and not allow(p) and not os.path.islink(fp):
                    by_size[sz].append(p)
            groups = collections.defaultdict(list)
            for sz, ps in by_size.items():
                if len(ps) > 1:
                    for p in ps:
                        h = hashlib.sha256(open(os.path.join(self.root, p), "rb").read()).hexdigest()
                        groups[h].append(p)
            dup = [g for g in groups.values() if len(g) > 1]
            self.add("D1", "Medium", "Exact duplicate files (%d group%s)" % (len(dup), "" if len(dup) == 1 else "s"), [p for g in dup for p in g],
                     "Keep the file in its home; owner decides which copy goes.", "B", [" == ".join(sorted(g)) for g in dup])
        if self.on("D3"):
            corpus = {p: self.read(p) for p in live}
            corpus = {p: t for p, t in corpus.items() if t is not None}
            names_ok = re.compile(r"^(readme|changelog|license|contributing|security|code_of_conduct|agents|claude|index)", re.I)
            orphans = []
            for p in live:
                if not p.lower().endswith(".md") or names_ok.match(os.path.basename(p)) or self.entry(p) or p.startswith(".claude/"):
                    continue
                b = os.path.basename(p)
                if not any(b in t for q, t in corpus.items() if q != p):
                    orphans.append(p)
            self.add("D3", "Low", "Docs that nothing else mentions", orphans,
                     "Link from the map or a parent doc, or ask the owner whether it is still needed.", "B")
        if self.on("D4"):
            self.nc("D4 unreferenced code/assets: run knip / vulture / deptry / cargo-machete (deep mode)")

    # docs: links, mentions, staleness
    def docs(self):
        live = self.live()
        mds = [p for p in live if p.lower().endswith(".md") and not re.match(r"changelog", os.path.basename(p), re.I)]
        broken, dead, refs = [], [], collections.defaultdict(set)
        for doc in mds:
            text = self.read(doc)
            if not text:
                continue
            body = strip_code(text)
            lines = body.splitlines()
            for n, line in enumerate(lines, 1):
                plain = re.sub(r"`[^`\n]*`", "", line)
                targets = re.findall(r"!?\[[^\]]*\]\(\s*<?([^)\s>]+)>?(?:\s+\"[^\"]*\")?\s*\)", plain)
                targets += re.findall(r"^\s*\[[^\]]+\]:\s*(\S+)", plain)
                for t in targets:
                    if re.match(r"^([a-z][a-z0-9+.-]*:|#|\{\{|<)", t, re.I) or "://" in t:
                        continue
                    rel = unquote(t.split("#")[0].split("?")[0])
                    if not rel:
                        continue
                    cand = rel.lstrip("/") if rel.startswith("/") else posixpath.normpath(posixpath.join(posixpath.dirname(doc), rel))
                    if os.path.exists(os.path.join(self.root, cand)):
                        refs[doc].add(cand.rstrip("/"))
                    else:
                        broken.append((doc, n, t))
                for tok in re.findall(r"`([^`\s]+)`", line):
                    if ("/" not in tok or not re.fullmatch(r"[\w.@/-]+", tok) or tok.startswith(("http", "~", "$", "/", "@"))
                            or "*" in tok or "..." in tok or not (re.search(r"\.\w{1,5}$", tok) or tok.endswith("/"))):
                        continue
                    for cand in (posixpath.normpath(tok), posixpath.normpath(posixpath.join(posixpath.dirname(doc), tok))):
                        if os.path.exists(os.path.join(self.root, cand)):
                            refs[doc].add(cand.rstrip("/")); break
                    else:
                        if not self.git_ignored(tok):   # a mention of an ignored area (private/, .local/) is not dead
                            dead.append((doc, n, tok))
        if self.on("L1"):
            self.add("L1", "High", "Broken relative links", [d for d, _, _ in broken],
                     "Point each link at the file's new home (git log --follow finds renames).", "A",
                     ["%s:%d -> %s" % b for b in broken])
            self.nc("L1 anchors (#fragments) and external URLs: run `lychee` (deep mode) if installed")
        if self.on("L2"):
            self.add("L2", "Medium", "Docs mention paths that do not exist", [d for d, _, _ in dead],
                     "Update the mention if a unique successor exists, otherwise ask the owner.", "A",
                     ["%s:%d `%s`" % d for d in dead])
        if self.on("L3"):
            days = as_num(self.C, "doc_stale_days", 90)
            last, ct = {}, 0
            for line in git(self.root, "log", "-n", "5000", "--name-only", "--format=%x01%ct").splitlines():
                if line.startswith("\x01"):
                    ct = int(line[1:] or 0)
                elif line:
                    last.setdefault(line, ct)
            stale = []
            for doc in mds[:400]:
                dt = last.get(doc)
                if not dt or (self.now - dt) < days * 86400:
                    continue
                newer = []
                for r in refs.get(doc, ()):
                    rt = max([t for q, t in last.items() if q == r or q.startswith(r + "/")] or [0])
                    if rt > dt:
                        newer.append(r)
                if newer:
                    stale.append((doc, int((self.now - dt) / 86400), sorted(newer)[:3]))
            self.add("L3", "Medium", "Docs older than %d days whose referenced paths changed since" % days,
                     [d for d, _, _ in stale], "Auditor re-reads each and proposes an update (a lead, not a verdict).", "B",
                     ["%s (%dd old; newer: %s)" % (d, a, ", ".join(n)) for d, a, n in stale])

    def readme(self):
        if not (self.on("R1") or self.on("R3")):
            return
        if self.on("R1"):
            rd = next((p for p in ("README.md", "README.rst", "README", "README.txt") if p in self.tset), None)
            if not rd:
                self.add("R1", "Medium", "No root README", [], "Write one (what it is, run, test, docs map).", "B",
                         ["README missing at repository root"], scope="global")
            else:
                heads = " ".join(re.findall(r"(?m)^#+\s*(.+)$", self.read(rd) or "")).lower()
                need = {"how to run/install": r"install|getting started|quick ?start|setup|usage|run",
                        "how to test": r"test",
                        "where the docs are": r"doc|guide|structure|layout|map|contents"}
                miss = [k for k, rx in need.items() if not re.search(rx, heads)]
                self.add("R1", "Medium", "README headings do not cover: " + ", ".join(miss), [rd] if miss else [],
                         "Add the missing section(s) (auditor judges wording).", "B")
        if self.on("R3"):
            for f in ("CLAUDE.md", "AGENTS.md"):
                if f in self.tset:
                    n = len((self.read(f) or "").splitlines())
                    if n > 200:
                        self.add("R3", "Medium", "%s has %d lines (target 200 or fewer)" % (f, n), [f],
                                 "Move procedures to skills or path-scoped rules (context-maintainer owns the text).", "B")
            if "CLAUDE.md" in self.tset and "AGENTS.md" in self.tset:
                cl = self.read("CLAUDE.md") or ""
                if "@AGENTS.md" not in cl and not os.path.islink(os.path.join(self.root, "CLAUDE.md")):
                    self.add("R3", "Medium", "CLAUDE.md and AGENTS.md both exist and neither imports the other",
                             ["CLAUDE.md", "AGENTS.md"], "Put `@AGENTS.md` at the top of CLAUDE.md (Claude Code reads AGENTS.md only when no CLAUDE.md exists).", "B")
        if self.on("R2"):
            self.nc("R2 README commands: run in a clean worktree (deep mode)")

    def generated(self):
        live = self.live()
        if self.on("G1"):
            dirs = {"dist", "build", "out", "target", "node_modules", "__pycache__", ".venv", "venv", ".next",
                    ".nuxt", "coverage", ".pytest_cache", ".mypy_cache", ".gradle", ".turbo", ".cache"}
            allow = Globs(as_list(self.C, "allow_tracked_generated"))
            hit = [p for p in live if (set(p.split("/")[:-1]) & dirs or p.endswith((".pyc", ".pyo"))) and not allow(p)]
            self.add("G1", "High", "Generated or cache output is tracked", hit,
                     "git rm --cached after owner approval, then ignore the folder.", "B")
        if self.on("G2"):
            pat = re.compile(r"auto-?generated|generated by|do not edit|@generated", re.I)
            declared = Globs(as_list(self.C, "generated"))
            ga = self.read(".gitattributes") or ""
            ga_globs = Globs([l.split()[0] for l in ga.splitlines() if "linguist-generated" in l and l.split()])
            hit = []
            for p in live[:3000]:
                if p.endswith((".lock", "package-lock.json")) or declared(p) or ga_globs(p):
                    continue
                t = self.read(p)
                if t and pat.search("\n".join(t.splitlines()[:5])):
                    hit.append(p)
            self.add("G2", "Low", "Files that look generated but are not declared as generated", hit,
                     "Add them to `generated` in the repo layer or mark linguist-generated.", "B")

    def config(self):
        root_files = [p for p in self.live() if "/" not in p]
        if self.on("C1"):
            groups = {"eslint": (r"\.eslintrc.*", r"eslint\.config\..*"), "prettier": (r"\.prettierrc.*", r"prettier\.config\..*"),
                      "babel": (r"\.babelrc.*", r"babel\.config\..*")}
            for tool, (a, b) in groups.items():
                fa = [p for p in root_files if re.fullmatch(a, p)]
                fb = [p for p in root_files if re.fullmatch(b, p)]
                if fa and fb:
                    self.add("C1", "Medium", "Two live %s configs" % tool, fa + fb, "Keep the newer format; owner approves.", "B")
            cfgs = [p for p in root_files if p.startswith(".") and p not in (".gitignore", ".gitattributes")
                    or re.search(r"\.(json|toml|ya?ml|ini|cfg)$", p) and p not in ("package.json", "package-lock.json")]
            lim = int(as_num(self.C, "max_root_config", 12))
            if len(cfgs) > lim:
                self.add("C1", "Low", "%d config files at the root (limit %d)" % (len(cfgs), lim), [],
                         "Move tool configs under `config/` where the tool allows it.", "B", sorted(cfgs), scope="global")
        if self.on("C2"):
            for name, files in {"JavaScript": ["package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock"],
                                "Python": ["poetry.lock", "uv.lock", "Pipfile.lock", "pdm.lock"]}.items():
                dirs = collections.defaultdict(list)
                for p in self.live():
                    if os.path.basename(p) in files:
                        dirs[os.path.dirname(p)].append(p)
                for d, ps in dirs.items():
                    if len(ps) > 1:
                        self.add("C2", "Medium", "Several %s lockfiles in %s" % (name, d or "."), ps,
                                 "Keep the one the CI uses; owner approves.", "B")
        if self.on("P2"):
            manifests = {"package.json", "pyproject.toml", "requirements.txt", "Cargo.toml", "go.mod", "Gemfile", "composer.json"}
            if any(os.path.basename(p) in manifests for p in self.tracked):
                upd = [p for p in self.tracked if re.search(r"(^|/)(dependabot\.ya?ml|renovate.*\.json5?|\.renovaterc.*)$", p)]
                if not upd:
                    self.add("P2", "Low", "No dependency-update automation (Dependabot or Renovate)", [],
                             "Optional: add a Dependabot config.", "B", ["no dependabot.yml / renovate config"], scope="global")
        if self.on("P1"):
            self.nc("P1 unused/missing dependencies: run knip / deptry / cargo-machete (deep mode)")

    def hygiene(self):
        live = self.live()
        if self.on("I1"):
            self.add("I1", "Medium", "Tracked files that .gitignore says to ignore",
                     [p for p in zlist(self.root, "ls-files", "-z", "-c", "-i", "--exclude-standard") if not self.skip(p)],
                     "git rm --cached after owner approval.", "B")
        if self.on("I2"):
            un = [p for p in zlist(self.root, "ls-files", "-z", "-o", "--exclude-standard") if not self.skip(p)]
            self.add("I2", "Medium", "Untracked, unignored files lingering (owner's call, never touched)", un,
                     "Owner decides: commit, ignore or delete. The agent does not touch them.", "C")
        if self.on("I3"):
            pat = re.compile(r"(^|/)(\.env(\.[\w-]+)?|id_rsa|id_ed25519|credentials\.json|[^/]+\.(pem|key|p12|pfx))$")
            safe = re.compile(r"\.(example|sample|template|dist)$")
            hit = [p for p in live if pat.search(p) and not safe.search(p)]
            self.add("I3", "Critical", "Files that look like secrets are tracked (content not shown)", hit,
                     "Owner rotates the secret; history rewrite is the owner's decision.", "C")
            if not shutil.which("gitleaks"):
                self.nc("I3 secret scan by content: gitleaks not installed (names only were checked)")
        if self.on("B1"):
            allow = Globs(as_list(self.C, "allow_large"))
            lo, mid, hi = as_num(self.C, "large_mib", 1), as_num(self.C, "huge_mib", 10), 50
            buckets = {"Low": [], "Medium": [], "High": []}
            for p in live:
                fp = os.path.join(self.root, p)
                if os.path.islink(fp) or allow(p):
                    continue
                sz = os.path.getsize(fp) / MIB
                if sz >= hi: buckets["High"].append((p, sz))
                elif sz >= mid: buckets["Medium"].append((p, sz))
                elif sz >= lo: buckets["Low"].append((p, sz))
            for sev, items in buckets.items():
                self.add("B1", sev, "Tracked files of %s size" % {"Low": "%g MiB or more" % lo, "Medium": "%g MiB or more" % mid,
                         "High": "50 MiB or more (GitHub warns at 50, blocks at 100)"}[sev], [p for p, _ in items],
                         "Declare as an allowed exception, or move to Git LFS / release assets (owner decides; never rewrite history).",
                         "B", ["%s (%.1f MiB)" % (p, s) for p, s in sorted(items, key=lambda x: -x[1])])
        if self.on("B2"):
            self.add("B2", "Medium", "Binary artifacts tracked",
                     [p for p in live if p.lower().endswith((".exe", ".dll", ".so", ".dylib", ".jar", ".class", ".o", ".whl"))],
                     "Build in CI or attach to a release instead (owner approves).", "B")

    def terms(self):
        live = self.live()
        if self.on("T1"):
            rules = [r for r in as_list(self.C, "forbidden_terms") if "=>" in r]
            gloss = Globs(as_list(self.C, "glossary") + as_list(self.C, "allow_terms") + [self.a.config])
            for r in rules:
                bad, good = [s.strip() for s in r.split("=>", 1)]
                rx = re.compile(r"(?<![\w-])" + re.escape(bad) + r"(?![\w-])", re.I)
                hits, paths = [], set()
                for p in live:
                    if gloss(p):
                        continue
                    if rx.search(os.path.basename(p)):
                        hits.append("%s (file name)" % p); paths.add(p)
                    t = self.read(p)
                    if t:
                        for n, line in enumerate(t.splitlines(), 1):
                            if rx.search(line):
                                hits.append("%s:%d" % (p, n)); paths.add(p)
                self.add("T1", "Medium", 'Term "%s" used instead of "%s" (%d places)' % (bad, good, len(hits)), list(paths),
                         'Replace with "%s" (context-maintainer owns the glossary; this is a text edit elsewhere).' % good, "B", hits)
            if not rules:
                self.nc("T1 forbidden terms: none declared (auditor still reads the glossary if present)")
        if self.on("T2"):
            words, hy = [], collections.Counter()
            for p in live:
                if p.lower().endswith(".md"):
                    t = re.sub(r"`[^`]*`", " ", strip_code(self.read(p) or "")).lower()
                    t = re.sub(r"https?://\S+", " ", t)
                    words += re.findall(r"[a-z]+", t)
                    hy.update(re.findall(r"\b[a-z]{3,}-[a-z]{3,}\b", t))
            wc, bg = collections.Counter(words), collections.Counter(zip(words, words[1:]))
            out = []
            for h, n in hy.items():
                a, b = h.split("-")
                forms = {"hyphen": n, "joined": wc.get(a + b, 0), "spaced": bg.get((a, b), 0)}
                if sum(1 for v in forms.values() if v >= 2) >= 2:
                    out.append("%s: %s" % (h, ", ".join("%s x%d" % kv for kv in forms.items() if kv[1])))
            self.add("T2", "Low", "Same term written in different forms", [], "Pick one form, record it in the glossary.", "B",
                     sorted(out)[:10], scope="global")

    def notchecked_static(self):
        judged = {"H3": "one canonical doc per topic", "L4": "owner/review date", "X1": "newcomer test"}
        if self.a.mode != "quick":
            for k, v in judged.items():
                self.nc("%s %s: needs the auditor (read and judge)" % (k, v))
        checks = as_list(self.C, "checks")
        self.nc("X3/X4 test command and declared checks: run by the agent%s" % (" -> " + "; ".join(checks) if checks else " (none declared)"))
        if self.a.mode == "quick":
            self.nc("checks outside the quick set were skipped (run --mode audit)")

    def run(self):
        self.naming(); self.structure(); self.junk(); self.docs(); self.readme()
        self.generated(); self.config(); self.hygiene(); self.terms(); self.notchecked_static()
        self.findings.sort(key=lambda f: (-SEV.index(f["severity"]), f["id"]))


def render(au, base):
    a = au.a
    counts = collections.Counter(f["severity"] for f in au.findings)
    tools = [t for t in ("lychee", "gitleaks", "git-sizer", "vulture", "deptry", "cargo-machete", "ast-grep", "rg")
             if shutil.which(t)] + [t for t in ("knip",) if os.path.exists(os.path.join(au.root, "node_modules/.bin/knip"))]
    keys = {"%s::%s" % (f["id"], p) for f in au.findings for p in (f["paths"] or ["(global)"])}
    new = resolved = None
    if base is not None:
        prev = set(base.get("keys", []))
        new, resolved = len(keys - prev), len(prev - keys)
    health = {"critical": counts["Critical"], "high": counts["High"], "medium": counts["Medium"], "low": counts["Low"],
              "info": counts["Info"], "not_checked": len(au.not_checked)}
    if a.json:
        print(json.dumps(dict(repo=au.name, commit=au.sha, mode=a.mode, date=str(datetime.date.today()),
                              layer="generic + " + a.config if au.cfg is not None else "generic only",
                              health=health, new=new, resolved=resolved, findings=au.findings,
                              not_checked=au.not_checked, tools=tools, keys=sorted(keys)), indent=1))
        return
    print("repo-maintenance %s | %s @ %s | %s" % (a.mode, au.name, au.sha, datetime.date.today()))
    print("layer: %s" % ("generic + " + a.config if au.cfg is not None else "generic only (no %s)" % a.config))
    line = " | ".join("%s %d" % (s, counts[s]) for s in reversed(SEV))
    if new is not None:
        line += "   (new %d, resolved %d since baseline)" % (new, resolved)
    print(line)
    for f in au.findings:
        print("\n[%s] %s  %s  (tier %s%s)" % (f["severity"], f["id"], f["title"], f["tier"], ", protected" if f["protected"] else ""))
        ev = f["evidence"]
        for e in ev[:a.max_evidence]:
            print("    " + e)
        if len(ev) > a.max_evidence:
            print("    ... +%d more" % (len(ev) - a.max_evidence))
        print("    fix: " + f["fix"])
    if au.not_checked:
        print("\nNOT_CHECKED")
        for n in au.not_checked:
            print("  - " + n)
    print("\ntools: " + (", ".join(tools) or "none of the optional tools found"))
    print("HEALTH " + json.dumps(health))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--mode", choices=["quick", "audit", "deep"], default="quick")
    ap.add_argument("--root", default=".")
    ap.add_argument("--config", default=".claude/repo-maintenance.md")
    ap.add_argument("--since", help="only report file-scoped findings touching files changed since this ref")
    ap.add_argument("--baseline", help="a previous --json output; report new/resolved counts")
    ap.add_argument("--json", action="store_true")
    ap.add_argument("--fail-on", choices=SEV, help="exit non-zero if a finding at or above this severity exists")
    ap.add_argument("--fail-code", type=int, default=1, help="exit code used by --fail-on (hooks need 2)")
    ap.add_argument("--max-evidence", type=int, default=6)
    args = ap.parse_args()
    au = Audit(args)
    au.run()
    base = None
    if args.baseline and os.path.isfile(args.baseline):
        try:
            base = json.load(open(args.baseline))
        except ValueError:
            base = None
    render(au, base)
    if args.fail_on and any(SEV.index(f["severity"]) >= SEV.index(args.fail_on) for f in au.findings):
        sys.exit(args.fail_code)


if __name__ == "__main__":
    try:
        main()
    except BrokenPipeError:
        sys.exit(0)
