select
    flight_id::varchar as flight_id,
    to_date(flight_date, 'DD/MM/YYYY') as flight_date,
    mileage::int as mileage
from {{ ref('flights') }}