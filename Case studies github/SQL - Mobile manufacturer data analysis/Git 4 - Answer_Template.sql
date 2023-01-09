--SQL Advance Case Study

use Projects
--Q1 . List all the states in which we have customers who have bought cellphones  from 2005 till today. 
select  distinct l.[State] from TRANSACTIONS t join customer c on c.IDCustomer
=t.IDCustomer join LOCATION L on l.IDLocation=t.IDLocation
where year(Date)>2004;	
--Q1--END

--Q2 . What state in the US is buying the most 'Samsung' cell phones? 
select state,sum(TotalPrice) TOTAL_SALES from TRANSACTIONS 
t join LOCATION l on t.IDLocation=l.IDLocation join model 
m on m.IDModel=t.IDModel join MANUFACTURER mf on mf.IDManufacturer
=m.IDManufacturer where mf.Manufacturer_Name='Samsung' group by [state] ;
--Q2--END

--Q3 . Show the number of transactions for each model per zip code per state.      
select [state],ZipCode,m.Model_Name,count(*) TRANS_COUNT from TRANSACTIONS 
t join location l on l.IDLocation=t.IDLocation join model m on m.IDModel
=t.IDModel group by [state],ZipCode,m.Model_Name ;
--Q3--END

--Q4 . Show the cheapest cellphone (Output should contain the price also) 
Select top 1 Model_Name,Unit_price from model order by Unit_price; 
--Q4--END

--Q5 . Find out the average price for each model in the top5 manufacturers in  terms of sales quantity and order by average price.
With top5 as
(select top 5 IDManufacturer,
sum(Quantity) TOTAL_QTY from TRANSACTIONS t join model m on 
t.IDModel=m.IDModel group by IDManufacturer order by TOTAL_QTY desc)
select Model_Name,avg(TotalPrice) AVG_PRICE from TRANSACTIONS 
t join model m on t.IDModel=m.IDModel join MANUFACTURER mf
on mf.IDManufacturer=m.IDManufacturer where m.IDManufacturer 
in (select IDManufacturer from top5) group by Model_Name

--Q5--END

--Q6 . List the names of the customers and the average amount spent in 2009,  where the average is higher than 500 
select Customer_Name,avg(TotalPrice) AVG_SPEND from TRANSACTIONS t 
join CUSTOMER c on c.IDCustomer=t.IDCustomer where year(Date)=2009
group by Customer_Name  having avg(TotalPrice)>500;
--Q6--END
	
--Q7 . List if there is any model that was in the top 5 in terms of quantity,  simultaneously in 2008, 2009 and 2010  
with top08 as 
(select top 5 Model_Name,sum(Quantity) TOT_QTY from TRANSACTIONS 
t join model m on m.IDModel=t.IDModel where year(Date)=2008 group 
by Model_Name order by TOT_QTY desc),top09 as
(select top 5 Model_Name,sum(Quantity) TOT_QTY from TRANSACTIONS 
t join model m on m.IDModel=t.IDModel where year(Date)=2009 group 
by Model_Name order by TOT_QTY desc),top010 as 
(select top 5 Model_Name,sum(Quantity) TOT_QTY from TRANSACTIONS 
t join model m on m.IDModel=t.IDModel where year(Date)=2010 group 
by Model_Name order by TOT_QTY desc)
select Model_Name from top08 
intersect 
select Model_Name from top09
intersect
select Model_Name from top010;

--Q7--END	

--Q88 . Show the manufacturer with the 2nd top sales in the year of 2009 and the  manufacturer with the 2nd top sales in the year of 2010. 
with top2009 as
(select top 1 * from (select top 2 IDManufacturer,sum(TotalPrice) 
TOT_SALES from TRANSACTIONS 
t join model m on m.IDModel=t.IDModel where year(date)=2009 group 
by IDManufacturer order by TOT_SALES desc)T1 order by TOT_SALES),
top2010 as
(select top 1 * from (select top 2 IDManufacturer,sum(TotalPrice) 
TOT_SALES from TRANSACTIONS 
t join model m on m.IDModel=t.IDModel where year(date)=2010 group 
by IDManufacturer order by TOT_SALES desc)T1 order by TOT_SALES)
select * from top2009 union all select * from top2010;

--Q8--END
--Q9 . Show the manufacturers that sold cellphones in 2010 but did not in 2009. 
With manuf10 as 
(select mf.Manufacturer_Name from TRANSACTIONS t join 
model m on m.IDModel=t.IDModel join MANUFACTURER mf on
mf.IDManufacturer=m.IDManufacturer where year(Date)=2010),
manuf09 as
(select mf.Manufacturer_Name from TRANSACTIONS t join 
model m on m.IDModel=t.IDModel join MANUFACTURER mf on
mf.IDManufacturer=m.IDManufacturer where year(Date)=2009)
select * from manuf10 except select * from manuf09;

--Q9--END

--Q10 . Find top 10 customers and their average spend, average quantity by each  year. Also find the percentage of change in their spend
WITH top10 as 
(select year(Date) [YEAR],Customer_Name,sum(totalprice) TOTAL_SALES,avg(TotalPrice) 
AVG_SPEND,avg(Quantity) AVG_QTY from TRANSACTIONS t join CUSTOMER c on c.IDCustomer
=t.IDCustomer group by year(Date),Customer_Name),row_n as
(select row_number() over(partition by [year] order by total_sales 
desc ) ROW_NUM#,*from top10)
select *,(TOTAL_SALES-lag(TOTAL_SALES)over(partition by customer_name order by 
[year]))/lag(TOTAL_SALES)over(partition by customer_name order by [year])*100
 YEARLY_PER_CHANGE from row_n where row_num#<11 order by Customer_Name,[YEAR];
--Q10--END

	