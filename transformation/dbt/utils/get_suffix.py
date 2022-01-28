import argparse


def main(branch_name: str) -> None:
    """
    turn raw branch name into a branch that can also be a databsae name
    :param branch_name: raw branch name
    :return: database friendly name
    """
    upper_branch = branch_name.upper()
    return (upper_branch.replace("-", "_"))


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--branch")
    command_line_args = parser.parse_args()
    if not command_line_args.branch:
        raise Exception
    main(command_line_args.branch)
