USE group5_Lab4
GO

-- Create stored procedures for table CART
CREATE PROCEDURE GetCustomerID
@C_Fname1 VARCHAR(50),
@C_Lname1 VARCHAR(50),
@C_ID INT OUTPUT
AS
SET @C_ID = (SELECT CustomerID FROM tblCUSTOMER
WHERE Fname = @C_Fname1 AND Lname = @C_Lname1)
GO

CREATE PROCEDURE GetProductID
@P_Name1 VARCHAR(255),
@P_ID INT OUTPUT
AS
SET @P_ID = (SELECT ProductID FROM tblPRODUCT
WHERE ProductName = @P_Name1)
GO

-- Populate table CART, ORDER, and ORDER PRODUCT
DECLARE @C_Fname VARCHAR(50), @C_Lname VARCHAR(50), @C_BirthDate DATE, @P_Name VARCHAR(255), @Q INT, @D DATE, @O_Date DATE
DECLARE @Cust_ID INT, @Prod_ID INT, @O_ID INT

DECLARE @MIN_PK INT
DECLARE @RUN INT = (SELECT COUNT(*) FROM CopyTblCUSTOMER)

SELECT @@TRANCOUNT

WHILE(@RUN > 0)
BEGIN
    SET @MIN_PK = (SELECT MIN(CustomerID) FROM CopyTblCUSTOMER)

    SET @C_Fname = (SELECT Fname FROM CopyTblCUSTOMER WHERE CustomerID = @MIN_PK)
    SET @C_Lname = (SELECT Lname FROM CopyTblCUSTOMER WHERE CustomerID = @MIN_PK)
    SET @C_BirthDate = (SELECT BirthDate FROM CopyTblCUSTOMER WHERE CustomerID = @MIN_PK)
    SET @P_Name = (SELECT ProductName FROM tblPRODUCT WHERE ProductID = FLOOR(RAND() * 5) + 1)
    SET @Q = (SELECT FlOOR(RAND() * 100) + 1)
    SET @D = '2023-10-30'
    
    EXEC GetCustomerID
    @C_Fname1 = @C_Fname,
    @C_Lname1 = @C_Lname,
    @C_ID = @Cust_ID OUTPUT

    EXEC GetProductID
    @P_Name1 = @P_Name,
    @P_ID = @Prod_ID OUTPUT

-- Error-handling
    IF @Cust_ID IS NULL
        BEGIN
            PRINT 'Hey... @Cust_ID is NULL and that is not good'
            RAISERROR ('@Cust_ID cannot be NULL; check spelling', 11,1)
        RETURN
    END

    IF @Prod_ID IS NULL
        BEGIN
            PRINT 'Hey... @Prod_ID is NULL and that is not good'
            RAISERROR ('@Prod_ID cannot be NULL; check spelling', 11,1)
        RETURN
    END

-- Populate table CART
    BEGIN TRAN T1
    INSERT INTO tblCART (CustFname, CustLname, CustBirthDate, ProductName, Quantity, Date,
                        CustomerID, ProductID)
    VALUES (@C_Fname, @C_Lname, @C_BirthDate, @P_Name, @Q, @D, @Cust_ID, @Prod_ID)

    IF @@ERROR <> 0
        BEGIN
            PRINT ('TRAN T1 is terminating due to some error')
            ROLLBACK TRAN T1
        END
    ELSE
        SELECT @@TRANCOUNT
        COMMIT TRAN T1

-- Populate table ORDER and ORDER_PRODUCT
    BEGIN TRAN T2
        INSERT INTO tblORDER (OrderDate, CustomerID)
        VALUES (@D, @Cust_ID)

        SET @O_ID = (SELECT SCOPE_IDENTITY())

        INSERT INTO tblORDER_PRODUCT(Quantity, OrderID, ProductID)
        VALUES (@Q, @O_ID, @Prod_ID)

    IF @@ERROR <> 0
        BEGIN
            PRINT ('TRAN T2 is terminating due to some error')
            ROLLBACK TRAN T2
        END
    ELSE
        SELECT @@TRANCOUNT
        COMMIT TRAN T2
DELETE FROM CopyTblCUSTOMER WHERE CustomerID = @MIN_PK
SET @RUN = @RUN - 1
END
GO
-- SELECT * FROM tblCART
-- SELECT * FROM tblORDER
-- SELECT * FROM tblORDER_PRODUCT