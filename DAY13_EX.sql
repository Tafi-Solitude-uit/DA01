--Bài tập 1
With duplicate_job AS (
  SELECT company_id, title, description,
  count(*) AS duplicate_job_count
  FROM job_listings
  GROUP BY company_id, title, description)
SELECT COUNT(*)
FROM duplicate_job
WHERE duplicate_job_count>1

--Bài tập 2
WITH prod_spend AS (
  (SELECT category,	product, SUM(spend) AS total_spend
  FROM product_spend
  WHERE EXTRACT(year FROM transaction_date) = '2022' AND category = 'electronics'
  GROUP BY category, product
  ORDER BY total_spend DESC
  limit 2)
  UNION
  (SELECT category,	product, SUM(spend) AS total_spend
  FROM product_spend
  WHERE EXTRACT(year FROM transaction_date) = '2022' AND category = 'appliance'
  GROUP BY category, product
  ORDER BY total_spend DESC
  limit 2)
)
SELECT category, product, total_spend
FROM prod_spend
ORDER BY category, total_spend DESC

--Bài tập 3


--Bài tập 4


--Bài tập 5


--Bài tập 6


--Bài tập 7


--Bài tập 8


--Bài tập 9


--Bài tập 10


--Bài tập 11


--Bài tập 12

