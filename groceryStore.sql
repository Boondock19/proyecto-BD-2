DROP TABLE IF EXISTS Temp_data;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS unit;

CREATE DATABASE grocery;
\connect "grocery"

CREATE TEMP TABLE Temp_data (
    CustomerFirstName varchar(64),
    CustomerLastName varchar(64),
    CustomerUserName varchar(64),
    CustomerPassword varchar(64),
    UserTimeInserted timestamp,
    CustomerAddress varchar(64),
    CustomerDeliveryAddress varchar(255),
    CustomerEmail varchar(128),
    CustomerPhone varchar(128),
    CustomerConfirmationCode varchar(255),
    EmployeeCode varchar(32),
    EmployeeFirstName varchar(64),
    EmployeeLastName varchar(64),
    CityName varchar(128),
    CityPostalCode varchar(16),
    UnitName varchar(64),
    UnitShort varchar(8),
    -- CatalogStatusName varchar(128),
    TimeInserted timestamp,
    TimeConfirmed timestamp

);

\COPY Temp_data FROM 'groceryStoreData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);


CREATE TABLE IF NOT EXISTS customer (
    id int  NOT NULL,
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
    CONSTRAINT customer_pk PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS city (
    id int  NOT NULL,
    city_name varchar(128)  NOT NULL,
    postal_code varchar(16)  NOT NULL,
    CONSTRAINT city_ak_1 UNIQUE (city_name, postal_code) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT city_pk PRIMARY KEY (id)
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

CREATE TABLE IF NOT EXISTS unit (
    id int  NOT NULL,
    unit_name varchar(64)  NOT NULL,
    unit_short varchar(8)  NULL,
    CONSTRAINT unit_ak_1 UNIQUE (unit_name) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT unit_ak_2 UNIQUE (unit_short) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT unit_pk PRIMARY KEY (id)
);
