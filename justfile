DBT := "uvx --from dbt-core dbt"
SELECTION := "-s state:modified.body+1 --state artifacts --defer --fail-fast --exclude dbt_artifacts test_name:relationships test_name:relationships_where tag:DQ"

# set shell := ["zsh", "-cu"]

default:
    @just --list

# clean:
#     {{ DBT }} clean

# deps:
#     {{ DBT }} deps

# deep-clean: clean deps

# get-manifest:
#     aws s3 cp s3://docs.snowflake.convexin.com/ci_master/manifest.json ./artifacts/manifest.json

# build all changed nodes and their their immediate dependents
# build *extra_args:
#     {{ DBT }} build {{ SELECTION }} {{ extra_args }}

# list all changed nodes and their their immediate dependents
# list:
#     {{ DBT }} list {{ SELECTION }}

# # run all changed nodes and their their immediate dependents
# run *extra_args:
#     {{ DBT }} run  {{ SELECTION }} {{ extra_args }}

# # test all changed nodes and their their immediate dependents
# test *extra_args:
#     {{ DBT }} test {{ SELECTION }} {{ extra_args }}

# # build and serve docs locally
# docs:
#     {{ DBT }} docs generate && {{ DBT }} docs serve

branch := `git rev-parse --abbrev-ref HEAD`

# set the pr_title: example - if branch is abcd-1234-feature-name,
# pr_title will be "ABCD-1234: feature name"
ticket_ref := uppercase(replace_regex(branch, '^([a-z]+)-([0-9]+).*$', '$1-$2'))
ticket_head := replace_regex(branch, '^[a-z]+-[0-9]+-?', '')
pr_title := ticket_ref + ': ' + replace_regex(ticket_head, '-', ' ')

pr pr_template="generic":
    open "https://github.com/steveh-101/all_the_data_things/compare/{{branch}}?quick_pull=1&expand=1&title={{pr_title}}&template={{pr_template}}.md"
