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

alter table sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE smallint
USING orderlinenumber::smallint;

alter table sales_dataset_rfm_prj
ALTER COLUMN sales TYPE numeric
USING sales::numeric;
--
SET datestyle = 'ISO, MDY';

alter table sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE timestamp with time zone
USING orderdate::timestamp with time zone;

alter table sales_dataset_rfm_prj
ALTER COLUMN status TYPE varchar(12)
USING status::varchar(12);

alter table sales_dataset_rfm_prj
ALTER COLUMN productline TYPE varchar(30)
USING productline::varchar(30);

alter table sales_dataset_rfm_prj
ALTER COLUMN msrp TYPE smallint
USING msrp::smallint;

alter table sales_dataset_rfm_prj
ALTER COLUMN productcode TYPE varchar(12)
USING productcode::varchar(12);

alter table sales_dataset_rfm_prj
ALTER COLUMN customername TYPE character varying
USING customername::character varying;

alter table sales_dataset_rfm_prj
ALTER COLUMN phone TYPE varchar(30)
USING phone::varchar(30)

alter table sales_dataset_rfm_prj
ALTER COLUMN addressline1 TYPE character varying
USING addressline1::character varying;

alter table sales_dataset_rfm_prj
ALTER COLUMN city TYPE varchar(20)
USING city::varchar(20);

alter table sales_dataset_rfm_prj
ALTER COLUMN state TYPE varchar(12)
USING state::varchar(12);

alter table sales_dataset_rfm_prj
ALTER COLUMN postalcode TYPE varchar(12)
USING postalcode::varchar(12);

alter table sales_dataset_rfm_prj
ALTER COLUMN country TYPE varchar(20)
USING country::varchar(20);

alter table sales_dataset_rfm_prj
ALTER COLUMN territory TYPE varchar(20)
USING territory::varchar(20);

alter table sales_dataset_rfm_prj
ALTER COLUMN dealsize TYPE varchar(12)
USING dealsize::varchar(12);

----Câu 2
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
