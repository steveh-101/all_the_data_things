{% macro drop_database(database) %}

    {% if database != 'ANALYTICS' %}

        {% set sql -%}
            drop database if exists {{ database }} ;
        {%- endset %}

        {{ dbt_utils.log_info("Dropping database " ~ database ~ " database.") }}

        {% do run_query(sql) %}

        {{ dbt_utils.log_info("Dropped database " ~ database ~ " target database.") }}

    {% else %}

        {{ exceptions.raise_compiler_error("Invalid arguments. Missing database... ") }}

    {% endif %}

{% endmacro %}
