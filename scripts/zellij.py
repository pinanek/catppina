import re
import sys


THEME_NAMES = {
    "latte": "catppina_light",
    "mocha": "catppina_dark",
}


def get(content: str) -> str:
    lines = content.splitlines()
    themes: dict[str, list[str]] = {}
    index = 0

    while index < len(lines):
        match = re.fullmatch(r"  catppuccin-(latte|mocha) \{", lines[index])
        if not match:
            index += 1
            continue

        flavor = match.group(1)
        theme = [f"  {THEME_NAMES[flavor]} {{"]
        depth = 1
        index += 1

        while index < len(lines) and depth:
            line = lines[index]
            depth += line.count("{") - line.count("}")
            theme.append(line)
            index += 1

        if depth:
            raise ValueError(f"Unclosed {flavor} theme block")

        themes[flavor] = theme

    missing_flavors = [flavor for flavor in THEME_NAMES if flavor not in themes]
    if missing_flavors:
        raise ValueError(f"Missing theme block(s): {', '.join(missing_flavors)}")

    return "themes {\n" + "\n\n".join(
        "\n".join(themes[flavor]) for flavor in THEME_NAMES
    ) + "\n}\n"


if __name__ == "__main__":
    file_path = sys.argv[1]

    with open(file_path) as f:
        print(get(f.read()), end="")
