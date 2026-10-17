import { readFile } from "node:fs/promises";

const themeNames = {
  latte: "catppina_light",
  mocha: "catppina_dark",
};
const [filePath] = process.argv.slice(2);
const lines = (await readFile(filePath, "utf8")).split(/\r?\n/);
const themes = {};
let index = 0;

while (index < lines.length) {
  const match = /^  catppuccin-(latte|mocha) \{$/.exec(lines[index]);
  if (!match) {
    index += 1;
    continue;
  }

  const flavor = match[1];
  const theme = [`  ${themeNames[flavor]} {`];
  let depth = 1;
  index += 1;

  while (index < lines.length && depth) {
    const line = lines[index];
    depth += (line.match(/\{/g) ?? []).length - (line.match(/\}/g) ?? []).length;
    theme.push(line);
    index += 1;
  }

  if (depth) {
    throw new Error(`Unclosed ${flavor} theme block`);
  }

  themes[flavor] = theme;
}

const missingFlavors = Object.keys(themeNames).filter((flavor) => !themes[flavor]);
if (missingFlavors.length) {
  throw new Error(`Missing theme block(s): ${missingFlavors.join(", ")}`);
}

process.stdout.write(
  "themes {\n" + Object.keys(themeNames).map((flavor) => themes[flavor].join("\n"))
    .join("\n\n") + "\n}\n",
);
