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
WITH payments AS (
  SELECT merchant_id, 
    EXTRACT(EPOCH FROM transaction_timestamp - 
      LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id, amount 
      ORDER BY transaction_timestamp)
    )/60 AS minute_difference 
  FROM transactions) 
SELECT COUNT(merchant_id) AS payment_count
FROM payments 
WHERE minute_difference <= 10

--Bài tập 7 (giống câu 2 DAY13)
WITH prod_spend AS (
  SELECT category, product, sum(spend) AS total_spend,
  row_number() OVER(PARTITION BY category ORDER BY sum(spend) DESC) as rank
  from product_spend
  WHERE EXTRACT(year from transaction_date) = '2022' 
  GROUP BY category, product)
SELECT category, product, total_spend
from prod_spend
WHERE rank <= 2

--Bài tập 8
WITH CTEs_top5_artists AS (
  SELECT artist_name, count(g.song_id) as song_count, 
  dense_rank() OVER(ORDER BY count(g.song_id) DESC) as artist_rank
  FROM artists as a
  join songs as s on s.artist_id = a.artist_id
  join global_song_rank as g on g.song_id = s.song_id
  WHERE rank <= 10
  GROUP BY artist_name)
SELECT artist_name, artist_rank
FROM CTEs_top5_artists
WHERE artist_rank <= 5
