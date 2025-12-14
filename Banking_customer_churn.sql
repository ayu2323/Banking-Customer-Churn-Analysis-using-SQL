DROP TABLE IF EXISTS bank_churn;

CREATE TABLE bank_churn (
    "RowNumber"        INT,
    "CustomerId"       INT,
    "Surname"          VARCHAR(50),
    "CreditScore"      INT,
    "Geography"        VARCHAR(50),
    "Gender"           VARCHAR(10),
    "Age"              INT,
    "Tenure"           INT,
    "Balance"          NUMERIC(15,2),
    "NumOfProducts"    INT,
    "HasCrCard"        SMALLINT,
    "IsActiveMember"   SMALLINT,
    "EstimatedSalary"  NUMERIC(15,2),
    "Exited"           SMALLINT
);

ALTER TABLE bank_churn RENAME COLUMN "RowNumber" TO row_number;
ALTER TABLE bank_churn RENAME COLUMN "CustomerId" TO customer_id;
ALTER TABLE bank_churn RENAME COLUMN "Surname" TO surname;
ALTER TABLE bank_churn RENAME COLUMN "CreditScore" TO credit_score;
ALTER TABLE bank_churn RENAME COLUMN "Geography" TO geography;
ALTER TABLE bank_churn RENAME COLUMN "Gender" TO gender;
ALTER TABLE bank_churn RENAME COLUMN "Age" TO age;
ALTER TABLE bank_churn RENAME COLUMN "Tenure" TO tenure;
ALTER TABLE bank_churn RENAME COLUMN "Balance" TO balance;
ALTER TABLE bank_churn RENAME COLUMN "NumOfProducts" TO num_of_products;
ALTER TABLE bank_churn RENAME COLUMN "HasCrCard" TO has_cr_card;
ALTER TABLE bank_churn RENAME COLUMN "IsActiveMember" TO is_active_member;
ALTER TABLE bank_churn RENAME COLUMN "EstimatedSalary" TO estimated_salary;
ALTER TABLE bank_churn RENAME COLUMN "Exited" TO exited;


select * from bank_churn 
limit 5

--data cleaning and validation
--Check the total number of records

select count(*) 
from bank_churn

--Check for NULL values in each column

select customer_id
FROM bank_churn
where customer_id isnull

select surname
FROM bank_churn
where surname isnull

select credit_score
FROM bank_churn
where credit_score isnull

select geography
FROM bank_churn
where geography isnull

select gender
FROM bank_churn
where gender isnull

select tenure
FROM bank_churn
where tenure isnull

select balance
FROM bank_churn
where balance isnull

-- check for duplicate 

select distinct(count(customer_id))
FROM bank_churn

--Check for invalid / outlier values
--1 check if any negative balance
select min(balance), max(balance), avg(balance)
from bank_churn

--2 Check Binary column for only 0 or 1 value 

select Distinct has_cr_card, is_active_member, exited
from bank_churn
-- 
SELECT DISTINCT geography FROM bank_churn;
SELECT DISTINCT gender FROM bank_churn;

-- Basic Statistics about DATA
SELECT 
    AVG(balance) AS avg_balance,
    AVG(estimated_salary) AS avg_salary,
    AVG(credit_score) AS avg_credit_score
FROM bank_churn;


--1.  Calculate the overall customer churn rate.

select  
round(100.0 * sum (exited)/ count(*), 2) as churn_rate_percentage
from bank_churn


--2.  Find the churn rate by geography and sort it in descending order.

SELECT geography , round(100.0 * sum(exited)/count(*), 2) as churn_rate
from bank_churn
GROUP By geography 
ORDER By churn_rate DESC

--3.  Identify which age group (<30, 30–45, >45) has the highest churn rate.
SELECT 
case
when age < 30 then 'Below 30'
when age between 30 and 45 then '30-45'
ELSE 'Above 45'
end as age_group,
round(100.0 * sum(exited)/count(*), 2) as churn_rate
from bank_churn
GROUP by age_group
ORDER By churn_rate DESC


--4.  Compare churn rate between active and inactive customers.
select is_active_member, 
round(100.0 * sum(exited)/count(*), 2) as churn_rate
from bank_churn
group by is_active_member

--5.  Calculate churn rate by gender.
select gender, 
round(100.0 * sum(exited)/count(*), 2) as churn_rate
from bank_churn
group by gender


--6.  Find the average account balance of churned customers versus retained customers.
select exited, round (avg(balance),2) as avg_balance
from bank_churn
group by exited




--7.  Calculate churn rate based on the number of products held by customers.
select num_of_products, 
round(100.0 * sum(exited)/count(*), 2) as churn_rate
from bank_churn
group by num_of_products

--8.  Determine whether customers with a credit card churn less than those without a credit card
select has_cr_card, 
round(100.0 * sum(exited)/count(*), 2) as churn_rate
from bank_churn
group by has_cr_card

--9.  Analyze churn rate across customer tenure buckets (0–2 years, 3–5
--    years, 6–10 years).

select 
case when tenure between 0 and 2 then '0-2 years'
when tenure between 3 and 5 then '3-5 years'
else '6-10 years'
end as tenure_group , round(100.0* sum(exited)/count(*), 2)as churn_rate
from bank_churn
group by tenure_group

--10. Identify high-value churned customers with balance greater than
--    100,000.
select customer_id,balance
from bank_churn
where exited = 1 and balance > 100000
--
--11. Find the top 5 customer segments with the highest churn rate based
--    on geography, age group, and activity status.

WITH segment_churn AS (
    SELECT 
        geography,
        is_active_member,
        CASE
            WHEN age < 30 THEN 'Below 30'
            WHEN age BETWEEN 30 AND 45 THEN '30-45'
            ELSE 'Above 45'
        END AS age_group,
        ROUND(100.0 * SUM(exited) / COUNT(*), 2) AS churn_rate
    FROM bank_churn
    GROUP BY geography, is_active_member, age_group
)
SELECT *
FROM segment_churn
ORDER BY churn_rate DESC
LIMIT 5;


--
--12. Calculate the percentage of churned customers who were inactive members.

--select exited, round(100.0* sum(
--case when is_active_member = 0 then 1 else 0 end)/count(*),2) as inactive_churn_percentage
--from bank_churn
--group by exited

select round(100.0* sum(
case when is_active_member = 0 then 1 else 0 end)/count(*),2) as inactive_churn_percentage
from bank_churn
where exited = 1

--13. Rank geographies by churn rate using a window function.
with churn_cte as(
SELECT geography , round(100.0 * sum(exited)/count(*), 2) as churn_rate
from bank_churn
GROUP By geography 
)

select geography, churn_rate, 
rank() over( order by churn_rate desc) as chrun_rank
FROM churn_cte

--14. Identify customers who are at high risk of churn based on:
--
--    -   Age greater than 45
--    -   Balance greater than 100,000
--    -   Inactive membership
with high_risk as(
Select customer_id,
case when age > 45 and balance > 100000 and is_active_member = 0 then 'High risk'
else 'low risk'
end as risk
from bank_churn
)   
 select * 
 from high_risk
 where risk = 'High risk'


--15. Calculate the average estimated salary of churned customers by geography.

select geography , avg(estimated_salary) as avg_churn_salary
from bank_churn
where exited = 1
group by geography 



----Key Insights Generated
--
----Customers aged 45+ showed the highest churn rate
----
----Inactive members were significantly more likely to churn
----
----Certain geographies had 2x higher churn than others
----
----High-balance but inactive customers represented critical revenue risk
----

