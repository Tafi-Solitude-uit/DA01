----Câu 1
select extract(year from created_at) as year, extract(month from created_at) as month, count(user_id) as total_user, count(order_id) as total_order
from `bigquery-public-data.thelook_ecommerce.order_items`
where status = 'Shipped' and (DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30')
group by year, month
order by year, month ASC
limit 1000
-->Qua từng tháng của các năm, tổng số lượng đơn hàng và số lượng người dùng tăng đều

----Câu 2
select extract(year from created_at) as year, extract(month from created_at) as month,AVG(sale_price) AS AOV, count(distinct user_id) as total_user, count(order_id) as total_order
from `bigquery-public-data.thelook_ecommerce.order_items`
where status = 'Shipped' and (DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30')
group by year, month
order by year, month ASC
-->Qua từng tháng của các năm, hầu hết giá trị trung bình của các đơn hàng giao động từ 50 đến 65, ngoại trừ 3 tháng đầu của năm 2019 do số lượng đơn hàng ít--,
còn lại hầu hết qua các tháng đều có số lượng đơn hàng tăng và số lượng người dùng tăng nên giá trị trung bình các đơn hàng luôn giao động ở mức ổn định]

----Câu 3
--**-- cách 1
(SELECT
      first_name,
      last_name,
      gender,
      age,
      'youngest' AS tag
FROM `bigquery-public-data.thelook_ecommerce.users`
WHERE age = (SELECT MIN(age) FROM `bigquery-public-data.thelook_ecommerce.users`)
      AND (created_at BETWEEN '2019-01-01' AND '2022-04-30'))

UNION ALL

(SELECT
      first_name,
      last_name,
      gender,
      age,
      'oldest' AS tag
FROM `bigquery-public-data.thelook_ecommerce.users`
WHERE age = (SELECT MAX(age) FROM `bigquery-public-data.thelook_ecommerce.users`)
      AND (created_at BETWEEN '2019-01-01' AND '2022-04-30'))
  
--**-- cách 2 với temp_table nhưng không chạy được trên bigquery:<< :
create temp table TEMP_record as (
  with youngest as (SELECT
        gender, id,
        first_name,
        last_name,
        age,
        'youngest' AS tag,
  FROM `bigquery-public-data.thelook_ecommerce.users`
  WHERE age = (SELECT MIN(age) FROM `bigquery-public-data.thelook_ecommerce.users`)
        AND (created_at BETWEEN '2019-01-01' AND '2022-04-30')
  GROUP BY gender, id, first_name, last_name, age
  order by gender),

  oldest as (SELECT
        gender, id,
        first_name,
        last_name,
        age,
        'oldest' AS tag
  FROM `bigquery-public-data.thelook_ecommerce.users`
  WHERE age = (SELECT MAX(age) FROM `bigquery-public-data.thelook_ecommerce.users`)
        AND (created_at BETWEEN '2019-01-01' AND '2022-04-30')
  GROUP BY gender, id, first_name, last_name, age
  order by gender)
  select *
  from youngest 
  union all 
  select *
  from oldest)
 
select 
      sum( CASE
        WHEN age = (SELECT MIN(age) FROM `bigquery-public-data.thelook_ecommerce.users`) THEN 1
      END) as youngest_count,
      sum( CASE
        WHEN age = (SELECT MAX(age) FROM `bigquery-public-data.thelook_ecommerce.users`) THEN 1
      END) as oldest_count
 from TEMP_record

youngest:1047
oldest:1032
--> độ tuổi trẻ nhất của các khách hàng là 12, với tổng số lượng là 1047; đối tượng lớn tuổi nhất của khách hàng là 70, với tổng số lượng là 1032
----Câu 4
select *
from (
SELECT
  FORMAT_DATE('%Y-%m', DATE(created_at)) AS month_year,
  A.product_id,
  B.name,
  SUM(sale_price) AS sales,
  SUM(cost) AS total_cost,
  SUM(sale_price) - SUM(cost) AS profit,
  DENSE_RANK() OVER (PARTITION BY FORMAT_DATE('%Y-%m', DATE(created_at)) ORDER BY FORMAT_DATE('%Y-%m', DATE(created_at)) ASC,
  SUM(sale_price) - SUM(cost) DESC) AS rank_per_month
FROM
  bigquery-public-data.thelook_ecommerce.order_items AS A
JOIN
  bigquery-public-data.thelook_ecommerce.products AS B ON A.product_id = B.id
group by  created_at, A.product_id, B.name) as K
where rank_per_month<=5

----Câu 5
SELECT
  created_at,
  B.category as product_categories,
  sum(SUM(sale_price) - SUM(cost)) OVER(PARTITION BY created_at, B.category ORDER BY created_at) AS revenue
FROM
  bigquery-public-data.thelook_ecommerce.order_items AS A
JOIN
  bigquery-public-data.thelook_ecommerce.products AS B ON A.product_id = B.id
WHERE
  DATE(created_at) BETWEEN DATE_SUB('2022-04-15', INTERVAL 3 MONTH) AND '2022-04-15'
GROUP BY
  created_at, B.category
