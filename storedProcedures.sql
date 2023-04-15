



CREATE PROCEDURE spCreateTestData (number_of_customers int, number_of_orders int, number_of_items int , avg_items_per_order int)
AS $$
BEGIN

CALL insertCustomers(number_of_customers);
CALL insertOrders(number_of_orders);
CALL insertItems(number_of_items);
-- CALL insertEmployess(number_of_employees);

END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE insert_customers(number_of_customers INT)
AS $$
BEGIN

    SELECT first_name, last_name FROM First_name,Last_name
    ORDER BY random() LIMIT number_of_customers;

    
END
$$ LANGUAGE plpgsql;

