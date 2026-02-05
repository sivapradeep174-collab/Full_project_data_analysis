USE retail;
SELECT COUNT(*) 
FROM retail_analytics_dataset_column_based_filled;
SELECT SUM(total_amount) AS total_revenue
FROM retail_analytics_dataset_column_based_filled;
SELECT store_location,
       SUM(total_amount) AS revenue
FROM retail_analytics_dataset_column_based_filled
GROUP BY store_location;
CREATE TABLE customers AS
SELECT DISTINCT customer_id, customer_age, gender
FROM retail_analytics_dataset_column_based_filled;
select*from customers;
SELECT r.transaction_id,
       r.product_category,
       r.total_amount,
       c.customer_age,
       c.gender
FROM retail_analytics_dataset_column_based_filled r
JOIN customers c
ON r.customer_id = c.customer_id;
CREATE TABLE final_sales_analysis AS
SELECT
    transaction_id,
    customer_id,
    product_category,
    store_location,
    transaction_date,
    total_amount,
    COALESCE(discount_percent,0) AS discount_percent,
    total_amount * (1 - COALESCE(discount_percent,0)/100) AS net_revenue
FROM retail_analytics_dataset_column_based_filled;

SELECT AVG(total_amount) AS mean_sales
FROM retail_analytics_dataset_column_based_filled;
SELECT 
    AVG(total_amount) AS mean_sales
FROM retail_analytics_dataset_column_based_filled;

SELECT
    MIN(total_amount) AS min_sales,
    MAX(total_amount) AS max_sales
FROM retail_analytics_dataset_column_based_filled;

SELECT AVG(total_amount) AS median_sales
FROM (
    SELECT 
        total_amount,
        ROW_NUMBER() OVER (ORDER BY total_amount) AS rn,
        COUNT(*) OVER () AS total_rows
    FROM retail_analytics_dataset_column_based_filled
) t
WHERE rn IN (
    FLOOR((total_rows + 1) / 2),
    FLOOR((total_rows + 2) / 2)
);
SELECT 
    STDDEV(total_amount) AS std_dev_sales
FROM retail_analytics_dataset_column_based_filled;

CREATE TABLE sales_with_discount AS
SELECT
    *,
    total_amount * COALESCE(discount_percent, 0) / 100 AS discount_amount,
    total_amount * (1 - COALESCE(discount_percent, 0) / 100) AS net_revenue
FROM retail_analytics_dataset_column_based_filled;
 select*from sales_with_discount;
 SELECT
    MONTH(transaction_date) AS month,
    SUM(total_amount) AS monthly_sales
FROM retail_analytics_dataset_column_based_filled
GROUP BY MONTH(transaction_date)
ORDER BY month;


SELECT
    store_location,
    SUM(total_amount) AS total_sales
FROM retail_analytics_dataset_column_based_filled
GROUP BY store_location
ORDER BY total_sales DESC;

SELECT
    product_category,
    COUNT(*) AS total_transactions,
    SUM(total_amount) AS total_sales,
    AVG(total_amount) AS avg_sales
FROM retail_analytics_dataset_column_based_filled
GROUP BY product_category
ORDER BY total_sales DESC;
SELECT
    MONTH(transaction_date) AS month,
    SUM(total_amount - (total_amount * COALESCE(discount_percent,0)/100)) AS monthly_net_revenue
FROM retail_analytics_dataset_column_based_filled
GROUP BY MONTH(transaction_date)
ORDER BY month;

SELECT
customer_id,
total_amount,
case
when total_amount > 1000 then 'high spender'
when total_amount between 500 and 999 then 'medium spender'
when total_amount <= 499 then 'low spender'
else 'no data'
end 
as spender
from retail_analytics_dataset_column_based_filled;


