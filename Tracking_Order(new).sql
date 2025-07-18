-- Select the shchema
USE food_service_db;

/* tracking the orders in progress 
 We use the aliases to make the statements shorter
 co-> customer_order cu-> customer 
 Show the track_order view, only tracks the "in-progress" order */
CREATE VIEW track_order AS
SELECT 
    co.customer_order_id,
    cu.customer_name,
    co.customer_order_date,
    co.customer_order_status
FROM customer_order co
JOIN customer cu ON co.customer_id = cu.customer_id
WHERE co.customer_order_status = 'in progress';

-- Query to see all customers' orders in progress
SELECT * FROM track_order;

/* Summary of the whole orders 
 co-> customer_order cu-> customer m->meal col -> customer_order_line_item
 Show the Order_summart view */
CREATE VIEW Order_Summary AS
SELECT 
    co.customer_order_id,
    cu.customer_name,
-- GROUP_CONCAT to combine the 'meal' with 'quantity'
    GROUP_CONCAT(CONCAT(m.meal_name, ' x', col.meal_unit_quantity) SEPARATOR ', ') AS items,
    co.customer_order_total AS total_amount,
    co.customer_order_status,
    co.customer_order_date
FROM customer_order co
JOIN customer cu ON co.customer_id = cu.customer_id
JOIN customer_order_line_item col ON co.customer_order_id = col.customer_order_id
JOIN meal m ON col.meal_id = m.meal_id
GROUP BY co.customer_order_id;

-- Query to see order summary
SELECT * FROM Order_Summary;

/* A preferred meal from customers to track order better
the data need to be filled to make the preferrences a complementary one */

-- Simple customer_preferences view 
CREATE VIEW customer_preferences AS
SELECT
    cu.customer_name,
    m.meal_name,
    COUNT(*) AS order_frequency,
    SUM(col.meal_unit_quantity) AS total_quantity
FROM customer cu
JOIN customer_order co ON cu.customer_id = co.customer_id
JOIN customer_order_line_item col ON co.customer_order_id = col.customer_order_id
JOIN meal m ON col.meal_id = m.meal_id
GROUP BY cu.customer_id, cu.customer_name, m.meal_id, m.meal_name
ORDER BY order_frequency DESC;

-- Query to see all customer preferences
SELECT * FROM customer_preferences;