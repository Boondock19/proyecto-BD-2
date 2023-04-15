\connect GroceryStoreData-1510627-1210921

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

-- Funcion

CREATE FUNCTION crea_data_cliente(numero integer) 
RETURNS integer AS $$
DECLARE
    contador integer := 0;
    i integer := 1;
    nombre text;
    aleatorio := numeric;
BEGIN
    WHILE i <= numero LOOP
        aleatorio := floor(random() * 11);
        SELECT @nombrecito := first_name_children, @per := porcentaje INTO nombre FROM nomb;
        IF aleatorio < @per THEN --Donde esta el 0,03 va el porcentaje de la tabla
            --insert a la tabla de la data ficticia
            INSERT INTO customer (first_name) VALUES (@nombrecito);
            i := i + 1;
        END IF;
    END LOOP;
    RETURN contador;
END;
$$ LANGUAGE plpgsql;


