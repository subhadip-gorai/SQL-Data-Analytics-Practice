use product;
create table student(
id int,
gender varchar(10)
);

alter table student add constraint primary key (id);

insert into student values
(1, 'M'),
(2, 'F'),
(3, 'M'),
(4, 'F');

create table marks(
Id int,
Sub varchar(10),
Marks int
);

insert into Marks values
(1, 'E', 65),
(2, 'C', 95),
(2, 'E', 52),
(5, 'C', 35),
(5, 'E', 60),
(6, 'E', 47);

insert into Marks values
(3, 'C', 55),
(3, 'E', 30);


-- Inner Join --

select marks.*, student.*
from marks inner join student on marks.id = student.id;

-- Left Join --

select marks.*, student.*
from marks left join student on marks.id = student.id;

-- Change table position
select student.*, marks.*
from  student left join marks on marks.id = student.id;

-- Right Join --

select marks.*, student.*
from marks right join student on marks.id = student.id;

-- Change table position
select student.*, marks.*
from  student right join marks on marks.id = student.id;

-- Full Outer Join --
-- Full Outer Join = Left Join + Right Join + Union

select marks.*, student.*
from marks left join student 
on marks.id = student.id

union

select marks.*, student.*
from marks right join student 
on marks.id = student.id;

-- Cross Join --

select marks.*, student.*
from marks cross join student;


