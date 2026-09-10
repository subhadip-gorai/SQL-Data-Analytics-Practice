-- DAY 06: SQL CONSTRAINTS RELATIONSHIP --

create database college;
use college;

-- Primary Key --

create table departments (
Department_Id int primary key,
Department_Name text
);

INSERT INTO departments (department_id, department_name)
VALUES
(1, 'Electrical Engineering'),
(2, 'Computer Science'),
(3, 'Mechanical Engineering'),
(4, 'Civil Engineering'),
(5, 'Electronics Engineering');

create table students (
Student_Id int primary key,
Student_Name text,
Email varchar(200),
Age int,
City varchar(100),
Department_Id int
);

INSERT INTO students
(student_id, student_name, email, age, city, department_id)
VALUES
(101, 'Rahul Sharma', 'rahul@gmail.com', 21, 'Kolkata', 1),
(102, 'Priya Das', 'priya@gmail.com', 22, 'Hyderabad', 2),
(103, 'Amit Kumar', 'amit@gmail.com', 20, 'Delhi', 3),
(104, 'Sneha Roy', 'sneha@gmail.com', 23, 'Mumbai', 2),
(105, 'Arjun Singh', 'arjun@gmail.com', 19, 'Kolkata', 4),
(106, 'Neha Gupta', 'neha@gmail.com', 24, 'Bangalore', 5),
(107, 'Sourav Paul', 'sourav@gmail.com', 21, 'Kolkata', 1),
(108, 'Riya Sen', 'riya@gmail.com', 22, 'Delhi', 3);

-- UNIQUE & NOT NULL --
-- Using alter table --

alter table Students modify Student_Id int not null;
alter table Students modify Email varchar(200) not null unique;
 
 -- Q1.Try inserting two students with the same email.
 
 INSERT INTO students
(student_id, student_name, email, age, city, department_id)
VALUES
(120, 'Ratul Varma', 'rahul@gmail.com', 25, 'Kolkata', 2);
 -- Response:- Error Code: 1062. Duplicate entry 'rahul@gmail.com' for key 'students.Email'
 
 
 -- CHECK Constraint --
 
 -- Add a CHECK constraint so that
 -- 		1.age must be greater than or equal to 18
 
alter table students modify age int check (age >= 18);

-- 			2.age must be less than or equal to 60

alter table students modify age int check (age <= 60);

-- Q2.Try inserting a student age 15.

INSERT INTO students
(student_id, student_name, email, age, city, department_id)
VALUES
(125, 'Sneha Gupta', 'sneha@gmail.com', 15, 'Bangalore', 12);
-- Response:- Error Code: 3819. Check constraint 'students_chk_1' is violated.

-- Create a CHECK constraint so that city can only contain: 
-- 		Kolkata		Hyderabad	  Delhi	    Mumbai		Bangalore

alter table students 
add constraint city check (
city in ('Kolkata', 'Hyderabad', 'Delhi', 'Mumbai', 'Bangalore')
);

-- Q3.Try inserting a student from Pune.

INSERT INTO students
(student_id, student_name, email, age, city, department_id)
VALUES
(125, 'Sneha Gupta', 'sneha@gmail.com', 25, 'Pune', 12);
-- Error Code: 3819. Check constraint 'city' is violated.


-- DEFAULT Constraint --

-- Q4.Add a status column to the students table with a default value: 'Active'

alter table students add column Status varchar(50) default 'Active';






