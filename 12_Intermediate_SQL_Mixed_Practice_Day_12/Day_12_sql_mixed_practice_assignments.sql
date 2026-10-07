-- DAY 12 - INTERMEDIATE SQL PRACTICE --

-- Practice Database --

-- Create Database --
CREATE DATABASE sales_analytics;
USE sales_analytics;

-- Create customers Table --
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    signup_date DATE NOT NULL
);

-- Create products Table --
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) CHECK (price > 0),
    stock_quantity INT DEFAULT 0
);

-- Create orders Table --
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    order_status VARCHAR(30) DEFAULT 'Pending',
    
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- Create order_details Table --
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT CHECK (quantity > 0),
    unit_price DECIMAL(10,2) CHECK (unit_price > 0),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- Insert Customers Table data --
INSERT INTO customers
(customer_id, customer_name, email, city, signup_date)
VALUES
(1, 'Rahul Sharma', 'rahul@gmail.com', 'Hyderabad', '2025-01-15'),
(2, 'Priya Das', 'priya@gmail.com', 'Kolkata', '2025-02-20'),
(3, 'Amit Roy', 'amit@gmail.com', 'Delhi', '2025-03-10'),
(4, 'Sneha Paul', 'sneha@gmail.com', 'Hyderabad', '2025-04-05'),
(5, 'Arjun Singh', 'arjun@gmail.com', 'Mumbai', '2025-05-18'),
(6, 'Neha Gupta', 'neha@gmail.com', 'Pune', '2025-06-12'),
(7, 'Rohan Das', 'rohan@gmail.com', 'Kolkata', '2025-07-25'),
(8, 'Ananya Sen', 'ananya@gmail.com', 'Delhi', '2025-08-14');

-- Insert Products Table data --
INSERT INTO products
(product_id, product_name, category, price, stock_quantity)
VALUES
(101, 'Laptop', 'Electronics', 65000, 15),
(102, 'Wireless Mouse', 'Accessories', 1200, 50),
(103, 'Mechanical Keyboard', 'Accessories', 3500, 30),
(104, 'Monitor', 'Electronics', 18000, 20),
(105, 'Headphones', 'Accessories', 2500, 40),
(106, 'Smartphone', 'Electronics', 45000, 25),
(107, 'USB-C Cable', 'Accessories', 800, 100),
(108, 'External Hard Drive', 'Storage', 6500, 18);

-- Insert Orders Table data --
INSERT INTO orders
(order_id, customer_id, order_date, order_status)
VALUES
(1001, 1, '2025-08-01', 'Completed'),
(1002, 2, '2025-08-03', 'Completed'),
(1003, 3, '2025-08-05', 'Pending'),
(1004, 1, '2025-08-10', 'Completed'),
(1005, 4, '2025-08-12', 'Cancelled'),
(1006, 5, '2025-08-15', 'Completed'),
(1007, 6, '2025-08-18', 'Completed'),
(1008, 7, '2025-08-20', 'Pending'),
(1009, 8, '2025-08-22', 'Completed'),
(1010, 3, '2025-09-01', 'Completed'),
(1011, 2, '2025-09-05', 'Completed'),
(1012, 5, '2025-09-10', 'Pending');

-- Insert Order Details Table data --
INSERT INTO order_details
(order_detail_id, order_id, product_id, quantity, unit_price)
VALUES
(1, 1001, 101, 1, 65000),
(2, 1001, 102, 2, 1200),

(3, 1002, 104, 1, 18000),
(4, 1002, 105, 1, 2500),

(5, 1003, 106, 1, 45000),
(6, 1003, 107, 2, 800),

(7, 1004, 103, 1, 3500),
(8, 1004, 105, 2, 2500),

(9, 1005, 101, 1, 65000),

(10, 1006, 106, 1, 45000),
(11, 1006, 108, 1, 6500),

(12, 1007, 102, 3, 1200),
(13, 1007, 103, 1, 3500),

(14, 1008, 104, 2, 18000),

(15, 1009, 101, 1, 65000),
(16, 1009, 107, 3, 800),

(17, 1010, 108, 2, 6500),
(18, 1010, 105, 1, 2500),

(19, 1011, 102, 2, 1200),
(20, 1011, 106, 1, 45000),

(21, 1012, 103, 2, 3500),
(22, 1012, 107, 4, 800);


-- Q1.Find orders placed during August 2025.

SELECT order_id, order_date FROM orders
WHERE order_date >= '2025-08-01'
AND order_date < '2025-09-01';

-- Q2.Find the number of days between each customer's signup date and their first order date.

SELECT c.customer_id,
datediff(min(o.order_date), c.signup_date) as first_order_date
FROM orders o JOIN customers c
ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Q3.Find the number of months between each customer's signup date and today.

SELECT timestampdiff(month, signup_date, current_date) FROM customers;

-- Q4.Find the number of orders placed in each month.

SELECT monthname(order_date) as month_name,
count(*) FROM orders GROUP BY month_name;

SELECT date_format(order_date, '%M') as month_name,
count(*) FROM orders GROUP BY month_name;

-- Q5.Find customers who have never placed an order.

SELECT DISTINCT o.customer_id, c.customer_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.customer_id is null;

-- Q6.Display each customer's total spending.

SELECT o.customer_id, 
SUM(quantity * unit_price) AS Total_spent
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
GROUP BY o.customer_id;

-- Q7.Calculates total spending for each customer.
-- Find customers whose spending is greater than the average customer spending.

WITH Customer_Spending AS
(SELECT o.customer_Id, sum(od.quantity * od.unit_price) as Total_Spending 
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY o.customer_Id)

SELECT * FROM Customer_Spending WHERE
total_spending > (SELECT avg(total_spending) FROM Customer_Spending);

-- Q8.Customer total orders, Customer total spending.
-- 	  Display both metrics.

WITH Customer_total_orders AS
(SELECT customer_id, count(order_id) AS Total_order
FROM orders GROUP BY customer_id),

Customer_Spending AS
(SELECT o.customer_Id,
sum(od.quantity * od.unit_price) as Total_Spending 
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY o.customer_Id)

SELECT cto.customer_id, cto.Total_Order, cs.Total_spending
FROM Customer_Spending cs JOIN Customer_total_orders cto
ON cto.Customer_id = cs.Customer_id;

-- Q9.Find customers whose spending is greater than the average customer spending.

WITH Customer_Total_Spending AS
(SELECT o.Customer_Id,
sum(od.quantity * od.unit_price) as Total_Spending
FROM orders o JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.Customer_Id)

SELECT * FROM Customer_Total_Spending
WHERE total_spending > (
SELECT avg(total_spending)
FROM Customer_Total_Spending
);

-- Q10.Find the product with the second-highest product price using Subqueries.

SELECT * FROM products
WHERE price = (
SELECT max(price) FROM products
WHERE price < (
SELECT max(price) FROM products
)
);

-- Q11.Find customers who have placed at least one order.

SELECT * FROM customers
WHERE customer_id IN (
SELECT customer_id
FROM orders
);

-- Q12.Find products that have never appeared in order_details.

-- 1st Approch --
SELECT p.* 
FROM products p LEFT JOIN order_details od
ON p.product_id = od.product_id
WHERE od.product_id is NULL;

-- 2nd Approch --
SELECT * FROM products
WHERE product_id NOT IN (
SELECT product_id
FROM order_details
);

-- Q13.Find orders whose total value is greater than the average order value. 

WITH Avg_orders AS
(SELECT SUM(quantity * unit_price) as Total_Value
FROM order_details GROUP BY order_id )

SELECT order_id,
SUM(quantity * unit_price) AS Total_Value
FROM order_details
GROUP BY order_id
HAVING SUM(quantity * unit_price) > ( 
SELECT avg(Total_Value)
FROM Avg_orders
);

-- Q14.For every product, display its price and the number of products
-- that are more expensive than it.
-- Expected concept:	product_name | price | more_expensive_products.

SELECT p.product_name, p.price, 
 ( 
SELECT count(*) 
FROM products p2
WHERE p2.price > p.price
) AS more_expensive_products
FROM products p;

-- Q15.Find products that are the most expensive within their category.

SELECT product_name, category, price
FROM products p
WHERE price = (
SELECT max(price)
FROM products
WHERE category = p.category
);

-- Q16.For every customer, count how many other customers
--     have placed more orders than that customer.

SELECT c.customer_id, c.customer_name,
count(o.order_id) as total_orders,
(
SELECT count(*)
FROM customers c2
WHERE (
SELECT count(o2.order_id)
FROM orders o2
WHERE o2.customer_id = c2.customer_id
)
>
count(o.order_id)
) AS customers_with_more_orders

FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- Q17.Find customers whose total spending is greater than every
-- 	   other customer's average spending in the same city.

WITH Customer_Spending AS
(SELECT c.customer_id, c.Customer_name, c.city,
sum(od.quantity * od.unit_price) as Total_spending
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.Customer_name, c.city
)

SELECT cs.customer_id, cs.Customer_name,
cs.city, cs.Total_spending
FROM Customer_Spending cs
WHERE cs.Total_spending > (
SELECT avg(other.Total_spending)
FROM customer_spending other
WHERE other.city = cs.city
AND other.customer_id <> cs.customer_id
);

-- Q18.Find customers whose total spending is greater than the average spending of all customers.

WITH customer_totals AS
(SELECT c.customer_id, c.customer_name,
sum(od.quantity * od.unit_price) as total_spending
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name)

SELECT customer_id, customer_name,
total_spending FROM customer_totals
WHERE total_spending > (
SELECT avg(total_spending)
FROM customer_totals
);

-- Q19.Category Analysis
-- 		For every category display:
-- 		category, number_of_products, average_price, total_stock, total_revenue.

WITH Product_summary AS
(SELECT category, count(product_id) as number_of_products,
avg(price) as average_price, sum(stock_quantity) as total_stock
FROM products GROUP BY category),

revenue_summary AS
(SELECT p.category,
sum(od.quantity * od.unit_price) as total_revenue
FROM products p JOIN order_details od
ON p.product_id = od.product_id
GROUP BY p.category)

SELECT ps.category, ps.number_of_products,
ps.average_price, ps.total_stock, rs.total_revenue
FROM Product_summary ps JOIN revenue_summary rs
ON ps.category = rs.category;

-- Q20.Customer First Order
-- 		For every customer who has ordered, find: customer_name, first_order_date.

SELECT c.customer_name,
min(order_date) AS first_order_date
FROM customers c JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- Q21.Customer Order Gap
-- 		Find the number of days between each customer's signup date and their first order date.
-- 		Display: customer_name, signup_date, first_order_date, days_to_first_order.

SELECT c.customer_name, c.signup_date,
min(o.order_date) AS first_order_date,
datediff(min(o.order_date), c.signup_date) AS days_to_first_order
FROM orders o JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.signup_date;

-- Q22.Find the most expensive product from every category.

SELECT  p.product_name, p.category, p.price
FROM products p
WHERE p.price = (
SELECT max(p2.price)
FROM products p2
WHERE p2.category = p.category
);

-- Q23.Final Data Analyst Challenge 
-- 		Create a customer-level sales report containing:
-- 		customer_name, city, signup_date, first_order_date, total_orders,
-- 		total_items, total_spending, average_order_value, customer_segment.
-- 		Customer segment:
-- 			total_spending >= 70000 → Platinum, total_spending >= 40000 → Gold,
-- 			total_spending >= 20000 → Silver, otherwise → Bronze.

WITH Customer_analysis AS
(SELECT c.customer_name, c.city, c.signup_date,
min(o.order_date) AS first_order_date,
count(DISTINCT o.order_id) AS total_orders,
sum(od.quantity) AS total_items,
round(sum(od.quantity * unit_price),2) AS total_spending
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY customer_name, city, signup_date)

SELECT customer_name, city, signup_date,
first_order_date, total_orders,
total_items, total_spending,
round(total_spending/total_orders, 2) AS average_order_value,
CASE
WHEN total_spending >= 70000 THEN 'Platinum'
WHEN total_spending >= 40000 THEN 'Gold'
WHEN total_spending >= 20000 THEN 'Silver'
ELSE 'Bronze' END AS customer_segment
FROM Customer_analysis;

















