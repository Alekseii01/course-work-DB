CREATE EXTENSION IF NOT EXISTS dblink;

-- dim_Date
INSERT INTO dim_Date (date, day, month, year, quarter, weekday)
SELECT DISTINCT d::DATE,
    EXTRACT(DAY FROM d),
    EXTRACT(MONTH FROM d),
    EXTRACT(YEAR FROM d),
    EXTRACT(QUARTER FROM d),
    EXTRACT(DOW FROM d)
FROM (
    SELECT orderdate FROM dblink('dbname=eco_oltp host=localhost user=postgres',
        'SELECT orderdate FROM Orders WHERE orderdate IS NOT NULL'
    ) AS t(orderdate TIMESTAMP)
    UNION
    SELECT reviewdate FROM dblink('dbname=eco_oltp host=localhost user=postgres',
        'SELECT reviewdate FROM Reviews WHERE reviewdate IS NOT NULL'
    ) AS t(reviewdate DATE)
    UNION
    SELECT datecertified FROM dblink('dbname=eco_oltp host=localhost user=postgres',
        'SELECT datecertified FROM ProductCertifications WHERE datecertified IS NOT NULL'
    ) AS t(datecertified DATE)
    UNION
    SELECT registrationdate FROM dblink('dbname=eco_oltp host=localhost user=postgres',
        'SELECT registrationdate FROM Customers WHERE registrationdate IS NOT NULL'
    ) AS t(registrationdate DATE)
) AS all_dates(d)
WHERE d::DATE NOT IN (SELECT date FROM dim_Date);

-- dim_Category
INSERT INTO dim_Category (category_name, description)
SELECT DISTINCT categoryname, description
FROM dblink('dbname=eco_oltp host=localhost user=postgres',
    'SELECT categoryname, description FROM Categories'
) AS t(categoryname TEXT, description TEXT)
WHERE categoryname NOT IN (SELECT category_name FROM dim_Category);

-- dim_Subcategory
INSERT INTO dim_Subcategory (subcategory_name, category_id, description)
SELECT s.subcategoryname, dc.category_id, s.description
FROM dblink('dbname=eco_oltp host=localhost user=postgres',
    'SELECT s.subcategoryname, c.categoryname, s.description 
     FROM Subcategories s
     JOIN Categories c ON s.categoryid = c.categoryid'
) AS s(subcategoryname TEXT, categoryname TEXT, description TEXT)
JOIN dim_Category dc ON s.categoryname = dc.category_name
WHERE s.subcategoryname NOT IN (SELECT subcategory_name FROM dim_Subcategory WHERE category_id = dc.category_id);

-- dim_EcoCertification
INSERT INTO dim_EcoCertification (certification_name, description, logo)
SELECT certificationname, description, logo
FROM dblink('dbname=eco_oltp host=localhost user=postgres',
    'SELECT certificationname, description, logo FROM EcoCertifications'
) AS t(certificationname TEXT, description TEXT, logo TEXT)
WHERE certificationname NOT IN (SELECT certification_name FROM dim_EcoCertification);

-- dim_Manufacturer
INSERT INTO dim_Manufacturer (manufacturer_name, country, website, sustainability_rating, description)
SELECT *
FROM (
    SELECT DISTINCT ON (manufacturername)
        manufacturername, country, website, sustainabilityrating, description
    FROM dblink('dbname=eco_oltp host=localhost user=postgres',
        'SELECT manufacturername, country, website, sustainabilityrating, description FROM Manufacturers'
    ) AS t(manufacturername TEXT, country TEXT, website TEXT, sustainabilityrating NUMERIC, description TEXT)
    ORDER BY manufacturername
) uniq
ON CONFLICT (manufacturer_name) DO UPDATE
SET
    country = EXCLUDED.country,
    website = EXCLUDED.website,
    sustainability_rating = EXCLUDED.sustainability_rating,
    description = EXCLUDED.description;

-- dim_Product
INSERT INTO dim_Product (
    product_name, subcategory_id, manufacturer_id, price, eco_score, material_description, image_url, description
)
SELECT p.productname, ds.subcategory_id, dm.manufacturer_id, p.price, p.ecoscore, p.materialdescription, p.imageurl, p.description
FROM dblink('dbname=eco_oltp host=localhost user=postgres',
    'SELECT p.productname, s.subcategoryname, c.categoryname, m.manufacturername, 
            p.price, p.ecoscore, p.materialdescription, p.imageurl, p.description
     FROM Products p
     JOIN Subcategories s ON p.subcategoryid = s.subcategoryid
     JOIN Categories c ON s.categoryid = c.categoryid
     JOIN Manufacturers m ON p.manufacturerid = m.manufacturerid'
) AS p(productname TEXT, subcategoryname TEXT, categoryname TEXT, manufacturername TEXT, 
       price NUMERIC, ecoscore NUMERIC, materialdescription TEXT, imageurl TEXT, description TEXT)
JOIN dim_Category dc ON p.categoryname = dc.category_name
JOIN dim_Subcategory ds ON p.subcategoryname = ds.subcategory_name AND ds.category_id = dc.category_id
JOIN dim_Manufacturer dm ON p.manufacturername = dm.manufacturer_name
WHERE p.productname NOT IN (
    SELECT product_name FROM dim_Product dp2 
    WHERE dp2.subcategory_id = ds.subcategory_id 
    AND dp2.manufacturer_id = dm.manufacturer_id
);

-- dim_Customer (SCD Type 2)
UPDATE dim_Customer AS target
SET end_date = CURRENT_DATE, is_current = FALSE
FROM dblink('dbname=eco_oltp host=localhost user=postgres',
    'SELECT customerid, firstname, lastname, email, phone, address, city, country, sustainabilitypreference, registrationdate FROM Customers'
) AS src(customerid INT, firstname TEXT, lastname TEXT, email TEXT, phone TEXT, address TEXT, city TEXT, country TEXT, sustainabilitypreference INT, registrationdate DATE)
WHERE target.src_customer_id = src.customerid AND target.is_current = TRUE
  AND (
    target.first_name IS DISTINCT FROM src.firstname OR
    target.last_name IS DISTINCT FROM src.lastname OR
    target.email IS DISTINCT FROM src.email OR
    target.phone IS DISTINCT FROM src.phone OR
    target.address IS DISTINCT FROM src.address OR
    target.city IS DISTINCT FROM src.city OR
    target.country IS DISTINCT FROM src.country OR
    target.sustainability_preference IS DISTINCT FROM src.sustainabilitypreference
  );

INSERT INTO dim_Customer (
    src_customer_id, first_name, last_name, email, phone, address, city, country, sustainability_preference, registration_date, start_date, end_date, is_current
)
SELECT src.customerid, src.firstname, src.lastname, src.email, src.phone, src.address, src.city, src.country, src.sustainabilitypreference, src.registrationdate, CURRENT_DATE, NULL, TRUE
FROM dblink('dbname=eco_oltp host=localhost user=postgres',
    'SELECT customerid, firstname, lastname, email, phone, address, city, country, sustainabilitypreference, registrationdate FROM Customers'
) AS src(customerid INT, firstname TEXT, lastname TEXT, email TEXT, phone TEXT, address TEXT, city TEXT, country TEXT, sustainabilitypreference INT, registrationdate DATE)
WHERE NOT EXISTS (
    SELECT 1 FROM dim_Customer current
    WHERE current.src_customer_id = src.customerid AND current.is_current = TRUE
);

-- bridge_Product_Certification
INSERT INTO bridge_Product_Certification (product_id, certification_id, date_certified, expiry_date)
SELECT dp.product_id, dec.certification_id, pc.datecertified, pc.expirydate
FROM dblink('dbname=eco_oltp host=localhost user=postgres',
    'SELECT p.productname, s.subcategoryname, c.categoryname, m.manufacturername,
            ec.certificationname, pc.datecertified, pc.expirydate
     FROM ProductCertifications pc
     JOIN Products p ON pc.productid = p.productid
     JOIN Subcategories s ON p.subcategoryid = s.subcategoryid
     JOIN Categories c ON s.categoryid = c.categoryid
     JOIN Manufacturers m ON p.manufacturerid = m.manufacturerid
     JOIN EcoCertifications ec ON pc.certificationid = ec.certificationid'
) AS pc(productname TEXT, subcategoryname TEXT, categoryname TEXT, manufacturername TEXT,
        certificationname TEXT, datecertified DATE, expirydate DATE)
JOIN dim_Category dc ON pc.categoryname = dc.category_name
JOIN dim_Subcategory ds ON pc.subcategoryname = ds.subcategory_name AND ds.category_id = dc.category_id
JOIN dim_Manufacturer dm ON pc.manufacturername = dm.manufacturer_name
JOIN dim_Product dp ON pc.productname = dp.product_name AND dp.subcategory_id = ds.subcategory_id AND dp.manufacturer_id = dm.manufacturer_id
JOIN dim_EcoCertification dec ON pc.certificationname = dec.certification_name
WHERE NOT EXISTS (
    SELECT 1 FROM bridge_Product_Certification bpc
    WHERE bpc.product_id = dp.product_id AND bpc.certification_id = dec.certification_id
);

-- fact_Sale
INSERT INTO fact_Sale (date_id, product_id, customer_id, quantity, total_amount)
SELECT dd.date_id, dp.product_id, dc.customer_id, t.quantity, t.quantity * t.unitprice AS total_amount
FROM dblink('dbname=eco_oltp host=localhost user=postgres',
    'SELECT o.orderdate, oi.quantity, oi.unitprice, o.customerid,
            p.productname, s.subcategoryname, c.categoryname, m.manufacturername
     FROM Orders o
     JOIN OrderItems oi ON o.orderid = oi.orderid
     JOIN Products p ON oi.productid = p.productid
     JOIN Subcategories s ON p.subcategoryid = s.subcategoryid
     JOIN Categories c ON s.categoryid = c.categoryid
     JOIN Manufacturers m ON p.manufacturerid = m.manufacturerid'
) AS t(orderdate TIMESTAMP, quantity INT, unitprice NUMERIC, customerid INT,
       productname TEXT, subcategoryname TEXT, categoryname TEXT, manufacturername TEXT)
JOIN dim_Date dd ON t.orderdate::DATE = dd.date
JOIN dim_Category dc_cat ON t.categoryname = dc_cat.category_name
JOIN dim_Subcategory ds ON t.subcategoryname = ds.subcategory_name AND ds.category_id = dc_cat.category_id
JOIN dim_Manufacturer dm ON t.manufacturername = dm.manufacturer_name
JOIN dim_Product dp ON t.productname = dp.product_name AND dp.subcategory_id = ds.subcategory_id AND dp.manufacturer_id = dm.manufacturer_id
JOIN dim_Customer dc ON t.customerid = dc.src_customer_id AND dc.is_current = TRUE
WHERE NOT EXISTS (
    SELECT 1 FROM fact_Sale fs
    WHERE fs.date_id = dd.date_id AND fs.product_id = dp.product_id 
    AND fs.customer_id = dc.customer_id AND fs.quantity = t.quantity 
    AND fs.total_amount = (t.quantity * t.unitprice)
);

-- fact_Review
INSERT INTO fact_Review (date_id, product_id, customer_id, rating, eco_rating)
SELECT dd.date_id, dp.product_id, dc.customer_id, r.rating, r.ecorating
FROM dblink('dbname=eco_oltp host=localhost user=postgres',
    'SELECT r.reviewdate, r.rating, r.ecorating, r.customerid,
            p.productname, s.subcategoryname, c.categoryname, m.manufacturername
     FROM Reviews r
     JOIN Products p ON r.productid = p.productid
     JOIN Subcategories s ON p.subcategoryid = s.subcategoryid
     JOIN Categories c ON s.categoryid = c.categoryid
     JOIN Manufacturers m ON p.manufacturerid = m.manufacturerid'
) AS r(reviewdate DATE, rating INT, ecorating INT, customerid INT,
       productname TEXT, subcategoryname TEXT, categoryname TEXT, manufacturername TEXT)
JOIN dim_Date dd ON r.reviewdate = dd.date
JOIN dim_Category dc_cat ON r.categoryname = dc_cat.category_name
JOIN dim_Subcategory ds ON r.subcategoryname = ds.subcategory_name AND ds.category_id = dc_cat.category_id
JOIN dim_Manufacturer dm ON r.manufacturername = dm.manufacturer_name
JOIN dim_Product dp ON r.productname = dp.product_name AND dp.subcategory_id = ds.subcategory_id AND dp.manufacturer_id = dm.manufacturer_id
JOIN dim_Customer dc ON r.customerid = dc.src_customer_id AND dc.is_current = TRUE
WHERE NOT EXISTS (
    SELECT 1 FROM fact_Review fr
    WHERE fr.date_id = dd.date_id AND fr.product_id = dp.product_id 
    AND fr.customer_id = dc.customer_id AND fr.rating = r.rating 
    AND fr.eco_rating = r.ecorating
);