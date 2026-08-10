-- DAY 01: SQL DATABASE & TABLE OPERATIONS --

-- Create Database --

create database Company;

use Company;


-- Create Table --

create table Employees (
emp_id int,
emp_name varchar(50),
age int,
salary decimal(10,2),
department varchar(30)
);

show tables;

describe employees;

select * from employees;


-- Add a Column --

alter table employees
add column email varchar(100);

describe employees;


-- Delete a column --

alter table employees
drop column email;

describe employees;


-- Rename a column --

alter table employees
rename column emp_id to id;

describe employees;


-- WHERE Clause --

show tables;

describe employee_data;

select age from employee_data where age >30;

select salary from employee_data where salary > 50000;

select department from employee_data where department = "HR";

select salary from employee_data where salary between 30000 and 60000;


-- Change/Modify Column Data Type --

select cast(salary as char(4)) from employee_data;