import json
import sys


def get(content: str, variant: str, theme: str) -> str:
    config: dict = json.loads(content)

    variant_name = f"Catppuccin {variant.capitalize()}"

    themes = [
        {
            **item,
            "name": theme,
        }
        for item in config.pop("themes")
        if item["name"] == variant_name
    ]

    return json.dumps(
        {
            "themes": themes,
            **config,
        },
        sort_keys=True,
        indent=2,
    )


if __name__ == "__main__":
    file_path = sys.argv[1]
    variant = sys.argv[2]
    theme = sys.argv[3]

    with open(file_path) as f:
        print(get(f.read(), variant, theme))
