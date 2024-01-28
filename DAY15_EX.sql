--Bài tập 1
SELECT EXTRACT(year from transaction_date) AS year, product_id, spend AS curr_year_spend,
  LAG(spend) OVER(PARTITION BY product_id ORDER BY transaction_date) AS prev_year_spend,
  ROUND((spend-LAG(spend) OVER(PARTITION BY product_id ORDER BY transaction_date))/(LAG(spend) OVER(PARTITION BY product_id ORDER BY transaction_date))*100,2) AS YOY_rate
FROM user_transactions;

--Bài tập 2
WITH CTEs_record AS(
SELECT MAKE_DATE(issue_year, issue_month, 1) AS issue_day, card_name, issued_amount,
RANK() OVER(PARTITION BY card_name ORDER BY MAKE_DATE(issue_year, issue_month, 1)) AS rank
FROM monthly_cards_issued )
SELECT card_name, issued_amount
from CTEs_record 
WHERE rank =1
ORDER BY issued_amount DESC

--Bài tập 3
WITH CTEs_trans AS(
SELECT user_id, spend, transaction_date,
  RANK() OVER(PARTITION BY user_id ORDER BY transaction_date) as rank_trans
FROM transactions)
SELECT user_id, spend, transaction_date
FROM CTEs_trans
WHERE rank_trans = 3
ORDER BY user_id

--Bài tập 4
WITH CTEs_trans AS (SELECT transaction_date, user_id,
  count(product_id) OVER(PARTITION BY user_id ORDER BY transaction_date DESC) as purchase_count,
  Row_number() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) as r
FROM user_transactions)
SELECT transaction_date, user_id, purchase_count
from CTEs_trans
where r=1
ORDER BY transaction_date ASC

--Bài tập 5
WITH CTEs_record AS (SELECT user_id, tweet_date, tweet_count,
  lag(tweet_count) OVER(PARTITION BY user_id) as col1, 
  lag(tweet_count,2) OVER(PARTITION BY user_id) as col2
FROM tweets)


--Bài tập 6


--Bài tập 7


--Bài tập 8

