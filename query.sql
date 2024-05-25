/*Basic:*/

/* Q1: Retrieve the total number of orders placed. */
Select count(*) as total_orders From orders


/* Q2: Calculate the total revenue generated from pizza sales.*/
Select sum(order_details.quantity * pizzas.price) as total_sales
from pizzas 
Join order_details
on pizzas.pizza_id = order_details.pizza_id


/* Q3: Identify the highest-priced pizza.*/

/* Method 1*/
Select pizza_types.name 
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
where pizzas.price = (Select MAx(price) From pizzas)

/* Method 2*/
Select pizza_types.name 
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
Order by pizzas.price DESC 
Limit 1


/* Q4: Identify the most common pizza size ordered.*/
select pizzas.size, count(Quantity) 
from order_details join pizzas on order_details.pizza_id = pizzas.pizza_id
group by 1
order by 2 DESc
limit 1 


/* Q5: List the top 5 most ordered pizza types along with their quantities.*/
Select pizza_types.name , sum(order_details.quantity) From Order_details
Join Pizzas On Order_details.Pizza_id = pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
Group by 1
order by 2 DESC
Limit 5


--Intermediate:

/* Q6: Join the necessary tables to find the total quantity of each pizza category ordered.*/
Select pizza_types.category , sum(order_details.quantity) From Order_details
Join Pizzas On Order_details.Pizza_id = pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
Group by 1
order by 2 DESC


/* Q7: Determine the distribution of orders by hour of the day.*/
Select extract(hour from time) as hour, count(order_id) as orders from orders
group by hour
order by orders desc;


/* Q8: Join relevant tables to find the category-wise distribution of pizzas. */
Select category, count(*) as total from pizza_types
group by category
order by total desc;


/* Q9: Group the orders by date and calculate the average number of pizzas ordered per day. */
Select ROUND(avg(total), 0) as Average_per_Day From 
(Select date, sum(order_details.quantity) as total from orders 
join order_details on orders.order_id = order_details.order_id
group by date)


/* Q10 : Determine the top 3 most ordered pizza types based on revenue. */
Select pizza_types.name as name, sum(pizzas.price * order_details.quantity) as total 
from order_details 
join pizzas 
on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by name
Order by total DESC
Limit 3



-- Advanced:

/* Q11 : Calculate the percentage contribution of each pizza type to total revenue. */
SELECT pizza_types.category, 
		Concat(Round(sum(order_details.quantity*pizzas.price) / 
	(Select sum(order_details.quantity*pizzas.price) FROM order_details 
	 join pizzas on order_details.pizza_id = pizzas.pizza_id) * 100 ,2), '%')
From pizza_types join Pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
Group by 1
order by 2 DESC


/* Q12 : Analyze the cumulative revenue generated over time. */
Select date , sum(total) over (order by date) as revenue
From
(SELECT orders.date, sum(pizzas.price * order_details.quantity) as total
From orders join order_details on orders.order_id = order_details.order_id
join pizzas on order_details.pizza_id = pizzas.pizza_id
Group by orders.date
order by orders.date )


/* Q13 : Determine the top 3 most ordered pizza types based on revenue for each pizza category. */
SELECT * From(
Select category, name, total, rank() over (partition by category order by total DESC) as revenue From(	
SELECT Pizza_types.category, Pizza_types.name , sum(Pizzas.price * order_details.quantity) as total 
From Order_details Join Pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
Group by Pizza_types.category, Pizza_types.name
order by total Desc))
Where revenue < 4
