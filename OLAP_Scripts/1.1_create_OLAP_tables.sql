-- dim_Date
CREATE TABLE IF NOT EXISTS dim_Date (
    date_id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    day INTEGER,
    month INTEGER,
    year INTEGER,
    quarter INTEGER,
    weekday INTEGER
);

-- dim_Category
CREATE TABLE IF NOT EXISTS dim_Category (
    category_id SERIAL PRIMARY KEY,
    category_name TEXT NOT NULL UNIQUE,
    description TEXT
);

-- dim_Subcategory
CREATE TABLE IF NOT EXISTS dim_Subcategory (
    subcategory_id SERIAL PRIMARY KEY,
    subcategory_name TEXT NOT NULL,
    category_id INTEGER REFERENCES dim_Category(category_id),
    description TEXT
);

-- dim_Manufacturer
CREATE TABLE IF NOT EXISTS dim_Manufacturer (
    manufacturer_id SERIAL PRIMARY KEY,
    manufacturer_name TEXT NOT NULL UNIQUE,
    country TEXT,
    website TEXT,
    sustainability_rating NUMERIC,
    description TEXT
);

-- dim_Product
CREATE TABLE IF NOT EXISTS dim_Product (
    product_id SERIAL PRIMARY KEY,
    product_name TEXT NOT NULL,
    subcategory_id INTEGER REFERENCES dim_Subcategory(subcategory_id),
    manufacturer_id INTEGER REFERENCES dim_Manufacturer(manufacturer_id),
    price NUMERIC,
    eco_score NUMERIC,
    material_description TEXT,
    image_url TEXT,
    description TEXT
);

-- dim_Customer (SCD Type 2)
CREATE TABLE IF NOT EXISTS dim_Customer (
    customer_id SERIAL PRIMARY KEY,
    src_customer_id INTEGER, -- from OLTP
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone TEXT,
    address TEXT,
    city TEXT,
    country TEXT,
    sustainability_preference INTEGER,
    registration_date DATE,
    start_date DATE,
    end_date DATE,
    is_current BOOLEAN
);

-- dim_EcoCertification
CREATE TABLE IF NOT EXISTS dim_EcoCertification (
    certification_id SERIAL PRIMARY KEY,
    certification_name TEXT NOT NULL UNIQUE,
    description TEXT,
    logo TEXT
);

-- bridge_Product_Certification
CREATE TABLE IF NOT EXISTS bridge_Product_Certification (
    product_id INTEGER REFERENCES dim_Product(product_id),
    certification_id INTEGER REFERENCES dim_EcoCertification(certification_id),
    date_certified DATE,
    expiry_date DATE,
    PRIMARY KEY (product_id, certification_id)
);

-- fact_Sale
CREATE TABLE IF NOT EXISTS fact_Sale (
    sale_id SERIAL PRIMARY KEY,
    date_id INTEGER REFERENCES dim_Date(date_id),
    product_id INTEGER REFERENCES dim_Product(product_id),
    customer_id INTEGER REFERENCES dim_Customer(customer_id),
    quantity INTEGER,
    total_amount NUMERIC
);

-- fact_Review
CREATE TABLE IF NOT EXISTS fact_Review (
    review_id SERIAL PRIMARY KEY,
    date_id INTEGER REFERENCES dim_Date(date_id),
    product_id INTEGER REFERENCES dim_Product(product_id),
    customer_id INTEGER REFERENCES dim_Customer(customer_id),
    rating INTEGER,
    eco_rating INTEGER
);