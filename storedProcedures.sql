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

    FOR i IN 1..number_of_customers LOOP
        SELECT id,city,(random() * population::INTEGER) AS randomPopulation  INTO selected_city
        FROM City_with_Population
        ORDER BY randomPopulation
        LIMIT 1;

        SELECT first_name1,lastname INTO first_name_random,second_name_random FROM First_name1,Apellido
        ORDER BY random()
        LIMIT 1;

        SELECT username INTO user_name_random FROM Username1
        ORDER BY random()
        LIMIT 1;

        SELECT password INTO password_random FROM Password
        ORDER BY random()
        LIMIT 1;

        SELECT email INTO email_random FROM Email1
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



CREATE OR REPLACE PROCEDURE insert_items(number_of_items INT)
AS $$
DECLARE
    i INTEGER;
    selected_unit RECORD;
    item_name_random TEXT;
    price_random decimal(10,2);
    item_photo_random TEXT;
    description_random TEXT;

BEGIN

    FOR i IN 1..number_of_items LOOP
        SELECT id INTO selected_unit
        FROM UNIT
        ORDER BY RANDOM()
        LIMIT 1;

        SELECT name_concat INTO item_name_random
        FROM (
            SELECT DISTINCT concat(food, ' ',brand_name) as name_concat
            FROM Food, Brand_name
        ) t
        ORDER BY Random()
        LIMIT 1;

        SELECT RANDOM()*(1000-1)+1 INTO price_random;

        SELECT 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus eleifend' INTO description_random;

        SELECT 'https://picsum.photos/id/237/200/300' INTO item_photo_random;

        INSERT INTO item (item_name,price,item_photo ,description,unit_id)
        VALUES (item_name_random, price_random, description_random, item_photo_random,selected_unit.id);
    END LOOP;

    
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE insert_Employees(number_of_employees INT)
AS $$
DECLARE
    i INTEGER;
    name_random TEXT;
    last_name_random TEXT;
    employee_code_random TEXT;

BEGIN
    FOR i IN 1..number_of_employees LOOP
        SELECT employee_code INTO employee_code_random FROM Employee_code ORDER BY random() LIMIT 1;
        SELECT first_name, last_name INTO name_random, last_name_random FROM First_name,Last_name ORDER BY random() LIMIT 1;
        INSERT INTO Employee(employee_code,first_name, last_name) VALUES (employee_code_random,name_random, last_name_random);
    END LOOP;

    
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE insert_orders(number_of_orders INT)
AS $$
DECLARE
    i INTEGER;
    customer_id_random int;  
    time_placed_now timestamp;
    details_random text;
    delivery_city_id_random int;  
    delivery_address_random varchar(255);  
    grade_customer_random int;
    grade_employee_random int;

BEGIN
  
    FOR i IN 1..number_of_orders LOOP
        SELECT id,delivery_city_id,delivery_address,FLOOR(RANDOM()*(100-1)+1)::INTEGER,FLOOR(RANDOM()*(50-1)+1)::INTEGER
        INTO customer_id_random,delivery_city_id_random,delivery_address_random,grade_customer_random,grade_employee_random 
        FROM Customer ORDER BY random() LIMIT 1;
        SELECT 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus eleifend' INTO details_random;
        INSERT INTO placed_order(customer_id,time_placed,details,delivery_city_id,delivery_address,grade_customer,grade_employee) 
        VALUES (customer_id_random,NOW(),details_random,delivery_city_id_random,delivery_address_random,grade_customer_random,grade_employee_random);
    END LOOP;

    
END
$$ LANGUAGE plpgsql;
 

CREATE PROCEDURE spCreateTestData (number_of_customers int, number_of_orders int, number_of_items int , avg_items_per_order int)
AS $$
BEGIN


PERFORM crea_data_cliente(number_of_customers);
CALL insert_Employees(FLOOR(number_of_customers*0.55)::INTEGER);
CALL insert_items(number_of_items);
CALL insert_orders(number_of_orders);


END
$$ LANGUAGE plpgsql;
