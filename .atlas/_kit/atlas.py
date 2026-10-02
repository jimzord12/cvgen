#!/usr/bin/env python3
"""Atlas: build, check and screenshot a repository's `.atlas/` folder.

Generic: no repository facts live here. Standard library plus Git on PATH.

  python atlas.py init  [--root R]            create .atlas/ with the kit and a starter site.json
  python atlas.py build [--root R]            validate src/, write atlas.data.js and the HTML pages
  python atlas.py check [--root R] [--strict] list pages whose sources changed since they were verified
  python atlas.py stamp [--root R] PAGE...|--all   record the sources' current hashes: "verified today"
  python atlas.py shots [--root R] [--out DIR] [--pages a,b] [--themes dark,light] [--mobile]
  python atlas.py sync-kit [--root R]         copy this script's kit into .atlas/_kit/

Sources are repo-relative paths, optionally with #anchor or :line. `git:<ref>:<path>` pins a file on
another branch; `http(s)://...` and `ext:<note>` are accepted but not hashed.
"""
import argparse, datetime, hashlib, json, os, re, shutil, subprocess, sys, tempfile

KIT_VERSION = "1.0"
KINDS = ["owner", "client", "lead", "agent", "external", "skill", "tool", "service"]
PAGE_KINDS = ["flow", "system", "roster"]
GATES = ["owner", "review", "check", "client"]
STATES = ["built", "planned", "manual"]
EDGE_TYPES = ["calls", "data", "writes"]
MARK = "<!-- atlas:generated -->"

HERE = os.path.dirname(os.path.abspath(__file__))


def die(msg):
    sys.exit("atlas: " + msg)


def git(root, *args, inp=None):
    try:
        r = subprocess.run(["git", "-C", root] + list(args), input=inp, capture_output=True, text=True)
    except FileNotFoundError:
        return None
    return r.stdout.strip() if r.returncode == 0 else None


def find_root(arg):
    if arg:
        return os.path.abspath(arg)
    d = os.getcwd()
    while True:
        if os.path.isdir(os.path.join(d, ".atlas")):
            return d
        p = os.path.dirname(d)
        if p == d:
            break
        d = p
    top = git(os.getcwd(), "rev-parse", "--show-toplevel")
    return os.path.abspath(top) if top else os.getcwd()


def kit_source():
    """The kit beside this script: <skill>/kit or, when vendored, this folder."""
    for d in (os.path.join(os.path.dirname(HERE), "kit"), HERE):
        if os.path.isfile(os.path.join(d, "atlas.js")) and os.path.isfile(os.path.join(d, "atlas.css")):
            return d
    die("cannot find atlas.js and atlas.css beside " + HERE)


def load_json(path):
    try:
        with open(path, encoding="utf-8") as f:
            return json.load(f)
    except json.JSONDecodeError as e:
        die("%s: invalid JSON at line %d col %d: %s" % (path, e.lineno, e.colno, e.msg))


def now_utc():
    return datetime.datetime.now(datetime.timezone.utc)


# ---------------------------------------------------------------- sources & hashes
def clean_src(s):
    if s.startswith(("http://", "https://", "ext:")):
        return None
    if s.startswith("git:"):
        return re.sub(r":\d+(-\d+)?$", "", s.split("#")[0])
    return re.sub(r":\d+(-\d+)?$", "", s.split("#")[0]).strip("/")


def src_hash(root, s, cache):
    key = clean_src(s)
    if key is None:
        return None, None
    if key in cache:
        return key, cache[key]
    h = None
    if key.startswith("git:"):
        _, ref, path = key.split(":", 2)
        h = git(root, "rev-parse", "--verify", "--quiet", "%s:%s" % (ref, path))
    else:
        p = os.path.join(root, key)
        if os.path.isfile(p):
            h = git(root, "hash-object", "--", key)
            if not h:
                with open(p, "rb") as f:
                    h = hashlib.sha1(f.read()).hexdigest()
        elif os.path.isdir(p):
            # a folder source vouches for what the folder holds, not every byte below it:
            # hash only its direct children (tracked files and subfolders), so ordinary
            # commits inside it do not mark the page stale
            listing = git(p, "ls-files")  # relative to the folder: any spelling of it works
            if listing is None:
                names = sorted(n for n in os.listdir(p) if not n.startswith("."))
            else:  # git quotes unusual names; the quoted form is still stable
                names = sorted({l.strip('"').split("/")[0] for l in listing.splitlines()})
            h = "dir1:" + hashlib.sha1("\n".join(names).encode()).hexdigest()
    cache[key] = h
    return key, h


def page_sources(page, site):
    out = []

    def take(lst):
        for s in lst or []:
            if s not in out:
                out.append(s)
    take(page.get("sources"))
    for ph in page.get("phases", []):
        for st in ph.get("steps", []):
            take(st.get("sources"))
    for g in page.get("groups", []):
        take(g.get("sources"))
        for n in g.get("nodes", []):
            take(n.get("sources"))
            if not n.get("sources") and n.get("path") and not re.search(r"[<*{]", n["path"]):
                take([n["path"]])
    if page.get("kind") == "roster":
        for a in site.get("actors", {}).values():
            take(a.get("sources"))
    return out


# ---------------------------------------------------------------- loading & validation
def load_atlas(root):
    at = os.path.join(root, ".atlas")
    src = os.path.join(at, "src")
    if not os.path.isfile(os.path.join(src, "site.json")):
        die("no %s; run `atlas.py init` first" % os.path.join(src, "site.json"))
    site = load_json(os.path.join(src, "site.json"))
    pdir = os.path.join(src, "pages")
    found = {}
    for fn in sorted(os.listdir(pdir)) if os.path.isdir(pdir) else []:
        if fn.endswith(".json"):
            p = load_json(os.path.join(pdir, fn))
            p.setdefault("id", fn[:-5])
            if p["id"] != fn[:-5]:
                die("%s: id %r must match the file name" % (fn, p["id"]))
            found[p["id"]] = p
    order = [i for i in site.get("pages", []) if i in found] + [i for i in found if i not in site.get("pages", [])]
    return at, site, [found[i] for i in order]


def validate(root, site, pages):
    errs, warns = [], []
    E = errs.append
    if not site.get("repo"):
        E("site.json: `repo` is required")
    actors = site.get("actors", {})
    for aid, a in actors.items():
        if not a.get("label"):
            E("actor %s: `label` is required" % aid)
        if a.get("kind") not in KINDS:
            E("actor %s: kind %r is not one of %s" % (aid, a.get("kind"), KINDS))
    for i in site.get("pages", []):
        if i not in [p["id"] for p in pages]:
            E("site.json pages lists %r but src/pages/%s.json does not exist" % (i, i))
    ids = {}
    for p in pages:
        pid = p["id"]
        if p.get("kind") not in PAGE_KINDS:
            E("%s: kind %r is not one of %s" % (pid, p.get("kind"), PAGE_KINDS))
        if not p.get("title"):
            E("%s: `title` is required" % pid)
        items = {}
        if p.get("kind") == "flow":
            if not p.get("phases"):
                E("%s: a flow needs phases" % pid)
            for ph in p.get("phases", []):
                if not ph.get("steps"):
                    E("%s: phase %r has no steps" % (pid, ph.get("title")))
                for s in ph.get("steps", []):
                    sid = s.get("id")
                    if not sid or sid in items:
                        E("%s: step id %r missing or duplicated" % (pid, sid))
                    items[sid] = s
            for s in items.values():
                where = "%s step %s" % (pid, s.get("id"))
                if not s.get("title"):
                    E(where + ": `title` is required")
                if s.get("actor") not in actors:
                    E(where + ": actor %r is not in site.actors" % s.get("actor"))
                for k in ("with", "uses"):
                    for a in s.get(k, []):
                        if a not in actors:
                            E(where + ": %s %r is not in site.actors" % (k, a))
                if s.get("loop") and s["loop"].get("to") not in items:
                    E(where + ": loop.to %r is not a step" % s["loop"].get("to"))
                for b in s.get("branch", []):
                    if b.get("to") not in items:
                        E(where + ": branch.to %r is not a step" % b.get("to"))
                for n in ([s["next"]] if isinstance(s.get("next"), str) else s.get("next", [])):
                    if n not in items:
                        E(where + ": next %r is not a step" % n)
                if s.get("gate") and s["gate"].get("type", "owner") not in GATES:
                    E(where + ": gate.type must be one of %s" % GATES)
                if s.get("state", "built") not in STATES:
                    E(where + ": state must be one of %s" % STATES)
                if not s.get("sources"):
                    E(where + ": every step needs at least one source (the truth rule)")
        elif p.get("kind") == "system":
            for g in p.get("groups", []):
                if not g.get("id") or g["id"] in items:
                    E("%s: group id %r missing or duplicated" % (pid, g.get("id")))
                items[g.get("id")] = g
                if g.get("kind", "tool") not in KINDS:
                    E("%s group %s: kind must be one of %s" % (pid, g.get("id"), KINDS))
                for n in g.get("nodes", []):
                    if not n.get("id") or n["id"] in items:
                        E("%s: node id %r missing or duplicated" % (pid, n.get("id")))
                    items[n.get("id")] = n
                    if n.get("actor") and n["actor"] not in actors:
                        E("%s node %s: actor %r is not in site.actors" % (pid, n.get("id"), n["actor"]))
            for e in p.get("edges", []):
                for end in ("from", "to"):
                    if e.get(end) not in items:
                        E("%s: edge %s %r is not a group or node" % (pid, end, e.get(end)))
                if e.get("type", "calls") not in EDGE_TYPES:
                    E("%s: edge type must be one of %s" % (pid, EDGE_TYPES))
        st = p.get("status")
        if st:
            if st.get("step") and st["step"] not in items:
                E("%s: status.step %r is not a step or node" % (pid, st["step"]))
            for w in st.get("waitingOn", []):
                if w not in actors:
                    E("%s: status.waitingOn %r is not in site.actors" % (pid, w))
            if not st.get("asOf") and not site.get("snapshot", {}).get("asOf"):
                warns.append("%s: status has no asOf date" % pid)
        ids[pid] = items
    # [[links]] anywhere
    def walk(o, where):
        if isinstance(o, str):
            for m in re.finditer(r"\[\[([^\]|]+)(?:\|[^\]]+)?\]\]", o):
                tgt = m.group(1)
                if tgt.startswith("actor:"):
                    if tgt[6:] not in actors:
                        E("%s: link [[%s]] names no actor" % (where, tgt))
                    continue
                pg, _, it = tgt.partition("#")
                if pg and pg not in ids and pg != "index":
                    E("%s: link [[%s]] names no page" % (where, tgt))
                elif it and pg in ids and it not in ids[pg]:
                    E("%s: link [[%s]] names no step or node" % (where, tgt))
        elif isinstance(o, dict):
            for k, v in o.items():
                walk(v, where)
        elif isinstance(o, list):
            for v in o:
                walk(v, where)
    walk(site, "site.json")
    for p in pages:
        walk(p, p["id"])
    # sources exist
    cache = {}
    for p in pages + [{"id": "site", "sources": site.get("sources", [])}]:
        for s in page_sources(p, site) if p["id"] != "site" else p["sources"]:
            key, hsh = src_hash(root, s, cache)
            if key is not None and hsh is None:
                E("%s: source %r does not exist" % (p["id"], s))
    return errs, warns


# ---------------------------------------------------------------- lock & staleness
def lock_path(at):
    return os.path.join(at, "atlas.lock.json")


def read_lock(at):
    p = lock_path(at)
    return load_json(p) if os.path.isfile(p) else {"pages": {}}


def staleness(root, site, pages, lock):
    cache, stale, verified = {}, {}, {}
    for p in pages:
        ent = lock.get("pages", {}).get(p["id"])
        if not ent:
            continue
        verified[p["id"]] = {"at": ent.get("verifiedAt"), "commit": ent.get("commit")}
        changed = []
        for s in page_sources(p, site):
            key, hsh = src_hash(root, s, cache)
            if key is None:
                continue
            if ent.get("sources", {}).get(key) != hsh and key not in changed:
                changed.append(key)
        if changed:
            stale[p["id"]] = changed
    return stale, verified


# ---------------------------------------------------------------- commands
SHELL = """<!doctype html>
%(mark)s
<html lang="%(lang)s" data-theme="auto">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="color-scheme" content="dark light">
<title>%(title)s</title>
<link rel="stylesheet" href="_kit/atlas.css">
<script>try{var t=(location.hash.match(/theme=(\\w+)/)||[])[1]||localStorage.getItem('atlas-theme');if(t)document.documentElement.setAttribute('data-theme',t)}catch(e){}</script>
</head>
<body data-page="%(id)s">
<noscript><p style="padding:24px;font:16px system-ui">The atlas needs JavaScript. The facts behind this page are in <code>.atlas/src/</code>.</p></noscript>
<script src="atlas.data.js"></script>
<script src="_kit/atlas.js"></script>
</body>
</html>
"""


def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def cmd_build(root, quiet=False):
    at, site, pages = load_atlas(root)
    errs, warns = validate(root, site, pages)
    for w in warns:
        print("warning: " + w)
    if errs:
        for e in errs:
            print("error: " + e)
        die("%d error(s); nothing written" % len(errs))
    lock = read_lock(at)
    stale, verified = staleness(root, site, pages, lock)
    head = git(root, "rev-parse", "--short", "HEAD")
    data = {"site": site, "pages": pages, "build": {
        "builtAt": now_utc().strftime("%Y-%m-%d %H:%M UTC"), "commit": head, "kit": KIT_VERSION,
        "stale": stale, "verified": verified}}
    js = "/* generated by atlas.py build: edit .atlas/src/, not this file */\nwindow.ATLAS = " + \
        json.dumps(data, ensure_ascii=False, indent=1) + ";\n"
    with open(os.path.join(at, "atlas.data.js"), "w", encoding="utf-8", newline="\n") as f:
        f.write(js)
    want = {"index.html": ("index", site.get("title") or site["repo"] + " Atlas")}
    for p in pages:
        want[p["id"] + ".html"] = (p["id"], re.sub(r"[`*]", "", p["title"]) + " · " + site["repo"] + " Atlas")
    for fn in os.listdir(at):
        if fn.endswith(".html") and fn not in want:
            with open(os.path.join(at, fn), encoding="utf-8") as f:
                if MARK in f.read(400):
                    os.remove(os.path.join(at, fn))
    for fn, (pid, title) in want.items():
        with open(os.path.join(at, fn), "w", encoding="utf-8", newline="\n") as f:
            f.write(SHELL % {"mark": MARK, "lang": site.get("lang", "en"), "title": esc(title), "id": pid})
    if not quiet:
        print("built %d page(s) + index into %s" % (len(pages), at))
        for pid, ch in stale.items():
            print("stale: %s (%d source(s) changed: %s)" % (pid, len(ch), ", ".join(ch[:5])))
        unver = [p["id"] for p in pages if p["id"] not in verified]
        if unver:
            print("not yet verified (run stamp after checking them): " + ", ".join(unver))
    return at, site, pages, stale


def cmd_check(root, strict):
    at, site, pages = load_atlas(root)
    errs, _ = validate(root, site, pages)
    stale, verified = staleness(root, site, pages, read_lock(at))
    for e in errs:
        print("error: " + e)
    for p in pages:
        pid = p["id"]
        if pid in stale:
            print("STALE   %-20s %s" % (pid, ", ".join(stale[pid])))
        elif pid not in verified:
            print("UNVERIFIED %-17s never stamped" % pid)
        else:
            print("ok      %-20s verified %s" % (pid, verified[pid]["at"]))
    snap = site.get("snapshot", {}).get("asOf")
    if snap:
        print("snapshot as of %s" % snap)
    if strict and (errs or stale):
        sys.exit(1)


def cmd_stamp(root, ids, all_):
    at, site, pages = load_atlas(root)
    errs, _ = validate(root, site, pages)
    if errs:
        for e in errs:
            print("error: " + e)
        die("fix the errors before stamping")
    lock = read_lock(at)
    targets = [p for p in pages if all_ or p["id"] in ids]
    if not targets:
        die("name the pages to stamp, or --all")
    cache, head = {}, git(root, "rev-parse", "--short", "HEAD")
    for p in targets:
        srcs = {}
        for s in page_sources(p, site):
            key, hsh = src_hash(root, s, cache)
            if key is not None:
                srcs[key] = hsh
        lock.setdefault("pages", {})[p["id"]] = {"verifiedAt": now_utc().strftime("%Y-%m-%d"), "commit": head, "sources": srcs}
        print("stamped %s (%d sources)" % (p["id"], len(srcs)))
    with open(lock_path(at), "w", encoding="utf-8", newline="\n") as f:
        json.dump(lock, f, indent=1, sort_keys=True)
        f.write("\n")
    cmd_build(root, quiet=True)


def copy_kit(at):
    kd = os.path.join(at, "_kit")
    os.makedirs(kd, exist_ok=True)
    src = kit_source()
    for fn in ("atlas.css", "atlas.js"):
        shutil.copyfile(os.path.join(src, fn), os.path.join(kd, fn))
    me = os.path.abspath(__file__)
    if os.path.abspath(os.path.join(kd, "atlas.py")) != me:
        shutil.copyfile(me, os.path.join(kd, "atlas.py"))
    print("kit %s copied into %s" % (KIT_VERSION, kd))


STARTER_SITE = {
    "repo": "REPO",
    "title": "How REPO works",
    "tagline": "One sentence on what this repository makes and for whom.",
    "lang": "en",
    "sourceBase": "../",
    "snapshot": {"asOf": "YYYY-MM-DD", "note": "Where things stand; derived from the sources, never remembered."},
    "pages": [],
    "actors": {
        "owner": {"label": "You", "kind": "owner", "role": "Decides and approves."},
        "lead": {"label": "Lead agent", "kind": "lead", "role": "Plans, builds and integrates."}
    },
    "terms": {},
    "moves": []
}

README = """# .atlas: how this repository works, as pictures

Open `index.html` in a browser (no server needed). Each page answers one question: a **flow** ("I just got X,
what happens?"), a **map** of the system's parts, or the **roster** of who and what does the work.

- Facts live in `src/` (`site.json`, `pages/<id>.json`). Never edit `atlas.data.js` or the `.html` files:
  `python .atlas/_kit/atlas.py build` writes them.
- Every step names its sources. `atlas.lock.json` remembers each source's hash when a page was last checked;
  `python .atlas/_kit/atlas.py check` lists pages whose sources changed since (they show an amber banner).
- After checking a page against its sources, `python .atlas/_kit/atlas.py stamp <page>` marks it verified.
- The kit (`_kit/`) is shared by every atlas; the protocol lives with the owner's personal `atlas` skill,
  outside this repository. `atlas.py` here is enough to build, check and stamp.
"""


def cmd_init(root):
    at = os.path.join(root, ".atlas")
    os.makedirs(os.path.join(at, "src", "pages"), exist_ok=True)
    sp = os.path.join(at, "src", "site.json")
    if not os.path.exists(sp):
        s = dict(STARTER_SITE)
        name = os.path.basename(root)
        s["repo"], s["title"] = name, "How %s works" % name
        with open(sp, "w", encoding="utf-8", newline="\n") as f:
            json.dump(s, f, indent=2, ensure_ascii=False)
            f.write("\n")
    rp = os.path.join(at, "README.md")
    if not os.path.exists(rp):
        with open(rp, "w", encoding="utf-8", newline="\n") as f:
            f.write(README)
    copy_kit(at)
    print("initialised %s; add pages under src/pages/, then build" % at)


def find_browser():
    env = os.environ.get("ATLAS_BROWSER")
    cands = [env] if env else []
    cands += [r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", r"C:\Program Files\Microsoft\Edge\Application\msedge.exe",
              r"C:\Program Files\Google\Chrome\Application\chrome.exe",
              "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome", "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"]
    for c in cands:
        if c and os.path.isfile(c):
            return c
    for n in ("google-chrome", "chromium", "chromium-browser", "microsoft-edge", "msedge", "chrome"):
        p = shutil.which(n)
        if p:
            return p
    die("no Chromium browser found; set ATLAS_BROWSER")


def file_url(path, frag):
    p = os.path.abspath(path).replace("\\", "/")
    return ("file:///" + p.lstrip("/")) + ("#" + frag if frag else "")


def cmd_shots(root, out, only, themes, mobile, height):
    at, site, pages, _ = cmd_build(root, quiet=True)
    br = find_browser()
    out = os.path.abspath(out or os.path.join(tempfile.gettempdir(), "atlas-shots-" + now_utc().strftime("%Y%m%d-%H%M%S")))
    if os.path.exists(out) and os.listdir(out):
        die("%s exists and is not empty; shots never overwrite" % out)
    os.makedirs(out, exist_ok=True)
    plan = [("index", "index.html", "", "home")]
    for p in pages:
        f = p["id"] + ".html"
        if p["kind"] == "flow":
            steps = [s for ph in p["phases"] for s in ph["steps"]]
            pick = (p.get("status") or {}).get("step") or steps[0]["id"]
            plan += [(p["id"], f, "", "map"), (p["id"], f, "view=story", "story"),
                     (p["id"], f, "view=map&focus=%s&open=1" % pick, "drawer")]
        elif p["kind"] == "system":
            deg = {}
            for e in p.get("edges", []):
                for end in (e["from"], e["to"]):
                    deg[end] = deg.get(end, 0) + 1
            nodes = [n["id"] for g in p["groups"] for n in g.get("nodes", [])]
            busiest = max(nodes, key=lambda n: deg.get(n, 0)) if nodes else None
            plan += [(p["id"], f, "", "map")] + ([(p["id"], f, "focus=%s&open=1" % busiest, "drawer")] if busiest else [])
        else:
            plan += [(p["id"], f, "", "cards"), (p["id"], f, "tab=matrix", "matrix")]
    # Chromium will not render a window narrower than about 500 px on Windows
    sizes = [(1600, height)] + ([(500, max(height, 2400))] if mobile else [])
    n = 0
    for pid, f, frag, label in plan:
        if only and pid not in only:
            continue
        for th in themes:
            for (w, hgt) in sizes:
                if w < 600 and label == "drawer":
                    continue
                fr = "&".join(x for x in (frag, "theme=" + th) if x)
                png = os.path.join(out, "%s__%s__%s__%d.png" % (pid, label, th, w))
                subprocess.run([br, "--headless=new", "--disable-gpu", "--hide-scrollbars", "--force-device-scale-factor=1",
                                "--window-size=%d,%d" % (w, hgt), "--virtual-time-budget=9000",
                                "--screenshot=" + png, file_url(os.path.join(at, f), fr)], capture_output=True, timeout=120)
                if os.path.isfile(png):
                    n += 1
                else:
                    print("failed: " + png)
    print("%d screenshot(s) in %s" % (n, out))


def main():
    ap = argparse.ArgumentParser(description="Atlas: build, check and screenshot .atlas/")
    ap.add_argument("cmd", choices=["init", "build", "check", "stamp", "shots", "sync-kit"])
    ap.add_argument("pages", nargs="*")
    ap.add_argument("--root")
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--strict", action="store_true")
    ap.add_argument("--out")
    ap.add_argument("--themes", default="dark,light")
    ap.add_argument("--mobile", action="store_true")
    ap.add_argument("--height", type=int, default=1300)
    a = ap.parse_args()
    root = find_root(a.root)
    if a.cmd == "init":
        cmd_init(root)
    elif a.cmd == "build":
        cmd_build(root)
    elif a.cmd == "check":
        cmd_check(root, a.strict)
    elif a.cmd == "stamp":
        cmd_stamp(root, a.pages, a.all)
    elif a.cmd == "shots":
        cmd_shots(root, a.out, set(a.pages), a.themes.split(","), a.mobile, a.height)
    elif a.cmd == "sync-kit":
        copy_kit(os.path.join(root, ".atlas"))


if __name__ == "__main__":
    main()
