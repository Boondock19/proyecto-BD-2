-- Para iniciar el servicio en Ubuntus sudo service postgresql start
-- Para el password del usuario Boondock es 123456


-- Los bebedores que no frecenan ninguna fuente de soda
SELECT * FROM BEBEDOR
WHERE CI NOT IN (SELECT CI FROM FRECUENTA);

-- Lo mismo pero con un not exists.
SELECT b.ci , b.nombre FROM BEBEDOR b 
WHERE NOT EXISTS (
    SELECT ci FROM FRECUENTA WHERE ci = b.ci );

-- 1- Bebedores que no les gusta la malta.
-- Solucion con except y exists.
SELECT * FROM BEBEDOR
EXCEPT (SELECT * FROM BEBEDOR b  WHERE EXISTS 
(SELECT g.* FROM GUSTA g WHERE EXISTS 
(SELECT * FROM BEBIDA 
WHERE NombreBeb = 'Malta' AND  codBeb = g.codBeb AND g.ci = b.ci)));

-- Solucion con cross join

SELECT b.* FROM BEBEDOR b
EXCEPT 
SELECT b2.* FROM BEBEDOR b2 , GUSTA g, BEBIDA be
WHERE  g.CI = b2.CI AND be.CodBeb = g.CodBeb AND be.NombreBeb = 'Malta';

-- Solucion con not in 

SELECT b.* FROM BEBEDOR b
WHERE b.CI NOT IN (SELECT g.CI FROM GUSTA g, BEBIDA be
WHERE g.CodBeb = be.CodBeb AND be.nombreBeb = 'Malta');

-- 2- Las fuentes de soda que no son frecuentadas por Luis Perez.
-- Solucion con not exists
SELECT fs.* FROM FUENTE_SODA fs
WHERE NOT EXISTS 
(SELECT f.CodFS,b.ci FROM FRECUENTA f , BEBEDOR b WHERE  
f.CI = b.CI AND b.Nombre = 'Luis Perez' AND fs.CodFS = f.CodFS);

-- Solucion con cross join 
SELECT fs.* FROM FUENTE_SODA fs
EXCEPT
SELECT fs2.* FROM FUENTE_SODA fs2, FRECUENTA f, BEBEDOR b
WHERE b.Nombre = 'Luis Perez' AND fs2.CodFS = f.CodFS  AND b.CI = f.CI;

-- 3- Los bebedores que les gusta al menos una bebida y que frecuentan al menos una fuente de soda.
-- Solucion con natural join y group by
SELECT DISTINCT b.* FROM BEBEDOR b 
NATURAL JOIN GUSTA g 
NATURAL JOIN FRECUENTA f GROUP BY b.ci;

-- Solucion con exists

SELECT b.* FROM BEBEDOR b
WHERE EXISTS (SELECT g.* FROM GUSTA g WHERE g.CI = b.CI) AND EXISTS (SELECT f.* FROM FRECUENTA f WHERE f.CI = b.CI);


-- Solucion con in

SELECT b.* FROM BEBEDOR b
WHERE b.CI IN (SELECT g.CI FROM GUSTA g) AND b.CI IN (SELECT f.CI FROM FRECUENTA f);

-- 4-  Para cada bebedor, las bebidas que no le gustan. 
 SELECT CI,Nombre,CodBeb,NombreBeb  FROM 
 (SELECT CI,CodBeb FROM BEBEDOR CROSS JOIN BEBIDA 
 EXCEPT (SELECT * FROM GUSTA)) AS Q1  
 NATURAL JOIN BEBEDOR 
 NATURAL JOIN BEBIDA;

  SELECT CI,Nombre,CodBeb,NombreBeb  FROM 
 BEBEDOR CROSS JOIN BEBIDA 
 EXCEPT (SELECT * FROM GUSTA   
 NATURAL JOIN BEBEDOR 
 NATURAL JOIN BEBIDA);

 SELECT b.*,be.* FROM BEBEDOR b, BEBIDA be  
 WHERE NOT EXISTS 
 (SELECT g.* FROM GUSTA g WHERE b.CI = g.CI AND  g.codBeb = be.CodBeb);


-- 5 Los bebedores que les gusta la malta y que no les gusta la Frescolita y la Coca-Cola.
-- Sirve pero Marlene no lo acepta.
SELECT * FROM BEBEDOR b NATURAL JOIN 
(SELECT CI FROM GUSTA NATURAL JOIN 
BEBIDA WHERE BEBIDA.NombreBeb = 'Malta') AS Q1 EXCEPT 
(SELECT * FROM BEBEDOR NATURAL JOIN 
((SELECT CI FROM GUSTA NATURAL JOIN 
BEBIDA WHERE BEBIDA.NombreBeb = 'Frescolita') AS Q2 NATURAL JOIN 
(SELECT CI FROM GUSTA NATURAL JOIN BEBIDA WHERE BEBIDA.NombreBeb = 'Coca-Cola') AS Q3));

-- 4 PERO CON EXISTS
SELECT * FROM BEBEDOR b
WHERE NOT EXISTS (
    SELECT * FROM GUSTA g , BEBIDA be
        WHERE g.CI NOT IN 
        (SELECT CI FROM GUSTA , BEBIDA WHERE 
        BEBIDA.NombreBeb = 'Frescolita' AND GUSTA.CodBeb = BEBIDA.CodBeb)
        AND g.CI NOT IN 
        (SELECT CI FROM GUSTA , BEBIDA WHERE 
        BEBIDA.NombreBeb = 'Coca-Cola' AND GUSTA.CodBeb = BEBIDA.CodBeb) 
) AND EXISTS (
     SELECT * FROM GUSTA g , BEBIDA be
        WHERE EXISTS 
        (SELECT * FROM GUSTA WHERE g.CI = b.CI AND G.CodBeb = be.codBeb AND be.NombreBeb ='Malta')
); 

SELECT * FROM BEBEDOR b 
WHERE EXISTS (
    SELECT * FROM GUSTA g , BEBIDA be WHERE 
    b.CI = g.CI AND g.CodBeb = be.CodBeb AND be.NombreBeb = 'Malta'
    AND NOT EXISTS (
        SELECT * FROM GUSTA g2 , BEBIDA be2, GUSTA g3 , BEBIDA be3 WHERE
        b.CI = g2.CI AND g2.CodBeb = be2.CodBeb AND be2.NombreBeb = 'Frescolita' AND 
        b.CI = g3.CI AND g3.CodBeb = be3.CodBeb AND be3.NombreBeb = 'Coca-Cola'
    ));

-- TRADUCCION DEL CACULO RELACIONAL DE LA 5
SELECT * FROM BEBEDOR b
WHERE EXISTS (
    SELECT * FROM GUSTA g, BEBIDA be WHERE
    g.CI = b.CI AND be.NombreBeb = 'Malta' AND g.CodBeb = be.CodBeb  
    AND NOT EXISTS(
    SELECT * FROM GUSTA g2 , BEBIDA be2 , GUSTA g3, BEBIDA be3 WHERE
    be2.NombreBeb = 'Frescolita' AND g2.CodBeb = be2.CodBeb  AND g3.CodBeb = be3.CodBeb AND
    be3.NombreBeb = 'Coca-Cola' AND g2.CI = b.CI AND g3.CI = b.CI
));

SELECT CI, Nombre
FROM BEBEDOR 
NATURAL JOIN GUSTA
NATURAL JOIN Bebida
WHERE BEBIDA.Nombrebeb='Malta'
EXCEPT
SELECT CI,NOMBRE
FROM BEBEDOR 
NATURAL JOIN GUSTA
NATURAL JOIN Bebida
WHERE BEBIDA.Nombrebeb='Frescolita' AND BEBIDA.NombreBeb='Coca-Cola';



-- 6 Los bebedores que no les gusta las bebidas que le gusta a Luis Perez.
 -- TRADUCCION :
SELECT * FROM BEBEDOR b
WHERE NOT EXISTS (
    SELECT * FROM GUSTA g 
    WHERE B.CI = g.CI  AND EXISTS (
        SELECT FROM BEBEDOR b2 , GUSTA g2 
        WHERE b2.CI = g2.CI AND b2.Nombre = 'Luis Perez 'AND g2.CodBeb = g.CodBeb 
    )
); 

-- 7 Los bebedores que frecuentan las fuentes de soda que frecuenta Luis Perez.

-- TRADUCCION :
SELECT * FROM BEBEDOR b
WHERE EXISTS (
    SELECT * FROM FRECUENTA fr
    WHERE b.CI = fr.CI AND NOT EXISTS(
        SELECT * FROM FRECUENTA fr2, BEBEDOR b2
        WHERE b2.Nombre = 'Luis Perez' AND fr2.CI = b2.CI AND fr2.CodFS != fr.CodFS
    )
);


SELECT * FROM BEBEDOR b 
WHERE NOT EXISTS (
    SELECT * FROM FRECUENTA fr WHERE
    EXISTS(
        SELECT * FROM BEBEDOR b2
        WHERE b2.Nombre = 'Luis Perez' AND fr.CI = b2.CI AND NOT EXISTS (
            SELECT * FROM FRECUENTA fr2 WHERE
            fr2.CI = b.CI  AND fr2.CodFS = fr.CodFS
        )
    )
);

SELECT * FROM BEBEDOR b WHERE
NOT EXISTS (
    SELECT * FROM FRECUENTA fr WHERE 
     EXISTS (
        SELECT * FROM BEBEDOR b2 WHERE
        b2.Nombre = 'Luis Perez' AND fr.CI = b2.CI)
    AND NOT EXISTS (
        SELECT * FROM FRECUENTA fr2 WHERE
        b.CI = fr2.CI AND fr2.CodFS = fr.CodFS
    ) 
);