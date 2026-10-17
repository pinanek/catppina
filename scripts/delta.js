import { readFile } from "node:fs/promises";

const [filePath, variant, theme] = process.argv.slice(2);
const content = await readFile(filePath, "utf8");
const escapedVariant = variant.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
const match = content.match(
  new RegExp(`\\[delta "catppuccin-${escapedVariant}"\\](\\n.+)*`, "m"),
);

const output = match
  ? match[0].replace(
    new RegExp(`catppuccin[- ]${escapedVariant}`, "gi"),
    () => theme,
  )
  : "";

console.log(output);
