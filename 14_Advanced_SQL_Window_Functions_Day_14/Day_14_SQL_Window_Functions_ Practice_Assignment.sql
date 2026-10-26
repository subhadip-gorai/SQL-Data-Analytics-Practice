-- DAY 14: SQL Window Functions — Practice Questions and Solutions --


-- Create the database and tables --

CREATE DATABASE window_functions_asgmt;
USE window_functions_asgmt;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    employee_id INT,
    sale_month DATE,
    sales_amount DECIMAL(10,2),
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);


-- Insert sample data --

-- Departments --
INSERT INTO departments VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Sales'),
(4, 'Finance');

-- Employees --
INSERT INTO employees VALUES
(101, 'Amit', 1, 60000, '2022-01-15'),
(102, 'Priya', 1, 75000, '2021-03-10'),
(103, 'Rahul', 2, 45000, '2023-06-20'),
(104, 'Sneha', 2, 50000, '2022-09-12'),
(105, 'Arjun', 3, 55000, '2021-11-05'),
(106, 'Neha', 3, 65000, '2020-07-18'),
(107, 'Rohit', 3, 55000, '2023-02-14'),
(108, 'Kiran', 4, 70000, '2020-04-22'),
(109, 'Pooja', 1, 60000, '2024-01-08'),
(110, 'Vikash', 4, 48000, '2022-12-01');

-- Sales --
INSERT INTO sales VALUES
(1, 105, '2026-01-01', 12000),
(2, 106, '2026-01-01', 18000),
(3, 107, '2026-01-01', 10000),
(4, 105, '2026-02-01', 15000),
(5, 106, '2026-02-01', 20000),
(6, 107, '2026-02-01', 14000),
(7, 105, '2026-03-01', 17000),
(8, 106, '2026-03-01', 16000),
(9, 107, '2026-03-01', 19000),
(10, 105, '2026-04-01', 13000),
(11, 106, '2026-04-01', 22000),
(12, 107, '2026-04-01', 16000);


-- Questions and Answers --

-- Part A — Ranking Functions --

-- Q1. Display all employees with their salary and a unique row number ordered by salary from
-- highest to lowest.

SELECT Employee_Id, Employee_Name, Salary,
ROW_NUMBER() over(ORDER BY salary DESC) as Row_Num
FROM employees;

-- Q2. Rank employees by salary from highest to lowest using RANK().

SELECT Employee_Id, Employee_Name, Salary,
RANK() OVER(ORDER BY salary DESC) as Rnk
FROM employees;

-- Q3. Rank employees by salary using DENSE_RANK(). Compare the result with Q2.

SELECT Employee_Id, Employee_Name, Salary,
DENSE_RANK() OVER(ORDER BY salary DESC) as Dense_Rnk,
RANK() OVER(ORDER BY salary DESC) as Rnk
FROM employees;

-- Q4. Assign a separate row number to employees within each department, ordered by salary from
-- highest to lowest.

SELECT e.Employee_Id, e.Employee_Name, d.Department_Name, e.Salary,
ROW_NUMBER() OVER(PARTITION BY d.department_id ORDER BY e.salary DESC) as Dept_Row_Num
FROM employees e JOIN departments d
ON e.department_id = d.department_id;

-- Q5. Find the top 2 highest-paid employees in each department using a window function.

WITH Top_employees AS
(SELECT e.Employee_Id, e.Employee_Name, d.Department_Name, e.Salary,
DENSE_RANK() OVER(PARTITION BY d.department_id ORDER BY e.salary DESC) as Dept_top_emp
FROM employees e JOIN departments d
ON e.department_id = d.department_id)

SELECT * FROM Top_employees WHERE Dept_top_emp < 3;


-- Part B: Aggregate Window Functions --

-- Q6. Display each employee's salary alongside the average salary of their department.

SELECT e.Employee_Id, e.Employee_Name, d.Department_Name, e.Salary,
round(avg(e.Salary) OVER(PARTITION BY d.department_id),2) as Avg_Dept_Salary
FROM employees e JOIN departments d
ON e.department_id = d.department_id;

-- Q7. Display each employee's salary and the total salary expense of their department.

SELECT e.Employee_Id, e.Employee_Name, d.Department_Name, e.Salary,
round(sum(e.Salary) OVER(PARTITION BY d.department_id),2) as Total_Dept_Salary
FROM employees e JOIN departments d
ON e.department_id = d.department_id;

-- Q8. Count the number of employees in each department without collapsing the employee rows.

SELECT e.Employee_Id, e.Employee_Name, d.Department_Name, e.Salary,
count(e.employee_id) OVER(PARTITION BY d.department_id) as Count_Dept_Emp
FROM employees e JOIN departments d
ON e.department_id = d.department_id;

-- Q9. Calculate the difference between each employee's salary and their department's average salary.

WITH Emp_Dept AS
(SELECT e.Employee_Id, e.Employee_Name, d.Department_Name, e.Salary,
avg(e.Salary) OVER(PARTITION BY d.department_id) as Avg_Dept_Salary
FROM employees e JOIN departments d
ON e.department_id = d.department_id)

SELECT *, (Salary - Avg_Dept_Salary) as Difference FROM Emp_Dept;


-- Part C: Value and Navigation Functions --

-- Q10. For each employee's monthly sales, display the previous month's sales.

SELECT e.Employee_Id, e.Employee_Name,
month(s.sale_month) as Sale_Month, 
s.sales_amount as Current_Month_Sales,
LAG(s.sales_amount) OVER(
PARTITION BY employee_id
ORDER BY month(s.sale_month)
) as Previous_Month_sales
FROM employees e JOIN sales s
ON e.employee_id = s.employee_id;

-- Q11. Display each employee's current monthly sales and next month's sales.

SELECT e.Employee_Id, e.Employee_Name,
month(s.sale_month) as Sale_Month, 
s.sales_amount as Current_Month_Sales,
LEAD(s.sales_amount) OVER(
PARTITION BY employee_id
ORDER BY month(s.sale_month)
) as Next_Month_Sales
FROM employees e JOIN sales s
ON e.employee_id = s.employee_id;

-- Q12. Find the highest salary in each department using FIRST_VALUE().

SELECT e.Employee_Id, e.Employee_Name, d.Department_Name, e.Salary,
FIRST_VALUE(e.salary) OVER(
PARTITION BY d.Department_id
ORDER BY e.salary DESC
) as Dept_Highest_salary
FROM employees e JOIN departments d
ON e.department_id = d.department_id;

-- Q13. For each employee's monthly sales, show the first month's sales using FIRST_VALUE().

SELECT e.Employee_Id, e.Employee_Name,
month(s.sale_month) as Sale_Month, 
s.sales_amount as Current_Month_Sales,
FIRST_VALUE(s.sales_amount) OVER(
PARTITION BY employee_id
ORDER BY month(s.sale_month)
) as First_Month_Sales
FROM employees e JOIN sales s
ON e.employee_id = s.employee_id;

-- Q14. Calculate the difference between current-month sales and previous-month sales
-- for each salesperson.

WITH Sales_details AS
(SELECT Sale_Id, Employee_Id,
month(Sale_Month) as Sale_Month,
Sales_Amount as Current_Month_Sales,
LAG(sales_amount) OVER(PARTITION BY employee_id ORDER BY month(Sale_Month)) as Previous_Month_Sales
FROM sales)

SELECT *, (Current_Month_Sales - Previous_Month_Sales) AS Sales_Amt_Diff
FROM Sales_details;


-- Part D — Analytical Challenge --

-- Q15. Rank salespeople by total sales across all four months. Display each salesperson's total sales
-- and rank.

WITH Total_Sales AS
(SELECT employee_id,
sum(sales_amount) as Total_Sales
FROM sales GROUP BY employee_id)

SELECT *,
DENSE_RANK() OVER(ORDER BY Total_Sales DESC) as Rnk
FROM Total_Sales;











