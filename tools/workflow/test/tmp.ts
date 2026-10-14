// Removing the temporary folders the tests make, safely: an empty or relative
// path would resolve to the working directory (tools/workflow), so only an
// absolute folder inside the system temp folder is removed; anything else throws.
import { rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { isAbsolute, relative, resolve } from "node:path";

export function isInsideTmp(path: string): boolean {
  if (path === "" || !isAbsolute(path)) return false;
  const rel = relative(resolve(tmpdir()), resolve(path));
  return rel !== "" && !rel.startsWith("..") && !isAbsolute(rel);
}

export function removeTmp(path: string): void {
  if (!isInsideTmp(path)) throw new Error(`refusing to remove ${JSON.stringify(path)}: not a folder inside ${tmpdir()}`);
  rmSync(path, { recursive: true, force: true });
}
