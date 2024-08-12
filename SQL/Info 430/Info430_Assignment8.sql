/*
CREATE DATABASE 

DROP TABLE tblPET_HOBBY, tblHobby, tblGENDER, tblTEMPERAMENT, tblCOUNTRY, tblPET_TYPE, tblPET
DROP TABLE tblTAG, tblHOBBY_TAG, tblREGION, tblFEE, tblPET_FEE, tblFEE_TYPE
DROP TABLE AllHobbies, CopyPKPetData, PKPetData

TRUNCATE ?

SELECT * FROM RAW_PetData;
SELECT * FROM PKPetData;
SELECT * FROM CopyPKPetData;
*/

USE quanly_Lab3
GO

CREATE TABLE tblPET_TYPE (
    PetTypeID INT IDENTITY(1,1) PRIMARY KEY,
    PetTypeName VARCHAR(50) NOT NULL
);
GO

-- Lab 8
CREATE TABLE tblREGION (
    RegionID INT IDENTITY(1,1) PRIMARY KEY,
    RegionName VARCHAR(50) NOT NULL
);
GO

CREATE TABLE tblCOUNTRY (
    CountryID INT IDENTITY(1,1) PRIMARY KEY,
    CountryName VARCHAR(50) NOT NULL,

    -- Lab 8
    RegionID INT FOREIGN KEY REFERENCES tblREGION(RegionID) NOT NULL
);
GO

CREATE TABLE tblTEMPERAMENT (
    TempID INT IDENTITY(1,1) PRIMARY KEY,
    TempName VARCHAR(50) NOT NULL
);
GO

CREATE TABLE tblGENDER (
    GenderID INT IDENTITY(1,1) PRIMARY KEY,
    GenderName VARCHAR(50) NOT NULL
);
GO

CREATE TABLE tblPET (
    PetID INT IDENTITY(1,1) PRIMARY KEY,
    PetName VARCHAR(50) NOT NULL,
    Cost NUMERIC(8,2) NOT NULL,
    Price NUMERIC(8,2) NOT NULL,
    DOB DATE NULL,
    PetTypeID INT FOREIGN KEY REFERENCES tblPET_TYPE(PetTypeID) NOT NULL,
    TempID INT FOREIGN KEY REFERENCES tblTEMPERAMENT(TempID) NOT NULL,
    CountryID INT FOREIGN KEY REFERENCES tblCOUNTRY(CountryID) NOT NULL,
    GenderID INT FOREIGN KEY REFERENCES tblGENDER(GenderID) NOT NULL
);
GO

CREATE TABLE tblHOBBY (
    HobbyID INT IDENTITY(1,1) PRIMARY KEY,
    HobbyName VARCHAR(50) NOT NULL
);
GO

CREATE TABLE tblPET_HOBBY (
    PetHobbyID INT IDENTITY(1,1) PRIMARY KEY,
    Points NUMERIC(8, 2) NOT NULL,
    PetID INT FOREIGN KEY REFERENCES tblPET(PetID) NOT NULL,
    HobbyID INT FOREIGN KEY REFERENCES tblHOBBY(HobbyID) NOT NULL
);
GO

-- Lab 8
CREATE TABLE tblTAG (
    TagID INT IDENTITY(1,1) PRIMARY KEY,
    TagName VARCHAR(50) NOT NULL
);
GO

CREATE TABLE tblHOBBY_TAG (
    HobbyTagID INT IDENTITY(1,1) PRIMARY KEY,
    HobbyID INT FOREIGN KEY REFERENCES tblHOBBY(HobbyID) NOT NULL,
    TagID INT FOREIGN KEY REFERENCES tblTAG(TagID) NOT NULL
);
GO

CREATE TABLE tblFEE_TYPE (
    FeeTypeID INT IDENTITY(1,1) PRIMARY KEY,
    FeeType VARCHAR(50) NOT NULL
)

CREATE TABLE tblFEE (
    FeeID INT IDENTITY(1,1) PRIMARY KEY,
    FeeName VARCHAR(50) NOT NULL,
    Descr VARCHAR(200) NOT NULL,
    Fee NUMERIC(8,2) NOT NULL,
    FeeTypeID INT FOREIGN KEY REFERENCES tblFEE_TYPE(FeeTypeID) NOT NULL
);
GO

CREATE TABLE tblPET_FEE (
    PetFeeID INT IDENTITY(1,1) PRIMARY KEY,
    (PetID, FeeID) PRIMARY KEY
    PetID INT FOREIGN KEY REFERENCES tblPET(PetID) NOT NULL,
    FeeID INT FOREIGN KEY REFERENCES tblFEE(FeeID) NOT NULL
);
GO

-- Create primary key table
CREATE TABLE PKPetData (
    petPK INT IDENTITY(1,1) PRIMARY KEY,
    PETNAME VARCHAR(250),
    PET_TYPE VARCHAR(250),
    TEMPERAMENT VARCHAR(250),
    COUNTRY VARCHAR(250),
    DATE_BIRTH DATE,
    GENDER VARCHAR(250),
    HOBBY1 VARCHAR(250),
    HOBBY2 VARCHAR(250),
    HOBBY3 VARCHAR(250),
    HOBBY4 VARCHAR(250),
    COST NUMERIC(8,2)
);
GO

-- Clean raw data (scrub null values)
-- Hobby, cost not required?
INSERT INTO PKPetData
    SELECT PETNAME, PET_TYPE, TEMPERAMENT, COUNTRY, DATE_BIRTH, GENDER, HOBBY1, HOBBY2, HOBBY3, HOBBY4, COST
    FROM RAW_PetData
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

-- Create copy of primary key table
CREATE TABLE CopyPKPetData (
    petPK INT IDENTITY(1,1) PRIMARY KEY,
    PETNAME VARCHAR(250),
    PET_TYPE VARCHAR(250),
    TEMPERAMENT VARCHAR(250),
    COUNTRY VARCHAR(250),
    DATE_BIRTH DATE,
    GENDER VARCHAR(250),
    HOBBY1 VARCHAR(250),
    HOBBY2 VARCHAR(250),
    HOBBY3 VARCHAR(250),
    HOBBY4 VARCHAR(250),
    COST NUMERIC(8,2)
);
GO
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

-- Populate look-up tables
INSERT INTO tblPET_TYPE (PetTypeName)
    SELECT DISTINCT PET_TYPE FROM PKPetData;
GO

INSERT INTO tblGENDER (GenderName)
    SELECT DISTINCT GENDER FROM PKPetData;
GO

INSERT INTO tblTEMPERAMENT (TempName)
    SELECT DISTINCT TEMPERAMENT FROM PKPetData;
GO

-- Lab 8
INSERT INTO tblREGION (RegionName)
    VALUES ('Africa'),
           ('Antartica'),
           ('Asia'),
           ('Australia'),
           ('Caribbean'),
           ('Europe'),
           ('North America'),
           ('South America');
GO

INSERT INTO tblCOUNTRY (CountryName, RegionID)
    -- SELECT DISTINCT COUNTRY FROM PKPetData;
    VALUES ('Peru', 8),
           ('Uganda', 1),
           ('Panama', 5),
           ('Jamaica', 1),
           ('United States', 7),
           ('Singapore', 3),
           ('Venezuela', 8),
           ('Vietnam', 3),
           ('Laos', 3),
           ('Japan', 3),
           ('Korea', 3),
           ('Mexico', 7),
           ('Brazil', 8),
           ('Thailand', 3),
           ('Dominican Republic', 5),
           ('Pakistan', 3),
           ('Russia', 6),
           ('Columbia', 8),
           ('Egypt', 1),
           ('Canada', 7),
           ('Malaysia', 3),
           ('Trinidad', 5),
           ('Kenya', 1),
           ('Iceland', 6),
           ('Australia', 4),
           ('France', 6),
           ('Kazakhstan', 3),
           ('Germany', 6),
           ('China', 3),
           ('India', 3),
           ('Haiti', 5);
GO

INSERT INTO tblFEE_TYPE (FeeType)
    VALUES ('Dollar'),
           ('Percent');
GO

INSERT INTO tblFEE (FeeName, Descr, Fee, FeeTypeID)
    VALUES ('Travel Fee', 'Asia', 3.75, 1),
           ('Tax', 'Europe', 11.50, 2),
           ('Insurance', 'Irascible, Defiant, Surly', 23.50, 1),
           ('Luxury Fee', 'Loving, Pleasant, Friendly', 15.00, 1),
           ('Thawing Fee', 'Iceland', 4.25, 1),
           ('Tariff', 'South America', 6.00, 1),
           ('Value Add1', 'Combined Musical Skills >= 40', 20.00, 1),
           ('Value Add2', 'Cooking, Knitting; HomeRepairProjects >= 40', 14.00, 1),
           ('Value Add3', 'Chess, Gaming, Painting, Drawing > 50', 11.00, 1);
GO

CREATE TABLE AllHobbies (
    HobbyName VARCHAR(250)
);
GO

INSERT INTO AllHobbies (HobbyName)
    SELECT DISTINCT HOBBY1 FROM PKPetData;
GO
INSERT INTO AllHobbies (HobbyName)
    SELECT DISTINCT HOBBY2 FROM PKPetData;
GO
INSERT INTO AllHobbies (HobbyName)
    SELECT DISTINCT HOBBY3 FROM PKPetData;
GO
INSERT INTO AllHobbies (HobbyName)
    SELECT DISTINCT HOBBY4 FROM PKPetData;
GO
INSERT INTO tblHOBBY (HobbyName)
    SELECT DISTINCT HobbyName FROM AllHobbies;
GO

DROP TABLE AllHobbies;