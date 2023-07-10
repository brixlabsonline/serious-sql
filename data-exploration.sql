select * from DVD_RENTALS.RENTAL limit 10; 
 
--ORDER BY 
DROP TABLE IF EXISTS sample_table;
CREATE TEMP TABLE sample_table AS
WITH raw_data (id, column_a, column_b) AS (
 VALUES
 (1, 0, 'A'),
 (2, 0, 'B'),
 (3, 1, 'C'),
 (4, 1, 'D'),
 (5, 2, 'D'),
 (6, 3, 'D')
)
SELECT * FROM raw_data;


select * from sample_table; 

select * from sample_table
order by column_a, column_b;

select * from sample_table
order by column_a desc, column_b; 

select * from sample_table
order by column_a, column_b desc;

select * from sample_table
order by column_b DESC , column_a;

select * from sample_table
order by column_b desc, column_a desc;

--Which customer_id has the latest rental_date for inventory_id = 1 and 2? 

select CUSTOMER_ID, RENTAL_DATE, INVENTORY_ID 
from DVD_RENTALS.RENTAL
order by INVENTORY_ID, RENTAL_DATE DESC ;

--In the dvd_rentals.sales_by_film_category table, which category has the highest total_sales?

select * from DVD_RENTALS.SALES_BY_FILM_CATEGORY
order by TOTAL_SALES DESC 
limit 1; 

-- What is the name of the category with the highest category_id in the dvd_rentals.category table?

select CATEGORY_ID, "name" 
from DVD_RENTALS.CATEGORY
order by 1 DESC 
limit 1; 

--For the films with the longest length, what is the title of the “R” rated film with the lowest replacement_cost in dvd_rentals.film table?

select TITLE, REPLACEMENT_COST, LENGTH, RATING from 
dvd_rentals.film 
order by LENGTH DESC, REPLACEMENT_COST 
limit 10; 

--Who was the manager of the store with the highest total_sales in the dvd_rentals.sales_by_store table?

select MANAGER 
from dvd_rentals.sales_by_store
order by TOTAL_SALES DESC 
limit 1; 

--What is the postal_code of the city with the 5th highest city_id in the dvd_rentals.address table?

select POSTAL_CODE, CITY_ID 
from DVD_RENTALS.ADDRESS
order by CITY_ID DESC
limit 5; 


-- ORDER BY 1 NULLS FIRST;


--Record Counts & Distinct Values
------------------------------------

select * from DVD_RENTALS.FILM_LIST;

select count(*) 
from DVD_RENTALS.FILM_LIST; --997 

select DISTINCT RATING
from DVD_RENTALS.FILM_LIST; 

select DISTINCT CATEGORY
from DVD_RENTALS.FILM_LIST; 

--Count of Unique values
select count(DISTINCT category) as unique_category_count
from DVD_RENTALS.FILM_LIST;  --16

--What is the frequency of values in the rating column in the film_list table?
select RATING , count(*) as record_count
from DVD_RENTALS.FILM_LIST
group by RATING ; 

--Apply Aggregate Count Function
--Only 1 row is returned for each group

select RATING , count(*) as freequency
from DVD_RENTALS.FILM_LIST
group by RATING
order by FREEQUENCY desc;

--Adding a Percentage Column

select 
	RATING, 
	COUNT(*) as freequency,
	ROUND( 
		100 * COUNT(*):: NUMERIC / SUM(COUNT(*)) OVER (), 
		2) AS percentage
from DVD_RENTALS.FILM_LIST
group by RATING 
order by FREEQUENCY DESC; 

--Counts For Multiple Column Combinations
--What are the 5 most frequent rating and category combinations in the film_list table?

select 
	RATING, 
	CATEGORY, 
	COUNT(*) as freequency
from DVD_RENTALS.FILM_LIST
group by rating, CATEGORY 
order by FREEQUENCY desc
limit 5; 

--Which actor_id has the most number of unique film_id records in the dvd_rentals.film_actor table?

select 
	actor_id, 
	count(distinct film_id) as distinct_count
from dvd_rentals.film_actor
group by ACTOR_ID
order by distinct_count DESC 
Limit 5; 

--How many distinct fid values are there for the 3rd most common price value in the dvd_rentals.nicer_but_slower_film_list table?
select * from dvd_rentals.nicer_but_slower_film_list; 

select 
	price, 
	count(price) as price_count, 
	count(distinct fid) as dist_fid_count 
from dvd_rentals.nicer_but_slower_film_list
group by price
order by PRICE_COUNT desc
limit 3; 

--How many unique country_id values exist in the dvd_rentals.city table?
select * from dvd_rentals.city; 
select 
    count(distinct country_id) as country_id_count
from dvd_rentals.city;

--What percentage of overall total_sales does the Sports category make up in the dvd_rentals.sales_by_film_category table?
select * from dvd_rentals.sales_by_film_category; 

select 
  	category,  
  	ROUND(
  		100 * TOTAL_SALES :: NUMERIC / SUM(TOTAL_SALES) OVER (), 2 ) as percentage
from dvd_rentals.sales_by_film_category;

--What percentage of unique fid values are in the Children category in the dvd_rentals.film_list table?

select * from dvd_rentals.film_list;

select 
 	category,
 	ROUND( 
 		100 * count( distinct fid):: NUMERIC / SUM(count( distinct fid)) OVER () , 2) as percentage
from dvd_rentals.film_list
group by CATEGORY; 

---------------------------------------------------------------------------------------------------------------------------------
--Identifying Duplicate Records
--Health Data

select * from HEALTH.USER_LOGS limit 10; 

select 
LOG_DATE,
COUNT(*)	
from HEALTH.USER_LOGS 
group by LOG_DATE 
order by LOG_DATE DESC; 

with cte as SELECT 
	id,
	COUNT(id) as rec_count
FROM HEALTH.USER_LOGS 
GROUP BY id;
select *
from cte; 

select count(*)
from HEALTH.USER_LOGS ; --43891

SELECT COUNT(DISTINCT id)
from HEALTH.USER_LOGS ; --554

select 
measure,
count(*) as freequency, 
ROUND(
     100 * count(*) / SUM(COUNT(*)) over (), 2) as percentage
from HEALTH.USER_LOGS 
group by MEASURE
order by 2 DESC ; 

select 
id, 
count(*) AS freequency, 
ROUND( 100 * count(*) / SUM(count(*)) over (), 2) as percentage
from HEALTH.USER_LOGS 
group by id
order by FREEQUENCY desc
limit 10; 

select 
MEASURE_VALUE,
count(*) as freequency
from HEALTH.USER_LOGS 
group by MEASURE_VALUE 
order by 2 DESC ;

select
SYSTOLIC, 
count(*) as freequency
from HEALTH.USER_LOGS 
group by 1
order by 2 desc; 

select
DIASTOLIC , 
count(*) as freequency
from HEALTH.USER_LOGS 
group by 1
order by 2 desc;

select * from HEALTH.USER_LOGS limit 10; 

select 
measure, 
count(*)
from HEALTH.USER_LOGS 
where MEASURE_VALUE = 0
group by 1; 

select * 
from HEALTH.USER_LOGS 
where MEASURE_VALUE = 0 and MEASURE = 'blood_pressure'
limit 10; 

select * 
from HEALTH.USER_LOGS 
where MEASURE_VALUE != 0 and MEASURE = 'blood_pressure'
limit 10; 


select count(* )
from HEALTH.USER_LOGS 
where SYSTOLIC = 0; 

select * 
from HEALTH.USER_LOGS 
where SYSTOLIC = 0
limit 10; 

select 
measure, 
COUNT(*)
from HEALTH.USER_LOGS 
where SYSTOLIC is null
group by MEASURE;


select * 
from HEALTH.USER_LOGS 
where SYSTOLIC != 0
limit 10; 

select count(* )
from HEALTH.USER_LOGS 
where DIASTOLIC = 0; 

select *
from HEALTH.USER_LOGS 
where DIASTOLIC = 0
limit 10; 

select 
measure,
count(*)
from HEALTH.USER_LOGS 
where DIASTOLIC is null
group by MEASURE; 

-- This result confirms that systolic and diastolic only has non-null records when measure = 'blood_pressure'

select count(*) from HEALTH.USER_LOGS; 

--subquery way
select count(*) from (select DISTINCT * from HEALTH.USER_LOGS) as non_dup;

--43890 - 31004

--cte_way
with deduplicated_logs as 
(select DISTINCT *
  from HEALTH.USER_LOGS ) 
select count(*) from deduplicated_logs; 

--temp_table way
drop table if exists deduplicated_user_logs;
create temp table deduplicated_user_logs AS
 select distinct * from HEALTH.USER_LOGS;

select count(*) from deduplicated_user_logs; 


select 
*,
count(*) as freequency
from HEALTH.USER_LOGS 
group by id, LOG_DATE, MEASURE , MEASURE_VALUE, SYSTOLIC, DIASTOLIC
having count(*) > 1; 


--cte

with group_by_counts as (
select *,
count(*) as freequency
from HEALTH.USER_LOGS 
group by id, LOG_DATE, MEASURE , MEASURE_VALUE, SYSTOLIC, DIASTOLIC
)
select 
id, 
sum(FREEQUENCY) as total_duplicate_rows
from group_by_counts
where FREEQUENCY > 1
group by id 
order by total_duplicate_rows DESC
limit 10; 


select * from HEALTH.USER_LOGS limit 10;

--Which measure_value had the most occurences in the health.user_logs value when measure = 'weight'?
select 
measure_value, 
count(*) as measure_count
from HEALTH.USER_LOGS 
where MEASURE = 'weight'
group by MEASURE_VALUE 
order by 2 desc
limit 1; 

--How many single duplicated rows exist when measure = 'blood_pressure' in the health.user_logs? How about the total number of duplicate records in the same table?
--140 and 301
select count(*) from HEALTH.USER_LOGS where MEASURE = 'blood_pressure';

with duplicate_count as (
select *, 
count(*) as freequency
from HEALTH.USER_LOGS 
where MEASURE = 'blood_pressure'
group by id, LOG_DATE, MEASURE , MEASURE_VALUE, SYSTOLIC, DIASTOLIC
)
select 
count(*) as total_single_duplicated_rows,
sum(FREEQUENCY) as total_duplicate_records
from DUPLICATE_COUNT
where freequency > 1;

--What percentage of records measure_value = 0 when measure = 'blood_pressure' in the health.user_logs table? How many records are there also for this same condition?
--562 total records for that condition

WITH all_measure_values AS (
  SELECT
    measure_value,
    COUNT(*) AS total_records,
    SUM(COUNT(*)) OVER () AS overall_total
  FROM health.user_logs
  WHERE measure = 'blood_pressure'
  GROUP BY 1
)
SELECT
  measure_value,
  total_records,
  overall_total,
  ROUND(100 * total_records::NUMERIC / overall_total, 2) AS percentage
FROM all_measure_values
WHERE measure_value = 0;

--What percentage of records are duplicates in the health.user_logs table?

WITH groupby_counts AS (
  SELECT
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic,
    COUNT(*) AS frequency
  FROM health.user_logs
  GROUP BY
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic
)
SELECT
  -- Need to subtract 1 from the frequency to count actual duplicates!
  -- Also don't forget about the integer floor division!
  ROUND(
    100 * SUM(CASE
        WHEN frequency > 1 THEN frequency - 1
        ELSE 0 END
    )::NUMERIC / SUM(frequency),
    2
  ) AS duplicate_percentage
FROM groupby_counts;

--OR 
--Total Distinct Records = (Total Row Count - Distinct Row Count) / Total Row Count

WITH deduped_logs AS (
  SELECT DISTINCT *
  FROM health.user_logs
)
SELECT
  ROUND(
    100 * (
      (SELECT COUNT(*) FROM health.user_logs) -
      (SELECT COUNT(*) FROM deduped_logs)
    )::NUMERIC /
    (SELECT COUNT(*) FROM health.user_logs),
    2
  ) AS duplicate_percentage;
 
