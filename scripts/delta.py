import sys
import re


def get(content: str, theme: str) -> str:
    mocha_re = re.compile(
        r"\[delta \"catppuccin\-mocha\"\](\n.+)*",
        re.MULTILINE,
    )

    match_result = mocha_re.search(content)
    if match_result:
        return re.sub(
            r"catppuccin[- ]mocha", theme, match_result.group(0), flags=re.IGNORECASE
        )

    return ""


if __name__ == "__main__":
    file_path = sys.argv[1]
    theme = sys.argv[2]

    with open(file_path, "r") as f:
        print(get(f.read(), theme))
