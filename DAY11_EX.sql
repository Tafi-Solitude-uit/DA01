--Bài tập 1
SELECT COUNTRY.CONTINENT, FLOOR(AVG(CITY.POPULATION)) AS AVERAGECITYPOPULATION
FROM COUNTRY
JOIN CITY ON COUNTRY.CODE = CITY.COUNTRYCODE
GROUP BY COUNTRY.CONTINENT

--Bài tập 2
SELECT ROUND(SUM(CASE 
			WHEN b.signup_action = 'Confirmed' THEN 1
			ELSE 0
			END)::DECIMAL / count(*), 2)
FROM emails AS a
INNER JOIN texts AS b ON a.email_id = b.email_id

--Bài tập 3
SELECT B.age_bucket,
  round(
    SUM(case when A.activity_type = 'open' then A.time_spent end) / SUM(case when a.activity_type != 'chat' then a.time_spent end)*100.0,2) as open_perc,
  round(
    SUM(case when A.activity_type = 'send' then A.time_spent end) / SUM(case when a.activity_type != 'chat' then a.time_spent end)*100.0,2) as send_perc
FROM activities AS A
join age_breakdown AS B on B.user_id=A.user_id
GROUP BY B.age_bucket

--Bài tập 4
SELECT customers.customer_id
FROM customer_contracts AS customers
JOIN products ON customers.product_id = products.product_id
GROUP BY customers.customer_id
HAVING COUNT(DISTINCT products.product_category) = (
          SELECT count(DISTINCT products.product_category)
          from products)

--Bài tập 5
select mng.employee_id, mng.name, count(emp.employee_id) as reports_count,
    round(avg(emp.age),0) as average_age
from Employees as mng
join Employees as emp on mng.employee_id = emp.reports_to
group by mng.employee_id
having count(emp.employee_id) >= 1
order by mng.employee_id ASC

--Bài tập 6
select Pdt.product_name, sum(Ords.unit) as unit
from Products as Pdt
join Orders as Ords on Pdt.product_id = Ords.product_id
where extract(month from Ords.order_date) = '2' and  extract(year from Ords.order_date) = '2020'
group by Pdt.product_name
having sum(Ords.unit) >= 100
order by Pdt.product_name

--Bài tập 7
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

----Bài tập kiểm tra giữa khóa (Mid-course test)
--Bài 1 
select distinct replacement_cost 
from film
order by replacement_cost ASC
limit 1

--Bài 2
select 
case 
	when replacement_cost between 9.99 and 19.99 then 'low'
	when replacement_cost between 20.00 and 24.99 then 'medium'
	when replacement_cost between 25.00 and 29.99 then 'high'
	else 'other'
end as catagory, count(*) as solg
from film
group by catagory
--Bài 3
select b.title, b.length, c.name 
from film_category as a 
join film as b on a.film_id=b.film_id
join category as c on a.category_id = c.category_id
where c.name ='Drama' or c.name ='Sports'
order by length DESC
limit 1

--Bài 4
select  c.name, count(b.film_id) as film_count 
from film_category as a 
join film as b on a.film_id=b.film_id
join category as c on a.category_id = c.category_id
group by c.name 
order by film_count DESC

--Bài 5
select c.last_name || ' ' || c.first_name as name, count(b.film_id) as film_count
from film_actor as a 
join film as b on a.film_id=b.film_id
join actor as c on a.actor_id = c.actor_id
group by name
order by film_count DESC
limit 1

--Bài 6
select count(c.address_id) as NULL_address
from address c
where c.address_id not in (
	select a.address_id
	from address a
	join customer b on a.address_id=b.address_id )

--Bài 7
select b.city, sum(p.amount) as total
from address a
join city b on a.city_id=b.city_id
join customer c on a.address_id = c.address_id
join payment p on c.customer_id = p.customer_id
group by b.city
order by total DESC
limit 1

--Bài 8
select y.country, b.city, sum(p.amount) as total
from address a
join city b on a.city_id=b.city_id
join country y on b.country_id=y.country_id
join customer c on a.address_id = c.address_id
join payment p on c.customer_id = p.customer_id
group by y.country ,b.city
order by total ASC
limit 1
