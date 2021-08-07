-- This file can be used to generate northwind database 

-- create tables & copy data from csv files in folder ./data

CREATE TABLE customers (
    customer_id VARCHAR(255) primary key,
    company_name VARCHAR(255) not null,
    contact_name VARCHAR(255),
    contact_title VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(255),
    region VARCHAR(255),
    postal_code VARCHAR(255),
    country VARCHAR(255), 
    phone VARCHAR(255),
    fax VARCHAR(255)
);

COPY customers(customer_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, fax)
FROM '/Users/jinglin/Documents/spiced_projects/unsupervised-lemon-student-code/week_05/data/customers.csv'
DELIMITER ','
CSV HEADER
NULL 'NULL';


CREATE TABLE categories (
    category_id INT primary key,
    category_name VARCHAR(255), 
    description VARCHAR(255), 
    picture TEXT
);

COPY categories(category_id, category_name, description, picture)
FROM '/Users/jinglin/Documents/spiced_projects/unsupervised-lemon-student-code/week_05/data/categories.csv'
DELIMITER ','
CSV HEADER
NULL 'NULL';


CREATE TABLE regions (
    region_id INT primary key,
    region_description VARCHAR(255)
);

COPY regions(region_id, region_description)
FROM '/Users/jinglin/Documents/spiced_projects/unsupervised-lemon-student-code/week_05/data/regions.csv'
DELIMITER ','
CSV HEADER
NULL 'NULL';


CREATE TABLE products (
    product_id INT primary key,
    product_name VARCHAR(255),
    supplier_id INT,
    category_id INT,
    quantity_per_unit VARCHAR(255),
    unit_price NUMERIC,
    units_in_stock INT, 
    units_on_order INT,
    reorder_level INT,
    discontinued INT
);

COPY products(product_id, product_name, supplier_id, category_id, quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued)
FROM '/Users/jinglin/Documents/spiced_projects/unsupervised-lemon-student-code/week_05/data/products.csv'
DELIMITER ','
CSV HEADER
NULL 'NULL';


CREATE TABLE employee_territories (
    employee_id INT,
    territory_id INT
);

COPY employee_territories(employee_id, territory_id)
FROM '/Users/jinglin/Documents/spiced_projects/unsupervised-lemon-student-code/week_05/data/employee_territories.csv'
DELIMITER ','
CSV HEADER
NULL 'NULL';


CREATE TABLE orders(
    order_id INT primary key,
    customer_id VARCHAR(255),
    employee_id INT,
    order_date TIMESTAMP,
    required_date TIMESTAMP,
    shipped_date TIMESTAMP,
    ship_via INT,
    freight NUMERIC,
    ship_name VARCHAR(255),
    ship_address VARCHAR(255),
    ship_city VARCHAR(255),
    ship_region VARCHAR(255),
    ship_postal_code VARCHAR(255),
    ship_country VARCHAR(255)
);

COPY orders(order_id, customer_id, employee_id, order_date, required_date, shipped_date, ship_via, freight,ship_name,ship_address,ship_city,ship_region,ship_postal_code,ship_country)
FROM '/Users/jinglin/Documents/spiced_projects/unsupervised-lemon-student-code/week_05/data/orders.csv'
DELIMITER ','
CSV HEADER
NULL 'NULL';


CREATE TABLE suppliers(
    supplier_id INT primary key,
    company_name VARCHAR(255),
    contact_name VARCHAR(255),
    contact_title VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(255),
    region VARCHAR(255),
    postal_code VARCHAR(255),
    country VARCHAR(255),
    phone VARCHAR(255),
    fax VARCHAR(255),
    home_page VARCHAR(255)
);

COPY suppliers(supplier_id, company_name, contact_name, contact_title, address, city, region,postal_code, country, phone, fax, home_page)
FROM '/Users/jinglin/Documents/spiced_projects/unsupervised-lemon-student-code/week_05/data/suppliers.csv'
DELIMITER ','
CSV HEADER
NULL 'NULL';


CREATE TABLE shippers(
    shipper_id INT primary key,
    company_name VARCHAR(255),
    phone VARCHAR(255)
);

COPY shippers(shipper_id, company_name, phone)
FROM '/Users/jinglin/Documents/spiced_projects/unsupervised-lemon-student-code/week_05/data/shippers.csv'
DELIMITER ','
CSV HEADER
NULL 'NULL';


CREATE TABLE territories(
    territory_id INT primary key,
    territory_description VARCHAR(255),
    region_id INT
);

COPY territories(territory_id, territory_description, region_id)
FROM '/Users/jinglin/Documents/spiced_projects/unsupervised-lemon-student-code/week_05/data/territories.csv'
DELIMITER ','
CSV HEADER
NULL 'NULL';


CREATE TABLE employees(
    employee_id INT primary key,
    last_name VARCHAR(255),
    first_name VARCHAR(255),
    title VARCHAR(255),
    title_of_courtesy VARCHAR(255),
    birth_date TIMESTAMP,
    hire_date TIMESTAMP,
    address VARCHAR(255),
    city VARCHAR(255),
    region VARCHAR(255),
    postal_code VARCHAR(255),
    country VARCHAR(255),
    home_phone VARCHAR(255),
    extension INT,
    photo TEXT,
    notes TEXT, 
    reports_to INT, 
    photo_path VARCHAR(255)
);

COPY employees(employee_id, last_name, first_name, title, title_of_courtesy, birth_date, hire_date, address, city, region, postal_code, country, home_phone, extension, photo, notes, reports_to, photo_path)
FROM '/Users/jinglin/Documents/spiced_projects/unsupervised-lemon-student-code/week_05/data/employees.csv'
DELIMITER ','
CSV HEADER
NULL 'NULL';


CREATE TABLE order_details(
    order_id INT,
    product_id INT,
    unit_price NUMERIC,
    quantity INT,
    discount NUMERIC
);

COPY order_details(order_id, product_id, unit_price, quantity, discount)
FROM '/Users/jinglin/Documents/spiced_projects/unsupervised-lemon-student-code/week_05/data/order_details.csv'
DELIMITER ','
CSV HEADER
NULL 'NULL';


-- add foreign keys 

ALTER TABLE products ADD FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE CASCADE;
ALTER TABLE products ADD FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE;

ALTER TABLE employee_territories ADD FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE;
ALTER TABLE employee_territories ADD FOREIGN KEY (territory_id) REFERENCES territories(territory_id) ON DELETE CASCADE;

ALTER TABLE orders ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE;
ALTER TABLE orders ADD FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE;

ALTER TABLE order_details ADD FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE;
ALTER TABLE order_details ADD FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE;

ALTER TABLE territories ADD FOREIGN KEY (region_id) REFERENCES regions(region_id) ON DELETE CASCADE;


-- change country name to iso code to be able to visualized in maps in metabase 

UPDATE customers
SET country = CASE 
    WHEN customers.country = 'Argentina' THEN 'AR'
    WHEN customers.country = 'Spain' THEN 'ES'
    WHEN customers.country = 'Switzerland' THEN 'CH'
    WHEN customers.country = 'Italy' THEN 'IT'
    WHEN customers.country = 'Venezuela' THEN 'VE'
    WHEN customers.country = 'Belgium' THEN 'BE'
    WHEN customers.country = 'Norway' THEN 'NO'
    WHEN customers.country = 'Sweden' THEN 'SE'
    WHEN customers.country = 'USA' THEN 'US'
    WHEN customers.country = 'France' THEN 'FR'
    WHEN customers.country = 'Mexico' THEN 'MX'
    WHEN customers.country = 'Brazil' THEN 'BR'
    WHEN customers.country = 'Austria' THEN 'AT'
    WHEN customers.country = 'Poland' THEN 'PL'
    WHEN customers.country = 'UK' THEN 'GB'
    WHEN customers.country = 'Ireland' THEN 'IE'
    WHEN customers.country = 'Germany' THEN 'DE'
    WHEN customers.country = 'Denmark' THEN 'DK'
    WHEN customers.country = 'Canada' THEN 'CA'
    WHEN customers.country = 'Finland' THEN 'FI'
    WHEN customers.country = 'Portugal' THEN 'PT'
    END;

UPDATE suppliers
SET country = CASE 
    WHEN suppliers.country = 'Spain' THEN 'ES'
    WHEN suppliers.country = 'Italy' THEN 'IT'
    WHEN suppliers.country = 'Norway' THEN 'NO'
    WHEN suppliers.country = 'Sweden' THEN 'SE'
    WHEN suppliers.country = 'France' THEN 'FR'
    WHEN suppliers.country = 'USA' THEN 'US'
    WHEN suppliers.country = 'Netherlands' THEN 'NL'
    WHEN suppliers.country = 'Brazil' THEN 'BR'
    WHEN suppliers.country = 'Australia' THEN 'AU'
    WHEN suppliers.country = 'UK' THEN 'GB'
    WHEN suppliers.country = 'Germany' THEN 'DE'
    WHEN suppliers.country = 'Japan' THEN 'JP'
    WHEN suppliers.country = 'Denmark' THEN 'DK'
    WHEN suppliers.country = 'Singapore' THEN 'SG'
    WHEN suppliers.country = 'Canada' THEN 'CA'
    WHEN suppliers.country = 'Finland' THEN 'FI'
    END;