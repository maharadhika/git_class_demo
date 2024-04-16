-- Subquerry

use LearnbaySQL

select * from emp_sal order by SALARY desc

--2nd hightest sal

select max(salary) from emp_sal

select max(salary) from emp_sal where salary < (select max(salary) from emp_sal)

-- find details of 2nd hightest salary employee

select * from emp where eid = (
select EID from emp_sal where salary = (select max(salary) from emp_sal where salary < (select max(salary) from emp_sal))
)

-- find 4th highest salary
select salary, row_number() over (order by Salary desc) as row_num from emp_sal


select salary from (select salary, row_number() over (order by Salary desc) as row_num 
from (select distinct salary from emp_sal) as s
) as rnk
where row_num=3

--Common Table Expression (CTE)  Also called sub querry refactoring
with row_wise as 
(select salary, row_number() over (order by Salary desc) as row_num from emp_sal)
select salary from row_wise where row_num=10



-- CTE common table expression  (ie creating a temporary table which exists only during that session time. It does not create a permanant table)

select E.Eid, name, dept, desi, salary, salary * 0.15 as EPF, salary * 0.10 as HRA 
from emp E inner join EMP_Sal es
on E.eid=es.EID

--now if I want to calculate net and gross salary from above then use CTE. It uses 'With' caluse

with sal_fact as (select E.Eid, name, dept, desi, salary, salary * 0.15 as EPF, salary * 0.10 as HRA 
from emp E inner join EMP_Sal es
on E.eid=es.EID )
select *, salary + EPF + HRA as Gross, Salary + HRA as Net from sal_fact


--Multiple CTEs can be joined as well
with emp_tn as
(select Eid, name, doj, datediff(yy,DOJ,getdate()) as tenure from EMP),
sal_fact as (select Eid,salary, salary * 0.15 as EPF, salary * 0.10 as HRA 
from eMP_Sal)

select emp_tn.eid, emp_tn.name,tenure, salary, EPF, HRA from emp_tn inner join sal_fact on emp_tn.eid= sal_fact.eid

select * from emp
-- Insert subquerry

create table training 
(EID varchar(5), name varchar(30), Dept varchar(10), module varchar(10) default 'Python')

-- Training has to be given to only employees from Pune. so insert their records from emp table to trainng table using insert subquerry

insert into training (Eid, name, dept)
select eid, name, city from emp where city= 'Pune'


select * from training


--- Exixts caluse
select * from emp where exists(
select* from emp_sal where dept='HR') -- if exists subquerry does not return anything then outer querry will also not return anything


-- Stored Procedures
-- create procedure
create procedure sp_city_view @city as varchar(20)
As
Begin
	select * from emp where city= @city
End

--call procedure
exec sp_city_view 'Pune'

--if you want to drop the procedure
drop procedure sp_tab_view

create procedure sp_tab_view @tab as varchar(20)
As
Begin
	exec('select * from ' +  @tab)
End

--call 
exec sp_tab_view 'Emp_sal'

--auto generate identity sequence (generally used to create primary key column)
use LearnbaySQL

create table student
(s_id int identity(1001,1), s_name varchar(30), branch varchar(10))

insert into student values  /* here s_id is auto generated*/
('Mona Singh','E&TC'),
('Mrinal Thakur','Comp'),
('Lyra Dsouza','IT')

select * from student
