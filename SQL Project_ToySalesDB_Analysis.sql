-- once the data in ToySalesDB is inplace with in desired format we start analyzing the data
-- Analysis-1
--1. total units sold per store

select sl.store_id, st.store_location ,sum(units) as units_sold from sales sl join stores st
on sl.store_id=st.store_id
group by sl.store_id,st.store_location
order by units_sold desc


--2 total units sold and total revenue per store

select st.Store_Location, st.store_name , sum(s.units) as units_sold, sum(s.units * p.product_price) as Total_revenue from sales s 
join stores st
on s.store_id=st.store_id
join products p
on s.Product_ID = p.Product_ID 
group by st.Store_Location, st.Store_Name order by st.Store_location

--Use CTE to find location-wise sales 

with store_performance as
(select st.Store_Location, st.store_name , sum(s.units) as units_sold, sum(s.units * p.product_price) as Total_revenue from sales s 
join stores st
on s.store_id=st.store_id
join products p
on s.Product_ID = p.Product_ID 
group by st.Store_Location, st.Store_Name)

select store_location,sum(units_sold) as Tot_UnitsSold,sum(total_revenue) as Tot_Revenue from store_performance
group by Store_Location order by Tot_Revenue

--interpretation
--Total revenue of Dountown is the hightest and Airport is the lowest

-- Total no of shops in each location
select store_location,count(store_name) from stores group by Store_Location



--Analysis 2- check total and monthly sales of each product name and product category
-- total sale
select p.product_id, sum(s.units) as units_sold,sum(s.units*p.product_price) as product_sales from products p join sales s
on p.Product_ID=s.Product_ID group by p.product_id order by product_id

-- monthly sale of each product id

select p.product_id, p.Product_Name, p.product_category, datename(month,s.date) as month_sale,datepart(year,s.date) as sale_year, sum(s.Units) as un_sold
from sales s join products p
on s.Product_ID= p.Product_ID
group by p.product_id, p.Product_Name,p. Product_Category, datename(month,s.date),datepart(year,s.date)


--Analysis 3- trend in sales of last 6 months

select max(date), dateadd(month,-6, max(date)) from sales  -- to find last 6 months dates from sales table

select * from sales s
where s.date between  (select dateadd(month,-6, max(date)) from sales) and (select max(date) from sales)

select s.store_id, st.store_name, sum(s.units) as Total_units_sold,sum(s.units * p.product_price) as Total_sale, s.date
from sales s join stores st
on s.store_id= st.store_id
join products p
on p.product_id=s.Product_ID
where s.date between  (select dateadd(month,-6, max(date)) from sales) and (select max(date) from sales)
group by s.store_id, st.store_name, s.date


-- Analysis 4 - sales performance over weekdays and weekends
with wkdy as
(select date, datename(WEEKDAY,date), datepart(weekday,date) from sales)

-- to find units sold per store on weekend and weekdays
select s.store_id,st.store_location, sum(s.units) as units_sold,
case when datename(weekday,date) in ('Saturday','Sunday') then 'Weekend' else 'Weekday' End as wkdy_type
from sales s
join stores st
on s.store_id = st.store_id group by s.store_id, st.store_location, 
case when datename(weekday,date) in ('Saturday','Sunday') then 'Weekend' else 'Weekday' End 

--to find total units sold in 'Airport' location on weekday and weekend
select st.store_location, sum(s.units) as total_units_sold,
case when datename(weekday,date) in ('Saturday','Sunday') then 'Weekend' else 'Weekday' End as wkdy_type
from sales s
join stores st
on s.store_id = st.store_id 
where Store_Location = 'Airport' 
group by st.store_location, 
case when datename(weekday,date) in ('Saturday','Sunday') then 'Weekend' else 'Weekday' End 

--to find total units sold in each city of 'Airport' location on weekday and weekend
select st.store_location,st.store_city,sum(s.units) as total_units_sold,
case when datename(weekday,date) in ('Saturday','Sunday') then 'Weekend' else 'Weekday' End as wkdy_type
from sales s
join stores st
on s.store_id = st.store_id 
where Store_Location = 'Airport' 
group by st.store_location, st.store_city,
case when datename(weekday,date) in ('Saturday','Sunday') then 'Weekend' else 'Weekday' End 

-- Analysis 5 - year wise comparison of units_sold of each product 
select date, datepart(year, date) as 'year' from sales

select p.product_id,p.product_name, sum(s.units) , datepart(year, s.date) as 'year'
from sales s join products p 
on s.product_id = p.product_id
group by p.product_id, p.product_name,datepart(year, s.date)

--quarter wise comparison of units_sold of each product
select p.product_id,p.product_name, sum(s.units) , datepart(year, s.date) as 'year', datepart(quarter, s.date) as 'quarter'
from sales s join products p 
on s.product_id = p.product_id
group by p.product_id, p.product_name,datepart(year, s.date),datepart(quarter, s.date)

--quarter wise comparison of units_sold of each product_category
select p.product_category, sum(s.units) , datepart(year, s.date) as 'year', datepart(quarter, s.date) as 'quarter'
from sales s join products p 
on s.product_id = p.product_id
group by p.product_category,datepart(year, s.date),datepart(quarter, s.date)

-- multiple CTEs
with last_year_sale as(
select p.product_category, sum(s.units) as units_sold , datepart(year, s.date) as 'year', datepart(quarter, s.date) as 'quarter'
from sales s join products p 
on s.product_id = p.product_id
where datepart(year, s.date) ='2022'
group by p.product_category,datepart(year, s.date),datepart(quarter, s.date)),

current_year_sale as(
select p.product_category, sum(s.units) as units_sold , datepart(year, s.date) as 'year', datepart(quarter, s.date) as 'quarter'
from sales s join products p 
on s.product_id = p.product_id
where datepart(year, s.date) ='2023'
group by p.product_category,datepart(year, s.date),datepart(quarter, s.date))

select ls.product_category, ls.year, ls.quarter, ls.units_sold as perv_units_sold, cs.units_sold as curr_units_sold
from last_year_sale ls join current_year_sale cs
on ls.product_category= cs.product_category and ls.quarter=cs.quarter
