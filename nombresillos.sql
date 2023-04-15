\connect GroceryStoreData-1510627-1210921

DROP FUNCTION IF EXISTS crea_data_cliente;
DROP TABLE IF EXISTS First_name1;
DROP TABLE IF EXISTS fullname;

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
-- Funcion

CREATE FUNCTION crea_data_cliente(numero integer) 
RETURNS integer AS $$
DECLARE
    i integer := 1;
    nombre text;
    aleatorio numeric := 0;
    --aleatorio2 := numeric;
    aux boolean := FALSE;
    nombrecito varchar(35);
    apellidito varchar(35);
    per numeric;

BEGIN
    WHILE TRUE LOOP
        WHILE i <= numero LOOP
            aleatorio := floor(random() * 11);
            SELECT first_name_children, porcentaje INTO nombrecito, per FROM nomb ORDER BY random() LIMIT 1;
            SELECT last_name INTO apellidito FROM last_name ORDER BY RANDOM() LIMIT 1;
            IF aleatorio < per THEN
                INSERT INTO First_name1 (first_name1) VALUES (nombrecito);
                INSERT INTO Apellido (lastname) VALUES (apellidito);

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
SELECT * FROM First_name1;
SELECT * FROM Apellido;