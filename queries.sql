-- Walmart Project Queries - MySQL

SELECT * FROM walmart;

select distinct payment_method from walmart;

SELECT payment_method, COUNT(*)
FROM walmart
GROUP BY payment_method;

select count(distinct branch) from walmart;

----------------------------
-- Walmart Data Analysis    
----------------------------

-- 1. Find different payment method and number of transactions, number of qty sold

SELECT payment_method, COUNT(*) transactions,sum(quantity) qty_sold
FROM walmart
GROUP BY payment_method;

-- 2. Identify the highest-rated category in each branch, displaying the branch, category AVG RATING
select * from(
SELECT branch, category , AVG(rating) as avg_rating, RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) as rank
FROM walmart
GROUP BY 1, 2
-- ORDER BY 1, 3 DESC;
)
where rank=1;

-- 3. Identify the busiest day for each branch based on the number of transactions

select * from(
SELECT branch, TO_CHAR(TO_DATE (date ,'DD/MM/YY'),'Day') as day_name,COUNT(*) as no_transactions,
	RANK() Over( PARTITION BY branch order by count(*) DESC) as rank
FROM walmart
GROUP BY 1, 2
-- ORDER BY 1, 3 DESC;
)
where rank=1;


-- 4. Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.

SELECT payment_method,sum(quantity) qty_sold
FROM walmart
GROUP BY payment_method;


-- 5. Determine the average, minimum, and maximum rating of category for each city. List the city, average_raling, min_rating, and max_rating.

select city,category ,
	MIN (rating) as min_rating,
	MAX(rating) as max_rating,
	AVG(rating) as avg_rating
FROM walmart
GROUP BY 1, 2;


-- 6. Calculate the total profit for each category by considering total_profit as (unit_price * quantity * profit_margin). 
-- 	  List category and total_profit, ordered from highest to lowest profit.

select category, SUM(total) as total_revenue , SUM(total * profit_margin) as profit
FROM walmart
GROUP BY 1;


-- 7. Determine the most common payment method for each Branch. Display Branch and the preferred_payment_method.

select * from
(SELECT branch, payment_method ,count(*) total_trans, RANK() OVER(PARTITION BY branch ORDER BY COUNT (*) desc) rank
FROM walmart
GROUP BY 1,2
)
where rank=1;


-- 8. Categorize sates into 3 group MORNING, AFTERNOON, EVENING. Find out each of the shift and number of invoices


SELECT branch,
	CASE
		WHEN EXTRACT(HOUR FROM (time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM (time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
END day_time,
count(*)
FROM walmart
GROUP BY 1,2
order by 1,3 desc;


-- 9. Identify 5 branch with highest decrese ratio in revevenue compare to last year (current year 2023 and last year 2022)

WITH revenue_2022 AS (
    SELECT branch, SUM(total) AS revenue
    FROM walmart
    WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022
    GROUP BY 1
),
revenue_2023 AS (
    SELECT branch, SUM(total) AS revenue
    FROM walmart
    WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
    GROUP BY 1
)
SELECT
    ls.branch,
    ls.revenue AS last_year,
    cs.revenue AS cur_year,
    (cs.revenue - ls.revenue) AS revenue_growth,
    ROUND(((cs.revenue - ls.revenue) / NULLIF(ls.revenue, 0)) * 100, 2) AS growth_percentage
FROM revenue_2022 AS ls
JOIN revenue_2023 AS cs ON ls.branch = cs.branch;

