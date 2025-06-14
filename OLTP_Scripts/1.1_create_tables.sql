-- CATEGORIES
DROP TABLE IF EXISTS stg_categories;
CREATE TABLE stg_categories (
    category_id INT,
    category_name TEXT,
    description TEXT
);

-- SUBCATEGORIES
DROP TABLE IF EXISTS stg_subcategories;
CREATE TABLE stg_subcategories (
    subcategory_id INT,
    category_id INT,
    subcategory_name TEXT,
    description TEXT
);

-- ECOCERTIFICATIONS
DROP TABLE IF EXISTS stg_ecocertifications;
CREATE TABLE stg_ecocertifications (
    certification_id INT,
    certification_name TEXT,
    description TEXT,
    logo TEXT
);

-- MANUFACTURERS
DROP TABLE IF EXISTS stg_manufacturers;
CREATE TABLE stg_manufacturers (
    manufacturer_id INT,
    manufacturer_name TEXT,
    country TEXT,
    website TEXT,
    sustainability_rating NUMERIC,
    description TEXT
);

-- PRODUCTS
DROP TABLE IF EXISTS stg_products;
CREATE TABLE stg_products (
    product_id INT,
    subcategory_id INT,
    manufacturer_id INT,
    product_name TEXT,
    description TEXT,
    price NUMERIC,
    stock INT,
    eco_score NUMERIC,
    material_description TEXT,
    image_url TEXT
);

-- PRODUCTCERTIFICATIONS
DROP TABLE IF EXISTS stg_productcertifications;
CREATE TABLE stg_productcertifications (
    product_id INT,
    certification_id INT,
    date_certified DATE,
    expiry_date DATE
);

-- CUSTOMERS
DROP TABLE IF EXISTS stg_customers;
CREATE TABLE stg_customers (
    customer_id INT,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone TEXT,
    address TEXT,
    city TEXT,
    country TEXT,
    registration_date DATE,
    sustainability_preference INT
);

-- ORDERS
DROP TABLE IF EXISTS stg_orders;
CREATE TABLE stg_orders (
    order_id INT,
    customer_id INT,
    order_date TIMESTAMP,
    total_amount NUMERIC,
    status TEXT,
    shipping_address TEXT,
    shipping_method TEXT,
    payment_method TEXT,
    eco_packaging BOOLEAN,
    carbon_offset BOOLEAN
);

-- ORDERITEMS
DROP TABLE IF EXISTS stg_orderitems;
CREATE TABLE stg_orderitems (
    order_item_id INT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price NUMERIC
);

-- REVIEWS
DROP TABLE IF EXISTS stg_reviews;
CREATE TABLE stg_reviews (
    review_id INT,
    product_id INT,
    customer_id INT,
    rating INT,
    eco_rating INT,
    review_text TEXT,
    review_date DATE
);