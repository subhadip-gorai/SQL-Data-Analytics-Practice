-- DAY 05: AGGREGATE FUNCTIONS --

use products;

-- Count Function --

-- Q1.Find the total number of products.
select count(Name) as Num_of_Products from products;


-- Sum Function --

-- Q2.Find the total stock. 
select sum(stock) as Total_Stock from products;


-- Min and Max Functions --

-- Q3.Find the minimum and maximum price together.
select min(price) as Min_Price, max(price) as Max_Price from products;


-- Round and Average Functions --

-- Q4.Find the average product price.
select round(avg(price),1) as Avg_Price from products;


-- Variance and Standard Deviation --

-- Q5.Find the variance and Standard Deviation of product prices.

select round((price)) as Variance_Price,
round((price)) as StdDev_Price 
from products;


-- Group By Clause --

-- Q6.Find the number of products in each category.

select category,
count(name) as Pro_Count from products
group by category;

-- Q7.Find the Total price of products in each color.

select color,
sum(price) as Total_Price from products
group by color;

-- Q8.Find the minimum and maximum price for each category.

select category,
min(price) as Low_Price,
max(price) as High_Price from products
group by category;

-- Q9.Group products by both category and brand and count the products.

select category, brand,
count(name) as Product_Count from products
group by category, brand;


-- Having Clause --

-- Q10.Find categories where the maximum product price is greater than 500. 

select category
from products
group by category
having max(price) > 500;

-- Q11.Find categories where total price exceed 600.

select category,
sum(price) as Total_Price
from products
group by category
having Total_Price > 600; 


-- Mixed Question Answers --

-- Q12.Find the top 3 categories by total price.

select category,
sum(price) as Total_Price from products
group by category
order by Total_Price desc
limit 3;

-- Q13.Find categories having: More than 5 products.

select category,
count(name) as Pro_Count from products
group by category
having Pro_Count > 5;

-- Q14.Find the category with the largest difference between maximum and minimum 
-- product price.

select category,
max(price) as Max_Price,
min(price) as Min_Price,
max(price) - min(price) as Price_Difference from products
group by category
order by Price_Difference desc
limit 1;

-- Q15.Find categories where the average price is higher than the 
-- overall average price.

select category,
round(avg(price)) as Avg_Price from products
group by category
having Avg_Price > (
select round(avg(price)) from products
);
