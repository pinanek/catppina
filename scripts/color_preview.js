import { mkdir, readFile, writeFile } from "node:fs/promises";

const root = new URL("../", import.meta.url);
const colors = JSON.parse(await readFile(new URL("colors.json", root), "utf8"));
const sample = await readFile(new URL("assets/colors/sample.svg", root), "utf8");
const variantNames = {
  latte: "light",
  mocha: "dark",
};

for (const [variant, palette] of Object.entries(colors)) {
  const output = new URL(`assets/colors/${variantNames[variant]}/`, root);
  await mkdir(output, { recursive: true });

  for (const [name, color] of Object.entries(palette)) {
    await writeFile(
      new URL(`${name}.svg`, output),
      sample.replaceAll('fill=""', `fill="${color}"`),
    );
  }
}
