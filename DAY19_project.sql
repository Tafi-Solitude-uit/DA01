----cau 1
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

----Cau 2
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

----Cau 3
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

----Cau 4
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN QTR_ID INT,
ADD COLUMN MONTH_ID INT,
ADD COLUMN YEAR_ID INT;

UPDATE sales_dataset_rfm_prj
SET
    QTR_ID = EXTRACT(QUARTER FROM ORDERDATE),
    MONTH_ID = EXTRACT(MONTH FROM ORDERDATE),
    YEAR_ID = EXTRACT(YEAR FROM ORDERDATE);

----Cau 5
