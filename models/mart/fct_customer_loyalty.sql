with agg as (
    select
        frequent_flyer_id,
        customer_id,
        year(flight_date) as loyalty_year,
        sum(mileage) as total_mileage,
        sum(loyalty_spend) as total_loyalty_spend,
        count(flight_id) as total_flights

    from {{ ref('int_customer_flights') }}

    group by
        frequent_flyer_id,
        customer_id,
        year(flight_date)
)

select
    frequent_flyer_id,
    customer_id,
    loyalty_year,
    total_mileage,
    total_loyalty_spend,
    total_flights,

    case
        when total_mileage >= 10000
             and total_loyalty_spend >= 5000
             and total_flights >= 5
            then 'Platinum'

        when total_mileage >= 5000
             and total_loyalty_spend >= 3000
             and total_flights >= 3
            then 'Gold'

        when total_mileage >= 1000
             and total_loyalty_spend >= 1000
             and total_flights >= 1
            then 'Silver'

        else 'Bronze'
    end as current_status

from agg