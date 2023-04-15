

CREATE OR REPLACE PROCEDURE random_city()
AS $$
DECLARE
    selected_city RECORD;
BEGIN
    SELECT id,city,(random() * population::INTEGER) AS randomPopulation  INTO selected_city
    FROM City_with_Population
    ORDER BY randomPopulation
    LIMIT 1;
    
    
     RAISE NOTICE 'Selectd id: % , Selected city: %, population: %', selected_city.id ,selected_city.city, selected_city.randomPopulation;

     RETURN;

END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE insert_customers(number_of_customers INT)
AS $$
DECLARE
    i INTEGER;
    selected_city RECORD;
    first_name_random TEXT;
    second_name_random TEXT;
    user_name_random TEXT;
    password_random TEXT;
    email_random TEXT;
    phone_number_random TEXT;
    confirmation_code_random TEXT;
    address_random TEXT;
    delivery_address_random TEXT;
BEGIN

    -- CREATE TEMP TABLE RESULT (
    --     first_name VARCHAR(64),
    --     last_name VARCHAR(64)
    -- );


    -- INSERT INTO RESULT (first_name, last_name) SELECT first_name,last_name FROM First_name,Last_name
    -- ORDER BY random() LIMIT number_of_customers;

    -- FOR items IN SELECT * FROM RESULT LOOP
    -- RAISE NOTICE 'first_name: %, last_name: %', quote_ident(items.first_name), quote_ident(items.last_name);
    -- END LOOP;

    
    -- CALL random_city();
    -- RAISE NOTICE 'Selectd id: % , Selected city: %, population: %', selected_city.id ,selected_city.city, selected_city.randomPopulation;

    -- FOR i IN SELECT * FROM RESULT LOOP
    --     INSERT INTO Customer (first_name, last_name, user_name, password, time_inserted, confirmation_code, time_confirmed, contact_email, contact_phone, city_id, address, delivery_city_id, delivery_address)
    --     VALUES (i.first_name, i.last_name, i.first_name || i.last_name, i.first_name || i.last_name, now(), i.first_name || i.last_name, now(), i.first_name || i.last_name || '@gmail.com', '123456789', 1, 'Calle 1', 1, 'Calle 2');
    -- END LOOP;

    FOR i IN 1..number_of_customers LOOP
        SELECT id,city,(random() * population::INTEGER) AS randomPopulation  INTO selected_city
        FROM City_with_Population
        ORDER BY randomPopulation
        LIMIT 1;

        SELECT first_name,last_name INTO first_name_random,second_name_random FROM First_name,Last_name
        ORDER BY random()
        LIMIT 1;

        SELECT username INTO user_name_random FROM Username
        ORDER BY random()
        LIMIT 1;

        SELECT password INTO password_random FROM Password
        ORDER BY random()
        LIMIT 1;

        SELECT email INTO email_random FROM Email
        ORDER BY random()
        LIMIT 1;

        SELECT phone_number INTO phone_number_random FROM Phone_number
        ORDER BY random()
        LIMIT 1;

        SELECT confirmation_code INTO confirmation_code_random FROM Confirmation_code
        ORDER BY random()
        LIMIT 1;

        SELECT address INTO address_random FROM Address
        ORDER BY random()
        LIMIT 1;

        SELECT delivery_address INTO delivery_address_random FROM Delivery_address
        ORDER BY random()
        LIMIT 1;

        INSERT INTO Customer (first_name, last_name, user_name, password, time_inserted, confirmation_code, time_confirmed, contact_email, contact_phone, city_id, address, delivery_city_id, delivery_address)
        VALUES (first_name_random, second_name_random, user_name_random, password_random, now(), confirmation_code_random, now(), email_random, phone_number_random, selected_city.id, address_random, selected_city.id, delivery_address_random);
    END LOOP;

    
END
$$ LANGUAGE plpgsql;


CREATE PROCEDURE spCreateTestData (number_of_customers int, number_of_orders int, number_of_items int , avg_items_per_order int)
AS $$
BEGIN

CALL insertCustomers(number_of_customers);
CALL insertOrders(number_of_orders);
CALL insertItems(number_of_items);
-- CALL insertEmployess(number_of_employees);

END
$$ LANGUAGE plpgsql;
