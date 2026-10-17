import { readFile } from "node:fs/promises";

const [filePath, variant] = process.argv.slice(2);
const config = JSON.parse(await readFile(filePath, "utf8"));
const variantName = `Catppuccin ${variant[0].toUpperCase()}${variant.slice(1)}`;

config.themes = config.themes
  .filter((item) => item.name === variantName)
  .map((item) => ({ ...item, name: `${variantName} (Catppina)` }));

console.log(JSON.stringify(config, (_key, value) => {
  if (value && typeof value === "object" && !Array.isArray(value)) {
    return Object.fromEntries(
      Object.entries(value).sort(([a], [b]) => a < b ? -1 : a > b ? 1 : 0),
    );
  }

  return value;
}, 2));
