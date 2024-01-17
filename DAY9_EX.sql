--Bài tập 1
SELECT 
SUM(
CASE
  WHEN device_type = 'LAPTOP' THEN 1
  ELSE 0
END) AS laptop_reviews,
SUM(
CASE
  WHEN device_type IN ('PHONE','TABLET') THEN 1
  ELSE 0
END) AS mobile_views
FROM viewership
--Bài tập 2
SELECT X, Y, Z, 
CASE
    WHEN X+Y>Z AND X+Z>Y AND Y+Z>X THEN 'Yes'
    ELSE 'No'
END AS TRIANGLE
FROM TRIANGLE

--Bài tập 3
SELECT ROUND(100.0 * COUNT(case_id)/(SELECT COUNT(*) FROM callers),1) AS call_percentage
FROM callers
WHERE call_category IS NULL OR call_category = 'n/a'

--Bài tập 4
SELECT NAME
FROM CUSTOMER
WHERE ID NOT IN (
    SELECT ID
    FROM CUSTOMER
    WHERE REFEREE_ID = 2) 

--Bài tập 5
SELECT survived, 
SUM(CASE
        WHEN pclass ='1'THEN 1
        ELSE 0
    END) AS first_class,
SUM(CASE
        WHEN pclass ='2'THEN 1
        ELSE 0
    END) AS second_class,
SUM(CASE
        WHEN pclass ='3'THEN 1
        ELSE 0
    END) AS third_class
FROM titanic
GROUP BY survived
ORDER BY survived ASC
