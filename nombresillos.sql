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


[0:31 p. m., 15/4/2023] Jose Matías González: Puedes crear un stored procedure en PostgreSQL que reciba como parámetro la cantidad de inserciones que deseas realizar y que realice las consultas necesarias para crear y luego insertar las filas en una tabla.

Por ejemplo, supongamos que tienes las tablas `tabla1`, `tabla2` y `tabla3`, y que deseas insertar `n` filas en la tabla `tabla_destino`. Puedes crear un stored procedure llamado `sp_insertar_filas` que reciba como parámetro la cantidad de inserciones y que realice las consultas necesarias para crear y luego insertar las filas en la tabla `tabla_destino`. El stored procedure podría tener el siguiente código:


CREATE OR REPLACE PROCEDURE sp_insertar_filas(n INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    i INTEGER;
BEGIN
    FOR i IN 1..n LOOP
        -- Consultas para crear la fila
        -- ...
        
        -- Inserción de la fila en la tabla_destino
        INSERT INTO tabla_destino (columna1, columna2, columna3)
        VALUES (valor1, valor2, valor3);
    END LOOP;
END;
$$;


En este ejemplo, el stored procedure `sp_insertar_filas` recibe como parámetro la cantidad de inserciones que deseas realizar y utiliza un bucle `FOR` para realizar las consultas necesarias y luego insertar las filas en la tabla `tabla_destino`. Dentro del bucle `FOR`, debes reemplazar las consultas para crear la fila y los valores de las columnas en la inserción por las consultas y valores que correspondan a tu caso específico.

Luego, para llamar al stored procedure y realizar las inserciones, puedes ejecutar la siguiente sentencia SQL:


CALL sp_insertar_filas(10);


En este ejemplo, se llama al stored procedure `sp_insertar_filas` y se le pasa como parámetro el valor `10`, lo que indica que se deben realizar 10 inserciones en la tabla `tabla_destino`.
[0:31 p. m., 15/4/2023] Jose Matías González: Claro, te puedo dar un ejemplo más específico. Supongamos que tienes una tabla llamada `tabla_origen` con las columnas `id`, `nombre` y `apellido`, y deseas insertar `n` filas en la tabla `tabla_destino` con las columnas `id_destino`, `nombre_completo` y `fecha_creacion`. Puedes crear un stored procedure llamado `sp_insertar_filas` que reciba como parámetro la cantidad de inserciones y que realice las consultas necesarias para crear y luego insertar las filas en la tabla `tabla_destino`. El stored procedure podría tener el siguiente código:


CREATE OR REPLACE PROCEDURE sp_insertar_filas(n INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    i INTEGER;
    id_origen INTEGER;
    nombre_completo TEXT;
BEGIN
    FOR i IN 1..n LOOP
        -- Consulta para obtener el id de la tabla_origen
        SELECT id INTO id_origen FROM tabla_origen ORDER BY RANDOM() LIMIT 1;
        
        -- Consulta para obtener el nombre completo
        SELECT CONCAT(nombre, ' ', apellido) INTO nombre_completo FROM tabla_origen WHERE id = id_origen;
        
        -- Inserción de la fila en la tabla_destino
        INSERT INTO tabla_destino (id_destino, nombre_completo, fecha_creacion)
        VALUES (id_origen, nombre_completo, NOW());
    END LOOP;
END;
$$;


En este ejemplo, el stored procedure `sp_insertar_filas` recibe como parámetro la cantidad de inserciones que deseas realizar y utiliza un bucle `FOR` para realizar las consultas necesarias y luego insertar las filas en la tabla `tabla_destino`. Dentro del bucle `FOR`, se realizan dos consultas para obtener el `id` y el `nombre_completo` de una fila aleatoria de la tabla `tabla_origen`. Luego, se inserta una fila en la tabla `tabla_destino` con el `id` obtenido de la tabla `tabla_origen`, el `nombre_completo` obtenido y la fecha actual.

Luego, para llamar al stored procedure y realizar las inserciones, puedes ejecutar la siguiente sentencia SQL:


CALL sp_insertar_filas(10);


En este ejemplo, se llama al stored procedure `sp_insertar_filas` y se le pasa como parámetro el valor `10`, lo que indica que se deben realizar 10 inserciones en la tabla `tabla_destino`.