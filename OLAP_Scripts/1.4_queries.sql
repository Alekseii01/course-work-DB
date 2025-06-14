-- 1. Income
SELECT c.category_name, SUM(fs.total_amount) AS total_revenue
FROM fact_Sale fs
JOIN dim_Product p ON fs.product_id = p.product_id
JOIN dim_Subcategory sc ON p.subcategory_id = sc.subcategory_id
JOIN dim_Category c ON sc.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;

-- 2. Average eco_score
SELECT m.manufacturer_name, AVG(p.eco_score) AS avg_eco_score
FROM dim_Manufacturer m
JOIN dim_Product p ON m.manufacturer_id = p.manufacturer_id
GROUP BY m.manufacturer_name
ORDER BY avg_eco_score DESC;

-- 3. Count of certified products sold by eco certification
SELECT ec.certification_name, COUNT(DISTINCT bpc.product_id) AS certified_products_sold
FROM bridge_Product_Certification bpc
JOIN dim_EcoCertification ec ON bpc.certification_id = ec.certification_id
JOIN fact_Sale fs ON bpc.product_id = fs.product_id
GROUP BY ec.certification_name
ORDER BY certified_products_sold DESC;

-- 4. Average eco rating from reviews by category
SELECT c.category_name, ROUND(AVG(fr.eco_rating), 2) AS avg_eco_rating
FROM fact_Review fr
JOIN dim_Product p ON fr.product_id = p.product_id
JOIN dim_Subcategory sc ON p.subcategory_id = sc.subcategory_id
JOIN dim_Category c ON sc.category_id = c.category_id
WHERE fr.eco_rating IS NOT NULL
GROUP BY c.category_name
ORDER BY avg_eco_rating DESC;

-- 5. Top 5 customers with the most eco-friendly purchases
SELECT dcu.first_name, dcu.last_name, COUNT(*) AS eco_friendly_purchases
FROM fact_Sale fs
JOIN dim_Product p ON fs.product_id = p.product_id
JOIN dim_Customer dcu ON fs.customer_id = dcu.customer_id
WHERE p.eco_score >= 9
GROUP BY dcu.first_name, dcu.last_name
ORDER BY eco_friendly_purchases DESC
LIMIT 5;

-- 6. Sales revenue by date
SELECT dd.date, SUM(fs.total_amount) AS daily_revenue
FROM fact_Sale fs
JOIN dim_Date dd ON fs.date_id = dd.date_id
GROUP BY dd.date
ORDER BY dd.date;

-- 7. Average rating by category
SELECT c.category_name, ROUND(AVG(fr.rating), 2) AS avg_rating
FROM fact_Review fr
JOIN dim_Product p ON fr.product_id = p.product_id
JOIN dim_Subcategory sc ON p.subcategory_id = sc.subcategory_id
JOIN dim_Category c ON sc.category_id = c.category_id
GROUP BY c.category_name
ORDER BY avg_rating DESC;