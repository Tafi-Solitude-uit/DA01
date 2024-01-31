----Câu 1
select *
from sales_dataset_rfm_prj

alter table sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE integer
USING ordernumber::integer;

alter table sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE integer
USING quantityordered::integer;

alter table sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric
USING priceeach::numeric;

alter table sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE smallint
USING orderlinenumber::smallint;

alter table sales_Câu 2
SELECT 
    *
FROM 
    sales_dataset_rfm_prj
WHERE 
    ORDERNUMBER IS NULL OR
    QUANTITYORDERED IS NULL OR
    PRICEEACH IS NULL OR
    ORDERLINENUMBER IS NULL OR
    SALES IS NULL OR
    ORDERDATE IS NULL ;

----Câu 3
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME VARCHAR(20),
ADD COLUMN CONTACTFIRSTNAME VARCHAR(20);

update sales_dataset_rfm_prj
set CONTACTLASTNAME = (
	upper(substring(left(contactfullname, POSITION('-' IN contactfullname)-1) from 1 for 1)) ||
	
	substring(left(contactfullname, POSITION('-' IN contactfullname)-1) from 2)
)

update sales_dataset_rfm_prj
set CONTACTFIRSTNAME = (
	upper(substring(right(contactfullname,
	length(contactfullname)-length(left(contactfullname, POSITION('-' IN contactfullname))))
	from 1 for 1)) ||
	
	substring(right(contactfullname,
	length(contactfullname)-length(left(contactfullname, POSITION('-' IN contactfullname)))) from 2)
)

----Câu 4
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN QTR_ID INT,
ADD COLUMN MONTH_ID INT,
ADD COLUMN YEAR_ID INT;

UPDATE sales_dataset_rfm_prj
SET
    QTR_ID = EXTRACT(QUARTER FROM ORDERDATE),
    MONTH_ID = EXTRACT(MONTH FROM ORDERDATE),
    YEAR_ID = EXTRACT(YEAR FROM ORDERDATE);

----Câu 5 (xử lý dữ liệu outlier bằng cách thay thế các giá trị outlier thành giá trị trung bình số lượng sản phẩm được đặt hàng của tất cả các đơn hàng trong bảng)
with twt_min_max_value as(
select Q1 - 1.5*IQR as MIN_value,
	   Q3 - 1.5*IQR as MAX_value
from(
	select 
		 percentile_cont(0.25) within group(order by QUANTITYORDERED) as Q1,
		 percentile_cont(0.75) within group(order by QUANTITYORDERED) as Q3,
		 percentile_cont(0.75) within group(order by QUANTITYORDERED) - percentile_cont(0.25) within group(order by QUANTITYORDERED) AS IQR
	from sales_dataset_rfm_prj) as record)
select * from sales_dataset_rfm_prj
where QUANTITYORDERED < (select MIN_value from twt_min_max_value)
	or QUANTITYORDERED > (select MAX_value from twt_min_max_value)

----Câu 6
create table SALES_DATASET_RFM_PRJ_CLEAN as
(
	SELECT *
	FROM sales_dataset_rfm_prj
)
	
----Update dữ liệu đã clean cho bảng SALES_DATASET_RFM_PRJ_CLEAN
with outlier as (
with twt_min_max_value as(
select Q1 - 1.5*IQR as MIN_value,
	   Q3 - 1.5*IQR as MAX_value
from(
	select 
		 percentile_cont(0.25) within group(order by QUANTITYORDERED) as Q1,
		 percentile_cont(0.75) within group(order by QUANTITYORDERED) as Q3,
		 percentile_cont(0.75) within group(order by QUANTITYORDERED) - percentile_cont(0.25) within group(order by QUANTITYORDERED) AS IQR
	from sales_dataset_rfm_prj) as record)
select * from SALES_DATASET_RFM_PRJ_CLEAN
where QUANTITYORDERED < (select MIN_value from twt_min_max_value)
	or QUANTITYORDERED > (select MAX_value from twt_min_max_value))
	
update SALES_DATASET_RFM_PRJ_CLEAN
set QUANTITYORDERED = (select avg(QUANTITYORDERED) 
					   from sales_dataset_rfm_prj)
where QUANTITYORDERED in (select QUANTITYORDERED from outlier)

select * from SALES_DATASET_RFM_PRJ_CLEAN
