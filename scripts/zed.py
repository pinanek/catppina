import json
import sys


def get(content: str) -> str:
    config: dict = json.loads(content)

    themes = config.pop("themes")

    new_theme = {}
    for theme in themes:
        if theme["name"] == "Catppuccin Mocha":
            new_theme = theme
            new_theme["name"] = "Catppuccin Mocha (Catppinna)"

    only_mocha_themes = [theme for theme in themes if "Catppuccin Mocha" in theme["name"]]

    new_config = { "themes": only_mocha_themes, **config }

    return json.dumps(new_config, sort_keys=True, indent=2)


if __name__ == "__main__":
    with open(sys.argv[1], "r") as f:
        print(get(f.read()))
