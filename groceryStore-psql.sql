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

\connect GroceryStoreData-1510627-1210921;

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


DROP TABLE IF EXISTS First_name;

CREATE TEMP TABLE IF NOT EXISTS First_name (
    first_name varchar(64) NOT NULL
);

\COPY First_name FROM 'namesData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TEMP TABLE IF NOT EXISTS Last_name (
    
    last_name varchar(64) NOT NULL
);

\COPY Last_name FROM 'lastNamesData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TEMP TABLE IF NOT EXISTS Email (
    
    email varchar(128) NOT NULL
);

\COPY Email FROM 'userEmailsData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TEMP TABLE IF NOT EXISTS Passwords (
    
    password varchar(64) NOT NULL
);

\COPY Passwords FROM 'passwordsData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TEMP TABLE IF NOT EXISTS Username (
    
    username varchar(64) NOT NULL

);

\COPY Username FROM 'usernamesData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TEMP TABLE IF NOT EXISTS Phone_number (
    
    phone_number varchar(128) NOT NULL
);

\COPY Phone_number FROM 'userPhonesData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TEMP TABLE IF NOT EXISTS Food (
    
    food varchar(64) NOT NULL
);

\COPY Food(food) FROM 'food.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TEMP TABLE IF NOT EXISTS Brand_name (
    
    brand_name varchar(64) NOT NULL
);

\COPY Brand_name FROM 'brandNames.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TEMP TABLE IF NOT EXISTS confirmation_code (
    
    confirmation_code varchar(255) NOT NULL
);

\COPY confirmation_code FROM 'confirmationCodesData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

CREATE TEMP TABLE IF NOT EXISTS Employee_code (
    employee_code varchar(32) NOT NULL
);

\COPY Employee_code FROM 'employeeCodesData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);


CREATE TEMP TABLA IF NOT EXISTS Temp_unit (
    unit_name varchar(64) NOT NULL,
    unit_short varchar(8) NOT NULL
);

\COPY Temp_unit FROM 'unitsData.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

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
    CONSTRAINT customer_city_1 FOREIGN KEY (city_id) REFERENCES city (id)  
    NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT customer_city_2 FOREIGN KEY (delivery_city_id) REFERENCES city (id)  NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT customer_pk PRIMARY KEY (id)
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

CREATE TABLE IF NOT EXISTS city (
    id SERIAL  NOT NULL,
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

CREATE TABLE delivery (
    id int  NOT NULL,
    delivery_time_planned timestamp  NOT NULL,
    delivery_time_actual timestamp  NULL,
    notes text  NULL,
    placed_order_id int  NOT NULL,
    employee_id int  NULL,
    CONSTRAINT delivery_pk PRIMARY KEY (id),
    CONSTRAINT delivery_employee FOREIGN KEY (employee_id) REFERENCES employee (id) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT delivery_placed_order FOREIGN KEY (placed_order_id) REFERENCES placed_order (id) NOT DEFERRABLE INITIALLY IMMEDIATE
);
-- Table: item
CREATE TABLE item (
    id int  NOT NULL,
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

CREATE TABLE IF NOT EXISTS unit (
    id int  NOT NULL,
    unit_name varchar(64)  NOT NULL,
    unit_short varchar(8)  NULL,
    CONSTRAINT unit_ak_1 UNIQUE (unit_name) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT unit_ak_2 UNIQUE (unit_short) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT unit_pk PRIMARY KEY (id)
);
CREATE TABLE notes (
    id int  NOT NULL,
    placed_order_id int  NOT NULL,
    employee_id int  NULL,
    customer_id int  NULL,
    note_time timestamp  NOT NULL,
    note_text text  NOT NULL,
    CONSTRAINT notes_pk PRIMARY KEY (id),
    CONSTRAINT notes_customer FOREIGN KEY (customer_id) REFERENCES customer (id)  NOT DEFERRABLE 
    INITIALLY IMMEDIATE,
    CONSTRAINT notes_employee FOREIGN KEY (employee_id) REFERENCES employee (id) NOT DEFERRABLE 
    INITIALLY IMMEDIATE,
    CONSTRAINT notes_placed_order FOREIGN KEY (placed_order_id) REFERENCES placed_order (id) NOT DEFERRABLE 
    INITIALLY IMMEDIATE
);

CREATE TABLE order_item (
    id int  NOT NULL,
    placed_order_id int  NOT NULL,
    item_id int  NOT NULL,
    quantity decimal(10,3)  NOT NULL,
    price decimal(10,2)  NOT NULL,
    CONSTRAINT order_item_pk PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (placed_order_id) REFERENCES placed_order (id)  NOT DEFERRABLE 
    INITIALLY IMMEDIATE,
    CONSTRAINT order_item_item FOREIGN KEY (item_id) REFERENCES item (id)  NOT DEFERRABLE 
    INITIALLY IMMEDIATE
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
    CONSTRAINT order_status_placed_order
    FOREIGN KEY (placed_order_id) REFERENCES placed_order (id) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT order_status_status_catalog FOREIGN KEY (status_catalog_id) REFERENCES status_catalog (id) NOT DEFERRABLE INITIALLY IMMEDIATE
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

INSERT INTO city (city_name, postal_code)
SELECT CityName,CityPostalCode FROM Temp_data
ON CONFLICT (city_name,postal_code) DO NOTHING;

SELECT * FROM city;



