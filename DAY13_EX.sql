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
with caller_count_table AS(
  SELECT policy_holder_id, COUNT(case_id) as caller_count
  from callers
  GROUP BY policy_holder_id
)
SELECT count(policy_holder_id) as member_count
FROM caller_count_table
WHERE caller_count >= 3

--Bài tập 4
SELECT c.page_id
FROM pages as c 
where c.page_id NOT IN(
  SELECT a.page_id
  FROM pages as a
  join page_likes as b on a.page_id=b.page_id
  GROUP BY a.page_id
  having count(b.user_id) >=1)
GROUP BY c.page_id
ORDER BY c.page_id ASC

--Bài tập 5
WITH record_CTEs AS (
SELECT curr_month.event_date, last_month.user_id
from user_actions AS last_month
JOIN user_actions AS curr_month ON last_month.user_id = curr_month.user_id
WHERE EXTRACT(MONTH FROM last_month.event_date) = EXTRACT(MONTH FROM curr_month.event_date - interval '1 month')
)
SELECT EXTRACT(month from rd.event_date) as mth,
count(DISTINCT rd.user_id) as monthly_active_users
FROM record_CTEs AS rd
WHERE EXTRACT(month from rd.event_date) = 7 AND
      EXTRACT(YEAR FROM rd.event_date) = 2022
GROUP BY EXTRACT(month from rd.event_date)

--Bài tập 6
select DATE_FORMAT(trans_date, '%Y-%m') as month, country, count(*) as trans_count,
 sum(case when state='approved' then 1 else 0 end) as approved_count, 
 sum(amount) as trans_total_amount, sum(case when state='approved' then amount else 0 end) as approved_total_amount
from Transactions
group by month, country

--Bài tập 7


--Bài tập 8


--Bài tập 9


--Bài tập 10


--Bài tập 11


--Bài tập 12

