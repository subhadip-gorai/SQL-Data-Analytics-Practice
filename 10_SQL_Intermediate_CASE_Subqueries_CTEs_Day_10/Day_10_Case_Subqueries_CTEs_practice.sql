-- DAY 10: CASE STATEMENTS, SUBQUERIES and CTE's --

CREATE DATABASE case_sub;
USE case_sub;

-- Create Department Table --
CREATE TABLE department (
    departmentId INT PRIMARY KEY,
    departmentName VARCHAR(50),
    location VARCHAR(50)
);

-- Insert Data into the Department Table --
INSERT INTO department (departmentId, departmentName, location)
VALUES
(1, 'IT', 'Hyderabad'),
(2, 'HR', 'Bangalore'),
(3, 'Finance', 'Mumbai'),
(4, 'Sales', 'Delhi'),
(5, 'Marketing', 'Pune');

-- Create Employee Table --
CREATE TABLE employee (
    employeeId INT PRIMARY KEY,
    name VARCHAR(50),
    departmentId INT,
    salary DECIMAL(10,2),
    experience INT,
    performanceScore INT,
    joiningDate DATE,
    FOREIGN KEY (departmentId) REFERENCES department(departmentId)
);

-- Insert Data into the Employee Table --
INSERT INTO employee
(employeeId, name, departmentId, salary, experience, performanceScore, joiningDate)
VALUES
(101, 'Amit',    1, 85000, 8, 5, '2016-03-15'),
(102, 'Priya',   1, 65000, 5, 4, '2019-07-10'),
(103, 'Rahul',   1, 45000, 2, 3, '2023-01-20'),
(104, 'Sneha',   2, 75000, 7, 5, '2017-05-12'),
(105, 'Rohan',   2, 48000, 3, 3, '2022-08-18'),
(106, 'Anjali',  2, 55000, 4, 4, '2020-11-25'),
(107, 'Vikash',  3, 95000, 10, 5, '2014-02-10'),
(108, 'Neha',    3, 70000, 6, 4, '2018-09-05'),
(109, 'Sourav',  3, 40000, 2, 2, '2024-01-15'),
(110, 'Pooja',   4, 80000, 8, 5, '2016-06-20'),
(111, 'Arjun',   4, 60000, 5, 4, '2019-03-11'),
(112, 'Kiran',   4, 35000, 1, 2, '2024-04-01'),
(113, 'Meena',   5, 72000, 6, 4, '2018-12-10'),
(114, 'Raj',     5, 52000, 3, 3, '2022-02-14'),
(115, 'Tina',    5, 90000, 9, 5, '2015-10-30');


-- CASE Statement --

-- Assignment 1: Salary Category
-- 				Create a new column salary_category:
-- 				Salary >= 80,000 → 'High'
-- 				Salary >= 50,000 → 'Medium'
-- 				Salary < 50,000 → 'Low'
-- Task: Display: employeeId, name, salary, salary_category.

SELECT EmployeeId, Name, Salary,
CASE
WHEN Salary >= 80000 THEN 'High'
WHEN Salary >= 50000 THEN 'Medium'
ELSE 'Low' END AS Salary_Category
FROM employee;

-- Assignment 2: Salary Increment
-- 				Create a column increment_percentage:
-- 				Salary >= 80,000 → 15%, 	Salary >= 60,000 → 10%,
-- 				Salary >= 40,000 → 7%,  	Otherwise → 5%.

SELECT EmployeeId, Name, Salary,
CASE
WHEN Salary >= 80000 THEN round(salary + (salary * (15/100)),2)
WHEN Salary >= 60000 THEN round(salary + (salary * (10/100)),2)
WHEN Salary >= 40000 THEN round(salary + (salary * (7/100)),2)
ELSE round(salary + (salary * (5/100)),2) END AS New_Salary
FROM employee;


-- CASE + Aggregate Functions --

-- Assignment 3: Count Employees by Salary Category
-- 				Using CASE, categorize employees into:
-- High: >= 80,000,		Medium: 50,000–79,999,		Low: < 50,000
-- Then find:
-- 			Number of High-salary employees
-- 			Number of Medium-salary employees
-- 			Number of Low-salary employees

SELECT
CASE
WHEN salary >= 80000 THEN "High"
WHEN salary BETWEEN 50000 AND 79999 THEN "Medium"
ELSE "Low" END AS Salary_Category,
COUNT(Salary) as Count_Employee
FROM employee
GROUP BY Salary_Category;

-- Assignment 4: Department Salary Status
-- For each department, calculate the average salary.
-- Then use CASE:
-- 			Average salary >= 70,000 → 'High Paying Department'
-- 			Average salary >= 50,000 → 'Medium Paying Department'
-- 			Otherwise → 'Low Paying Department'

SELECT d.DepartmentName, round(avg(e.salary),2) as Avg_Salary,
CASE
WHEN avg(e.salary) >= 70000 THEN "High Paying Department"
WHEN avg(e.salary) >= 50000  THEN "Medium Paying Department"
ELSE "Low Paying Department" END AS Department_Salary_Status
FROM employee e JOIN department d
on d.departmentId = e.departmentId
GROUP BY DepartmentName;


-- SUBQUERIES --

-- Assignment 5: Employees in a Specific Department
-- 				Find employees who belong to the same department as 'Tina'.

SELECT e.Name, d.DepartmentName
FROM employee e JOIN department d
ON e.departmentId = d.departmentId
WHERE d.DepartmentName = (
SELECT DepartmentName FROM 
employee e JOIN department d
ON e.departmentId = d.departmentId
WHERE name = "Tina"
);

-- Best Approach --
SELECT e.Name, d.DepartmentName
FROM employee e JOIN department d
ON e.departmentId = d.departmentId
WHERE e.DepartmentId = (
SELECT departmentId from employee
WHERE name = "Tina"
);

-- Correlated Subquery --

-- Assignment 6: Employees Earning More Than Their Department Average
-- Find employees whose salary is greater than the average salary of their own department.
-- Display: employeeId, name, departmentId, salary.

SELECT e.employeeId, e.name, e.departmentId, e.salary
FROM employee e 
WHERE e.salary > (
SELECT avg(e2.salary) FROM employee e2
WHERE e2.departmentId = e.departmentId
);


-- CTE Practice -- (CTE - Common Table Expressions) --

-- Assignment 7: Employees Above Department Average
-- 				Create a CTE containing:  departmentId,  average_salary.
-- 				Then join it with the employee table and find employees
-- 				whose salary is greater than their department's average.
-- Display:		employee_id, name, departmentId, salary, average_salary.

WITH dept_Salary AS
(SELECT departmentId, round(avg(salary),2) as average_salary
FROM employee GROUP BY departmentId)

SELECT e.employeeId, e.name, e.departmentId, e.salary,
d.average_salary
FROM employee e JOIN dept_Salary d
on e.departmentId = d.departmentId
WHERE e.salary > d.average_salary;

-- Assignment 8: Salary Ranking Category
-- 				Create a CTE that calculates the average salary.
-- 				Then classify employees:
-- 					Salary > average salary → 'Above Average'
-- 					Salary = average salary → 'Average'
-- 					Salary < average salary → 'Below Average'

WITH Average_Salary AS
(SELECT avg(salary) AS average_salary
from employee)

SELECT e.employeeId, e.Name, e.Salary,
CASE
WHEN e.Salary > a.average_salary THEN 'Above Average'
WHEN e.Salary = a.average_salary THEN 'Average'
ELSE 'Below Average' END AS Salary_status
FROM employee e CROSS JOIN Average_Salary a;


-- Mixed Practice --

-- Assignment 9: Find the second-highest salary.

SELECT max(salary) AS second_highest_salary
FROM employee WHERE salary < (SELECT max(salary) FROM employee);

-- Assignment 10: Find the second-highest salary with employee name.

SELECT Name, Salary
FROM employee WHERE salary = (
SELECT max(salary) FROM employee
WHERE salary < (
SELECT max(salary) FROM employee
)
);

-- Assignment 11: Find employees who earn more than the average salary of all employees 
-- 				and classify them:
-- 				100,000 → 'Very High',  70,000 → 'High',  Otherwise → 'Above Average'.

SELECT EmployeeId Name, Salary,
CASE
WHEN salary >= 100000 THEN 'Very High'
WHEN salary >= 70000 THEN 'High'
ELSE 'Above Average' END AS Salary_type
FROM employee WHERE salary > (
SELECT avg(salary) FROM employee
);

-- Assignment 12: Find the highest-paid employee in each department.
-- 				  Display: employeeId, name, departmentId, salary.

-- 1st Approach using correlated subquery --

SELECT e.EmployeeId, e.Name, e.DepartmentId, e.Salary
FROM employee e WHERE e.salary = (
SELECT max(e2.salary) FROM employee e2
where e.DepartmentId = e2.DepartmentId
);

-- 2nd Approach using CTE --

WITH Highest_dpt_salary AS (
SELECT DepartmentId, max(salary) AS Max_salary
FROM employee GROUP BY DepartmentId
)

SELECT e.EmployeeId, e.Name, e.DepartmentId, e.Salary
FROM employee e JOIN Highest_dpt_salary h 
ON e.DepartmentId = h.DepartmentId
WHERE e.salary = h.Max_salary;

-- Assignment 13: Find departments whose average salary is 
-- 				  greater than the company's overall average salary

WITH Dpt_avg AS
(SELECT d.DepartmentId, d.DepartmentName,
round(avg(e.salary),2) AS Avg_salary
FROM employee e JOIN department d
ON d.DepartmentId = e.DepartmentId
GROUP BY e.departmentId)

SELECT * FROM Dpt_avg
WHERE Avg_salary > (
SELECT avg(salary) FROM employee
);

-- Assignment 14: Find employees who earn more than
-- 				  their department's average salary and display:
-- 		employeeId, name, departmentId, salary, department_average, salary_status.
-- 		Where salary_status is: 'Above Department Average', 'Below Department Average'.

WITH department_average AS
(SELECT departmentId, round(avg(salary),2) AS DptAvg_salary
FROM employee GROUP BY departmentId)

SELECT e.EmployeeId, e.Name, e.DepartmentId, e.Salary, d.DptAvg_salary,
CASE WHEN e.salary > d.DptAvg_salary THEN 'Above Department Average'
ELSE 'Below Department Average' END AS Salary_status
FROM employee e JOIN department_average d
ON e.departmentId = d.departmentId
WHERE e.salary > d.DptAvg_salary;

-- Assignment 15: Employee Salary Analysis
-- 				  Display: employee, salary, department_avg, salary_difference,
-- 				  salary_status: Above Average, Average and Below Average.

WITH Avg_dpt_salary AS
(SELECT departmentId, round(avg(salary),2) as department_avg 
FROM employee GROUP BY departmentId)

SELECT e.name as Employee, e.Salary, a.Department_avg,
e.salary - a.department_avg AS Salary_difference,
CASE
WHEN e.salary > a.department_avg THEN "Above Average"
WHEN e.salary = a.department_avg THEN "Average"
ELSE "Below Average" END AS Salary_status
FROM employee e JOIN Avg_dpt_salary a 
ON e.departmentId = a.departmentId;




























