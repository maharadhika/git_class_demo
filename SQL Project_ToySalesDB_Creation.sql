-- SQL Toy Sales Project
-- create database
create database ToySalesDB

use ToySalesDB

--create tables structure/ schema to import data

create table stores
( Store_ID varchar(max),
Store_Name varchar(max),
Store_City varchar(max),
Store_Location varchar(max),
Store_Open_Date varchar(max)
)

create table products
(
Product_ID varchar(max),
Product_Name varchar(max),
Product_Category varchar(max),
Product_Cost varchar(max),
Product_Price varchar(max)
)


create table inventory
(
Store_ID varchar(max),
Product_ID varchar(max),	
Stock_On_Hand varchar(max)
)

create table sales
(
Sale_ID	varchar(max),
Date varchar(max),
Store_ID varchar(max),
Product_ID	varchar(max),
Units varchar(max)
)

-- check the tables
select * from stores
select * from products
select * from inventory
select * from sales


--import data from csv files to tables using bulk insert 
--files location C:\Users\ashst\Learnbay_SQL Sample Codes

bulk insert stores
from 'C:\Users\ashst\Learnbay_SQL Sample Codes\stores.csv'
with (fieldterminator =',',
rowterminator ='\n',
firstrow=2,
maxerrors= 20
)

bulk insert products
from 'C:\Users\ashst\Learnbay_SQL Sample Codes\products.csv'
with (fieldterminator =',',
rowterminator ='\n',
firstrow=2,
maxerrors= 20
)

bulk insert inventory
from 'C:\Users\ashst\Learnbay_SQL Sample Codes\inventory.csv'
with (fieldterminator =',',
rowterminator ='\n',
firstrow=2,
maxerrors= 20
)

bulk insert sales
from 'C:\Users\ashst\Learnbay_SQL Sample Codes\sales.csv'
with (fieldterminator =',',
rowterminator ='\n',
firstrow=2,
maxerrors= 20
)

-- check and identify required datatype of columns and alter tables 
-- data cleaning 
-- convert datatypes to desired data types by alter table columns

select table_name,column_name, data_type 
from INFORMATION_SCHEMA.columns
where table_name in ('stores' , 'products', 'inventory','sales')
order by table_name

--stores table
select * from stores

select Store_ID from stores 
where store_id is null 

select Store_Open_Date from stores 
where Store_Open_Date is null 

alter table stores 
alter column Store_Id int 



select * from stores where isdate(store_open_date)=0

select store_open_date, 
substring(store_open_date,1,2) as dd, 
substring(store_open_date,4,2) as mm,
substring(store_open_date,7,4) as yyyy,
concat(substring(store_open_date,7,4),'-',substring(store_open_date,4,2),'-',substring(store_open_date,1,2)) as dt
from stores

update stores
set Store_Open_Date= concat(substring(store_open_date,7,4),'-',substring(store_open_date,4,2),'-',substring(store_open_date,1,2)) 
from stores

alter table stores
alter column Store_open_date Date

-- product table
select * from products

alter table products
alter column product_id int

select product_cost, substring(product_cost,2,len(product_cost)) as pc from products

update products 
set product_cost= substring(product_cost,2,len(product_cost))


select product_price, substring(product_price,2,len(product_price)) as pp from products

update products 
set product_price= substring(product_price,2,len(product_price))

alter table products 
alter column product_cost decimal(7,2)

alter table products 
alter column product_price decimal(7,2)

select column_name, data_type 
from INFORMATION_SCHEMA.columns
where table_name = 'products'

-- inventory table

select column_name, data_type 
from INFORMATION_SCHEMA.columns
where table_name = 'inventory'

select * from inventory

select store_id from inventory where isnumeric(store_id)=0

select product_id from inventory where isnumeric(product_id)=0

select Stock_On_Hand from inventory where isnumeric(Stock_On_Hand)=0

alter table inventory
alter column store_id int 

alter table inventory
alter column product_id int 

alter table inventory
alter column stock_on_hand int 

-- sales table
select column_name, data_type 
from INFORMATION_SCHEMA.columns
where table_name = 'sales'

alter table sales
alter column sale_id int 

alter table sales
alter column store_id int 

alter table sales
alter column product_id int 

alter table sales
alter column units int 



select [date], 
substring([date],9,2) as dd, 
substring([date],6,2) as mm,
substring([date],1,4) as yyyy,
concat(substring([date],1,4),'-',substring([date],6,2),'-',substring([date],9,2)) as dt
from sales

update sales
set Date= concat(substring([date],1,4),'-',substring([date],6,2),'-',substring([date],9,2)) 
from sales

alter table sales
alter column [Date] date 

select sale_id from sales where isnumeric(sale_id)=0

select top 1000 *from sales


