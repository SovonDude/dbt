-- Best practice 
-- Always define all the sources in CTE style for central modification

with renamed as (
    select
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status as payment_status,
        amount as payment_amount,
        created as payment_created,
        _batched_at 
    from {{ source('stripe', 'payment') }}
)

select * from renamed