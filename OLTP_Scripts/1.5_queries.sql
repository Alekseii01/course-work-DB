-- 1 TOP-5 the most ecologi products (по EcoScore)
SELECT
    p.ProductID,
    p.ProductName,
    p.EcoScore,
    p.MaterialDescription
FROM
    Products p
WHERE
    p.EcoScore IS NOT NULL
ORDER BY
    p.EcoScore DESC
LIMIT 5;

-- 2 Average EcoScore 
SELECT
    m.ManufacturerID,
    m.ManufacturerName,
    ROUND(AVG(p.EcoScore), 2) AS avg_eco_score
FROM
    Manufacturers m
    JOIN Products p ON m.ManufacturerID = p.ManufacturerID
WHERE
    p.EcoScore IS NOT NULL
GROUP BY
    m.ManufacturerID, m.ManufacturerName
ORDER BY
    avg_eco_score DESC;

-- 3 Average eco-friendly rate from rewiews
SELECT
    c.CategoryName,
    ROUND(AVG(r.EcoRating), 2) AS avg_eco_rating
FROM
    Reviews r
    JOIN Products p ON r.ProductID = p.ProductID
    JOIN Subcategories s ON p.SubcategoryID = s.SubcategoryID
    JOIN Categories c ON s.CategoryID = c.CategoryID
WHERE
    r.EcoRating IS NOT NULL
GROUP BY
    c.CategoryName
ORDER BY
    avg_eco_rating DESC;