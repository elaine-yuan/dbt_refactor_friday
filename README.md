# Refactor Friday

A repository contains my solution to [**Refactor Friday**](https://github.com/edxhayter/dbt-data-drills/tree/main/docs/challenge_1), from [Ed Hayter's dbt Data Drills](https://github.com/edxhayter/dbt-data-drills).

The goal of this challenge is to take an existing piece of legacy SQL, refactor it using dbt best practices, and then validate the refactored code to ensure the refactored code produces the same results as the original.

Instead of keeping source preparation, joins, calculations, and aggregations in one query, the logic is separated into distinct layers in a modular dbt project. This makes the transformation easier to understand, test, maintain, and validate.

## Key Steps

1. Refactor the legacy SQL code into a modular dbt project.
2. Compare the legacy code against the refactored code using the [`dbt-audit-helper`](https://github.com/dbt-labs/dbt-audit-helper) package.
3. Validate that the refactored model produces equivalent results to the legacy code.

## Project Structure

```text
dbt_refactor_friday/
│
├── analyses/
│   ├── compare_and_classify_query_results.sql
│   └── compare_and_classify_relation_rows.sql
│
├── seeds/
│   ├── bookings.csv
│   ├── flights.csv
│   └── customers.csv
│
├── models/
│   ├── staging/
│   │   ├── stg_bookings.sql
│   │   ├── stg_flights.sql
│   │   └── stg_customers.sql
│   │
│   ├── intermediate/
│   │   ├── int_booking_flights.sql
│   │   └── int_customer_flights.sql
│   │
│   └── marts/
│       └── fct_customer_loyalty.sql
│
└── ...
```


## Refactoring the Legacy Code

I broke the original legacy query into smaller, modular dbt components using seeds, staging models, intermediate models, and a mart.

The resulting project contains:

* 3 seeds
* 3 staging models
* 2 intermediate models
* 1 mart model

### 1. Seeds

I created three seeds containing the source data used in the challenge:

* `bookings`
* `flights`
* `customers`

These seeds allow the challenge data to be loaded directly into the dbt project.

### 2. Staging Models

I created three staging models to prepare the seed data for downstream transformations:

* `stg_bookings`
* `stg_flights`
* `stg_customers`

These models explicitly defines the appropriate data type for each column.

### 3. Intermediate Models

The transformation logic is broken into two intermediate models.

#### `int_booking_flights`

This model prepares the booking and flight data for downstream analysis.

The key transformation is flattening the flight IDs dictionary from the booking data so that individual flight records can be joined and analyzed.

#### `int_customer_flights`

This model joins the customer, booking, and flight data together. For each booking, the first flight is identified and its booking price is assigned as customer loyalty spend.

### 4. Mart Model

#### `fct_customer_loyalty`

The final mart model aggregates customer-level metrics, such as total flights, total mileage, and total loyalty spend.

It also determines each customer's `current_status` based on the metrics above.

The result is a business-ready table containing the customer loyalty information needed for analysis.

## Audit Helper Validation

After refactoring the legacy SQL, I used the dbt-audit-helper package to compare the results of the legacy and refactored models.

The comparison queries are located in the analyses folder.

Two audit_helper macros are used:
* compare_and_classify_query_results: compares the results of the legacy and refactored mart models
* compare_and_classify_relation_rows: performs the comparison directly between the two dbt model relations

Both comparisons use the following columns to identify each customer loyalty record:

* frequent_flyer_id
* customer_id
* loyalty_year

Using these columns as the primary key allows audit_helper to match the corresponding rows from the legacy and refactored models and identify any differences between them.

This validation helps confirm that the refactoring changed the structure of the SQL without unintentionally changing the results.
