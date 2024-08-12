-- CREATE DATABASE group5_Lab4
-- DROP TABLE ORDER IF MISTAKE OCCURS: ORDER_PRODUCT --> ORDER --> CUSTOMER --> PRODUCT --> PRODUCT_TYPE
-- DROP TABLE ...

USE group5_Lab4
GO

CREATE TABLE tblPRODUCT_TYPE (
    ProductTypeID INT IDENTITY(1,1) PRIMARY KEY,
    ProductTypeName VARCHAR(255) NOT NULL,
    ProductTypeDescr VARCHAR(255) NOT NULL
);
GO

CREATE TABLE tblPRODUCT (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    Price NUMERIC(8,2) NOT NULL,
    ProductDescr VARCHAR(255) NOT NULL,
    ProductTypeID INT FOREIGN KEY REFERENCES tblPRODUCT_TYPE(ProductTypeID) NOT NULL
);
GO

CREATE TABLE tblCUSTOMER (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL
);
GO

CREATE TABLE tblORDER (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerID INT FOREIGN KEY REFERENCES tblCUSTOMER(CustomerID) NOT NULL
);
GO

CREATE TABLE tblORDER_PRODUCT (
    OrderProdID INT IDENTITY(1,1) PRIMARY KEY,
    Quantity INT NOT NULL,
    OrderID INT FOREIGN KEY REFERENCES tblORDER(OrderID) NOT NULL,
    ProductID INT FOREIGN KEY REFERENCES tblPRODUCT(ProductID) NOT NULL
);
GO

CREATE TABLE tblCART (
    pkID INT IDENTITY(1,1) PRIMARY KEY,
    CustFname VARCHAR(50) NOT NULL,
    CustLname VARCHAR(50) NOT NULL,
    CustBirthDate DATE NOT NULL,
    ProductName VARCHAR(255) NOT NULL,
    Quantity INT NOT NULL,
    Date DATE NOT NULL,
    CustomerID INT FOREIGN KEY REFERENCES tblCUSTOMER(CustomerID) NOT NULL,
    ProductID INT FOREIGN KEY REFERENCES tblPRODUCT(ProductID) NOT NULL
);
GO

-- Populate table CUSTOMER
INSERT INTO tblCUSTOMER (Fname, Lname, BirthDate)
    SELECT TOP 100 CustomerFname, CustomerLname, DateOfBirth
    FROM PEEPS.dbo.tblCUSTOMER
    WHERE
    CustomerFname IS NOT NULL AND
    CustomerLname IS NOT NULL AND
    DateOfBirth IS NOT NULL;
GO

-- Populate table PRODUCT_TYPE and PRODUCT
INSERT INTO tblPRODUCT_TYPE (ProductTypeName, ProductTypeDescr)
VALUES
    ('ProductType_A', 'ProductType_Descr_A'),
    ('ProductType_B', 'ProductType_Descr_B'),
    ('ProductType_C', 'ProductType_Descr_C'),
    ('ProductType_D', 'ProductType_Descr_D'),
    ('ProductType_E', 'ProductType_Descr_E');
GO

INSERT INTO tblPRODUCT (ProductName, Price, ProductDescr, ProductTypeID)
VALUES
    ('Product_A', 10, 'ProductDescr_A', 1),
    ('Product_B', 20, 'ProductDescr_B', 2),
    ('Product_C', 30, 'ProductDescr_C', 3),
    ('Product_D', 40, 'ProductDescr_D', 4),
    ('Product_E', 50, 'ProductDescr_E', 5);
GO

-- Create working copy
CREATE TABLE CopyTblCUSTOMER (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL
);
INSERT INTO CopyTblCUSTOMER (Fname, Lname, BirthDate)
    SELECT Fname, Lname, BirthDate
    FROM tblCUSTOMER;
GO
-- SELECT * FROM CopyTblCustomer