-- The report 

use LearnbaySQL

create table students
( id int , name varchar(20), marks int)

insert into students values
(1, 'Julia',88),
(2, 'Samantha',68),
(3, 'Maria',99),
(4, 'Scarlet',78),
(5, 'Ashley',63),
(6, 'Jane',81)

select * from students


create table grades
(grade int, min_marks int, max_marks int)

insert into grades values
(1,0,9),
(2,10,19),
(3,20,29),
(4,30,39),
(5,40,49),
(6,50,59),
(7,60,69),
(8,70,79),
(9,80,89),
(10,90,100)

select * from grades

select id, name, marks,
  case
	when marks between 0 and 9 then 1
	when marks between 10 and 19 then 2
	when marks between 20 and 29 then 3
	when marks between 30 and 39 then 4
	when marks between 40 and 49 then 5
	when marks between 50 and 59 then 6
	when marks between 60 and 69 then 7
	when marks between 70 and 79 then 8
	when marks between 80 and 89 then 9
	when marks between 90 and 100 then 10
  end as grade 
from students



with CTE_rep (id, name,marks, grade)
as
 (
 select id, name, marks,
  case
	when marks between 0 and 9 then 1
	when marks between 10 and 19 then 2
	when marks between 20 and 29 then 3
	when marks between 30 and 39 then 4
	when marks between 40 and 49 then 5
	when marks between 50 and 59 then 6
	when marks between 60 and 69 then 7
	when marks between 70 and 79 then 8
	when marks between 80 and 89 then 9
	when marks between 90 and 100 then 10
  end as grade 
from students
)

select id, case
	when grade>=8 then name
	else NULL
	end as name
,marks, grade from CTE_rep
order by
	case when grade > 7 then name end asc,
	case when grade <=7 then marks end desc
	
