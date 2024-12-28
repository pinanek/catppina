import re
import sys


def get(content: str) -> str:
    script_re = re.compile(
        r"[\n\s\S]*<summary>.+Mocha<\/summary>[\n\s\S]+\*\*Fish\*\*:\n```sh(\n([\n\s\S]*?)\n)*?```",
        re.MULTILINE,
    )

    match_result = script_re.match(content)
    if match_result:
        script = match_result.group(2).strip()
        return script.replace("-Ux", "-gx")


if __name__ == "__main__":
    with open(sys.argv[1], "r") as f:
        print(get(f.read()))
