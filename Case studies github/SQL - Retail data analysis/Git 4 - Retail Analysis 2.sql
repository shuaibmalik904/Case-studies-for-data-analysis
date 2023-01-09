--DATA PREPARATION AND UNDERSTANDING:
--Q1.
select count(*) ROW_COUNT from Customer
select count(*) ROW_COUNT from Transactions
select count(*) ROW_COUNT from Category
--Q2.
select count(*) TRANS_COUNT from Transactions where cast(qty as int)<0
--Q3.
select *,convert(date,tran_date,103) [DATE] from Transactions
--Q4.
select *,year(convert(date,tran_date,105)) YEAR,datename(month,convert
(date,tran_date,105)) MONTH,day(convert(date,tran_date,105)) DAY from Transactions
--Q5.
select prod_cat from Category where prod_subcat='DIY'

--DATA ANALYSIS:
--Q1.
select top 1 Store_type,Count(*) TRAN_COUNT from Transactions
where qty>0 group by Store_type order by TRAN_COUNT desc
--Q2.
select gender,count(*) GENDER_COUNT from customer
where gender in('M','F') group by gender
--Q3.
select top 1 city_code,count(*) CUST_COUNT from 
Customer group by city_code order by CUST_COUNT desc
--Q4.
select count(*) SUBCAT_COUNT from Category where prod_cat='Books'
--Q5.
Select top 1 prod_subcat,sum(cast(qty as int)) TOT_QTY from Transactions 
t join Category c on c.prod_cat_code=t.prod_cat_code and t.
prod_subcat_code=c.prod_sub_cat_code where qty>0 group by prod_subcat
order by TOT_QTY desc
--Q6.
Select sum(cast(total_amt as float)) TOT_AMT from Transactions t 
join Category c on t.prod_cat_code=c.prod_cat_code and t.prod_subcat_code
=c.prod_sub_cat_code where prod_cat in ('Electronics','Clothing')

--Q7.
select count(*) CUST_COUNT from (select customer_Id,count(*) TOT_TRANS 
from Transactions t join Customer c on t.cust_id=c.customer_Id where 
qty>0 group by customer_Id having count(*)>10)T1
--Q8.
Select round(sum(cast(total_amt as float)),0) TOTAL_SALES from 
Transactions t join Category c on c.prod_cat_code=t.prod_cat_code 
and t.prod_subcat_code=c.prod_sub_cat_code where store_type=
'Flagship store'and prod_cat in('Electronics','Clothing')
--Q9.
Select prod_subcat,sum(cast(total_amt as float)) TOT_REVENUE from Transactions t 
join Category c on c.prod_cat_code=t.prod_cat_code and t.prod_subcat_code=
c.prod_sub_cat_code join Customer cs on cs.customer_Id=t.cust_id where gender
='M' and prod_cat='Electronics' group by prod_subcat

--Q10.
With top5 as
(select top 5 prod_cat,sum(cast(total_amt as float)) TOTAL_SALES
from Transactions t join Category c on c.prod_cat_code=t.prod_cat_code
and t.prod_subcat_code=c.prod_sub_cat_code group by prod_cat order by 
TOTAL_SALES desc),sales as
(select prod_subcat,sum(cast(total_amt as float)) TOTAL_SALES,
abs(sum(case when qty<0 then cast(total_amt as float) end))
TOTAL_RETURN from Transactions t join Category c on c.prod_cat_code
=t.prod_cat_code and t.prod_subcat_code=c.prod_sub_cat_code group 
by prod_subcat)select PROD_SUBCAT,total_sales/(select sum(total_sales) 
from sales)*100 SALES_PERCT,total_return/(select sum(total_return) 
from sales)*100 RETURN_PERCT from sales

--Q.11
with data30 as
(Select *,datediff(year,convert(date,DOB,105),getdate()) AGE, 
datediff(day,convert(date,tran_date,105),(select max(convert
(date,tran_date,105)) from transactions)) DAY_NUM from 
Transactions t right join Customer c on t.cust_id=c.customer_Id)
select sum(cast(total_amt as float)) NET_REVENUEfrom data30 
where age between 25 and 35 and day_num<31

--Q.12
Select prod_cat,abs(sum(cast(total_amt as float))) TOTAL_RETURN 
from Transactions t join Category c on t.prod_cat_code=c.prod_cat_code 
and t.prod_subcat_code=c.prod_sub_cat_code where datediff(month,convert
(date,tran_date,105),(select max(convert(date,tran_date,105)) from 
transactions))<4 and qty<0 group by prod_cat order by TOTAL_RETURN desc

--Q.13
select top 1 Store_type,sum(cast(total_amt as float)) TOT_SALES,
sum(cast(qty as int)) TOT_QTY from Transactions group by Store_type 
order by TOT_SALES desc,TOT_QTY desc

--Q.14
with avg_rev as
(Select transaction_id,cust_id,tran_date,c.prod_cat,prod_subcat,
qty,total_amt,Store_type from Transactions t join Category c on t.prod_cat_code=
c.prod_cat_code and t.prod_subcat_code=c.prod_sub_cat_code)
select prod_cat,avg(cast(total_amt as float)) AVG_REVENUE from avg_rev
group by prod_cat having avg(cast(total_amt as float))
>(select avg(cast(total_amt as float)) from avg_rev)

--Q.15
with top05 as 
(Select top 5 prod_cat,sum(cast(qty as int)) TOTAL_QTY 
from Transactions t join Category c on t.prod_cat_code=
c.prod_cat_code and t.prod_subcat_code=c.prod_sub_cat_code
group by prod_cat order by TOTAL_QTY desc)
Select prod_subcat,sum(cast(total_amt as float)) 
TOTAL_REVENUE,avg(cast(total_amt as float)) AVG_REVENUE 
from Transactions t join Category c on t.prod_cat_code=
c.prod_cat_code and t.prod_subcat_code=c.prod_sub_cat_code
where prod_cat in(select prod_cat from top05)
group by prod_subcat order by prod_cat

