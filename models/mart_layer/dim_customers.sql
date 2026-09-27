-- The models can be set to view or table as per the command {{config(materialized='view')}} or {{config(materialized='table')}}
-- Best practice 
-- Always define all the sources in CTE style for central modification

with
    customers as (
        select * from {{ ref('stg_jaffle_shop_customers') }}   -- read from other models
    ),

    customer_orders as (
        select
            user_id as customer_id,
            min(order_date) as first_order_date,
            max(order_date) as most_recent_order_date,
            count(id) as number_of_orders
        from {{ source('jaffle_shop', 'orders') }} -- read directly from source
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

select * from final