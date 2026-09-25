select
    bf.booking_id,
    bf.flight_id,
    bf.booking_price,
    bf.frequent_flyer_id,
    c.customer_id,
    c.customer_name,
    f.flight_date,
    f.mileage,
    case
        when rank() over (
            partition by bf.booking_id
            order by f.flight_date asc
        ) = 1
        then bf.booking_price
    end as loyalty_spend

from {{ ref('int_booking_flights') }} bf

left join {{ ref('stg_flights') }} f
    on bf.flight_id = f.flight_id

left join {{ ref('stg_customers') }} c
    on bf.frequent_flyer_id = c.frequent_flyer_id