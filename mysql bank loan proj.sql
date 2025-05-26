use project_bank_loan;

-- 1. Total Loan Applications
select count(*) as Total_Loan_Applications from bank_loan;

-- 2. Month To Date (MTD)

ALTER TABLE bank_loan ADD COLUMN issue_date_date DATE;

UPDATE bank_loan
SET issue_date_date = STR_TO_DATE(issue_date, '%d-%m-%Y');

ALTER TABLE bank_loan DROP COLUMN issue_date;

ALTER TABLE bank_loan CHANGE issue_date_date  issue_date DATE;


select count(*) as MTD_Total_Loan_Applications 
from bank_loan
where month(issue_date)=12 and year(issue_date)=2021;

-- 3. Total Funded Amount
select sum(loan_amount) as Total_funded_AMT from bank_loan;

-- 4. Sum of Loan Amount on every Month
select month(issue_date), sum(loan_amount) from bank_loan group by month(issue_date);

-- 5. Month on Month Changes in Loan Amount

select 
mnth, amount, 
lag(amount) over(order by mnth) as prev_month,
round(
(amount - (lag(amount) over(order by mnth))) / (lag(amount) over(order by mnth)) * 100, 2
)
as MOM_disbursment_Change
from 
(
select month(issue_date) as mnth,
sum(loan_amount) as Amount
from bank_loan
group by mnth
) as t;

-- 6. Average Intrest rate

select round(avg(int_rate) * 100,3)  as avg_int_rate from bank_loan;

-- 7. Calculate Good Loan, Bad Loan and Current Ongoing loans

select 
count((case when loan_status = 'Fully Paid' 
	  then id end)) / (count(id)) * 100  as Good_loan 
      from bank_loan;


select 
count((case when loan_status = 'Charged Off' 
	  then id end)) / (count(id)) * 100  as badloan
      from bank_loan;

select 
count((case when loan_status = 'Current' 
	  then id end)) / (count(id)) * 100  as Current_ongoing
      from bank_loan;      

-- 8. Loan Status View

select 
loan_status,
count(id) as Total_Applications,
sum(loan_amount) as Total_amount_Funded,
sum(total_payment) as Total_amount_Recived,
avg(int_rate) * 100 as Intrest_rate
from bank_loan
group by loan_status;

-- 9 . Total loan, Amount recived, Amount Disbursment

select 
month(issue_date) as Mnth,
monthname(issue_date) as month_number,
count(id) as Total_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_amount_recived
from bank_loan
GROUP BY YEAR(issue_date), MONTH(issue_date), MONTHNAME(issue_date)
order by mnth asc ;

select * from bank_loan;

-- 10. Find category/ purpose of the loan

select 
purpose, 
count(id) as Total_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_amount_recived
from bank_loan
GROUP BY purpose
order by count(id) desc ;

-- 11. Loan Applicants withrespect to HOME OWNERSHIP

select
home_ownership, 
count(id) as Total_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_amount_recived
from bank_loan
GROUP BY home_ownership
order by count(id) desc ;













































































































