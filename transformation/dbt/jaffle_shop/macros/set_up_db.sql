{% macro set_up_db(db) %}

    {% if db  and db != "ANALYTICS" %}

        {{ create_db(db) }}
        {{ grant_tester_access(db) }}
    {% else %}

        {{ exceptions.raise_compiler_error("Invalid arguments. Missing source db and/or destination db") }}

    {% endif %}

{% endmacro %}


{% macro create_db(db) %}
{% set sql -%}
    create or replace database {{ db }};
{%- endset %}
{{ dbt_utils.log_info("Creating database " ~ db ~ "") }}
{% do run_query(sql) %}
{{ dbt_utils.log_info("Created database " ~ db ~ "") }}
{% endmacro %}

-- TODO: every macro should be in it's own file
{% macro grant_tester_access(db) %}
{% set sql -%}
grant usage on database {{ db }} to role tester;
use role securityadmin;
grant usage on future schemas in database {{ db }} to role tester;
grant select on future tables in database {{ db }} to role tester;
grant select on future views in database {{ db }} to role tester;
{%- endset %}
{{ dbt_utils.log_info("Granting access to role TESTER") }}
{% do run_query(sql) %}
{% endmacro %}



{% macro clone_schema(source, db) %}
{% set sql -%}
    create or replace schema {{ db }}.du_staging clone {{source}}.du_staging;
{%- endset %}
{{ dbt_utils.log_info("Cloning schema " ~ source ~ ".du_staging") }}
{% do run_query(sql) %}
{{ dbt_utils.log_info("Cloned schema " ~ source ~ ".du_staging") }}
{% endmacro %}


{% macro get_schemas() %}
{% set get_schemas_query %}
select
distinct SCHEMA_NAME
from SNOWFLAKE.account_usage.schemata
where CATALOG_NAME ='DU_PROD'
and SCHEMA_NAME not in ('PUBLIC', 'INFORMATION_SCHEMA')
and deleted is null;
{% endset %}
{% set results = run_query(get_schemas_query) %}
{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}
{{ return(results_list) }}
{% endmacro %}


{% macro create_schemas(db, schemas) %}
{{ dbt_utils.log_info("Creating schemas") }}
{% set create_schemas_statement %}
{%- for s in schemas %}
create or replace schema {{ db }}.{{s}};
{% endfor %}
{% endset %}
{% do run_query(create_schemas_statement) %}
{{ dbt_utils.log_info("Created schemas") }}
{% endmacro %}
