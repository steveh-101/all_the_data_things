import re
import argparse
import hashlib


def main(raw_branch: str, prefixes=["SNOW-", "DU-", "FDU-", "DS-"]) -> None:
    """
    turn raw branch name into branch suffix to be used in Snowflake
    :param raw_branch: raw branch name
    :param prefixes: feature branch prefixes to look for
    :return: if the regex matches, returns a ranch suffix like SNOW-1234
             else, return first 16 characters of the mds hash of the raw branch
    """
    upper_branch = raw_branch.upper()
    if upper_branch.startswith(tuple(prefixes)):
        parts = upper_branch.split("-")
        result = re.findall("({}-\d+)".format(parts[0]), upper_branch)
        prefix = result[0].replace("-", "_")
        print(prefix)
    else:
        hash = hashlib.md5(raw_branch.encode()).hexdigest()[:16]
        print(hash)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--branch")
    command_line_args = parser.parse_args()
    if not command_line_args.branch:
        raise Exception
    main(command_line_args.branch)
