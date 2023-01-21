use credit_card_classification;

-- 4 Select all the data from table credit_card_data to check if the data was imported correctly.
select * from credit_card_data;

-- 5 Use the alter table command to drop the column q4_balance from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
ALTER TABLE credit_card_data
DROP COLUMN q4_balance;

select * from credit_card_data
limit 10;

-- 6 Use sql query to find how many rows of data you have. 
-- I have 17976, I think the rows with NaNs have not been imported.
select count(customer_number) as total
from credit_card_data;

-- 7 Now we will try to find the unique values in some of the categorical columns:

-- What are the unique values in the column Offer_accepted?
-- yes / no
select distinct offer_accepted
from credit_card_data;

-- What are the unique values in the column Reward?
-- Air Miles
-- Cash Back
-- Points
select distinct reward
from credit_card_data;

-- What are the unique values in the column mailer_type?
-- Letter / Postcard
select distinct mailer_type
from credit_card_data;

-- What are the unique values in the column credit_cards_held?
-- 1, 2, 3, 4 
select distinct credit_cards_held
from credit_card_data
order by credit_cards_held; -- I didn't need to order them, but I like to display them in order

-- What are the unique values in the column household_size?
-- 1, 2, 3, 4, 5, 6, 7, 8, 9
select distinct household_size
from credit_card_data
order by household_size; -- same as before


-- 8 Arrange the data in a decreasing order by the average_balance of the customer. 
-- Return only the customer_number of the top 10 customers with the highest average_balances in your data.
select customer_number
from credit_card_data
order by average_balance desc
limit 10;

-- 9 What is the average balance of all the customers in your data?
-- 940.6383
select avg(average_balance) as avg_average_balance
from credit_card_data;

-- 10 In this exercise we will use simple group_by to check the properties of some of the categorical variables in our data. 
-- Note wherever average_balance is asked, please take the average of the column average_balance:

-- What is the average balance of the customers grouped by Income Level? The returned result should have only two columns, 
-- income level and Average balance of the customers. Use an alias to change the name of the second column.
select income_level, avg(average_balance) as avg_b
from credit_card_data
group by income_level;

-- What is the average balance of the customers grouped by number_of_bank_accounts_open? 
-- The returned result should have only two columns, number_of_bank_accounts_open and Average balance of the customers. 
-- Use an alias to change the name of the second column.
select bank_accounts_open, avg(average_balance)
from credit_card_data
group by bank_accounts_open;

-- What is the average number of credit cards held by customers for each of the credit card ratings? 
-- The returned result should have only two columns, rating and average number of credit cards held. 
-- Use an alias to change the name of the second column.
select credit_rating, avg(average_balance)
from credit_card_data
group by credit_rating;

-- Is there any correlation between the columns credit_cards_held and number_of_bank_accounts_open? 
-- You can analyse this by grouping the data by one of the variables and then aggregating the results 
-- of the other column. Visually check if there is a positive correlation or negative correlation 
-- or no correlation between the variables.
select credit_cards_held, count(bank_accounts_open) as count_bank_accounts_open
from credit_card_data
group by credit_cards_held
order by credit_cards_held;

select bank_accounts_open, count(credit_cards_held) as count_credit_cards_held
from credit_card_data
group by bank_accounts_open
order by bank_accounts_open;

-- Propose it to Natascha
-- I think the correlation here could be seeing that the more we increase the bank accounts open, the less customers we 
-- see having more than 1 account. The most common combination is 1 account with 2 cards, followed by 1 accounts w/
-- 1 card, and 1 account with 3 cards. once we start increasing the accounts open to 2, the most common combinations are 
-- with one or 2 cards, and the other combinations (2 accounts w/ 3 cards, all the combo w/ 3 accounts) are insignificant.
select bank_accounts_open, credit_cards_held, COUNT(*) as accounts
  from credit_card_data
 group by bank_accounts_open, credit_cards_held
 order by bank_accounts_open asc, credit_cards_held asc, accounts asc;
 
 
-- Your managers are only interested in the customers with the following properties:

-- Credit rating medium or high
-- Credit cards held 2 or less
-- Owns their own home
-- Household size 3 or more

-- For the rest of the things, they are not too concerned. 
-- Write a simple query to find what are the options available for them? 
-- Can you filter the customers who accepted the offers here?

select * from credit_card_data
where credit_rating != 'Low'
	and credit_cards_held < 3
    and own_your_home = 'Yes'
    and household_size >= 3
    and offer_accepted = 'Yes';
    
-- Your managers want to find out the list of customers whose average balance is less than the average 
-- balance of all the customers in the database. 
-- Write a query to show them the list of such customers. You might need to use a subquery for this problem.
select customer_number, average_balance
from credit_card_data
having average_balance < 
	(select avg(average_balance) from credit_card_data)
order by average_balance desc; -- I like to order them in a desc way

-- Since this is something that the senior management is regularly interested in, create a view of the same query.
create view less_than_average as
	select customer_number, average_balance
	from credit_card_data
	having average_balance < 
		(select avg(average_balance) from credit_card_data)
	order by average_balance desc;

-- What is the number of people who accepted the offer vs number of people who did not?
select offer_accepted, count(offer_accepted) as total
from credit_card_data
group by offer_accepted;

-- Your managers are more interested in customers with a credit rating of high or medium. 
-- What is the difference in average balances of the customers with high credit card rating 
-- and low credit card rating?
with average_high_rating as (
	select avg(average_balance) as average_high
    from credit_card_data
    where credit_rating = 'High'
), average_low_rating as (
	select avg(average_balance) as average_low
    from credit_card_data
    where credit_rating = 'Low'
)
select (average_high - average_low) as difference_high_low_rating
from average_high_rating, average_low_rating;

-- In the database, which all types of communication (mailer_type) were used and with how many customers?
select mailer_type, count(customer_number) as total_customer
from credit_card_data
group by mailer_type;

-- Provide the details of the customer that is the 11th least Q1_balance in your database.
-- There are 3 customers at the 11th place
with q1_ranking as (
	select *, 
		dense_rank() over(order by q1_balance asc) as ranking
        from credit_card_data
)
select * from q1_ranking
where ranking = 11;












