CREATE DATABASE ccura_INFO_330B_Autumn_2022
USE ccura_INFO_330B_Autumn_2022


--tblRESIDENT
CREATE TABLE tblRESIDENT (
    ResidentID INT IDENTITY(1,1) PRIMARY KEY,
    ResidentFName VARCHAR(50),
    ResidentLName VARCHAR(50),
    ResidentBirthDate DATE
)

--tblLEASE
CREATE TABLE tblLEASE (
    LeaseID INT IDENTITY(1,1) PRIMARY KEY,
    LStartDate DATE,
    LEndDate DATE,
    MonthlyPayment CHAR(4),
    ResidentID INT REFERENCES tblRESIDENT(ResidentID),
    UnitID INT REFERENCES tblUNIT(UnitID)
)



--tblLEASE_INCIDENT
CREATE TABLE tblLEASE_INCIDENT(
    LeaseID INT REFERENCES tblLEASE(LeaseID),
    IncidentID INT REFERENCES tblINCIDENT(IncidentID),
    PRIMARY KEY(LeaseID, IncidentID)
)


--tblINCIDENT
CREATE TABLE tblINCIDENT(
    IncidentID INT IDENTITY(1,1) PRIMARY KEY,
    IncidentName VARCHAR(50),
    IncidentDate DATE,
    IncidentAmount VARCHAR(10)
)



--tblUNIT
CREATE TABLE tblUNIT(
    UnitID INT IDENTITY(1,1) PRIMARY KEY,
    UnitNumber CHAR(5),
    BuildingID INT REFERENCES tblBUILDING(BuildingID),
    Unit_TypeID INT REFERENCES tblUNIT_TYPE(Unit_TypeID)
)



--tblBUILDING
CREATE TABLE tblBUILDING (
    BuildingID INT IDENTITY(1,1) PRIMARY KEY,
    BuildingName VARCHAR(50)
)

--tblUNIT_TYPE
CREATE TABLE tblUNIT_TYPE(
    Unit_TypeID INT IDENTITY(1,1) PRIMARY KEY,
    Unit_TypeName VARCHAR(50),
    Unit_TypeBedrooms VARCHAR(20)
)



----Stored Procedures for creating the data inside each table

--tblRESIDENT stored procedure
GO
CREATE OR ALTER PROCEDURE register_resident
@ResidentFirstName VARCHAR(50),
@ResidentLastName VARCHAR(50),
@ResidentBdate DATE
AS
DECLARE @ResidentID INT
SET @ResidentID = (SELECT ResidentID FROM tblRESIDENT
               WHERE ResidentFName = @ResidentFirstName 
               AND ResidentLName = @ResidentLastName
               )

BEGIN TRANSACTION insert_resident
INSERT INTO tblRESIDENT (ResidentFName, ResidentLName, ResidentBirthDate)
VALUES (@ResidentFirstName, @ResidentLastName, @ResidentBdate)
COMMIT TRANSACTION insert_resident
GO

EXECUTE register_resident
    @ResidentFirstName = 'Carlos',
    @ResidentLastName = 'Cura',
    @ResidentBdate = '11-04-2000'

EXECUTE register_resident
    @ResidentFirstName = 'Mia',
    @ResidentLastName = 'Pham',
    @ResidentBdate = '10-25-2002'

EXECUTE register_resident
    @ResidentFirstName = 'Gemmalyn',
    @ResidentLastName = 'Abuan',
    @ResidentBdate = '06-08-2001'

EXECUTE register_resident
    @ResidentFirstName = 'Mason',
    @ResidentLastName = 'Sadang',
    @ResidentBdate = '01-05-2000'

EXECUTE register_resident
    @ResidentFirstName = 'Yussuf',
    @ResidentLastName = 'Mohamad',
    @ResidentBdate = '12-14-2000'


--tblBUILDING stored procedure
GO
CREATE OR ALTER PROCEDURE building_identifier
@buildingName VARCHAR(50)
AS
DECLARE @BuildingID INT
SET @BuildingID = (SELECT BuildingID FROM tblBUILDING
               WHERE BuildingName = @buildingName)

BEGIN TRANSACTION insert_building
INSERT INTO tblBUILDING (BuildingName)
VALUES (@buildingName)
COMMIT TRANSACTION insert_building
GO


EXECUTE building_identifier
    @buildingName = 'Hawkins'

EXECUTE building_identifier
    @buildingName = 'Paccar'

EXECUTE building_identifier
    @buildingName = 'Kane'

EXECUTE building_identifier
    @buildingName = 'Madrona'


SELECT * 
FROM tblRESIDENT r 
INNER JOIN tblUNIT u ON u.ResidentID = r.ResidentID


--tblUNIT_TYPE STORED PROCEDURE
GO
CREATE OR ALTER PROCEDURE unitType_identifier
@UnitTypeName VARCHAR(50),
@UnitTypeBedrooms VARCHAR(20)

AS
DECLARE @UnitID INT
SET @UnitID = (SELECT Unit_TypeID FROM tblUNIT_TYPE
               WHERE Unit_TypeName = @UnitTypeName
               AND Unit_TypeBedrooms = @UnitTypeBedrooms )

BEGIN TRANSACTION insert_unit_type

INSERT INTO tblUNIT_TYPE(Unit_TypeName, Unit_TypeBedrooms)
VALUES (@UnitTypeName, @UnitTypeBedrooms)
COMMIT TRANSACTION insert_unit_type
GO


EXECUTE unitType_identifier
    @UnitTypeName = 'Studio',
    @UnitTypeBedrooms = '1'
    

EXECUTE unitType_identifier
    @UnitTypeName = 'Rail Road',
    @UnitTypeBedrooms = '2'
   


EXECUTE unitType_identifier
    @UnitTypeName = 'Walk Up',
    @UnitTypeBedrooms = '3'
    


EXECUTE unitType_identifier
    @UnitTypeName = 'Loft',
    @UnitTypeBedrooms = '4'


--stored procedure for tblUNIT (3 diff procedures [2 nested and 1 main])

--get nested procedure from building
GO
CREATE OR ALTER PROCEDURE get_buildingID
@buildingName VARCHAR(50),
@buildingID INT OUTPUT
AS
SET @buildingID = (SELECT BuildingID from tblBUILDING WHERE BuildingName = @buildingName)
GO 



--get nested procedure from unit_type
GO
CREATE OR ALTER PROCEDURE get_unittypeID
@UnitTypeName VARCHAR(50),
@UnitTypeBedrooms VARCHAR(20),
@UnitTypeID INT OUTPUT
AS
SET @UnitTypeID = (SELECT Unit_TypeID 
    from tblUNIT_TYPE 
    WHERE Unit_TypeName = @UnitTypeName
    AND Unit_TypeBedrooms = @UnitTypeBedrooms)
GO 

--Main stored procedure for tblUNIT
GO 
CREATE OR ALTER PROCEDURE insert_newrow_tblUNIT
@i_buildingName VARCHAR(50),
@i_UnitTypeName VARCHAR(50),
@i_UnitTypeBedrooms VARCHAR(20),
@i_UnitNumber CHAR(5)
AS 
DECLARE @i_buildingID INT, @i_unittypeid INT
BEGIN TRANSACTION 
EXECUTE get_buildingID
 @buildingName = @i_buildingName ,
 @buildingID = @i_buildingID  OUTPUT

EXECUTE get_unittypeID
 @UnitTypeName = @i_UnitTypeName,
 @UnitTypeBedrooms = @i_UnitTypeBedrooms,
 @UnitTypeID = @i_unittypeid OUTPUT

INSERT INTO tblUNIT (BuildingID, UnitNumber, Unit_TypeID)
VALUES (@i_buildingID, @i_UnitNumber ,@i_unittypeid)
COMMIT TRANSACTION

EXECUTE insert_newrow_tblUNIT
@i_buildingName = 'Hawkins',
@i_UnitTypeName = 'Studio',
@i_UnitTypeBedrooms = '1',
@i_UnitNumber = '215'

EXECUTE insert_newrow_tblUNIT
@i_buildingName = 'Paccar',
@i_UnitTypeName = 'Rail Road',
@i_UnitTypeBedrooms = '2',
@i_UnitNumber = '123'

EXECUTE insert_newrow_tblUNIT
@i_buildingName = 'Kane',
@i_UnitTypeName = 'Walk Up',
@i_UnitTypeBedrooms = '3',
@i_UnitNumber = '343'

EXECUTE insert_newrow_tblUNIT
@i_buildingName = 'Madrona',
@i_UnitTypeName = 'Loft',
@i_UnitTypeBedrooms = '4',
@i_UnitNumber = '589'



--Stored procedures for tblLEASE (3 Procedures [2 Nested, 1 Main])

--Nested Procedure for ResidentID
GO
CREATE OR ALTER PROCEDURE get_ResidentID
@ResidentFName VARCHAR(50),
@ResidentLName VARCHAR(50),
@ResidentBirthDate DATE,
@ResidentID INT OUTPUT
AS
SET @ResidentID = (SELECT ResidentID 
                    FROM tblRESIDENT 
                    WHERE ResidentFName = @ResidentFName
                    AND ResidentLName = @ResidentLName
                    AND ResidentBirthDate = @ResidentBirthDate )
GO 

--Nested procedure for Unit ID
GO
CREATE OR ALTER PROCEDURE get_UnitID
@UnitNumber CHAR(5),
@UnitID INT OUTPUT
AS
SET @UnitID = (SELECT UnitID
                    FROM tblUNIT
                    WHERE UnitNumber = @UnitNumber)
GO 

--Stored procedure for inserting new row into tblLEASE
GO
CREATE OR ALTER PROCEDURE insert_row_tblLEASE 
@i_ResidentFName VARCHAR(50),
@i_ResidentLName VARCHAR(50),
@i_ResidentBirthDate DATE,
@i_UnitNumber CHAR(5),
@i_LStartDate DATE,
@i_LEndDate DATE,
@i_MonthlyPayment CHAR(4)

AS 
DECLARE @i_ResidentID INT, @i_UnitID INT 
BEGIN TRANSACTION

EXECUTE get_ResidentID
@ResidentFName = @i_ResidentFName,
@ResidentLName = @i_ResidentLName ,
@ResidentBirthDate = @i_ResidentBirthDate,
@ResidentID = @i_ResidentID OUTPUT

EXECUTE get_UnitID
@UnitNumber = @i_UnitNumber,
@UnitID = @i_UnitID OUTPUT

INSERT INTO tblLEASE(LStartDate, LEndDate, MonthlyPayment, ResidentID, UnitID)
VALUES(@i_LStartDate, @i_LEndDate, @i_MonthlyPayment, @i_ResidentID, @i_UnitID )
COMMIT TRANSACTION 
GO


EXECUTE insert_row_tblLEASE 
@i_ResidentFName = 'Carlos',
@i_ResidentLName = 'Cura',
@i_ResidentBirthDate = '11-04-2000',
@i_UnitNumber = '215',
@i_LStartDate = '01-04-2017',
@i_LEndDate = '12-01-2017',
@i_MonthlyPayment = '1250'

EXECUTE insert_row_tblLEASE 
@i_ResidentFName = 'Mia',
@i_ResidentLName = 'Pham',
@i_ResidentBirthDate = '10-25-2002',
@i_UnitNumber = '123',
@i_LStartDate = '02-22-2016',
@i_LEndDate = '11-08-2016',
@i_MonthlyPayment = '1500'

EXECUTE insert_row_tblLEASE 
@i_ResidentFName = 'Gemmalyn',
@i_ResidentLName = 'Abuan',
@i_ResidentBirthDate = '06-08-2001',
@i_UnitNumber = '343',
@i_LStartDate = '03-13-2018',
@i_LEndDate = '11-24-2018',
@i_MonthlyPayment = '1750'

EXECUTE insert_row_tblLEASE 
@i_ResidentFName = 'Mason',
@i_ResidentLName = 'Sadang',
@i_ResidentBirthDate = '01-05-2000',
@i_UnitNumber = '589',
@i_LStartDate = '04-17-2019',
@i_LEndDate = '12-27-2019',
@i_MonthlyPayment = '2000'


--tblIncident stored procedure
GO
CREATE OR ALTER PROCEDURE incident_reports
@IncidentName VARCHAR(50),
@IncidentDate DATE,
@IncidentAmount VARCHAR(10)

AS
DECLARE @IncidentID INT
SET @IncidentID = (SELECT IncidentID FROM tblINCIDENT
               WHERE IncidentName = @IncidentName
               AND IncidentAmount = @IncidentAmount
               AND IncidentDate = @IncidentDate  )

BEGIN TRANSACTION insert_Incident

INSERT INTO tblIncident(IncidentName, IncidentAmount, IncidentDate )
VALUES (@IncidentName, @IncidentAmount,@IncidentDate)

COMMIT TRANSACTION  insert_Incident
GO



EXECUTE incident_reports
@IncidentName = 'Fire',
@IncidentDate = '07-25-2016',
@IncidentAmount = '5000'

EXECUTE incident_reports
@IncidentName = 'Car Robbery',
@IncidentDate = '08-13-2017',
@IncidentAmount = '3000'

EXECUTE incident_reports
@IncidentName = 'Dog Attacks',
@IncidentDate = '03-09-2018',
@IncidentAmount = '2500'

EXECUTE incident_reports
@IncidentName = 'Water Leak',
@IncidentDate = '12-23-2019',
@IncidentAmount = '4500'



--Stored procedure for tblLEASE_INCIDENT
--Use IDs from tables linked to bridge table
    --Get 2 ids from the tables connected to the bridge table(lease and incident id)
        --Use these 2 in my INSERT INTO clause due to them linking the tables together at the specificied incident
        --these 2 id's will act as connectors for the bridge tables data
            --Need to get columns from the 2 tables that uniquely link their each respective values to tblLEASE_INCIDENT

--tblLEASE_INCIDENT stored procedure
GO
CREATE OR ALTER PROCEDURE insert_LeaseIncidentTable
    @LStartDate DATE,
    @ResidentFName VARCHAR(50),
    @ResidentLName VARCHAR(50),
    @IncidentDate DATE,
    @IncidentName VARCHAR(50)
AS 
DECLARE @LeaseID INT, @IncidentID INT
BEGIN TRANSACTION 
SET @LeaseID = (SELECT l.LeaseID 
        FROM tblLEASE  l
        INNER JOIN tblRESIDENT r ON r.ResidentID = l.ResidentID
        WHERE LStartDate = @LStartDate
        AND ResidentFName = @ResidentFName
        AND ResidentLName = @ResidentLName
)

SET @IncidentID = (SELECT IncidentID 
                    FROM tblINCIDENT
                    WHERE IncidentDate = @IncidentDate
                    AND IncidentName = @IncidentName
)
INSERT INTO tblLEASE_INCIDENT(LeaseID, IncidentID)
VALUES(@LeaseID, @IncidentID)
COMMIT TRANSACTION
GO 

EXECUTE insert_LeaseIncidentTable
@LStartDate = '2017-01-04',
    @ResidentFName = 'Carlos',
    @ResidentLName = 'Cura', 
    @IncidentDate = '08-13-2017',
    @IncidentName = 'Car Robbery'

EXECUTE insert_LeaseIncidentTable
@LStartDate = '02-22-2016',
    @ResidentFName = 'Mia',
    @ResidentLName = 'Pham', 
    @IncidentDate = '07-25-2016',
    @IncidentName = 'Fire'

EXECUTE insert_LeaseIncidentTable
@LStartDate = '03-13-2018',
    @ResidentFName = 'Gemmalyn',
    @ResidentLName = 'Abuan', 
    @IncidentDate = '03-09-2018',
    @IncidentName = 'Dog Attacks'

EXECUTE insert_LeaseIncidentTable
@LStartDate = '04-17-2019',
    @ResidentFName = 'Mason',
    @ResidentLName = 'Sadang', 
    @IncidentDate = '12-23-2019',
    @IncidentName = 'Water Leak'

--SQL CODE DOWN BELOW

--1)Write the SQL code to create a parameterized report that returns the residents listed as renters based on passing the 
--following: a) BuildingName, b) UnitNumber, and c) Date. For each resident, provide the following information in your report: 
--First Name, Last Name, Unit Number, Building Name, Lease Start Date, Lease End Date. Hint: 
--A parameterized report is just a stored procedure that performs a SELECT based on input parameters. 
GO 
CREATE OR ALTER PROCEDURE ResidentInfo
   @buildingName VARCHAR(50),
   @unitNumber CHAR(5),
   @LstartDate DATE,
   @LendDate DATE
AS
   SELECT ResidentFName, ResidentLName, UnitNumber, BuildingName, LStartDate, LEndDate
   FROM tblLease l
   INNER JOIN tblRESIDENT r ON r.ResidentID = l.ResidentID 
   INNER JOIN tblUNIT u ON u.UnitID = l.UnitID
   INNER JOIN tblBuilding b ON b.BuildingID = u.BuildingID
   INNER JOIN tblUNIT_TYPE ut ON ut.Unit_TypeID = u.Unit_TypeID
    WHERE BuildingName = @buildingName 
    AND UnitNumber = @unitNumber
    AND LStartDate = @LstartDate
    AND LEndDate = @LendDate
GO

EXECUTE ResidentInfo
@buildingName = 'Hawkins',
   @unitNumber = '215',
   @LstartDate ='01-04-2017',
   @LendDate = '12-01-2017'



--2)Write the SQL to CREATE and EXECUTE a stored procedure that uses an explicit transaction to INSERT a new row into the LEASE table 
--when provided the following values: FirstName, LastName, BirthDate, UnitNumber, BuildingName, BeginDate, EndDate, and MonthlyPayment.
-- Write a SELECT statement to confirm that your stored procedure works.

--Nested Procedure for ResidentID
GO
CREATE OR ALTER PROCEDURE get_ResidentID
@ResidentFName VARCHAR(50),
@ResidentLName VARCHAR(50),
@ResidentBirthDate DATE,
@ResidentID INT OUTPUT
AS
SET @ResidentID = (SELECT ResidentID 
                    FROM tblRESIDENT 
                    WHERE ResidentFName = @ResidentFName
                    AND ResidentLName = @ResidentLName
                    AND ResidentBirthDate = @ResidentBirthDate )
GO 

--Nested procedure for Unit ID
GO
CREATE OR ALTER PROCEDURE get_UnitID
@UnitNumber CHAR(5),
@UnitID INT OUTPUT
AS
SET @UnitID = (SELECT UnitID
                    FROM tblUNIT
                    WHERE UnitNumber = @UnitNumber)
GO 

--Main procedure for inserting new row into tblLEASE
GO
CREATE OR ALTER PROCEDURE insert_row_tblLEASE 
@i_ResidentFName VARCHAR(50),
@i_ResidentLName VARCHAR(50),
@i_ResidentBirthDate DATE,
@i_UnitNumber CHAR(5),
@i_LStartDate DATE,
@i_LEndDate DATE,
@i_MonthlyPayment CHAR(4)

AS 
DECLARE @i_ResidentID INT, @i_UnitID INT 
BEGIN TRANSACTION

EXECUTE get_ResidentID
@ResidentFName = @i_ResidentFName,
@ResidentLName = @i_ResidentLName ,
@ResidentBirthDate = @i_ResidentBirthDate,
@ResidentID = @i_ResidentID OUTPUT

EXECUTE get_UnitID
@UnitNumber = @i_UnitNumber,
@UnitID = @i_UnitID OUTPUT

INSERT INTO tblLEASE(LStartDate, LEndDate, MonthlyPayment, ResidentID, UnitID)
VALUES(@i_LStartDate, @i_LEndDate, @i_MonthlyPayment, @i_ResidentID, @i_UnitID )
COMMIT TRANSACTION 
GO


EXECUTE insert_row_tblLEASE 
@i_ResidentFName = 'Yussuf',
@i_ResidentLName = 'Mohamad',
@i_ResidentBirthDate = '12-14-2000',
@i_UnitNumber = '589',
@i_LStartDate = '01-04-2020',
@i_LEndDate = '10-11-2020',
@i_MonthlyPayment = '2250'

--Resident Yussuf has a start date of '01-04-2020' which is in the system
SELECT * FROM tblLEASE WHERE LStartDate = '01-04-2020'



--3)Write the SQL to add a computed column LeaseLengthMonths to tblLEASE that calculates 
--length of each lease in months based on BeginDate and EndDate. Store the values physically in the database.

ALTER TABLE tblLEASE ADD LeaseLengthMonths
AS DATEDIFF(Month, LStartDate, LEndDate) 

SELECT * FROM tblLEASE


--4)Write the SQL code to create a VIEW that returns the list of buildings with at least $20,000 in total value (length of lease x monthly payment) 
--for current leases AND that have had fewer than 3 incidents. 
--Note: You can use the computed column from the previous question to help with this question.

    --Revenue has to be atleast 20,000
    --buildings must have less than 3 incidents


CREATE VIEW ListBuilding AS 
SELECT COUNT(li.LeaseID) as IncidentReport ,b.BuildingID as BuildingIdentifier, b.BuildingName, SUM(LeaseLengthMonths *  MonthlyPayment) AS SumRevenue
FROM tblUNIT u  
INNER JOIN tblBUILDING b ON u.BuildingID = b.BuildingID
INNER JOIN tblLEASE l ON l.UnitID = u.UnitID
INNER JOIN tblLEASE_INCIDENT li ON li.LeaseID = l.UnitID
WHERE GetDate() BETWEEN LStartDate AND LEndDate
GROUP BY b.BuildingID , b.BuildingName
HAVING COUNT(li.LeaseID) < 3 AND SUM(LeaseLengthMonths *  MonthlyPayment) >= 20000 


SELECT * FROM ListBuilding

DROP VIEW ListBuilding

--5)Write the SQL to enforce the following business rule: "No resident younger than 21 can have a lease length of more than one year." 
-- EXECUTE your stored procedure from #2 with parameter values that trigger your check constraint and prevent an INSERT. 
 

CREATE OR ALTER FUNCTION lease_age_registration()
RETURNS INT 
AS
BEGIN
DECLARE @ret INT = 0 
IF EXISTS (
            SELECT *
            FROM tblLEASE l 
            INNER JOIN tblRESIDENT r ON r.ResidentID = l.ResidentID
            WHERE LeaseLengthMonths < 12
            AND r.ResidentBirthDate > (DATEADD(YEAR , -21, getdate()))
)
SET @ret = 1
RETURN @ret
END


ALTER TABLE tblLEASE WITH NOCHECK
ADD CONSTRAINT chk_resident_age
CHECK(dbo.lease_age_registration() = 0)

ALTER TABLE tblLEASE
DROP CONSTRAINT chk_resident_age

--Tried to execute but the lease dates were more than 1 year
EXECUTE insert_row_tblLEASE 
@i_ResidentFName = 'Mia',
@i_ResidentLName = 'Pham',
@i_ResidentBirthDate = '10-25-2002',
@i_UnitNumber = '589',
@i_LStartDate = '01-04-2022',
@i_LEndDate = '10-11-2024',
@i_MonthlyPayment = '2250'