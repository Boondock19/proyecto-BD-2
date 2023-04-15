\connect GroceryStoreData-1510627-1210921

DROP FUNCTION IF EXISTS crea_data_cliente;
DROP TABLE IF EXISTS First_name1;
DROP TABLE IF EXISTS Apellido;
DROP TABLE IF EXISTS Username1;
DROP SEQUENCE IF EXISTS user_seq;
DROP TABLE IF EXISTS dominios;
DROP TABLE IF EXISTS Email1;
DROP TABLE IF EXISTS tiempito;

CREATE TEMP TABLE nombresillos(
    ano int,
    sexo varchar(8),
    origen varchar(64),
    first_name_children varchar(35),
    count int,
    rank int
);

\COPY nombresillos FROM 'nombresillos.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);


CREATE TEMP TABLE nomb(
    sexo varchar(8),
    first_name_children varchar(35),
    total_count int
    -- porcentaje decimal
);

-- INICIAL 
INSERT INTO nomb(sexo, first_name_children,total_count)
SELECT sexo, UPPER(first_name_children) as first_name_children_uppercase, SUM(count) as total_count
FROM nombresillos
WHERE sexo = 'FEMALE'
GROUP BY sexo, UPPER(first_name_children)
ORDER BY total_count DESC
LIMIT 100;

INSERT INTO nomb(sexo, first_name_children,total_count)
SELECT sexo, UPPER(first_name_children) as first_name_children_uppercase, SUM(count) as total_count
FROM nombresillos
WHERE sexo = 'MALE'
GROUP BY sexo, UPPER(first_name_children)
ORDER BY total_count DESC
LIMIT 100;


ALTER TABLE nomb ADD COLUMN porcentaje DECIMAL(5,2) DEFAULT 0.00;

UPDATE nomb
SET porcentaje = subquery.porcentaje
FROM (
  SELECT first_name_children, ROUND(total_count*100.0/sum(total_count) OVER (), 2) as porcentaje
  FROM nomb
  WHERE sexo = 'FEMALE'
  ORDER BY total_count DESC
  LIMIT 100
) AS subquery
WHERE nomb.first_name_children = subquery.first_name_children;

UPDATE nomb
SET porcentaje = subquery.porcentaje
FROM (
  SELECT first_name_children, ROUND(total_count*100.0/sum(total_count) OVER (), 2) as porcentaje
  FROM nomb
  WHERE sexo = 'MALE'
  ORDER BY total_count DESC
  LIMIT 100
) AS subquery
WHERE nomb.first_name_children = subquery.first_name_children;

SELECT * FROM nomb;

CREATE TABLE IF NOT EXISTS First_name1 (
    first_name1 varchar(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS Apellido (
    lastname varchar(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS Username1 (
    username varchar(64) NOT NULL
);

-- Funcion
CREATE SEQUENCE user_seq;

CREATE TABLE IF NOT EXISTS dominios(
    dominio varchar(20)
);

INSERT INTO dominios (dominio) VALUES('@gmail.com');
INSERT INTO dominios (dominio)VALUES('@hotmail.com');
INSERT INTO dominios (dominio)VALUES('@yahoo.com');
INSERT INTO dominios (dominio)VALUES('@usb.ve');
INSERT INTO dominios (dominio)VALUES('@bankofamerica.com');

SELECT * FROM dominios;

CREATE TABLE IF NOT EXISTS Email1 (
    email varchar(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS tiempito(
    timecito timestamp,
    timecitolater timestamp
);


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

CREATE FUNCTION crea_data_cliente(numero integer) 
RETURNS integer AS $$
DECLARE
    i integer := 1;
    nombre text;
    aleatorio numeric := 0;
    aux boolean := FALSE;
    nombrecito varchar(35);
    apellidito varchar(35);
    per numeric;
    v_nextval INT;
    user_name1 varchar(80);
    dom varchar(20);
    contrasena varchar(64);
    phone_number_random varchar(128);
    confirmation_code_random varchar(255);
    address_random varchar(64);
    delivery_address_random varchar(255);
    time_in timestamp;
    time_con timestamp;
    selected_city RECORD;
    idprueba int;

BEGIN
    WHILE TRUE LOOP
        WHILE i <= numero LOOP
            aleatorio := floor(random() * 11);
            SELECT first_name_children, porcentaje INTO nombrecito, per FROM nomb ORDER BY random() LIMIT 1;
            SELECT last_name INTO apellidito FROM Last_name ORDER BY RANDOM() LIMIT 1;
            SELECT NEXTVAL('user_seq') INTO v_nextval;
            SELECT dominio INTO dom FROM dominios ORDER BY RANDOM() LIMIT 1;
            SELECT password INTO contrasena FROM Passwords ORDER BY RANDOM() LIMIT 1;
            SELECT phone_number INTO phone_number_random FROM Phone_number ORDER BY random() LIMIT 1;
            SELECT confirmation_code INTO confirmation_code_random FROM Confirmation_code ORDER BY random() LIMIT 1;
            SELECT address INTO address_random FROM Address ORDER BY random() LIMIT 1;
            SELECT delivery_address INTO delivery_address_random FROM Delivery_address ORDER BY random() LIMIT 1;
            SELECT time_inserted INTO time_in FROM Time_inserted ORDER BY RANDOM() LIMIT 1;
            SELECT time_confirmed INTO time_con FROM Time_confirmed WHERE time_in <= time_con ORDER BY random() LIMIT 1;
            SELECT id,city,(random() * population::INTEGER) AS randomPopulation  INTO selected_city FROM City_with_Population
                    ORDER BY randomPopulation LIMIT 1;

            IF aleatorio < per THEN
                user_name1 := CONCAT(nombrecito,'.',apellidito,'.',v_nextval);
                INSERT INTO customer (id, first_name, last_name, user_name, password, time_inserted,
                confirmation_code, time_confirmed, contact_email, contact_phone, city_id, 
                address, delivery_city_id, delivery_address) 
                VALUES (i, nombrecito, apellidito, user_name1, contrasena, 
                time_in, confirmation_code_random, now(), CONCAT(user_name1,dom), phone_number_random, 
                selected_city.id, address_random, selected_city.id, delivery_address_random)
                ON CONFLICT ON CONSTRAINT customer_ak_1 DO NOTHING;

                i := i + 1; 
            END IF;

            IF i-1 = numero THEN
                aux := TRUE;
            END IF;
        END LOOP;

        if aux THEN
            RETURN 1;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT crea_data_cliente(25);
-- SELECT * FROM First_name1;
-- SELECT * FROM Apellido;
-- SELECT * FROM Username1;
-- SELECT * FROM Email1;
-- SELECT * FROM tiempito;
SELECT * FROM customer;