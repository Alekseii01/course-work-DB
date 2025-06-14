INSERT INTO Categories (CategoryID, CategoryName, Description)
SELECT DISTINCT ON (category_id) category_id, category_name, description
FROM stg_categories
ORDER BY category_id, category_name
ON CONFLICT (CategoryID) DO UPDATE
SET
    CategoryName = EXCLUDED.CategoryName,
    Description = EXCLUDED.Description
WHERE
    Categories.CategoryName IS DISTINCT FROM EXCLUDED.CategoryName OR
    Categories.Description IS DISTINCT FROM EXCLUDED.Description;

INSERT INTO Subcategories (SubcategoryID, CategoryID, SubcategoryName, Description)
SELECT DISTINCT ON (subcategory_id) subcategory_id, category_id, subcategory_name, description
FROM stg_subcategories
ORDER BY subcategory_id, subcategory_name
ON CONFLICT (SubcategoryID) DO UPDATE
SET
    CategoryID = EXCLUDED.CategoryID,
    SubcategoryName = EXCLUDED.SubcategoryName,
    Description = EXCLUDED.Description
WHERE
    Subcategories.CategoryID IS DISTINCT FROM EXCLUDED.CategoryID OR
    Subcategories.SubcategoryName IS DISTINCT FROM EXCLUDED.SubcategoryName OR
    Subcategories.Description IS DISTINCT FROM EXCLUDED.Description;

INSERT INTO EcoCertifications (CertificationID, CertificationName, Description, Logo)
SELECT DISTINCT ON (certification_id) certification_id, certification_name, description, logo
FROM stg_ecocertifications
ORDER BY certification_id, certification_name
ON CONFLICT (CertificationID) DO UPDATE
SET
    CertificationName = EXCLUDED.CertificationName,
    Description = EXCLUDED.Description,
    Logo = EXCLUDED.Logo
WHERE
    EcoCertifications.CertificationName IS DISTINCT FROM EXCLUDED.CertificationName OR
    EcoCertifications.Description IS DISTINCT FROM EXCLUDED.Description OR
    EcoCertifications.Logo IS DISTINCT FROM EXCLUDED.Logo;

INSERT INTO Manufacturers (ManufacturerID, ManufacturerName, Country, Website, SustainabilityRating, Description)
SELECT DISTINCT ON (manufacturer_id) manufacturer_id, manufacturer_name, country, website, sustainability_rating, description
FROM stg_manufacturers
ORDER BY manufacturer_id, manufacturer_name
ON CONFLICT (ManufacturerID) DO UPDATE
SET
    ManufacturerName = EXCLUDED.ManufacturerName,
    Country = EXCLUDED.Country,
    Website = EXCLUDED.Website,
    SustainabilityRating = EXCLUDED.SustainabilityRating,
    Description = EXCLUDED.Description
WHERE
    Manufacturers.ManufacturerName IS DISTINCT FROM EXCLUDED.ManufacturerName OR
    Manufacturers.Country IS DISTINCT FROM EXCLUDED.Country OR
    Manufacturers.Website IS DISTINCT FROM EXCLUDED.Website OR
    Manufacturers.SustainabilityRating IS DISTINCT FROM EXCLUDED.SustainabilityRating OR
    Manufacturers.Description IS DISTINCT FROM EXCLUDED.Description;

INSERT INTO Products (ProductID, SubcategoryID, ManufacturerID, ProductName, Description, Price, Stock, EcoScore, MaterialDescription, ImageURL)
SELECT DISTINCT ON (product_id) product_id, subcategory_id, manufacturer_id, product_name, description, price, stock, eco_score, material_description, image_url
FROM stg_products
ORDER BY product_id, product_name
ON CONFLICT (ProductID) DO UPDATE
SET
    SubcategoryID = EXCLUDED.SubcategoryID,
    ManufacturerID = EXCLUDED.ManufacturerID,
    ProductName = EXCLUDED.ProductName,
    Description = EXCLUDED.Description,
    Price = EXCLUDED.Price,
    Stock = EXCLUDED.Stock,
    EcoScore = EXCLUDED.EcoScore,
    MaterialDescription = EXCLUDED.MaterialDescription,
    ImageURL = EXCLUDED.ImageURL
WHERE
    Products.SubcategoryID IS DISTINCT FROM EXCLUDED.SubcategoryID OR
    Products.ManufacturerID IS DISTINCT FROM EXCLUDED.ManufacturerID OR
    Products.ProductName IS DISTINCT FROM EXCLUDED.ProductName OR
    Products.Description IS DISTINCT FROM EXCLUDED.Description OR
    Products.Price IS DISTINCT FROM EXCLUDED.Price OR
    Products.Stock IS DISTINCT FROM EXCLUDED.Stock OR
    Products.EcoScore IS DISTINCT FROM EXCLUDED.EcoScore OR
    Products.MaterialDescription IS DISTINCT FROM EXCLUDED.MaterialDescription OR
    Products.ImageURL IS DISTINCT FROM EXCLUDED.ImageURL;

INSERT INTO ProductCertifications (ProductID, CertificationID, DateCertified, ExpiryDate)
SELECT DISTINCT ON (product_id, certification_id) product_id, certification_id, date_certified, expiry_date
FROM stg_productcertifications
ORDER BY product_id, certification_id, date_certified
ON CONFLICT (ProductID, CertificationID) DO UPDATE
SET
    DateCertified = EXCLUDED.DateCertified,
    ExpiryDate = EXCLUDED.ExpiryDate
WHERE
    ProductCertifications.DateCertified IS DISTINCT FROM EXCLUDED.DateCertified OR
    ProductCertifications.ExpiryDate IS DISTINCT FROM EXCLUDED.ExpiryDate;

INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, Address, City, Country, RegistrationDate, SustainabilityPreference)
SELECT DISTINCT ON (customer_id) customer_id, first_name, last_name, email, phone, address, city, country, registration_date, sustainability_preference
FROM stg_customers
ORDER BY customer_id, registration_date DESC
ON CONFLICT (CustomerID) DO UPDATE
SET
    FirstName = EXCLUDED.FirstName,
    LastName = EXCLUDED.LastName,
    Email = EXCLUDED.Email,
    Phone = EXCLUDED.Phone,
    Address = EXCLUDED.Address,
    City = EXCLUDED.City,
    Country = EXCLUDED.Country,
    RegistrationDate = EXCLUDED.RegistrationDate,
    SustainabilityPreference = EXCLUDED.SustainabilityPreference
WHERE
    Customers.FirstName IS DISTINCT FROM EXCLUDED.FirstName OR
    Customers.LastName IS DISTINCT FROM EXCLUDED.LastName OR
    Customers.Email IS DISTINCT FROM EXCLUDED.Email OR
    Customers.Phone IS DISTINCT FROM EXCLUDED.Phone OR
    Customers.Address IS DISTINCT FROM EXCLUDED.Address OR
    Customers.City IS DISTINCT FROM EXCLUDED.City OR
    Customers.Country IS DISTINCT FROM EXCLUDED.Country OR
    Customers.RegistrationDate IS DISTINCT FROM EXCLUDED.RegistrationDate OR
    Customers.SustainabilityPreference IS DISTINCT FROM EXCLUDED.SustainabilityPreference;

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status, ShippingAddress, ShippingMethod, PaymentMethod, EcoPackaging, CarbonOffset)
SELECT DISTINCT ON (order_id) order_id, customer_id, order_date, total_amount, status, shipping_address, shipping_method, payment_method, eco_packaging, carbon_offset
FROM stg_orders
ORDER BY order_id, order_date
ON CONFLICT (OrderID) DO UPDATE
SET
    CustomerID = EXCLUDED.CustomerID,
    OrderDate = EXCLUDED.OrderDate,
    TotalAmount = EXCLUDED.TotalAmount,
    Status = EXCLUDED.Status,
    ShippingAddress = EXCLUDED.ShippingAddress,
    ShippingMethod = EXCLUDED.ShippingMethod,
    PaymentMethod = EXCLUDED.PaymentMethod,
    EcoPackaging = EXCLUDED.EcoPackaging,
    CarbonOffset = EXCLUDED.CarbonOffset
WHERE
    Orders.CustomerID IS DISTINCT FROM EXCLUDED.CustomerID OR
    Orders.OrderDate IS DISTINCT FROM EXCLUDED.OrderDate OR
    Orders.TotalAmount IS DISTINCT FROM EXCLUDED.TotalAmount OR
    Orders.Status IS DISTINCT FROM EXCLUDED.Status OR
    Orders.ShippingAddress IS DISTINCT FROM EXCLUDED.ShippingAddress OR
    Orders.ShippingMethod IS DISTINCT FROM EXCLUDED.ShippingMethod OR
    Orders.PaymentMethod IS DISTINCT FROM EXCLUDED.PaymentMethod OR
    Orders.EcoPackaging IS DISTINCT FROM EXCLUDED.EcoPackaging OR
    Orders.CarbonOffset IS DISTINCT FROM EXCLUDED.CarbonOffset;

INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
SELECT DISTINCT ON (order_item_id) order_item_id, order_id, product_id, quantity, unit_price
FROM stg_orderitems
ORDER BY order_item_id, order_id
ON CONFLICT (OrderItemID) DO UPDATE
SET
    OrderID = EXCLUDED.OrderID,
    ProductID = EXCLUDED.ProductID,
    Quantity = EXCLUDED.Quantity,
    UnitPrice = EXCLUDED.UnitPrice
WHERE
    OrderItems.OrderID IS DISTINCT FROM EXCLUDED.OrderID OR
    OrderItems.ProductID IS DISTINCT FROM EXCLUDED.ProductID OR
    OrderItems.Quantity IS DISTINCT FROM EXCLUDED.Quantity OR
    OrderItems.UnitPrice IS DISTINCT FROM EXCLUDED.UnitPrice;

INSERT INTO Reviews (ReviewID, ProductID, CustomerID, Rating, EcoRating, ReviewText, ReviewDate)
SELECT DISTINCT ON (review_id) review_id, product_id, customer_id, rating, eco_rating, review_text, review_date
FROM stg_reviews
ORDER BY review_id, review_date
ON CONFLICT (ReviewID) DO UPDATE
SET
    ProductID = EXCLUDED.ProductID,
    CustomerID = EXCLUDED.CustomerID,
    Rating = EXCLUDED.Rating,
    EcoRating = EXCLUDED.EcoRating,
    ReviewText = EXCLUDED.ReviewText,
    ReviewDate = EXCLUDED.ReviewDate
WHERE
    Reviews.ProductID IS DISTINCT FROM EXCLUDED.ProductID OR
    Reviews.CustomerID IS DISTINCT FROM EXCLUDED.CustomerID OR
    Reviews.Rating IS DISTINCT FROM EXCLUDED.Rating OR
    Reviews.EcoRating IS DISTINCT FROM EXCLUDED.EcoRating OR
    Reviews.ReviewText IS DISTINCT FROM EXCLUDED.ReviewText OR
    Reviews.ReviewDate IS DISTINCT FROM EXCLUDED.ReviewDate;