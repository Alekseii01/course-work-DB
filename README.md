# Course Project: Eco-products Analytics

## Project Structure

### 1. OLTP

- Staging tables: categories, subcategories, certifications, manufacturers, products, product certifications, customers, orders, order items, reviews.
- Data loading: COPY from csv into staging tables.
- Main tables: Categories, Subcategories, EcoCertifications, Manufacturers, Products, ProductCertifications, Customers, Orders, OrderItems, Reviews.
- Data transfer from staging to main tables via INSERT ... SELECT ... ON CONFLICT DO UPDATE.

### 2. OLTP Queries

- Top 5 products by EcoScore.
- Average EcoScore by manufacturer.
- Average eco-friendly rating by category from reviews.

### 3. OLAP (Data Mart)

- Dimension tables: dim_Date, dim_Category, dim_Subcategory, dim_Manufacturer, dim_Product, dim_Customer (SCD2), dim_EcoCertification.
- Bridge table: bridge_Product_Certification.
- Fact tables: fact_Sale, fact_Review.

### 4. ETL

- Data loading from OLTP via dblink into all dimension and fact tables.
- Customer historization (SCD2).
- Ensuring uniqueness and referential integrity during load.

### 5. Export for Power BI

- COPY all dimension and fact tables into separate csv files for analysis and visualization.

### 6. OLAP Queries

- Revenue by category.
- Average eco_score by manufacturer.
- Number of certified products sold by certification.
- Average eco rating by category.
- Top 5 customers by number of eco-friendly purchases.
- Revenue by date.
- Average rating by category.

# Structure of the Power BI Analytical Report

## 1. Key Metrics

- **Total Sales Count** — 25,000
- **Total Revenue** — 7.78 million

## 2. Visualizations

- Total Sales Count and eco_rating by day — bar and line chart (X: day, Y: sales count and eco_rating)
- Total Sales Count by country — pie chart (segments: countries, values: sales)
- Total Revenue by country — cards for each country
- Total Sales Count by year, quarter, month, day — line chart (time axis)
- Total Revenue by country — area/bar chart (countries, revenue)
- Filters by product subcategories (subcategory_name)

## 3. Data Model Fields Used

- Total Sales Count
- Total Revenue
- eco_rating
- country
- subcategory_name

## 4. Compliance

- All key metrics and filters are implemented in the report.
- The report includes business indicators, time trends, geography, and interactive filtering by subcategories.