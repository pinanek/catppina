import { mkdir, readFile, writeFile } from "node:fs/promises";
import { compile } from "@catppuccin/vscode";

const root = new URL("../", import.meta.url);
const colors = JSON.parse(
  await readFile(new URL("colors.json", root), "utf8"),
);
const output = new URL("dist/vscode/", root);

await mkdir(output, { recursive: true });

for (const [flavor, variant] of [["latte", "light"], ["mocha", "dark"]]) {
  const theme = compile(flavor, {
    accentColor: "blue",
    colorOverrides: colors,
  });

  theme.name = `catppina_${variant}`;

  await writeFile(
    new URL(`${theme.name}.json`, output),
    JSON.stringify(theme, null, 2) + "\n",
  );
}
