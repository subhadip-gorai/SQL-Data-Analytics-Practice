-- DAY 08: JOINS and SET OPERATIONS --

create database join_set;
use join_set;

-- Departments Table --
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

INSERT INTO departments (department_id, department_name)
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Sales'),
(6, 'Operations');

-- Employees Table --
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10,2)
);

INSERT INTO employees
(employee_id, employee_name, department_id, salary)
VALUES
(101, 'Rahul Sharma', 1, 55000),
(102, 'Priya Das', 2, 48000),
(103, 'Amit Kumar', 1, 62000),
(104, 'Sneha Roy', 3, 58000),
(105, 'Arjun Singh', 5, 45000),
(106, 'Neha Gupta', 7, 52000),
(107, 'Sourav Paul', 3, 60000);

-- Projects Table --
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    department_id INT
);

INSERT INTO projects
(project_id, project_name, department_id)
VALUES
(201, 'Website Development', 1),
(202, 'Recruitment System', 2),
(203, 'Financial Analysis', 3),
(204, 'Sales Dashboard', 5),
(205, 'Brand Campaign', 4),
(206, 'New Operations System', 6),
(207, 'AI Research', 7);


-- Inner Join --

-- Q1.Show only employees whose department exists in the departments table.

select emp.employee_name, dept.department_name
from employees emp inner join departments dept
on emp.department_id = dept.department_id;

-- Q2.Display: employee_id	employee_name	department_name		salary
-- 		using an INNER JOIN.

select emp.employee_id, emp.employee_name,
dept.department_name, emp.salary
from employees emp inner join departments dept
on emp.department_id = dept.department_id;

-- Q3.Find employees who work in the IT department.

select emp.employee_name, dept.department_name
from employees emp inner join departments dept
on emp.department_id = dept.department_id
where dept.department_name = 'IT';

-- Q4.Display employees working in: Finance
-- 	and show their salary.

select emp.employee_name, dept.department_name, emp.salary
from employees emp inner join departments dept
on emp.department_id = dept.department_id
where dept.department_name = 'Finance';

-- Q5.Join all three tables:	1.employees		2.departments		3.projects
-- 	  Display: employee_name, department_name, project_name columns
-- 		Only show matching records.

select emp.employee_name, dept.department_name, pro.project_name
from departments dept
inner join employees emp
on emp.department_id = dept.department_id
inner join projects pro
on pro.department_id = dept.department_id;


-- Left Join --

-- Q6.Display all employees, even if they don't have a matching department.
-- 		Output: employee_name, department_name.

select emp.employee_name, dept.department_name
from employees emp left join departments dept
on emp.department_id = dept.department_id;

-- Q7.Find employees whose department doesn't exist.

select emp.employee_name, dept.department_name
from employees emp left join departments dept
on emp.department_id = dept.department_id
where dept.department_name is null;

-- Q8.Which departments have no employees?

select dept.department_name, emp.employee_name
from departments dept left join  employees emp
on emp.department_id = dept.department_id
where emp.employee_name is null;


-- Right Join --

-- Q9.Using RIGHT JOIN, display: employee_name, department_name
-- 	  Make sure all departments are included.

select emp.employee_name, dept.department_name
from employees emp right join departments dept
on emp.department_id = dept.department_id;

-- Q10.Find departments that have no employees using RIGHT JOIN.

select emp.employee_name, dept.department_name
from employees emp right join departments dept
on emp.department_id = dept.department_id
where emp.employee_name is null;

-- * A right join B = B left join A * --

-- Full Outer Join --
-- (Left Join + Right Join + Union = Full Outer Join)

-- Q11.Display all employees and all departments, whether 
-- 	   they have a matching record or not.

select emp.employee_name, dept.department_name
from employees emp left join departments dept
on emp.department_id = dept.department_id
union
select emp.employee_name, dept.department_name
from employees emp right join departments dept
on emp.department_id = dept.department_id;

-- Q12.Find records that exist on only one side:
--     In other words:
--        Employees without departments.
--        Departments without employees.

select emp.employee_name, dept.department_name
from employees emp left join departments dept
on emp.department_id = dept.department_id
where dept.department_name is null
union
select emp.employee_name, dept.department_name
from employees emp right join departments dept
on emp.department_id = dept.department_id
where emp.employee_name is null;


-- Union --

-- Former_Employees Table--
CREATE TABLE former_employees (
    employee_id INT,
    employee_name VARCHAR(100)
);

INSERT INTO former_employees
(employee_id, employee_name)
VALUES
(108, 'Riya Sen'),
(109, 'Vikash Roy'),
(110, 'Ankit Das');

-- Q13.Display a combined list of: [Current Employees + Former Employees] use UNION.

select employee_id, employee_name
from employees
union
select employee_id, employee_name
from former_employees;

INSERT INTO former_employees
(employee_id, employee_name)
VALUES (101, 'Rahul Sharma');

-- Union All --

select employee_id, employee_name
from employees
union all
select employee_id, employee_name
from former_employees;

-- Conclusion: Union Removes dublicates and Union All keeps dublicates.


-- Cross Join --

-- Q14.Generate every possible combination of: employees × departments
-- 	   Display: employee_name and department_name.

select employee_name, department_name
from employees cross join departments;


-- Data Analyst Challenge --

-- Q15.Display: employee_name, department_name, salary
--     for employees earning more than ₹50,000.

select emp.employee_name, dept.department_name, emp.salary
from employees emp inner join departments dept
on emp.department_id = dept.department_id
where emp.salary > 50000;

-- Q16.Find the average salary for each department.
--     Display: department_name, average_salary.

select dept.department_name,
avg(emp.salary) as Avg_salary
from employees emp inner join departments dept
on emp.department_id = dept.department_id
group by dept.department_name;

-- Q17.Display departments with more than one employee.

select dept.department_name,
count(emp.employee_id) as Employee_Count
from employees emp inner join departments dept
on emp.department_id = dept.department_id
group by dept.department_name
having count(emp.employee_id) > 1;

-- Q18.Find the highest-paid employee in each department.

select dept.department_name, emp.employee_name, emp.salary
from employees emp inner join departments dept
on emp.department_id = dept.department_id
where emp.salary = (
select max(e.salary)
from employees e
where e.department_id = emp.department_id
);

-- Q19.Create a report showing: Employee Name, Department Name, Project Name, Salary
--     Requirements: 
-- 			1.Employees should be matched with their departments.
-- 			2.Departments should be matched with their projects.
-- 			3.Only valid relationships should appear.
-- 			4.Sort by salary from highest to lowest.

select emp.employee_name, dept.department_name,
pro.project_name, emp.salary
from departments dept
inner join employees emp
on emp.department_id = dept.department_id
inner join projects pro
on pro.department_id = dept.department_id
order by emp.salary desc;




