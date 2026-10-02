# .atlas: how this repository works, as pictures

Open `index.html` in a browser (no server needed). Each page answers one question: a **flow** ("I just got X,
what happens?"), a **map** of the system's parts, or the **roster** of who and what does the work.

- Facts live in `src/` (`site.json`, `pages/<id>.json`). Never edit `atlas.data.js` or the `.html` files:
  `python .atlas/_kit/atlas.py build` writes them.
- Every step names its sources. `atlas.lock.json` remembers each source's hash when a page was last checked;
  `python .atlas/_kit/atlas.py check` lists pages whose sources changed since (they show an amber banner).
- After checking a page against its sources, `python .atlas/_kit/atlas.py stamp <page>` marks it verified.
- The kit (`_kit/`) is shared by every atlas; the protocol lives with the owner's personal `atlas` skill,
  outside this repository. `atlas.py` here is enough to build, check and stamp.
