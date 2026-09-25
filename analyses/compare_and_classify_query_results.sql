{% set old_query %}
    select *
    from {{ ref('legacy_code') }}
{% endset %}

{% set new_query %}
    select *
    from {{ ref('fct_customer_loyalty') }}
{% endset %}

{{ audit_helper.compare_and_classify_query_results(
    a_query=old_query,
    b_query=new_query,
    primary_key_columns=[
        'frequent_flyer_id',
        'customer_id',
        'loyalty_year'
    ]
) }}