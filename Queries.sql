-- Para iniciar el servicio en Ubuntus sudo service postgresql start
-- Para el password del usuario Boondock es 123456

-- Selects para verificar la insercion de los datos.

--  First_names
SELECT * FROM First_name;

--  Last_names
SELECT * FROM Last_name;

-- Emails
SELECT * FROM Email;

-- Passwords
SELECT * FROM Passwords;

-- Usernames
SELECT * FROM Username;

-- Phone_numbers
SELECT * FROM Phone_number;

-- Food
SELECT * FROM Food;

-- Brand_names
SELECT * FROM Brand_name;

-- confirmation_code
SELECT * FROM confirmation_code;

-- Employee_code
SELECT * FROM Employee_code;

-- Unit

SELECT * FROM Unit;


CALL insert_customers(5);
