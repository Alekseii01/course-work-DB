CREATE TABLE IF NOT EXISTS Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    Description TEXT
);

CREATE TABLE IF NOT EXISTS Subcategories (
    SubcategoryID INT PRIMARY KEY,
    CategoryID INT NOT NULL,
    SubcategoryName VARCHAR(50) NOT NULL,
    Description TEXT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE IF NOT EXISTS EcoCertifications (
    CertificationID INT PRIMARY KEY,
    CertificationName VARCHAR(50) NOT NULL,
    Description TEXT,
    Logo VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Manufacturers (
    ManufacturerID INT PRIMARY KEY,
    ManufacturerName VARCHAR(100) NOT NULL,
    Country VARCHAR(50),
    Website VARCHAR(255),
    SustainabilityRating DECIMAL(3,1),
    Description TEXT
);

CREATE TABLE IF NOT EXISTS Products (
    ProductID INT PRIMARY KEY,
    SubcategoryID INT NOT NULL,
    ManufacturerID INT NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    EcoScore DECIMAL(3,1),
    MaterialDescription TEXT,
    ImageURL VARCHAR(255),
    FOREIGN KEY (SubcategoryID) REFERENCES Subcategories(SubcategoryID),
    FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers(ManufacturerID)
);

CREATE TABLE IF NOT EXISTS ProductCertifications (
    ProductID INT NOT NULL,
    CertificationID INT NOT NULL,
    DateCertified DATE NOT NULL,
    ExpiryDate DATE,
    PRIMARY KEY (ProductID, CertificationID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CertificationID) REFERENCES EcoCertifications(CertificationID)
);

CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Address TEXT,
    City VARCHAR(50),
    Country VARCHAR(50),
    RegistrationDate DATE NOT NULL,
    SustainabilityPreference INT
);

CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate TIMESTAMP NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    ShippingAddress TEXT,
    ShippingMethod VARCHAR(50),
    PaymentMethod VARCHAR(50),
    EcoPackaging BOOLEAN,
    CarbonOffset BOOLEAN,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE IF NOT EXISTS OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE IF NOT EXISTS Reviews (
    ReviewID INT PRIMARY KEY,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    Rating INT NOT NULL,
    EcoRating INT,
    ReviewText TEXT,
    ReviewDate DATE NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);