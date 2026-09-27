-- Best practice 
-- Always define all the sources in CTE style for central modification

with orders as  (
    select * from {{ ref ('stg_jaffle_shop_orders' )}}
),

order_payments as (
    select
        order_id,
        sum (case when payment_status = 'success' then payment_amount end) as amount
    from {{ ref ('stg_stripe_payments') }} -- read from other models
    group by 1
    ),

 final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce (order_payments.amount, 0) as amount
    from orders  -- read from other models
    left join order_payments using (order_id)
)

select * from final