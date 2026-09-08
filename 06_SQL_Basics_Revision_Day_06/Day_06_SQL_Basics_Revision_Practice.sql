-- PRACTICING QUESTIONS BASED ON SQL BASICS --

-- Create Database --
create database product;
use product;

-- Create Table --
create table product_info (
Product_id int,
Product_Name text,
Category Varchar(50),
Price decimal(10,2),
Quantity int,
City varchar(50)
);

-- Insert Values --
insert into product_info values 
(1, "Laptop", "electronics", 55000, 10, "Kolkata"),
(2, 'Mouse', 'Electronics', 800, 25, 'Delhi'),
(3, 'Keyboard', 'Electronics', 1500, 15, 'Mumbai'),
(4, 'Chair', 'Furniture', 4500, 8, 'Kolkata'),
(5, 'Table', 'Furniture', 7000, 5, 'Delhi'),
(6, 'Monitor', 'Electronics', 12000, 12, 'Mumbai'),
(7, 'Notebook', 'Stationery', 120, 50, 'Kolkata'),
(8, 'Pen', 'Stationery', 20, 100, 'Delhi'),
(9, 'Headphones', 'Electronics', 2500, 20, 'Mumbai'),
(10, 'Desk Lamp', 'Furniture', 1800, 18, 'Kolkata');


-- Questions and Answers --

-- Q1.Find the total inventory value.

select Product_name, Price, Quantity,
Price * Quantity as Total_inventory_value 
from product_info;

-- Q2.Find the absolute difference between the maximum
-- and minimum price. 

select max(price) as Highest_Price,
min(price) as Lowest_price,
 max(price) - min(price) as Absolute_Difference
from product_info;

-- Q3.Find the number of products in each category.

select Category,
count(Product_id) as Count
from product_info
group by category;

-- Q4.Find the total inventory value for each category.

select Category,
sum(Price * Quantity) as Total_inventory_value 
from product_info
group by Category;

-- Q5.Display only categories where the average price is
-- greater than ₹3,000.

select Category,
avg(Price) as Avg_Price
from product_info
group by Category
having avg(Price) > 3000;

-- Q5.Find the city having the highest total quantity.

select City,
sum(quantity) as Highest_Total_Quantity
from product_info
group by city
order by sum(quantity) desc
limit 1;

-- 06.Extract the first and last 3 characters of every product name.

select Product_Name, 
left(Product_Name,3) as First_Char,
right(Product_Name,3) as last_Char
from product_info;

-- 07.Replace the word Laptop with Gaming Laptop. 

select product_name,
replace(product_name,"Laptop","Gaming Laptop") as Replace_Name
from product_info;

-- Q8.Reverse every product name.

select product_name,
reverse(product_name) as Reverse_Name
from product_info;

-- Q9.Add *** to the right of every product name using RPAD().

select product_name,
rpad(product_name,char_length(product_name) + 3,'*') as RPAD_Name
from product_info;

-- Q10.Find products whose names contain the letter e and whose
-- price is greater than ₹1,000.

select product_name, price
from product_info
where product_name like "%e%" and Price > 1000;

-- Q11.Find the average price of Electronics products.

select category,
Round(avg(price),2) as Avg_Price
from product_info
where category = "electronics";

-- Q12.Find the total inventory value for each city, then show only cities where
-- inventory value is greater than ₹100,000

select City,
sum(Price * Quantity) as Total_inventory_value 
from product_info
group by City
having sum(Price * Quantity) > 100000;

-- Q13.Find categories where:
-- 		total quantity > 30
-- 		AND average price > ₹1,000.

select category,
sum(quantity) as Total_quantity,
avg(price) as Avg_price
from product_info
group by category
having sum(quantity) > 30 and avg(price) > 1000;

-- Q14.Find products where:
-- 		price > average product price
-- 		AND quantity > 10.

select * from product_info
where price > (select round(avg(price),2) from product_info)
and
quantity > 10;

-- Q15.Find products whose name contains the letter o, then:
-- 		convert name to uppercase
-- 		show name length
-- 		show price
-- 		sort by price descending.

select product_name,
upper(product_name) as Name,
length(product_name) as Lenth_Name,
price
from product_info
where product_name like '%o%'
order by price desc;

-- Q16.Find the category with the highest average price. 

select Category,
avg(price) as Highest_Avg_Price
from product_info
group by category
order by avg(price) desc
limit 1;

-- Q17.Find categories containing at least 2 products and having an average price 
-- 		greater than ₹2,000.

select Category,
avg(price) as Avg_Price
from product_info
group by category
having count(*) >= 2
and avg(price) > 2000;

-- Q18.For each category, display: 
-- 		category -- product_count -- total_quantity 
-- 		average_price -- minimum_price -- maximum_price
-- 		Only show categories where product_count >= 2.

select Category,
count(product_id) as Product_Count,
sum(quantity) as Total_Quantity,
avg(price) as Avg_Price,
min(price) as Lowest_Price,
max(price) as Highest_Price
from product_info
group by category
having count(product_id) > 2;

-- Q19.Create a query that produces a report like:
-- 	Requirements:
-- 		Count products
-- 		Calculate total quantity
-- 		Calculate average price
-- 		Find maximum price
-- 		Calculate total inventory value
-- 		Group by category
-- 		Only include categories with total quantity > 20
-- 		Sort by total inventory value descending

select Category,
count(product_id) as Count_Product,
sum(quantity) as Total_Quantity,
avg(price) as Avg_Price,
max(price) as Highest_Price,
sum(price * quantity) as Total_inventory
from product_info
group by category
having sum(quantity) > 20
order by sum(price * quantity) desc;



