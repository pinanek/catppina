import re
import sys


def get(content: str) -> str:
    mocha_re = re.compile(
        r"[\n\s\S]*^.+catppuccin-mocha (\{[\n\s\S]*?\})",
        re.MULTILINE,
    )

    match_result = mocha_re.match(content)
    if match_result:
        return "themes {\n catppina " + match_result.group(1) + "\n}"


if __name__ == "__main__":
    with open(sys.argv[1], "r") as f:
        print(get(f.read()))
