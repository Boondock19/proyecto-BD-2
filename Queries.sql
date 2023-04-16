-- Procedimiento del cual podemos crear datos para las pruebas de datos
-- Se debe llamar con la siguiente firma:
-- spCreateTestData (number_of_customers int, number_of_orders int, number_of_items int , avg_items_per_order int)

CALL spCreateTestData (25, 45, 25 ,10);

SELECT * FROM Customer;
SELECT * FROM Employee;
SELECT * FROM item;
SELECT * FROM placed_order;