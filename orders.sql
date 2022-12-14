SELECT
      a.order_id,
      a.user_id,
      a.product_id,
      b.num_of_item,
      a.status,
      EXTRACT (date FROM a.created_at) AS order_date,
      COUNT(a.order_id) AS order_count,
      COUNT(a.user_id) AS user_count,
      SUM(case when a.delivered_at IS NOT NULL THEN  b.num_of_item * c.retail_price ELSE NULL END ) AS revenue,
      SUM((case when a.delivered_at IS NOT NULL THEN   b.num_of_item * c.retail_price ELSE NULL END)- c.cost) AS net
             

from 

`bigquery-public-data.thelook_ecommerce.order_items`a,
`bigquery-public-data.thelook_ecommerce.orders`b,
`bigquery-public-data.thelook_ecommerce.products`c

WHERE 
                  a.order_id = b.order_id
      AND         a.user_id = b.user_id
      AND         a.product_id = c.id
        
GROUP BY          a.order_id,
                  a.user_id,
                  a.product_id,
                  a.created_at,
                  b.num_of_item,
                  a.status

ORDER BY 
                  order_date, 
                  order_count,
                  revenue;
