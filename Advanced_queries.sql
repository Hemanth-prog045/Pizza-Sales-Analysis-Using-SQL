-- Identify the most common pizza size ordered.
select 
pizzas.size, 
count(order_details.order_details_id) as order_count
from pizzas 
join order_details
on pizzas.pizza_id = order_details.pizza_id 
group by pizzas.size 
order by order_count desc;

-- Calculate the percentage contribution 
-- of each pizza type to total revenue.
SELECT
    pizza_types.category,
    ROUND(
        SUM(orders_details.quantity * pizzas.price) * 100 /
        (
            SELECT SUM(orders_details.quantity * pizzas.price)
            FROM orders_details
            JOIN pizzas
                ON orders_details.pizza_id = pizzas.pizza_id
        ),
        2
    ) AS revenue_percentage
FROM pizza_types
JOIN pizzas
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details
    ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue_percentage DESC;

-- Analyze the cumulative revenue generated over time

SELECT
    order_date,
    SUM(revenue) OVER (ORDER BY order_date) AS cum_revenue
FROM
(
    SELECT
        orders.order_date,
        SUM(orders_details.quantity * pizzas.price) AS revenue
    FROM orders
    JOIN orders_details
        ON orders.order_id = orders_details.order_id
    JOIN pizzas
        ON orders_details.pizza_id = pizzas.pizza_id
    GROUP BY orders.order_date
) AS sales;

-- Determine the top 3 most ordered pizza types
-- based on revenue for each pizza category.
SELECT
    category,
    pizza_name,
    revenue
FROM
(
    SELECT
        pizza_types.category,
        pizza_types.name AS pizza_name,
        SUM(orders_details.quantity * pizzas.price) AS revenue,
        RANK() OVER (
            PARTITION BY pizza_types.category
            ORDER BY SUM(orders_details.quantity * pizzas.price) DESC
        ) AS ranking
    FROM pizza_types
    JOIN pizzas
        ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN orders_details
        ON pizzas.pizza_id = orders_details.pizza_id
    GROUP BY
        pizza_types.category,
        pizza_types.name
) AS ranked_pizzas
WHERE ranking <= 3
ORDER BY category, revenue DESC;