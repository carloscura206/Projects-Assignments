--------------------#2
--CREATE DATABASE INFO430_Lab2_ccura01


-----------#3
USE INFO430_Lab2_ccura01

-----------#4

CREATE TABLE tblCUSTOMER (
    CustID INTEGER IDENTITY(1,1) PRIMARY KEY, 
    CustFname varchar(25) NOT NULL, 
    CustLname VARCHAR(25) NOT NULL, 
    CustDOB DATE NULL
)

CREATE TABLE tblPRODUCT_TYPE (
    ProdTypeID INTEGER IDENTITY(1,1) PRIMARY KEY, 
    ProdTypeName varchar(50) NOT NULL, 
    ProdTypeDescr VARCHAR(500) NULL
)

CREATE TABLE tblPRODUCT (
    ProductID INTEGER IDENTITY(1,1) PRIMARY KEY, 
    ProdName varchar(50) , 
    ProdTypeID INTEGER FOREIGN KEY REFERENCES tblPRODUCT_TYPE(ProdTypeID) NOT NULL, --[ProdTypeID], 
    Price NUMERIC(7,2), 
    ProdDescr varchar(500) 
)

CREATE TABLE tblEMPLOYEE (
    EmpID INTEGER IDENTITY(1,1) PRIMARY KEY, 
    EmpFname varchar(25) NOT NULL, 
    EmpLname varchar(25) NOT NULL, 
    EmpDOB DATE NULL
)

CREATE TABLE tblORDER (
    OrderID INTEGER IDENTITY(1,1) PRIMARY KEY, 
    OrderDate DATE NULL, 
    CustID INTEGER FOREIGN KEY REFERENCES tblCUSTOMER(CustID) NOT NULL, 
    ProductID INTEGER FOREIGN KEY REFERENCES tblPRODUCT(ProductID) NOT NULL, 
    EmpID INTEGER FOREIGN KEY REFERENCES tblEMPLOYEE(EmpID) NOT NULL, 
    Quantity NUMERIC(7,2)
)

----------------#5  ===POPULATING LOOK UP TABLES with INSERT INTO statements
INSERT INTO tblCUSTOMER(CustFname, CustLname, CustDOB)
VALUES ('William', 'Phan', '08-09-2000'),
('Michael', 'Jordan', '12-17-1967')

INSERT INTO tblPRODUCT_TYPE(ProdTypeName,ProdTypeDescr)
VALUES ('Sports', 'Things related to excercise'), ('School', 'Things related to studying'), ('Lifestyle', 'Things related to everyday life')


INSERT INTO tblPRODUCT(ProdName, ProdTypeID, Price, ProdDescr)
VALUES
('Basketball', (SELECT ProdTypeID FROM tblPRODUCT_TYPE WHERE ProdTypeName = 'Sports'), '23.0', 'A round object that people use to shoot around'), 
('Pencil', (SELECT ProdTypeID FROM tblPRODUCT_TYPE WHERE ProdTypeName = 'School'), '0.99', 'An object that people use to write on'), 
('Notebook', (SELECT ProdTypeID FROM tblPRODUCT_TYPE WHERE ProdTypeName = 'Lifestyle'), '4.99', 'An object that people use to express about')


INSERT INTO tblEMPLOYEE(EmpFname, EmpLname, EmpDOB)
VALUES ('Vincent', 'Nguyen', '01-02-2002'),
('Mandon', 'Gieng', '05-23-1980'),
('Nicole', 'Hernandez', '07-15-1992')

---------#6

--Main stored procedure & 3 nested
--INSERT INTO tblORDER(OrderDate, CustID , ProductID, EmpID, Quantity)

--#Make 3 nested stored procedures

--GetCustomerID (Nested procedure #1)
GO
CREATE OR ALTER PROCEDURE get_customerID
@custFname VARCHAR(25),
@custLname VARCHAR(25),
@custBirthdate DATE,
@customerID INT OUTPUT
AS
SET @customerID = (SELECT CustID 
                    from tblCUSTOMER 
                    WHERE CustFname = @custFname
                    and CustLname = @custLname
                    AND CustDOB = @custBirthdate
                    )
GO 

--GetEmployeeID (Nested procedure #2)
GO
CREATE OR ALTER PROCEDURE get_employeeID
@employeeFname VARCHAR(25),
@employeeLname VARCHAR(25),
@employeeBirthdate DATE,
@employeeID INT OUTPUT
AS
SET @employeeID = (SELECT EmpID 
                    from tblEMPLOYEE 
                    WHERE EmpFname = @employeeFname
                    AND EmpLname =  @employeeLname
                    AND EmpDOB = @employeeBirthdate
                    )
GO 


--GetProductID (Nested procedure #3)
GO
CREATE OR ALTER PROCEDURE get_productID
@productName VARCHAR(50),
@productID INT OUTPUT
AS
SET @productID = (SELECT ProductID 
                    from tblPRODUCT 
                    WHERE ProdName = @productName
                    )
GO 


-------------#7   

--Main stored procedure  
GO
CREATE OR ALTER PROCEDURE insert_newrow_tblORDER
@i_custFname VARCHAR(25),
@i_custLname VARCHAR(25),
@i_custBirthdate DATE,
@i_employeeFname VARCHAR(25),
@i_employeeLname VARCHAR(25),
@i_employeeBirthdate DATE,
@i_OrderDate DATE,
@i_Quantity INT,
@i_productName VARCHAR(50)
AS 
DECLARE @i_customerID INT , @i_employeeID INT, @i_productID INT 

EXECUTE get_customerID
@custFname = @i_custFname,
@custLname = @i_custLname,
@custBirthdate = @i_custBirthdate,
@customerID = @i_customerID OUTPUT


EXECUTE get_employeeID
@employeeFname = @i_employeeFname,
@employeeLname = @i_employeeLname,
@employeeBirthdate = @i_employeeBirthdate,
@employeeID = @i_employeeID OUTPUT

 
EXECUTE get_productID
@productName = @i_productName,
@productID = @i_productID OUTPUT

BEGIN TRANSACTION 
INSERT INTO tblORDER(OrderDate, CustID, ProductID, EmpID, Quantity)
VALUES(@i_OrderDate, @i_customerID, @i_productID, @i_employeeID, @i_Quantity)
COMMIT TRANSACTION 

GO

--executing parameters need to be unique
EXECUTE insert_newrow_tblORDER
@i_custFname = 'William',
@i_custLname = 'Phan',
@i_custBirthdate = '08-09-2000',
@i_employeeFname = 'Vincent',
@i_employeeLname = 'Nguyen',
@i_employeeBirthdate = '01-02-2002',
@i_productName = 'Basketball',
@i_OrderDate = '03-04-2013',
@i_Quantity = 2

--price doesnt distinguish what the product is, name is unique 

SELECT * FROM tblORDER
DELETE FROM tblPRODUCT WHERE ProductID > 3