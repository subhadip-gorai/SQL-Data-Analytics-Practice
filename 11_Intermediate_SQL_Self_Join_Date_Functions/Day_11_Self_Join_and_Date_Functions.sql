-- DAY 11: INTERMEDIATE SQL – SELF JOINs & DATE FUNCTIONS --

CREATE DATABASE SJDF;

USE SJDF;

-- Create Table --
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    department VARCHAR(50),
    manager_id INT,
    salary DECIMAL(10,2),
    joining_date DATE,
    birth_date DATE,
    resignation_date DATE,
    email VARCHAR(100)
);

-- Insert Data --
INSERT INTO employees
(employee_id, employee_name, department, manager_id, salary, joining_date, birth_date, resignation_date, email)
VALUES
(101, 'Rahul', 'Data Analytics', NULL, 75000, '2021-03-15', '1995-07-12', NULL, 'rahul@company.com'),
(102, 'Priya', 'Data Analytics', 101, 55000, '2022-06-20', '1998-02-18', NULL, 'priya@company.com'),
(103, 'Amit', 'Data Analytics', 101, 60000, '2023-01-10', '1996-11-25', NULL, NULL),
(104, 'Sneha', 'Finance', NULL, 80000, '2020-09-05', '1994-04-15', NULL, 'sneha@company.com'),
(105, 'Rohit', 'Finance', 104, 50000, '2022-11-12', '1999-01-20', '2025-08-15', NULL),
(106, 'Anjali', 'HR', NULL, 70000, '2021-07-01', '1995-09-30', NULL, 'anjali@company.com'),
(107, 'Vikash', 'HR', 106, 45000, '2023-03-18', '2000-06-10', NULL, 'vikash@company.com'),
(108, 'Neha', 'IT', NULL, 85000, '2019-12-10', '1993-12-05', NULL, NULL),
(109, 'Arjun', 'IT', 108, 65000, '2022-04-25', '1997-08-22', NULL, 'arjun@company.com'),
(110, 'Karan', 'IT', 108, 58000, '2024-01-15', '2001-03-17', NULL, 'karan@company.com'),
(111, 'Pooja', 'Marketing', NULL, 72000, '2020-05-20', '1996-10-11', '2026-02-10', 'pooja@company.com'),
(112, 'Sourav', 'Marketing', 111, 48000, '2023-08-07', '1999-05-28', NULL, NULL);


-- SELF JOIN --

-- Q1.Display: Employee Name, Employee Department, Manager Name, Manager Department 
-- 				Only show employees who have a manager.

SELECT e.Employee_Name, e.Department,
m.employee_name as Manager_Name,
m.department as Manager_Department
FROM employees e JOIN employees m
on m.employee_id = e.Manager_Id;

-- Q2.Find all employees who earn less than their manager.
-- 	  Display: Employee Name, Employee Salary, Manager Name, Manager Salary.

SELECT e.Employee_Name, e.salary as Employee_salary,
m.employee_name as Manager_Name,
m.salary as Manager_salary
FROM employees e JOIN employees m
on m.employee_id = e.Manager_Id
WHERE e.salary < m.salary;


-- COALESCE() and IFNULL() --

-- Q3.Some employees don't have an email address.
-- 	  Display: employee_name, email
-- 	  Replace missing emails with: Not Provided

-- 1st Approch --
SELECT employee_name, coalesce(email, 'Not Provided') FROM employees;

-- 2nd Approch --
SELECT employee_name, ifnull(email, 'Not Provided') FROM employees;

-- Q4.Display: employee_name, email, resignation_date.
-- 	  Replace missing values in both columns with appropriate text.

SELECT employee_name, coalesce(email, 'Not Provided'),
ifnull(resignation_date, 'Currently Working') FROM employees;


-- Current Date & Date Extraction --

-- Q5.Display each employee's: Employee Name, Joining Date, Joining Year,
-- 	  Joining Month, Joining Day.

SELECT Employee_Name, Joining_Date, year(Joining_Date) as Joining_Year,
month(Joining_Date) as Joining_Month, day(Joining_Date) as Joining_Day
FROM employees;

-- Q6.Find employees who joined during April.

SELECT Employee_Name, month(Joining_Date) as Joining_Month
FROM employees where month(Joining_Date) = 4;


-- DATE_ADD() and DATE_SUB() --

-- Q7.Find the date 90 days after joining for employees in the IT department.

SELECT Joining_Date,
date_add(Joining_Date, interval 90 day) as After_90_Days
FROM employees;

-- Q8.Find employees whose joining date was at least 1 year before today's date.

SELECT employee_Name, current_date(), Joining_Date FROM employees
WHERE Joining_Date <= date_sub(current_date(), interval 1 year);

-- DATEDIFF() --

-- Q9.Calculate how many days each employee has worked in the company.

SELECT current_date() as Todays_Date, Joining_date,
datediff(current_date(), Joining_date) as Total_Working_Days
FROM employees;

-- Q10.For employees who have resigned,
-- calculate their total employment duration in days.

SELECT Joining_date, Resignation_date,
datediff(Resignation_date, Joining_date) as Total_Days_before_Resignation
FROM employees;

-- Q11.Find the employee with the longest employment duration.

SELECT employee_name, current_date(), Joining_date,
datediff(coalesce(Resignation_date, current_date()), Joining_date) as Employment_Days
FROM employees 
ORDER BY Employment_Days desc LIMIT 1;


-- DATE_FORMAT() --

-- Q12.Display employee name and joining date in this format:
-- 	   Employee: Rahul | Joined: 15 March 2021.

SELECT Employee_Name, 
date_format(joining_date, "%d %M %Y") as Joined
FROM employees;


-- STR_TO_DATE() --

-- Create Table --
CREATE TABLE joining_records (
    record_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    joining_date_text VARCHAR(20)
);

-- Insert Data --
INSERT INTO joining_records
(record_id, employee_name, joining_date_text)
VALUES
(1, 'Rahul', '15-03-2021'),
(2, 'Priya', '20-06-2022'),
(3, 'Amit', '10-01-2023'),
(4, 'Sneha', '05-09-2020'),
(5, 'Rohit', '12-11-2022');

-- Q13.Convert the joining_date_text column into a proper MySQL date.
-- 	   The original format is: DD-MM-YYYY

SELECT joining_date_text,
str_to_date(joining_date_text, "%d-%m-%Y") as Converted_Date
FROM joining_records;

-- Q14.Find the year and month from the converted date.

SELECT joining_date_text,
Year(str_to_date(joining_date_text, "%d-%m-%Y")) as Converted_Year,
month(str_to_date(joining_date_text, "%d-%m-%Y")) as Converted_Month
FROM joining_records; 


-- Mixed Practice --

-- Q15.Display: Employee Name, Manager Name, Joining Date, Days Worked.

SELECT e.Employee_Name, m.Employee_Name as Manager_Name, e.Joining_Date,
datediff(coalesce(e.resignation_date, current_date()), e.Joining_Date)
FROM employees e JOIN employees m
on e.Manager_id = m.employee_id;

-- Q16.Display employees who: Have a manager, Joined after 2021, Earn less than their manager;

SELECT E.Employee_name, e.Joining_date,
m.employee_name as Manager_name,
e.salary as Employee_salary,
m.salary as Manager_salary
FROM employees e JOIN employees m
ON e.Manager_id = m.employee_id
WHERE year(e.joining_date) > 2021
AND e.salary < m.salary;

-- Q17.Display all currently working employees with:
-- 	   Employee Name, Department, Joining Date, Days Worked, Email Status.

SELECT Employee_name, Department, Joining_date,
datediff(current_date(), Joining_Date) as Days_Worked,
ifnull(email, "Not Provided") as Email_Status FROM employees
WHERE resignation_date is null;





 














