// The tests' folder removal refuses anything outside the system temp folder.
// The refusals are tested on the pure check, so a broken guard fails a test
// instead of deleting a real folder.
import { expect, test } from "bun:test";
import { existsSync, mkdtempSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { isInsideTmp, removeTmp } from "./tmp";

test("isInsideTmp refuses an empty, relative, outside or temp-root path", () => {
  expect(isInsideTmp("")).toBe(false);
  expect(isInsideTmp(".")).toBe(false);
  expect(isInsideTmp(join(import.meta.dirname, ".."))).toBe(false);
  expect(isInsideTmp(tmpdir())).toBe(false);
  expect(isInsideTmp(join(tmpdir(), "x", "..", ".."))).toBe(false);
  expect(isInsideTmp(join(tmpdir(), "workflow-tmp-x"))).toBe(true);
});

test("removeTmp removes a temporary folder", () => {
  const dir = mkdtempSync(join(tmpdir(), "workflow-tmp-"));
  removeTmp(dir);
  expect(existsSync(dir)).toBe(false);
});
