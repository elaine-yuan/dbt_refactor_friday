{% set old_relation = ref('legacy_code') %}
{% set new_relation = ref('fct_customer_loyalty') %}

{{ audit_helper.compare_and_classify_relation_rows(
    a_relation=old_relation,
    b_relation=new_relation,
    primary_key_columns=['frequent_flyer_id', 'customer_id', 'loyalty_year']
) }}