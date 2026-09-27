select 
    id as order_id, 
    user_id as customer_id, 
    order_date, status
from dfds_dbt_db.jaffle_shop.orders