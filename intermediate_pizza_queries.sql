-- Join the necessary tables to find the total quantity of 
-- each pizza category ordered.
select pizza_types.category,
sum(orders_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join 
orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc;

-- Determine the distribution of orders by hour of the day.
select hour(order_time), count(order_id) from orders
group by hour(order_time);

-- Join relevant tables to find the category-wise
-- distribution of pizzas.
select category, count(name) from
pizza_types 
group by category;

-- Group the orders by date and 
-- calculate the average number of pizzas ordered per day.
SELECT ROUND(AVG(quantity), 0) AS average_pizzas_per_day
FROM
(
    SELECT
        orders.order_date,
        SUM(orders_details.quantity) AS quantity
    FROM orders
    JOIN orders_details
        ON orders.order_id = orders_details.order_id
    GROUP BY orders.order_date
) AS order_quantity;

-- Determine the top 3 most ordered pizza types
-- based on revenue.
select pizza_types.name, 
SUM(orders_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by revenue desc 
limit 3;


