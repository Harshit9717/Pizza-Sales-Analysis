--Retrieve the total numbers of orders placed.
select count(order_id) as total_orders from orders;

--Calculate the total revenue generated from pizza sales.
select sum(order_details.quantity * pizzas.price) as total_revenue
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id

--Identify the highest-priced pizza.
select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
order by pizzas.price desc 
limit 1;

--Identify the most common pizza size ordered.
select pizzas.size, count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc;

--List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name, sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name
order by quantity desc
limit 5;

--Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category, sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category
order by quantity desc; 

--Determine the distribution of orders by hour of the day.
select extract(hour from orders.time) as order_hours, count(order_id) as order_count
from orders
group by order_hours;

--Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name) 
from pizza_types
group by category;

--Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0) as average_pizzas_per_day from 
(select orders.date, sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.date) as order_quantity;

--Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name, sum(order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by revenue desc
limit 3;

--Analyze the cumulative revenue generated over time.
select date, sum(revenue) over (order by date) as cumulative_revenue
from
(select orders.date, sum(order_details.quantity*pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.date) as sales;

