-- Retrieve the total number of orders placed.

select count(order_id) as total_orders from orders;

-- Calculate the total revenue generated from pizza sales.

select 
round(sum(orders_details.quantity * pizzas.price),2) as total_sales
from orders_details join pizzas
on pizzas.pizza_id = orders_details.pizza_id;

-- Identify the highest-priced pizza.

select pizza_types.name,pizzas.price
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price DESC
LIMIT 1;

-- Identify the most common pizza size ordered.
SELECT
    pizzas.size,
    COUNT(orders_details.order_details_id) AS order_count
FROM pizzas
JOIN orders_details
ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;

-- List the top 5 most ordered pizza types 
-- along with their quantities.
