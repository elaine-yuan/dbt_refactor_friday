select
    customer_id::varchar as customer_id,
    frequent_flyer_id::varchar as frequent_flyer_id,
    customer_name::varchar as customer_name
from {{ ref('customers') }}