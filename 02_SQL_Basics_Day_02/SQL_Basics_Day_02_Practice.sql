create database TCS;
use tcs;

-- Create Table --

create table employees (
id int,
name varchar(50),
department varchar(50),
city varchar(50),
salary int,
age int
);


-- Insert data in a column --

insert into employees values
(331, 'Subhadip', 'IT', 'Kolkata', 50000, 28),
(375, 'Riya', 'HR', 'Delhi', 75000, 25),
(485, 'Amit', 'IT', 'Mumbai', 150000, 26),
(781, 'SumanDwip', 'Sales', 'Kolkata', 65000, 28),
(568, 'Rajlaxmi', 'HR', 'Jaipur', 42000, 30),
(482, 'Pooja', 'HR', 'Delhi', 35000, 29),
(758, 'Pratap', 'IT', 'Kolkata', 84000, 28),
(748, 'Gaurab', 'IT', 'Kolkata', 44000, 28),
(158, 'Rajdeep', 'Sales', 'Mumbai', 35000, 25),
(928, 'Suresh', 'HR', 'Delhi', 72000, 29);

show tables;
describe employees;
select * from employees;


-- Find unique values --

select distinct department from employees;

select distinct city from employees;

select distinct department,city from employees;


-- Logical Operators --

-- AND --
select * from employees where department = 'IT' and salary > 50000;

select * from employees where age > 27 and salary < 50000;

select * from employees where department = 'IT' and city = 'Mumbai';

-- OR --
select * from employees where department = 'HR' or department = 'Sales';

select * from employees where city = 'Kolkata' or city = 'Mumbai';

select * from employees where city = 'Kolkata' or department = 'HR';

-- NOT --
select * from employees where city != 'Delhi';

select * from employees where not department = 'IT';

select * from employees where salary > 40000 or department != 'HR';


-- Pattern Matching --

-- Find employees whose name start with letter A
select * from employees where name like "A%";

-- Find employees whose name ends with letter A
select * from employees where name like "%A";

-- Find employees whose name contains i 
select * from employees where name like "%i%";

-- Find employees whose city start with M
select * from employees where city like "M%";

-- Find employees whose name start with R and has exactly 4 characters
select * from employees where name like "R___";


-- Practice Challenge Questions --

-- Q1.Find the unique cities where employees with salary grater than 40000 live
select distinct city from employees where salary > 40000;

-- Q2.Find employees who:
-- are from IT or Sales
-- and salary is greater than 45000
select * from employees where (department = "IT" or department  = "Sales") and salary > 45000;

-- Q3.Find unique departments of employees who are not from Delhi
select distinct department from employees where city != "Delhi";

-- Q4.Find employees who are from Kolkata, have salary greater than 40000, 
-- and whose name start with S
select * from employees where city = "Kolkata" and salary > 40000
and name like 'S%';