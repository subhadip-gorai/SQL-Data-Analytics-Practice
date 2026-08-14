-- DAY 03: SQL CRUD OPERATIONS --

use tcs;
show tables;
desc employees;
select * from employees;


-- INSERT Data (DML Statement) --

insert into employees values
(781, 'Tamal', 'Manager', 'Holdiya', 45000, 32),
(627, 'Bapi', 'IT', 'Delhi', 35000, 24),
(781, 'Jayanta', 'HR', 'Kolkata', 35000, 32);


-- LIMIT Clause --

-- Q1.Display the first 5 employees.
select * from employees limit 5;

-- Q2.Display the first 3 employees with only name and salary.
select name,salary from employees limit 3;


-- ORDER BY Clause--

-- Q3.Sort employees by age from youngest to oldest. 
select * from employees 
order by age;

-- Q4.Sort employees by name alphabetically.
select * from employees 
order by name;

-- Q5.Sort employees by department alphabetically and salary highest to lowest. 
select * from employees 
order by department asc, salary desc;

-- Q6.Display the Top 5 highest-paid employees.
select * from employees 
order by salary desc 
limit 5;

-- OFFSET Clause --

-- Q7.Skip the first 5 employees and display the next 3 employees
select * from employees limit 3 offset 5;

-- Q8.Find the employee who has 2nd highest salary.
select * from employees order by salary desc limit 1 offset 1;


-- UPDATE Data (DML Statement) --

set SQL_Safe_updates = 0;

-- Q9.Change pratap's city from Hydrabaad to Kolkata.
update employees 
set city = 'Kolkata' 
where name = 'Pratap';

-- Q10.Increase the salary of all Sales employees by 5000. 
update employees 
set salary = salary + 5000
where department = 'Sales';


-- DELETE Data (DML Statement) --

-- Q11.Delete employees whose salary is less than 50000. 
delete from employees where salary < 50000;


-- Difference between DELETE(DML), TRUNCATE(DDL) and DROP(DDL) --

-- Delete statement use for specific rows remove from a table  --
delete from employees where name = 'Saikat';

-- Truncate statement use for remove all rows from a table but keeps the table stracture --
truncate table employees;

-- Drop statement use for remove entire table and database --
Drop table employees;
drop database tcs;


-- Mixed Practice --

-- Q1.Find employees whose name start with S.
select * from employees where name like "S%";

-- Q2.Find unique departments.
select distinct department from employees;

-- Q3.Find employees with salary between 30000 and 60000. 
select * from employees where salary between 30000 and 60000;

-- Q4.Find employees whose name has exactly 6 characters.
select * from employees where name like '______';

-- Q5.Find the 3rd to 7th highest paid employees. 
select * from employees order by salary desc limit 4 offset 2;

