WITH all_merge AS (
select
    subquery.*,
    flights.flight_date,
    flights.mileage,
    customers.customer_id,
    customers.customer_name,
    CASE WHEN RANK() OVER (partition by booking_id ORDER BY flight_date ASC) = 1 THEN booking_price END AS loyalty_spend
FROM (
SELECT
    booking_id, 
    flatten.value::int AS flight_id,
    booking_price,
    frequent_flyer_id
from {{ ref('bookings') }},
LATERAL FLATTEN(input => TRY_PARSE_JSON(flight_ids)) flatten
) subquery
LEFT JOIN {{ ref('flights') }} ON subquery.flight_id = flights.flight_id
LEFT JOIN {{ ref('customers') }} ON subquery.frequent_flyer_id = customers.frequent_flyer_id
)

SELECT
    frequent_flyer_id,
    customer_id,
    year_of_flight AS loyalty_year,
    total_mileage,
    total_loyalty_spend,
    total_flights,
    CASE
      WHEN total_mileage >= 10000 AND total_loyalty_spend >= 5000 AND total_flights >= 5 THEN 'Platinum'
      WHEN total_mileage >= 5000 AND total_loyalty_spend >= 3000 AND total_flights >= 3 THEN 'Gold'
      WHEN total_mileage >= 1000 AND total_loyalty_spend >= 1000 AND total_flights >= 1 THEN 'Silver'
      ELSE 'Bronze'
    END AS current_status,

FROM
(SELECT
frequent_flyer_id,
customer_id,
sum(mileage) AS total_mileage,
count(flight_id) AS total_flights,
YEAR(date(flight_date, 'dd/mm/yyyy')) AS year_of_flight,
sum(loyalty_spend) AS total_loyalty_spend
FROM all_merge
GROUP BY customer_id, YEAR(date(flight_date, 'dd/mm/yyyy')), frequent_flyer_id
) aggregated
ORDER BY 2 ASC