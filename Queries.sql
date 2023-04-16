-- Procedimiento del cual podemos crear datos para las pruebas de datos
-- Se debe llamar con la siguiente firma:
-- spCreateTestData (number_of_customers int, number_of_orders int, number_of_items int , avg_items_per_order int)

CALL spCreateTestData (25, 45, 25 ,10);


-- Consultas para verificar la insercion de los datos.
SELECT * FROM Customer;
SELECT * FROM Employee;
SELECT * FROM item;
SELECT * FROM placed_order;

-- Idea para el QUERY 1.

-- SELECT DISTINCT c.customer_name, c.city
-- FROM orders o
-- JOIN customers c ON o.customer_id = c.customer_id
-- JOIN (
--     SELECT c.city, percentile_disc(0.95) WITHIN GROUP (ORDER BY order_total_price DESC) AS percentile_95
--     FROM orders o
--     JOIN customers c ON o.customer_id = c.customer_id
--     JOIN (
--         SELECT oi.order_id, SUM(oi.item_quantity * i.price) AS order_total_price
--         FROM order_items oi
--         JOIN item_in_box ib ON oi.box_id = ib.id
--         JOIN item i ON ib.item_id = i.id
--         GROUP BY oi.order_id
--     ) t ON o.id = t.order_id
--     GROUP BY c.city
-- ) top_5_percent ON c.city = top_5_percent.city AND o.order_total_price >= top_5_percent.percentile_95
-- ORDER BY c.city;