/*
SELECT * FROM CopyPKPetData
SELECT * FROM tblPET
SELECT * FROM tblPET_HOBBY
*/

USE quanly_Lab3
GO

-- Create procedures for look-up tables
CREATE PROCEDURE PetTypeGetID
@PT_Name2 VARCHAR(50),
@PT_ID2 INT OUTPUT
AS
SET @PT_ID2 = (SELECT PetTypeID FROM tblPET_TYPE
WHERE PetTypeName = @PT_Name2)
GO

CREATE PROCEDURE GenderGetID
@G_Name2 VARCHAR(50),
@G_ID2 INT OUTPUT
AS
SET @G_ID2 = (SELECT GenderID FROM tblGENDER
WHERE GenderName = @G_Name2)
GO

CREATE PROCEDURE TemperamentGetID
@T_Name2 VARCHAR(50),
@T_ID2 INT OUTPUT
AS
SET @T_ID2 = (SELECT TempID FROM tblTEMPERAMENT
WHERE TempName = @T_Name2)
GO

CREATE PROCEDURE HobbyGetID
@H_Name VARCHAR(50),
@H_ID INT OUTPUT
AS
SET @H_ID = (SELECT HobbyID FROM tblHOBBY
WHERE HobbyName = @H_Name)
GO

CREATE PROCEDURE CountryGetID
@C_Name2 VARCHAR(50),
@C_ID2 INT OUTPUT
AS
SET @C_ID2 = (SELECT CountryID FROM tblCOUNTRY
WHERE CountryName = @C_Name2)
GO

-- Begin repetitive script

-- Declare all named variables
DECLARE
@PetName VARCHAR(50), @Cost NUMERIC(8,2), @DOB DATE,
@PT_Name VARCHAR(50), @G_Name VARCHAR(50), @T_Name VARCHAR(50), @C_Name VARCHAR(50),
@H1_Name VARCHAR(50), @H2_Name VARCHAR(50), @H3_Name VARCHAR(50), @H4_Name VARCHAR(50)

-- Keep track of which ROW/PK we are at (reading/ripping)
-- Data processing
DECLARE @MIN_PK INT

-- Keep track of the while loop
DECLARE @RUN INT = (SELECT COUNT(*) FROM CopyPKPetData)

-- Declare IDs for named variables
DECLARE
@PT_ID INT, @G_ID INT, @T_ID INT, @C_ID INT, @PR_ID INT,
@H1_ID INT, @H2_ID INT, @H3_ID INT, @H4_ID INT, @P_ID INT

WHILE(@RUN > 0)
BEGIN
    SET @MIN_PK = (SELECT MIN(petPK) FROM CopyPKPetData)

-- Populate the name variables from the working copy, the row's PK should be the same as @MIN_PK
    SET @PetName = (SELECT PETNAME FROM CopyPKPetData WHERE petPK = @MIN_PK)
    SET @PT_Name = (SELECT PET_TYPE FROM CopyPKPetData WHERE petPK = @MIN_PK)
    SET @T_Name = (SELECT TEMPERAMENT FROM CopyPKPetData WHERE petPK = @MIN_PK)
    SET @C_Name = (SELECT COUNTRY FROM CopyPKPetData WHERE petPK = @MIN_PK)
    SET @DOB = (SELECT DATE_BIRTH FROM CopyPKPetData WHERE petPK = @MIN_PK)
    SET @G_Name = (SELECT GENDER FROM CopyPKPetData WHERE petPK = @MIN_PK)
    SET @H1_Name = (SELECT HOBBY1 FROM CopyPKPetData WHERE petPK = @MIN_PK)
    SET @H2_Name = (SELECT HOBBY2 FROM CopyPKPetData WHERE petPK = @MIN_PK)
    SET @H3_Name = (SELECT HOBBY3 FROM CopyPKPetData WHERE petPK = @MIN_PK)
    SET @H4_Name = (SELECT HOBBY4 FROM CopyPKPetData WHERE petPK = @MIN_PK)
    SET @Cost = (SELECT COST FROM CopyPKPetData WHERE petPK = @MIN_PK)

-- Calling our stored procedures for obtaining the FK values in tblPET
    EXEC PetTypeGetID
    @PT_Name2 = @PT_Name,
    @PT_ID2 = @PT_ID OUTPUT

    EXEC GenderGetID
    @G_Name2 = @G_Name,
    @G_ID2 = @G_ID OUTPUT 

    EXEC TemperamentGetID
    @T_Name2 = @T_Name,
    @T_ID2 = @T_ID OUTPUT

    EXEC HobbyGetID
    @H_Name = @H1_Name,
    @H_ID = @H1_ID OUTPUT

    EXEC HobbyGetID
    @H_Name = @H2_Name,
    @H_ID = @H2_ID OUTPUT

    EXEC HobbyGetID
    @H_Name = @H3_Name,
    @H_ID = @H3_ID OUTPUT

    EXEC HobbyGetID
    @H_Name = @H4_Name,
    @H_ID = @H4_ID OUTPUT

    EXEC CountryGetID
    @C_Name2 = @C_Name,
    @C_ID2 = @C_ID OUTPUT

    BEGIN TRANSACTION T1
        INSERT INTO tblPET(PetName, Cost, Price, DOB, PetTypeID, TempID, CountryID, GenderID)
        VALUES (@PetName, @Cost, 0, @DOB, @PT_ID, @T_ID, @C_ID, @G_ID)

        -- Get the most-recent Identity value provided by the database within the scope of my transaction)
        SET @P_ID = (SELECT SCOPE_IDENTITY())

        INSERT INTO tblPET_HOBBY(Points, PetID, HobbyID)
        VALUES (38, @P_ID, @H1_ID), (13, @P_ID, @H2_ID), (9, @P_ID, @H3_ID), (1, @P_ID, @H4_ID)

    IF @@ERROR <> 0
        BEGIN
            PRINT 'Something broke during commit'
            ROLLBACK TRANSACTION T1
        END
    ELSE
    COMMIT TRANSACTION T1
DELETE FROM CopyPKPetData WHERE petPK = @MIN_PK
SET @RUN = @RUN - 1
END
GO

-- TEST
INSERT INTO CopyPKPetData
    SELECT PETNAME, PET_TYPE, TEMPERAMENT, COUNTRY, DATE_BIRTH, GENDER, HOBBY1, HOBBY2, HOBBY3, HOBBY4, COST
    FROM PKPetData
    WHERE
    PETNAME IS NOT NULL AND
    PET_TYPE IS NOT NULL AND
    TEMPERAMENT IS NOT NULL AND
    COUNTRY IS NOT NULL AND
    DATE_BIRTH < GETDATE() AND
    GENDER IS NOT NULL AND
    HOBBY1 IS NOT NULL AND
    HOBBY2 IS NOT NULL AND
    HOBBY3 IS NOT NULL AND
    HOBBY4 IS NOT NULL AND
    COST IS NOT NULL;
GO

-- Lab 8
-- SELECT * FROM CopyPKPetData
-- SELECT * FROM tblPET
-- SELECT * FROM tblFEE
-- SELECT * FROM tblPET_FEE
CREATE PROCEDURE uspInsertPET_FEE
@P_Name VARCHAR(50),
@F_Name VARCHAR(50),
@C_Name VARCHAR(50),
@T_Name VARCHAR(50)
AS
DECLARE @P_ID INT, @F_ID INT

DECLARE @MIN_PK INT, @RUN INT = (SELECT COUNT(*) FROM CopyPKPetData)

WHILE(@RUN > 0)
BEGIN
    SET @MIN_PK = (SELECT MIN(petPK) FROM CopyPKPetData)
    
    SET @P_Name = (SELECT PETNAME FROM CopyPKPetData WHERE petPK = @MIN_PK)
    SET @P_ID = (SELECT PetID FROM tblPET WHERE PetName = @P_Name)

    SET @C_Name = (SELECT COUNTRY FROM CopyPKPetData WHERE petPK = @MIN_PK)
    SET @F_ID = (SELECT FeeID FROM tblFEE WHERE Descr = @C_Name)

    SET @T_NAME = (SELECT TEMPERAMENT FROM CopyPKPetData WHERE petPK = @MIN_PK)
    SET @F_ID = (SELECT FeeID FROM tblFEE WHERE Descr LIKE '%@T_Name%')


    


BEGIN TRANSACTION T1
    INSERT INTO tblPET_FEE(PetID, FeeID)
    VALUES (@P_ID, @F_ID)

    IF @@ERROR <> 0
        BEGIN
            PRINT 'Something broke during commit'
            ROLLBACK TRANSACTION T1
        END
    ELSE
    COMMIT TRANSACTION T1
DELETE FROM CopyPKPetData WHERE petPK = @MIN_PK
SET @RUN = @RUN - 1
END
GO

CREATE FUNCTION fn_TotalPrice(@PK INT)
RETURNS NUMERIC(8,2)
AS
BEGIN
    DECLARE @RET NUMERIC(8,2) =
    (SELECT Cost)

