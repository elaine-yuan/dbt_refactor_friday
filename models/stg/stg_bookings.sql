select
    booking_id::varchar as booking_id,
    flight_ids::varchar as flight_ids,
    booking_price::int as booking_price,
    frequent_flyer_id::varchar as frequent_flyer_id
from {{ ref('bookings') }}