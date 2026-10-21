-- DAY 12: SQL Financial Transaction Analysis Questions & Answers --

CREATE DATABASE Exam_2;
USE Exam_2;

-- Import Data --
SHOW TABLES;
SELECT * FROM transactions;
SELECT * FROM countries;
SELECT * FROM currencies;
SELECT * FROM users;
SELECT * FROM merchants;


-- Q1.Determine the top 5 countries by total transaction amount for both sending and receiving funds
-- in the last quarter of 2023 (October to December 2023). Provide separate lists for the countries
-- that sent the most funds and those that received the most funds. Additionally,
-- round the totalsent and totalreceived amounts to 2 decimal places.

SELECT c.country_name,
round(sum(t.transaction_amount), 2) as total_sent
FROM transactions t
JOIN users u ON u.user_id = t.sender_id
JOIN countries c ON u.user_id = c.country_id
WHERE t.transaction_date >= '2023-10-01'
AND t.transaction_date < '2024-01-01'
GROUP BY c.country_name
ORDER BY total_sent DESC
LIMIT 5;

SELECT c.country_name,
round(sum(t.transaction_amount), 2) as total_sent
FROM transactions t
JOIN users u ON u.user_id = t.recipient_id
JOIN countries c ON u.user_id = c.country_id
WHERE t.transaction_date >= '2023-10-01'
AND t.transaction_date < '2024-01-01'
GROUP BY c.country_name
ORDER BY total_sent DESC
LIMIT 5;

-- Q2.Your task is to analyze the transaction data and determine the top 10 merchants,
-- sorted by the total transaction amount they received, within the period from
-- November 2023 to April 2024. For each of these top 10 merchants, provide
-- the following details: merchant ID, business name, the total transaction amount received,
-- and the average transaction amount.

SELECT m.merchant_id, m.business_name,
SUM(t.transaction_amount) AS total_received,
AVG(t.transaction_amount) AS average_transaction
FROM transactions t JOIN merchants m
ON m.merchant_id = t.recipient_id
WHERE t.transaction_date BETWEEN '2023-11-01' AND '2024-04-30'
GROUP BY m.merchant_id, m.business_name
ORDER BY total_received DESC
LIMIT 10;

-- Q3.Categorize transactions as 'High Value' (above $10,000) or 'Regular'
-- (less than or equal to $10,000) and calculate the total amount for
-- each category for the year 2023.

SELECT
CASE WHEN transaction_amount > 10000 THEN 'High Value'
ELSE 'Regular' END AS transaction_category,
sum(transaction_amount) AS total_amount
FROM transactions
WHERE year(transaction_date) = '2023'
GROUP BY transaction_category;

-- Q4.To meet compliance requirements, the finance team needs to identify the nature of transactions
-- conducted by the company. Specifically, you are required to analyze transaction data for the
-- first quarter of 2024 (January to March).

-- Your task is to create a new column in the dataset that indicates whether each transaction is
-- international (where the sender and recipient are from different countries) or
-- domestic (where the sender and recipient are from the same country).
-- Additionally, provide a count of the number of international and
-- domestic transactions for this period.

SELECT
CASE WHEN sender.country_id <> recipient.country_id THEN 'International'
ELSE 'Domestic' END AS transaction_type,
count(*) AS transaction_count
FROM transactions t
JOIN users sender ON t.sender_id = sender.user_id
JOIN users recipient ON t.recipient_id = recipient.user_id
WHERE transaction_date >= '2024-01-01' AND transaction_date < '2024-04-01'
GROUP BY transaction_type;

-- Q5.Your task is to calculate the average transaction amount per user
-- (Round up to 2 Decimal Places) for the past six months, covering the period from 1 November 2023
-- (inclusive) to 1 May 2024(exclusive). Once you have the average transaction amount for each user,
-- identify and list the users whose average transaction amount exceeds $5,000.

SELECT u.user_id, u.email,
ROUND(AVG(t.transaction_amount), 2) as avg_amount
FROM transactions t JOIN users u 
ON t.sender_id = u.user_id 
WHERE t.transaction_date >= '2023-11-01'
AND t.transaction_date < '2024-05-01'
GROUP BY u.user_id, u.email
HAVING avg_amount > 5000
ORDER BY u.user_id ASC;

-- Q6.As part of identifying top customers for a new loyalty program, the finance team needs to find
-- the most valuable customer over the past year. Specifically, your task is to determine the user
-- who has the highest total transaction amount from May 22, 2023, to May 22, 2024.
-- Please provide the details of this user, including their user ID, name, and
-- total transaction amount.

SELECT u.user_id, u.email, u.name,
ROUND(SUM(t.transaction_amount), 2) as total_amount
FROM transactions t JOIN users u  
ON t.sender_id = u.user_id
WHERE t.transaction_date >= '2023-05-22'
AND t.transaction_date < '2024-05-22'
GROUP BY u.user_id, u.email, u.name
ORDER BY total_amount DESC
LIMIT 1;

-- Q7.The finance team is analyzing currency conversion trends to manage exposure to currency risks.
-- Which currency had the highest transaction amount from in the past one year up to today
-- indicating the greatest exposure? (assume today is 22-05-2024)

SELECT currency_code,
sum(transaction_amount) AS Total_amount
FROM transactions
WHERE transaction_date > '2023-05-22'
AND transaction_date <= '2024-05-22'
GROUP BY currency_code
ORDER BY Total_amount DESC LIMIT 1;

-- Q8.The sales team wants to identify top-performing merchants. Which merchant should be
-- considered as the most successful in terms of total transaction amount received between
-- November 2023 and April 2024?

SELECT m.merchant_id, m.business_name,
sum(t.transaction_amount) AS total_amount
FROM merchants m JOIN transactions t
ON m.merchant_id = t.recipient_id
WHERE t.transaction_date >= '2023-11-01'
AND t.transaction_date < '2024-05-01'
GROUP BY m.merchant_id, m.business_name
ORDER BY total_amount DESC LIMIT 1;

-- Q9.As part of a financial analysis, the team needs to categorize transactions based on
-- multiple criteria. Create a report that categorizes transactions into 'High Value International',
-- 'High Value Domestic', 'Regular International', and 'Regular Domestic' based on
-- the following criteria:
-- 		High Value: transaction amount > $10,000
-- 		International: sender and recipient from different countries

-- Write a query to categorize each transaction and count the number of transactions
-- in each category for the year 2023.

SELECT CASE
WHEN transaction_amount > 10000 AND sender.country_id <> recipient.country_id
THEN 'High Value International'
WHEN transaction_amount > 10000 AND sender.country_id = recipient.country_id
THEN 'High Value Domestic'
WHEN transaction_amount <= 10000 AND sender.country_id <> recipient.country_id
THEN 'Regular International'
ELSE 'Regular Domestic' END AS transaction_category,
COUNT(*) AS transaction_count
FROM transactions t
JOIN users sender ON t.sender_id = sender.user_id
JOIN users recipient ON t.recipient_id = recipient.user_id
WHERE year(transaction_date) = '2023'
GROUP BY transaction_category;

-- Q10.The finance department requires a comprehensive monthly report for the year 2023 that
-- segments transactions by type and nature. Specifically, the report should classify transactions
-- into 'High Value' (above $10,000) and 'Regular' (below $10,000), and further differentiate them
-- as either 'International' (sender and recipient from different countries) or
-- 'Domestic' (sender and recipient from the same country).

-- Your task is to write a query that groups transactions by year, month, value_category,
-- location_category, and then calculates both the total transaction amount and the average
-- transaction amount for each group. This detailed analysis will provide valuable insights into
-- transaction patterns and help the finance department in their review and planning processes.
-- 		The returned table should contain the transaction\_year, transaction\_month, value\_category,
-- 		location\_category in ascending order.
-- 		Round the total_amount and average_amount to 2 decimal places.

SELECT year(transaction_date) AS transaction_year,
month(transaction_date) AS transaction_month,
CASE WHEN transaction_amount > 10000 THEN 'High Value'
ELSE 'Regular' END AS value_category,
CASE WHEN sender.country_id <> recipient.country_id THEN 'International'
ELSE 'Domestic' END AS location_category,
ROUND(SUM(transaction_amount), 2) AS total_amount,
ROUND(AVG(transaction_amount), 2) AS average_amount
FROM transactions t
JOIN users sender ON t.sender_id = sender.user_id
JOIN users recipient ON t.recipient_id = recipient.user_id
WHERE year(transaction_date) = '2023'
GROUP BY transaction_year, transaction_month, value_category, location_category
ORDER BY transaction_year, transaction_month, value_category, location_category ASC;

-- Q11.The sales team wants to evaluate the performance of merchants by creating a score based on
-- their transaction amounts. The score is calculated as follows:

-- If total transactions exceed $50,000, the score is 'Excellent'
-- If total transactions are greater than $10,000 and lesser than or equal to $20,000,
-- the score is 'Average'
-- If total transactions are lesser than or equal to $10,000, the score is 'Below Average'

-- Write a query to assign a performance score to each merchant and calculate the average transaction
-- amount for each performance category for the period from November 2023 to April 2024.

SELECT m.merchant_id, m.business_name,
ROUND(SUM(t.transaction_amount),2) AS total_received,
CASE 
    WHEN SUM(t.transaction_amount) > 50000 THEN 'Excellent'
    WHEN SUM(t.transaction_amount) > 20000 THEN 'Good'
    WHEN SUM(t.transaction_amount) > 10000 THEN 'Average'
    ELSE 'Below Average' END AS performance_score,
ROUND(AVG(t.transaction_amount), 2) AS average_transaction
FROM merchants m JOIN transactions t
ON m.merchant_id = t.recipient_id
WHERE t.transaction_date >= '2023-11-01' AND t.transaction_date < '2024-05-01'
GROUP BY m.merchant_id, m.business_name
ORDER BY
CASE
WHEN SUM(t.transaction_amount) > 50000 THEN 1
WHEN SUM(t.transaction_amount) > 20000 THEN 2
WHEN SUM(t.transaction_amount) > 10000 THEN 3
ELSE 4
END ASC,
total_received DESC;

-- Q12.Write a query to list user IDs and their email addresses for users who have made at least one
-- transaction in at least 6 out of 12 months from May 2023 to April 2024.

SELECT u.user_id, u.email
FROM users u JOIN transactions t
ON u.user_id = t.sender_id
WHERE t.transaction_date >= '2023-05-01' AND t.transaction_date < '2024-05-01'
GROUP BY u.user_id, u.email
HAVING COUNT(DISTINCT(date_format(t.transaction_date, '%Y-%m'))) >= 6
ORDER BY u.user_id;

-- Q13.Write a query that calculates the total transaction amount for each merchant by month, and then
-- create a column to indicate whether the merchant exceeded $50,000 in that month. The transaction date
-- range should be considered from 1st Nov 2023 to 1st May 2024 (inclusive).
-- The new column should contain the values 'Exceeded $50,000' or 'Did Not Exceed $50,000'.
-- Display the merchant ID, business name, transaction year, transaction month, total transaction amount
-- (rounding to 2 decimal place), and the new column indicating performance status.

SELECT m.merchant_id, m.business_name,
year(t.transaction_date) AS transaction_year,
month(t.transaction_date) AS transaction_month,
ROUND(SUM(t.transaction_amount), 2) AS total_transaction_amount,
CASE WHEN SUM(t.transaction_amount) > 50000 THEN 'Exceeded $50,000'
ELSE 'Did Not Exceed $50,000' END AS performance_status
FROM merchants m JOIN transactions t 
ON m.merchant_id = t.recipient_id
WHERE transaction_date >= '2023-11-01' AND transaction_date < '2024-05-02'
GROUP BY m.merchant_id, m.business_name, transaction_year, transaction_month
ORDER BY merchant_id, transaction_year, transaction_month ASC;














