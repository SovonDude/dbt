-- The models can be set to view or table as per below command
-- {{config(materialized='view')}}

with
    customers as (
        select * from {{ ref('stg_jaffle_shop_customers') }}
    ),

    orders as (
        select * from {{ ref('stg_jaffle_shop_orders') }}
    ),

    customer_orders as (
        select
            customer_id,
            min(order_date) as first_order_date,

Save

202122232425262728293031323317181915169101112131478456231





dbt Wizard
Commands
Results
Problems
1
Code quality
Compiled code
Lineage$0
            max(order_date) as most_recent_order_date,
            count(order_id) as number_of_orders
        from orders
        group by 1
    ),

    final as (
        select
            customers.customer_id,
            customers.first_name,
            customers.last_name,
            customer_orders.first_order_date,
            customer_orders.most_recent_order_date,
            coalesce(customer_orders.number_of_orders, 0) as number_of_orders
        from customers
        left join customer_orders using (customer_id)
    )

select *
from final
