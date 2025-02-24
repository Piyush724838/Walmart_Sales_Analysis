CREATE TABLE sales_data (
    invoice_id VARCHAR(50) PRIMARY KEY,
    Branch VARCHAR(50),
    City VARCHAR(50),
    category VARCHAR(50),
    unit_price DECIMAL(10, 2),
    quantity DECIMAL(10,2),
    date DATE,
    time TIME,
    payment_method VARCHAR(50),
    rating DECIMAL(10,2) ,
    profit_margin DECIMAL(10, 2),
    total DECIMAL(15, 2)
);
DROP TABLE sales_data


SELECT * from sales_data

SET datestyle = 'DMY';


COPY sales_data(invoice_id,	Branch,	City, category, unit_price,	quantity,	date, time,	payment_method,	rating,	profit_margin,	total)
FROM 'C:\Users\hrith\OneDrive\Desktop\Project_walmartt\Walmart_clean_data.csv'
DELIMITER ','
CSV HEADER;


SELECT * from sales_data LIMIT 10;
--

SELECT COUNT(*) FROM sales_data;

SELECT 
	payment_method,
	COUNT(*) 
FROM sales_data
GROUP BY payment_method;


SELECT COUNT(DISTINCT branch)
FROM sales_data;

SELECT MAX(quantity) from sales_data;

SELECT MIN(quantity) from sales_data;

-- Bussines Problems
--1-Find the different payment methods and no. of transactions , number of quantity sold 

SELECT payment_method, count(*) AS no_payments, 
SUM(quantity) as no_qty_sold
from sales_data
group by payment_method;

--impotant note :The error indicates that you're trying to include 
--payment_method in the SELECT list without including it in the 
--GROUP BY clause. When using aggregate functions like COUNT, 
--every column that isn't part of an aggregate function must appear 
--in the GROUP BY clause.
--COUNT(*): This counts the number of rows in each group of payment_method.
--GROUP BY payment_method: This groups the results by each unique payment_method.



--2-identify the highest rated category in each brand , displlaying the 
--branch , category

SELECT * from sales_data

SELECT *
from
(SELECT 
	branch,
	category,
	AVG(rating) AS avg_rating,
	RANK() OVER(PARTITION BY branch, ORDER BY AVG(rating) DESC) as rank
from sales_data
group by branch,category
)
WHERE rank = 1

--This SQL query calculates the average rating for each category within a branch. 
--It then ranks the categories within each branch based on their average ratings in descending order. 
--The outer query selects only the top-ranked category (rank = 1) for each branch,
--showing the highest-rated categories per branch.

--3-Identify the busiest day for each branch based on the number of transactions

SELECT * FROM sales_data


select * 
from(
	SELECT 
	branch,
	TO_CHAR(date,'Day') AS Day_name,
	count(*) as no_transactions,
	RANK() OVER(PARTITION BY branch ORDER BY count(*) desc) as rank
	from sales_data
	GROUP BY branch,Day_name
)
where rank = 1

--This query calculates the number of transactions per day for each branch. 
--It extracts the day name from the `date` column using `TO_CHAR(date, 'Day')`.
--Then, it ranks the days within each branch based on transaction count in descending order.
--The outer query filters to show the busiest day for each branch.


--4-Calculate the total quantity Of itemis sold per payment method. List payment _ method and total _ quantity

SELECT * FROM sales_data


SELECT 
	payment_method,
	SUM(quantity) as no_qty_sold
FROM sales_data
GROUP BY payment_method

--This SQL query calculates the total quantity of items sold for each payment method.
--It uses the `SUM(quantity)` function to aggregate the quantity values and 
--groups the results by the `payment_method` column. The output shows 
--the total quantity sold for each payment method used in sales.

--5-Determine the average, minimum, and maximum rating of products for each city.
--List the city, average _ rating, min_rating, and max_rating.

SELECT * FROM sales_data

SELECT  
	city,
	category,
	MIN(rating) as min_rating,
	MAX(rating) as max_rating,
	AVG(rating) as avg_rating
from sales_data
GROUP BY 1,2

--This query calculates the minimum, maximum, and average ratings
--for each combination of `city` and `category` in the `sales_data` table.
--It groups the data by `city` and `category` (using `GROUP BY 1,2` 
--to refer to the first and second columns), providing summary statistics 
--for each group.

--6-Calculate the total profit for each category by considering total _ profit as
--(unit_price * quantity * profit _ margin).
--List category and total _ profit, 
--ordered from highest to lowest profit.


SELECT * FROM sales_data

SELECT 
	category,
	SUM(total) as total_revenue,
	SUM(total * profit_margin) as profit
from sales_data
group by category
order by profit desc
	
--This query calculates the total revenue and profit for each product 
--category in the `sales_data` table. It sums the `total` column for 
--revenue and multiplies `total` by `profit_margin` for profit. 
--The results are grouped by `category` and ordered by profit in 
--descending order.

--7-Determine the most common payment method for each Branch.
--Display Branch and the preferred _ payment _ method .

SELECT * FROM sales_data

WITH cte
AS
(SELECT 
	branch,
	payment_method,
	COUNT(*) as total_trans,
	RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) desc) as rank
from sales_data
group by branch,payment_method
)
SELECT * FROM cte
WHERE rank = 1
--This query uses a Common Table Expression (CTE) to calculate the 
--total number of transactions (`total_trans`) for each payment method 
--per branch. It ranks the payment methods within each branch based on 
--transaction count in descending order. The outer query filters to show
--the top-ranked payment method for each branch.

--8-Cate+rize sales into 3 group MORNING, AFTERNOON, EVENING
--Find out each of the shift and number of invoices

SELECT * FROM sales_data

SELECT 
	branch, 
CASE 
		WHEN EXTRACT(HOUR FROM(time))  < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM(time))  BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END day_time,
	COUNT(*)
from sales_data
group by 1,2
ORDER BY 1,3 desc

--This query categorizes transactions into time periods (`Morning`,
--`Afternoon`, `Evening`) based on the hour extracted from the `time` 
--column. It groups the results by branch and time period (`day_time`) 
--and counts transactions for each group. Finally, it orders the results
--by branch and transaction count in descending order.


--9- Identity 5 branch with highest decrese ratio in
--revevenue compare to last year (current year 2023 and last year 2022)
--rdr == last_rev-cr_rev/ls_rev*100

WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM sales_data
    WHERE EXTRACT(YEAR FROM date) = 2022
    GROUP BY 1
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM sales_data
    WHERE EXTRACT(YEAR FROM date) = 2023
    GROUP BY 1
)
SELECT 
    ls.branch,
    ls.revenue AS last_year_revenue,
    cs.revenue AS cr_year_revenue,
    ROUND(
        ((ls.revenue - cs.revenue) * 1.0 / ls.revenue) * 100, 2
    ) AS rev_dec_ratio
FROM revenue_2022 AS ls
JOIN revenue_2023 AS cs 
ON ls.branch = cs.branch
WHERE ls.revenue > cs.revenue
ORDER BY rev_dec_ratio DESC;










