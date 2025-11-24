SELECT 
	Year(start_timestamp) As Year,
	Month(start_timestamp) As month,
    sum(total_paid) as Total_revenue
FROM rental
GROUP BY Year,Month
UNION ALL
SELECT 
	Year(start_timestamp) As Year,
	NULL As month,
    sum(total_paid) as Total_revenue
FROM rental
GROUP BY Year
UNION ALL
SELECT 
	NULL As Year,
	NULL As month,
    sum(total_paid) as Total_revenue
FROM rental
ORDER BY (YEAR IS NULL),Year;

-- Display the category name and the number of bikes the shop owns in
-- each category (call this column number_of_bikes ). Show only the categories
-- where the number of bikes is greater than 2 

SELECT Category, count(category) As No_Of_bikes
FROM bike GROUP BY Category
HAVING No_of_bikes > 2;


-- Emily needs a list of customer names with the total number of
-- memberships purchased by each.
-- For each customer, display the customer's name and the count of
-- memberships purchased (call this column membership_count ). Sort the
-- results by membership_count , starting with the customer who has purchased
-- the highest number of memberships.
-- Keep in mind that some customers may not have purchased any
-- memberships yet. In such a situation, display 0 for the membership_count .

SELECT
	c.name,
    count(m.membership_type_id) As membership_count
FROM customer c LEFT JOIN membership m 
ON c.id = m.customer_id
GROUP BY c.name ORDER BY membership_count DESC;
    


-- Emily is working on a special offer for the winter months. Can you help her
-- prepare a list of new rental prices?
-- For each bike, display its ID, category, old price per hour (call this column
-- old_price_per_hour ), discounted price per hour (call it new_price_per_hour ), old
-- price per day (call it old_price_per_day ), and discounted price per day (call it
-- new_price_per_day ).
-- Electric bikes should have a 10% discount for hourly rentals and a 20%
-- discount for daily rentals. Mountain bikes should have a 20% discount for
-- hourly rentals and a 50% discount for daily rentals. All other bikes should
-- have a 50% discount for all types of rentals.
-- Round the new prices to 2 decimal digits.

WITH 
	bike_info As (
		SELECT
		id,
		category,
		price_per_hour,
        price_per_day
	FROM bike
	GROUP BY id,category
)
SELECT 
	id,
    category,
    price_per_hour As old_price_per_hour,
    CASE 
		 WHEN Category = 'electric' THEN price_per_hour * 0.90 
		 WHEN Category = 'mountain bike' THEN price_per_hour * 0.80
         ELSE price_per_hour * 0.50
	END New_Price_per_hour,
     price_per_day As old_price_per_day,
	CASE 
		WHEN Category = 'electric' THEN price_per_day * 0.80 
		WHEN Category = 'mountain bike' THEN price_per_day * 0.50
		ELSE  price_per_day * 0.50 
	END New_price_per_day
FROM bike_info;
    
    
-- Emily is looking for counts of the rented bikes and of the available bikes in
-- each category.
-- Display the number of available bikes (call this column
-- available_bikes_count ) and the number of rented bikes (call this column
-- rented_bikes_count ) by bike category.

SELECT 
	Category,
    count(*) as Total_bike,
    count(CASE WHEN status = 'available' THEN 1 END) As Total_Available_bike,
    count(CASE WHEN status = 'rented' THEN 1 END) As Total_Rented_bike,
    count(CASE WHEN status='out of service' THEN 1 END) As Total_Out_Of_Service
FROM bike 
GROUP BY Category;

-- Emily is preparing a sales report. She needs to know the total revenue
-- from rentals by month, the total by year, and the all-time across all the
-- years.
-- Bike rental shop - SQL Case study 5
-- Display the total revenue from rentals for each month, the total for each
-- year, and the total across all the years. Do not take memberships into
-- account. There should be 3 columns: year , month , and revenue .
-- Sort the results chronologically. Display the year total after all the month


SELECT 
	Year(start_timestamp) As Year,
	Month(start_timestamp) As month,
    sum(total_paid) as Total_revenue
FROM rental
GROUP BY Year,Month
UNION ALL
SELECT 
	Year(start_timestamp) As Year,
	NULL As month,
    sum(total_paid) as Total_revenue
FROM rental
GROUP BY Year
UNION ALL
SELECT 
	NULL As Year,
	NULL As month,
    sum(total_paid) as Total_revenue
FROM rental
ORDER BY (YEAR IS NULL),Year;


-- Emily has asked you to get the total revenue from memberships for each
-- combination of year, month, and membership type.
-- Display the year, the month, the name of the membership type (call this
-- column membership_type_name ), and the total revenue (call this column
-- total_revenue ) for every combination of year, month, and membership type.
-- Sort the results by year, month, and name of membership type.


SELECT 
	YEAR(m.start_date) As Year,
    MONTH(m.Start_date) AS Month,
    mt.name As membership_type_name,
    sum(m.total_paid) As total_revenue 
FROM membership m JOIN membership_type mt ON m.membership_type_id = mt.id
GROUP BY Year,Month,membership_type_name
ORDER BY Year,Month,membership_type_name;



-- Next, Emily would like data about memberships purchased in 2023, with
-- subtotals and grand totals for all the different combinations of membership
-- types and months.
-- Display the total revenue from memberships purchased in 2023 for each
-- combination of month and membership type. Generate subtotals and
-- grand totals for all possible combinations. There should be 3 columns:
-- membership_type_name , month , and total_revenue .
-- Sort the results by membership type name alphabetically and then
-- chronologically by month.
SELECT 
	MONTH(m.start_date) as month,
    mt.name As membership_type,
    sum(m.total_paid) as Total_Revenue
FROM membership m JOIN membership_type mt ON m.membership_type_id = mt.id
WHERE YEAR(start_date) = 2023
GROUP BY month,membership_type
UNION ALL
SELECT 
	MONTH(m.start_date) as month,
    null As membership_type,
    sum(m.total_paid) as Total_Revenue
FROM membership m JOIN membership_type mt ON m.membership_type_id = mt.id
WHERE YEAR(start_date) = 2023
GROUP BY month
UNION ALL
SELECT 
	null as month,
    null As membership_type,
    sum(m.total_paid) as Total_Revenue
FROM membership m JOIN membership_type mt ON m.membership_type_id = mt.id
WHERE YEAR(start_date) = 2023
ORDER BY 
	Month IS NULL,      -- ensures grand total appears at last
	Month;

WITH Count_rent As (
	SELECT
		c.name,
		count(r.bike_id) as Total_rentals 
	FROM customer c LEFT JOIN rental r ON r.customer_id = c.id
	GROUP BY c.name 
	ORDER BY Total_rentals DESC
)
SELECT
	CASE 
		WHEN Total_rentals > 10 THEN 'more than 10' 
        WHEN Total_rentals BETWEEN 5 AND 10 THEN 'between 5 and 10' 
        WHEN Total_rentals <5 THEN 'less than 5'
	END rental_count_category,
    count(Total_rentals) As Total_customers
FROM count_rent
GROUP BY rental_count_category;
    
    
 


