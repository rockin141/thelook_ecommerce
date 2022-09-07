select 
      a.order_id,
      a.user_id,
      a.product_id,
        c.category,
        c.brand,
        c.name,
        b.num_of_item,
        a.status,
          extract (date from a.created_at) as order_date,
          count (a.delivered_at) as completing_order_count,
          count (a.shipped_at) as shipping_count,
          count (a.returned_at) as cancel_order_count,
              sum(case when a.delivered_at is not null then  b.num_of_item * c.retail_price else null end ) as revenue,
              count(a.order_id) as order_count,
              SUM((case when a.delivered_at is not null then  b.num_of_item * c.retail_price else null end)- c.cost) as net
             

from 

`bigquery-public-data.thelook_ecommerce.order_items`a,
`bigquery-public-data.thelook_ecommerce.orders`b,
`bigquery-public-data.thelook_ecommerce.products`c

where a.order_id = b.order_id
      and a.user_id = b.user_id
      and a.product_id = c.id
        group by a.order_id,
                  a.user_id,
                  a.product_id,
                  a.created_at,
                  a.delivered_at,
                  a.shipped_at,
                  a.returned_at,
                   c.category,
                   c.brand,
                   c.name,
                   b.num_of_item,
                   a.status

                        order by order_date, 
                                shipping_count,
                                completing_order_count,
                                cancel_order_count,
                                order_count,
                                revenue;
