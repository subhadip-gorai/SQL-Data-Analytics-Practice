-- DAY 04: DATA TRANSFORMATION & STRING OPERATIONS --

create database KJS;
use kjs;

CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price VARCHAR(20),
    description VARCHAR(100),
    supplier VARCHAR(50)
);

INSERT INTO products
VALUES
(1, 'Laptop', 'Electronics', '55000', 'HP Laptop', 'TechWorld'),
(2, 'wireless mouse', 'Accessories', '1200', 'Wireless Mouse', 'LogiTech'),
(3, 'KEYBOARD', 'Accessories', '1800', 'Mechanical Keyboard', 'KeyPro'),
(4, 'USB Cable', 'Accessories', '', 'Type C Cable', 'CableTech'),
(5, 'Monitor', 'Electronics', NULL, '24 Inch Monitor', 'ViewTech'),
(6, 'headphones', 'Audio', '2500', 'Bluetooth Headphones', 'SoundMax'),
(7, 'Smart Watch', 'Wearables', '4500', 'Fitness Smart Watch', 'TimeTech'),
(8, 'Power Bank', 'Accessories', '2000', 'Fast Charging Power Bank', NULL);


-- Data Transfer Operation --

-- Q1.Create a new table called products_backup and copy all records from products into it.

create table products_backup (
	product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price VARCHAR(20),
    description VARCHAR(100),
    supplier VARCHAR(50)
);

insert into products_backup
select * from products;

-- Q2.Copy only product_id, product_name, and category into another table called
-- product_summary.

create table product_summary (
	product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50)
);

insert into product_summary
select product_id, product_name, category from products;


-- Change Data Type --

-- Q3.Convert name into text datatype.

alter table products 
modify column product_name text;


-- NULL & Empty Values --

-- Q4.Find products where price is NULL.

select * from products where price is NULL;

-- Q5.Find products where price is an empty string.

select * from products where price = '';


-- UPPER, LOWER & LENGTH --

-- Q6.Product name in uppercase.

select product_name, upper(product_name) as U_Name from products;

-- Q7.Product name in lowercase.

select product_name, lower(product_name) as L_Name from products;

-- Q8.Find the length of every product_name.

select product_name, length(product_name) as len_Name from products;

-- Q9.Find the longest product name.

select product_name, length(product_name) as Long_Name
from products
order by Long_Name desc
limit 1;

-- Q10.Find the shortest product name.

select product_name, length(product_name) as Short_Name
from products
order by Short_Name Asc
limit 1;

-- Q11.Find products where the name contains more than 10 characters.

SELECT *
FROM products
WHERE LENGTH(product_name) > 10;


-- Combine Columns --

-- Q12.Combine product_name and category.

select product_name, category, concat(product_name,' ',category) as Name_Cate
from products;


-- Extract Specific Characters --

-- Q13.Extract First 5 caracters from product names.

select product_name, left(product_name,5) as LE_Name from products;

-- Q14.Extract last 5 caracters from product names.

select product_name, Right(product_name,5) as RE_Name from products;

-- Q15.Extract characters from 5th position to next 4 charactrers in name column.

select product_name, substring(product_name,5,4) from products;


-- TRIM --

-- Q16.LTrim
select ltrim("  Laptop  ") from products;

-- Q17.RTrim
select rtrim("  Laptop  ") from products;

-- Q18.Trim
select trim("  Laptop  ") from products;


-- LPAD and RPAD --

-- Q19.Convert product_id into a 5-character ID.

select product_id, lpad(product_id,5,'0') as New_ID from products;

-- Q20.Make every product name exactly 15 characters by adding *.

select product_name, rpad(product_name,15,'*') as New_Name from products;


-- Reverse and Replace --

-- Q21.Reverse every product_name.
select product_name, reverse(product_name) as Rev_Name from products;

-- Q22.Replace Laptop with Notebook. 
select product_name, replace(product_name,"Laptop","Notebook") as Rep_Name
from products;

-- Q23.Replace spaces in product_name with _.
select product_name, replace(product_name," ","_") as Rep_Name
from products;


