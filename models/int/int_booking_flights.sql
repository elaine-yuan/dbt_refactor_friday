select
    booking_id,
    flatten.value::varchar as flight_id,
    booking_price,
    frequent_flyer_id
from {{ ref('stg_bookings') }},
lateral flatten(
    input => try_parse_json(flight_ids)
) as flatten