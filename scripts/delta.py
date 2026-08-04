import re
import sys


def get(content: str, variant: str, theme: str) -> str:
    pattern = re.compile(
        rf'\[delta "catppuccin-{re.escape(variant)}"\](\n.+)*',
        re.MULTILINE,
    )

    match_result = pattern.search(content)
    if match_result:
        return re.sub(
            rf"catppuccin[- ]{re.escape(variant)}",
            theme,
            match_result.group(0),
            flags=re.IGNORECASE,
        )

    return ""


if __name__ == "__main__":
    file_path = sys.argv[1]
    variant = sys.argv[2]
    theme = sys.argv[3]

    with open(file_path) as f:
        print(get(f.read(), variant, theme))
