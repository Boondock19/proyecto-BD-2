



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
DECLARE
    items RECORD;
BEGIN

    CREATE TEMP TABLE RESULT (
        first_name VARCHAR(64),
        last_name VARCHAR(64)
    );


    INSERT INTO RESULT (first_name, last_name) SELECT first_name,last_name FROM First_name,Last_name
    ORDER BY random() LIMIT number_of_customers;

    FOR items IN SELECT * FROM RESULT LOOP
    RAISE NOTICE 'first_name: %, last_name: %', quote_ident(items.first_name), quote_ident(items.last_name);
    END LOOP;

    -- FOR i IN SELECT * FROM RESULT LOOP
    --     INSERT INTO Customer (first_name, last_name, user_name, password, time_inserted, confirmation_code, time_confirmed, contact_email, contact_phone, city_id, address, delivery_city_id, delivery_address)
    --     VALUES (i.first_name, i.last_name, i.first_name || i.last_name, i.first_name || i.last_name, now(), i.first_name || i.last_name, now(), i.first_name || i.last_name || '@gmail.com', '123456789', 1, 'Calle 1', 1, 'Calle 2');
    -- END LOOP;

   
    
END
$$ LANGUAGE plpgsql;

