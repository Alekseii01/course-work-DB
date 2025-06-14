COPY stg_categories(category_id, category_name, description)
FROM '/Users/zidvi33/Downloads/course_work_DB/data/categories.csv'
DELIMITER ',' CSV HEADER;

COPY stg_subcategories(subcategory_id, category_id, subcategory_name, description)
FROM '/Users/zidvi33/Downloads/course_work_DB/data/subcategories.csv'
DELIMITER ',' CSV HEADER;

COPY stg_ecocertifications(certification_id, certification_name, description, logo)
FROM '/Users/zidvi33/Downloads/course_work_DB/data/eco_certifications.csv'
DELIMITER ',' CSV HEADER;

COPY stg_manufacturers(manufacturer_id, manufacturer_name, country, website, sustainability_rating, description)
FROM '/Users/zidvi33/Downloads/course_work_DB/data/manufacturers.csv'
DELIMITER ',' CSV HEADER;

COPY stg_products(product_id, subcategory_id, manufacturer_id, product_name, description, price, stock, eco_score, material_description, image_url)
FROM '/Users/zidvi33/Downloads/course_work_DB/data/products.csv'
DELIMITER ',' CSV HEADER;

COPY stg_productcertifications(product_id, certification_id, date_certified, expiry_date)
FROM '/Users/zidvi33/Downloads/course_work_DB/data/product_certifications.csv'
DELIMITER ',' CSV HEADER;

COPY stg_customers(customer_id, first_name, last_name, email, phone, address, city, country, registration_date, sustainability_preference)
FROM '/Users/zidvi33/Downloads/course_work_DB/data/customers.csv'
DELIMITER ',' CSV HEADER;

COPY stg_orders(order_id, customer_id, order_date, total_amount, status, shipping_address, shipping_method, payment_method, eco_packaging, carbon_offset)
FROM '/Users/zidvi33/Downloads/course_work_DB/data/orders.csv'
DELIMITER ',' CSV HEADER;

COPY stg_orderitems(order_item_id, order_id, product_id, quantity, unit_price)
FROM '/Users/zidvi33/Downloads/course_work_DB/data/order_items.csv'
DELIMITER ',' CSV HEADER;

COPY stg_reviews(review_id, product_id, customer_id, rating, eco_rating, review_text, review_date)
FROM '/Users/zidvi33/Downloads/course_work_DB/data/reviews.csv'
DELIMITER ',' CSV HEADER;