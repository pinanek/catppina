import json
from pathlib import Path


def resolve_path(path: str) -> str:
    root_path = Path(__file__).parent.parent.resolve()
    return str(root_path.joinpath(path))


def get_color_palette() -> dict[str, str]:
    with open(resolve_path("color_overrides.json"), "r") as f:
        color_overrides_content = json.load(f)

    return color_overrides_content["mocha"]


def get_preview_sample() -> str:
    with open(resolve_path("assets/colors/sample.svg"), "r") as f:
        return f.read()


def generate_color_preview(name: str, color: str, preview_sample_content: str) -> None:
    preview_content = preview_sample_content.replace('fill=""', f'fill="{color}"')

    with open(resolve_path(f"assets/colors/{name}.svg"), "w") as f:
        f.write(preview_content)


def main():
    color_palette = get_color_palette()
    preview_sample_content = get_preview_sample()

    for name, color in color_palette.items():
        generate_color_preview(name, color, preview_sample_content)


if __name__ == "__main__":
    main()
