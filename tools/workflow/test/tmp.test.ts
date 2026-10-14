// The tests' folder removal refuses anything outside the system temp folder.
import { expect, test } from "bun:test";
import { existsSync, mkdtempSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { removeTmp } from "./tmp";

test("removeTmp refuses an empty, relative or outside path and removes a temporary folder", () => {
  expect(() => removeTmp("")).toThrow("refusing to remove");
  expect(() => removeTmp(".")).toThrow("refusing to remove");
  expect(() => removeTmp(join(import.meta.dirname, ".."))).toThrow("refusing to remove");
  expect(() => removeTmp(tmpdir())).toThrow("refusing to remove");
  const dir = mkdtempSync(join(tmpdir(), "workflow-tmp-"));
  removeTmp(dir);
  expect(existsSync(dir)).toBe(false);
});
