import json
from pathlib import Path

ROOT_PATH = Path(__file__).parent.parent.resolve()
COLORS_PATH = ROOT_PATH / "colors.json"
PREVIEW_SAMPLE_PATH = ROOT_PATH / "assets/colors/sample.svg"
PREVIEW_OUTPUT_PATH = ROOT_PATH / "assets/colors"

VARIANT_NAMES = {
    "latte": "light",
    "mocha": "dark",
}


def get_color_palettes() -> dict[str, dict[str, str]]:
    with COLORS_PATH.open() as f:
        return json.load(f)


def get_preview_sample() -> str:
    return PREVIEW_SAMPLE_PATH.read_text()


def generate_color_preview(
    variant: str,
    name: str,
    color: str,
    preview_sample: str,
) -> None:
    output_dir = PREVIEW_OUTPUT_PATH / VARIANT_NAMES[variant]
    output_dir.mkdir(parents=True, exist_ok=True)

    content = preview_sample.replace('fill=""', f'fill="{color}"')

    (output_dir / f"{name}.svg").write_text(content)


def main() -> None:
    color_palettes = get_color_palettes()
    preview_sample = get_preview_sample()

    for variant, palette in color_palettes.items():
        for name, color in palette.items():
            generate_color_preview(
                variant,
                name,
                color,
                preview_sample,
            )


if __name__ == "__main__":
    main()
