DROP TABLE IF EXISTS Temp_data;
DROP TABLE IF EXISTS First_name;
DROP TABLE IF EXISTS Last_name;
DROP TABLE IF EXISTS Email;
DROP TABLE IF EXISTS Passwords;
DROP TABLE IF EXISTS Username;
DROP TABLE IF EXISTS Phone_number;
DROP TABLE IF EXISTS Food;
DROP TABLE IF EXISTS Brand_name;
DROP TABLE IF EXISTS confirmation_code;
DROP TABLE IF EXISTS Employee_code;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS City;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Unit;
DROP TABLE IF EXISTS customer1;

\connect GroceryStoreData-1510627-1210921;

-- CREATE TEMP TABLE Temp_data (
--     CustomerFirstName varchar(64),
--     CustomerLastName varchar(64),
--     CustomerUserName varchar(64),
--     CustomerPassword varchar(64),
--     UserTimeInserted timestamp,
--     CustomerAddress varchar(64),
--     CustomerDeliveryAddress varchar(255),
--     CustomerEmail varchar(128),
--     CustomerPhone varchar(128),
--     CustomerConfirmationCode varchar(255),
--     EmployeeCode varchar(32),
--     EmployeeFirstName varchar(64),
--     EmployeeLastName varchar(64),
--     CityName varchar(128),
--     CityPostalCode varchar(16),
--     UnitName varchar(64),
--     UnitShort varchar(8),
--     -- CatalogStatusName varchar(128),
--     TimeInserted timestamp,
--     TimeConfirmed timestamp

-- );

-- \COPY Temp_data FROM 'groceryStoreData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);


CREATE TEMP TABLE IF NOT EXISTS Temp_first_name (
    first_name varchar(64) NOT NULL
);

\COPY Temp_first_name FROM 'namesData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS First_name (
    id SERIAL,
    first_name varchar(64) NOT NULL,
    CONSTRAINT first_name_pk PRIMARY KEY (id)
);

INSERT INTO First_name (first_name)
SELECT first_name FROM Temp_first_name;

CREATE TEMP TABLE IF NOT EXISTS Temp_Last_name (
    last_name varchar(64) NOT NULL
);

\COPY Temp_Last_name FROM 'lastNamesData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS Last_name (
    id SERIAL,
    last_name varchar(64) NOT NULL,
    CONSTRAINT last_name_pk PRIMARY KEY (id)
);

INSERT INTO Last_name (last_name)
SELECT last_name FROM Temp_Last_name;

CREATE TEMP TABLE IF NOT EXISTS Temp_email (
    email varchar(128) NOT NULL
);



\COPY Temp_email FROM 'userEmailsData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS Email (
    id SERIAL,
    email varchar(128) NOT NULL,
    CONSTRAINT email_pk PRIMARY KEY (id)
);

INSERT INTO Email (email)
SELECT email FROM Temp_email;

CREATE TEMP TABLE IF NOT EXISTS Temp_passwords (
    password varchar(64) NOT NULL
);



\COPY Temp_passwords FROM 'passwordsData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS Password (
    password varchar(64) NOT NULL
);

INSERT INTO Password (password)
SELECT password FROM Temp_passwords;


CREATE TEMP TABLE IF NOT EXISTS Temp_username (
    username varchar(64) NOT NULL
);

\COPY Temp_username FROM 'usernamesData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS Username (
    id SERIAL,
    username varchar(64) NOT NULL,
    CONSTRAINT username_pk PRIMARY KEY (id)
);

INSERT INTO Username (username)
SELECT username FROM Temp_username;

CREATE TEMP TABLE IF NOT EXISTS Temp_phone_number (
    phone_number varchar(128) NOT NULL
);

\COPY Temp_phone_number FROM 'userPhonesData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS Phone_number (
    id SERIAL,
    phone_number varchar(128) NOT NULL,
    CONSTRAINT phone_number_pk PRIMARY KEY (id)
);

INSERT INTO Phone_number (phone_number)
SELECT phone_number FROM Temp_phone_number;

CREATE TABLE IF NOT EXISTS Temp_address (
    address varchar(255) NOT NULL
);


\COPY Temp_address FROM 'address.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS Address (
    id SERIAL,
    address varchar(255) NOT NULL,
    CONSTRAINT address_pk PRIMARY KEY (id)
);

INSERT INTO Address (address)
SELECT address FROM Temp_address;


CREATE TEMP TABLE IF NOT EXISTS Temp_city (
    city varchar(128) NOT NULL,
    city_ascii varchar(128) NOT NULL,
    state_id varchar(16) NOT NULL,
    state_name varchar(64) NOT NULL,
    county_fips varchar(16) NOT NULL,
    county_name varchar(64) NOT NULL,
    lat varchar(16) NOT NULL,
    lng varchar(16) NOT NULL,
    population varchar(16) NOT NULL,
    density varchar(16) NOT NULL,
    source varchar(16) NOT NULL,
    military varchar(16) NOT NULL,
    incorporated varchar(16) NOT NULL,
    timezone varchar(64) NOT NULL,
    ranking varchar(16) NOT NULL,
    zips varchar(32) NOT NULL,
    id varchar(16) NOT NULL
);

\COPY Temp_city FROM 'uscities.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS City_with_Population (
    id SERIAL,
    city varchar(128) NOT NULL,
    city_ascii varchar(128) NOT NULL,
    state_id varchar(16) NOT NULL,
    state_name varchar(64) NOT NULL,
    county_fips varchar(16) NOT NULL,
    county_name varchar(64) NOT NULL,
    lat varchar(16) NOT NULL,
    lng varchar(16) NOT NULL,
    population varchar(16) NOT NULL,
    density varchar(16) NOT NULL,
    source varchar(16) NOT NULL,
    military varchar(16) NOT NULL,
    incorporated varchar(16) NOT NULL,
    timezone varchar(64) NOT NULL,
    ranking varchar(16) NOT NULL,
    zips varchar(32) NOT NULL,
    CONSTRAINT city_with_population_pk PRIMARY KEY (id)
);

INSERT INTO City_with_Population (city, city_ascii, state_id, state_name, county_fips, county_name, lat, lng, population, density, source, military, 
incorporated, timezone, ranking, zips) SELECT city, city_ascii, state_id, state_name, county_fips, county_name, lat, lng, population, density, source, military, 
incorporated, timezone, ranking, zips FROM Temp_city;

ALTER TABLE City_with_Population DROP COLUMN city_ascii, DROP COLUMN state_id, DROP COLUMN state_name, DROP COLUMN county_fips, DROP COLUMN county_name, DROP COLUMN lat, DROP COLUMN lng, 
DROP COLUMN density, DROP COLUMN source, DROP COLUMN military, DROP COLUMN incorporated, DROP COLUMN timezone, DROP COLUMN ranking;

CREATE TEMP TABLE Temp_delivery_address (
   delivery_address varchar(255)
);

\COPY Temp_delivery_address FROM 'deliveryAddress.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS Delivery_address (
    id SERIAL,
    delivery_address varchar(255) NOT NULL,
    CONSTRAINT delivery_address_pk PRIMARY KEY (id)
);

INSERT INTO Delivery_address (delivery_address)
SELECT delivery_address FROM Temp_delivery_address;

CREATE TEMP TABLE IF NOT EXISTS Temp_food (
    food varchar(64) NOT NULL,
    science_name varchar(64),
    group_2 varchar(64),
    sub_group varchar(64)
);


\COPY Temp_food FROM 'food.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS Food (
    id SERIAL,
    food varchar(64) NOT NULL,
    CONSTRAINT food_pk PRIMARY KEY (id)
);

INSERT INTO Food (food)
SELECT food FROM Temp_food;

CREATE TEMP TABLE IF NOT EXISTS Temp_brand_name (
    
    brand_name varchar(64) NOT NULL
);

\COPY Temp_brand_name FROM 'brandNames.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS Brand_name (
    id SERIAL,
    brand_name varchar(64) NOT NULL,
    CONSTRAINT brand_name_pk PRIMARY KEY (id)
);

INSERT INTO Brand_name (brand_name)
SELECT brand_name FROM Temp_brand_name;

CREATE TEMP TABLE IF NOT EXISTS Temp_time_inserted (
    
    time_inserted timestamp NOT NULL
);

\COPY Temp_time_inserted FROM 'timeInserted.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);


CREATE TABLE IF NOT EXISTS Time_inserted (
    id SERIAL,
    time_inserted timestamp NOT NULL,
    CONSTRAINT time_inserted_pk PRIMARY KEY (id)
);

INSERT INTO Time_inserted (time_inserted)
SELECT time_inserted FROM Temp_time_inserted;

CREATE TEMP TABLE IF NOT EXISTS Temp_time_confirmed (
    
    time_confirmed timestamp NOT NULL
);

\COPY Temp_time_confirmed FROM 'timeConfirmed.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS Time_confirmed (
    id SERIAL,
    time_confirmed timestamp NOT NULL,
    CONSTRAINT time_confirmed_pk PRIMARY KEY (id)
);

INSERT INTO Time_confirmed (time_confirmed)
SELECT time_confirmed FROM Temp_time_confirmed;

CREATE TEMP TABLE IF NOT EXISTS Temp_confirmation_code (
    
    confirmation_code varchar(255) NOT NULL
);

\COPY Temp_confirmation_code FROM 'confirmationCodesData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS Confirmation_code (
    id SERIAL,
    confirmation_code varchar(255) NOT NULL,
    CONSTRAINT confirmation_code_pk PRIMARY KEY (id)
);

INSERT INTO Confirmation_code (confirmation_code)
SELECT confirmation_code FROM Temp_confirmation_code;


CREATE TEMP TABLE IF NOT EXISTS Temp_employee_code (
    employee_code varchar(32) NOT NULL
);

\COPY Temp_employee_code FROM 'employeeCodesData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TABLE IF NOT EXISTS Employee_code (
    id SERIAL,
    employee_code varchar(32) NOT NULL,
    CONSTRAINT employee_code_pk PRIMARY KEY (id)
);


INSERT INTO Employee_code (employee_code)
SELECT employee_code FROM Temp_employee_code;

CREATE TEMP TABLE IF NOT EXISTS Temp_unit (
    unit_name varchar(64) NOT NULL,
    unit_short varchar(8) NOT NULL
);

\COPY Temp_unit FROM 'unitsData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);


CREATE TABLE IF NOT EXISTS city (
    id SERIAL  NOT NULL,
    city_name varchar(128)  NOT NULL,
    postal_code varchar(16)  NOT NULL,
    CONSTRAINT city_ak_1 UNIQUE (city_name, postal_code) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT city_pk PRIMARY KEY (id)
);

INSERT INTO city (city_name,postal_code)
SELECT city,zips FROM City_with_Population
ON CONFLICT (city_name,postal_code) DO NOTHING;

SELECT * FROM city;

CREATE TABLE IF NOT EXISTS customer (
    id SERIAL,
    first_name varchar(64)  NOT NULL,
    last_name varchar(64)  NOT NULL,
    user_name varchar(64)  NOT NULL,
    password varchar(64)  NOT NULL,
    time_inserted timestamp  NOT NULL,
    confirmation_code varchar(255)  NOT NULL,
    time_confirmed timestamp  NULL,
    contact_email varchar(128)  NOT NULL,
    contact_phone varchar(128)  NULL,
    city_id int  NULL,
    address varchar(255)  NULL,
    delivery_city_id int  NULL,
    delivery_address varchar(255)  NULL,
    CONSTRAINT customer_ak_1 UNIQUE (user_name) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT customer_city_1 FOREIGN KEY (city_id) REFERENCES city (id) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT customer_city_2 FOREIGN KEY (delivery_city_id) REFERENCES city (id)  NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT customer_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS customer1 (
    first_name varchar(64)  NOT NULL,
    last_name varchar(64)   NULL,
    user_name varchar(64)   NULL,
    password varchar(64)   NULL,
    time_inserted timestamp   NULL,
    confirmation_code varchar(255)   NULL,
    time_confirmed timestamp  NULL,
    contact_email varchar(128)   NULL,
    contact_phone varchar(128)  NULL,
    city_id int  NULL,
    address varchar(255)  NULL,
    delivery_city_id int  NULL,
    delivery_address varchar(255)  NULL
);

-- Table: employee
CREATE TABLE IF NOT EXISTS employee (
    id int  NOT NULL,
    employee_code varchar(32)  NOT NULL,
    first_name varchar(64)  NOT NULL,
    last_name varchar(64)  NOT NULL,
    CONSTRAINT employee_ak_1 UNIQUE (employee_code) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT employee_pk PRIMARY KEY (id)
);
-- Table: placed_order
CREATE TABLE placed_order (
    id int  NOT NULL,
    customer_id int  NOT NULL,
    time_placed timestamp  NOT NULL,
    details text  NULL,
    delivery_city_id int  NOT NULL,
    delivery_address varchar(255)  NOT NULL,
    grade_customer int  NULL,
    grade_employee int  NULL,
    CONSTRAINT placed_order_pk PRIMARY KEY (id),
    CONSTRAINT placed_order_city FOREIGN KEY (delivery_city_id) REFERENCES city (id) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT placed_order_customer FOREIGN KEY (customer_id) REFERENCES customer (id) NOT DEFERRABLE INITIALLY IMMEDIATE
);


CREATE TABLE delivery (
    id int  NOT NULL,
    delivery_time_planned timestamp  NOT NULL,
    delivery_time_actual timestamp  NULL,
    notes text  NULL,
    placed_order_id int  NOT NULL,
    employee_id int  NULL,
    CONSTRAINT delivery_pk PRIMARY KEY (id),
    CONSTRAINT delivery_employee FOREIGN KEY (employee_id) REFERENCES employee (id) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT delivery_placed_order FOREIGN KEY (placed_order_id) REFERENCES placed_order(id) NOT DEFERRABLE INITIALLY IMMEDIATE
);


CREATE TABLE box (
    id int  NOT NULL,
    box_code varchar(32)  NOT NULL,
    delivery_id int  NOT NULL,
    employee_id int  NOT NULL,
    CONSTRAINT box_ak_1 UNIQUE (box_code) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT box_pk PRIMARY KEY (id),
    CONSTRAINT box_delivery FOREIGN KEY (delivery_id) REFERENCES delivery (id) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT box_employee FOREIGN KEY (employee_id) REFERENCES employee (id) NOT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE IF NOT EXISTS unit (
    id SERIAL  NOT NULL,
    unit_name varchar(64)  NOT NULL,
    unit_short varchar(8)  NULL,
    CONSTRAINT unit_ak_1 UNIQUE (unit_name) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT unit_ak_2 UNIQUE (unit_short) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT unit_pk PRIMARY KEY (id)
);

INSERT INTO unit (unit_name,unit_short)
SELECT unit_name,unit_short FROM Temp_unit;

-- Table: item
CREATE TABLE item (
    id SERIAL,
    item_name varchar(255)  NOT NULL,
    price decimal(10,2)  NOT NULL,
    item_photo text  NULL,
    description text  NULL,
    unit_id int  NOT NULL,
    CONSTRAINT item_ak_1 UNIQUE (item_name) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT item_pk PRIMARY KEY (id),
    CONSTRAINT item_unit FOREIGN KEY (unit_id) REFERENCES unit (id) NOT DEFERRABLE INITIALLY IMMEDIATE
);

-- Table: item_in_box
CREATE TABLE item_in_box (
    id int  NOT NULL,
    box_id int  NOT NULL,
    item_id int  NOT NULL,
    qunatity decimal(10,3)  NOT NULL,
    is_replacement bool  NOT NULL,
    CONSTRAINT item_in_box_pk PRIMARY KEY (id),
    CONSTRAINT item_in_box_box FOREIGN KEY (box_id) REFERENCES box (id) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT item_in_box_item FOREIGN KEY (item_id) REFERENCES item (id) NOT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE notes (
    id int  NOT NULL,
    placed_order_id int  NOT NULL,
    employee_id int  NULL,
    customer_id int  NULL,
    note_time timestamp  NOT NULL,
    note_text text  NOT NULL,
    CONSTRAINT notes_pk PRIMARY KEY (id),
    CONSTRAINT notes_customer FOREIGN KEY (customer_id) REFERENCES customer (id)  NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT notes_employee FOREIGN KEY (employee_id) REFERENCES employee (id) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT notes_placed_order FOREIGN KEY (placed_order_id) REFERENCES placed_order (id) NOT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE order_item (
    id int  NOT NULL,
    placed_order_id int  NOT NULL,
    item_id int  NOT NULL,
    quantity decimal(10,3)  NOT NULL,
    price decimal(10,2)  NOT NULL,
    CONSTRAINT order_item_pk PRIMARY KEY (id),
    CONSTRAINT order_item_item FOREIGN KEY (item_id) REFERENCES item (id)  NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT order_item_placed_order FOREIGN KEY (placed_order_id) REFERENCES placed_order (id)  NOT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE status_catalog (
    id int  NOT NULL,
    status_name varchar(128)  NOT NULL,
    CONSTRAINT status_catalog_ak_1 UNIQUE (status_name) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT status_catalog_pk PRIMARY KEY (id)
);
-- Table: order_status
CREATE TABLE order_status (
    id int  NOT NULL,
    placed_order_id int  NOT NULL,
    status_catalog_id int  NOT NULL,
    status_time timestamp  NOT NULL,
    details text  NULL,
    CONSTRAINT order_status_pk PRIMARY KEY (id),
    CONSTRAINT order_status_placed_order FOREIGN KEY (placed_order_id) REFERENCES placed_order (id) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT order_status_status_catalog FOREIGN KEY (status_catalog_id) REFERENCES status_catalog (id) NOT DEFERRABLE INITIALLY IMMEDIATE
);





