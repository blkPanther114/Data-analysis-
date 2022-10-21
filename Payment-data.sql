--LAB 3
Create database Lab3
Select * from Payments

-- What is the count of the unqiue accounts that makes at least one payment on any given day
select Count(DISTINCT account_id) as Unique_Count
from payments
WHERE  payment_date = '2022-01-02' AND Payment_Status = 'completed';
--HAVING count("payment_id") >= 1;



-- What is the count of the unqiue accounts that makes at least one payment in a month
select Count(DISTINCT account_id) as count_accounts
from payments 
WHERE Month(payment_date) = 9 AND Payment_Status = 'completed';





-- Average payments per account?
select account_id,avg(Amount) as Average_count_per_payment
from PAYMENTS 
GROUP BY account_id;






-- Failed payment rate for the month of January in 2022?
Select ((count(case when Payment_Status='Failed' then 1 end )*1.00)/(count(Payment_Status)*1.00)) AS FAILD_RATE_THIS_MONTH from payments WHERE MONTH(Payment_date)= 1


-- What is the number of GBP payments that have no decimal place?
SELECT count(amount) AS NO_DECIMAL_PLACE from payments where amount = round(amount,0) AND CURRENCY = 'GBP';
