// Removing the temporary folders the tests make, safely: an empty or relative
// path would resolve to the working directory (tools/workflow), so only an
// absolute folder inside the system temp folder is removed; anything else throws.
import { rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { isAbsolute, relative, resolve } from "node:path";

export function removeTmp(path: string): void {
  const inside = path !== "" && isAbsolute(path) && (() => {
    const rel = relative(resolve(tmpdir()), resolve(path));
    return rel !== "" && !rel.startsWith("..") && !isAbsolute(rel);
  })();
  if (!inside) throw new Error(`refusing to remove ${JSON.stringify(path)}: not a folder inside ${tmpdir()}`);
  rmSync(path, { recursive: true, force: true });
}
