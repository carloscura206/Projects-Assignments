USE UNIVERSITY

USE spotify_Group5

--tblCUSTOMER SPROC  (SYNTHETHIC TRANSACTION FOR tblCUSTOMER IS DOWN BELOW)

SELECT * FROM tblCUSTOMER

-- Get 2 nested ID's
GO
CREATE OR ALTER PROCEDURE get_CustTypeID
@CustomerTypeName varchar(50),
@CustTypeID INT OUTPUT
AS
SET @CustTypeID = (SELECT CustomerType_ID
                            FROM tblCUSTOMER_TYPE
                            WHERE CustomerTypeName = @CustomerTypeName)

GO

SELECT * FROM tblCUSTOMER_TYPE

GO

CREATE OR ALTER PROCEDURE get_CountryID
@CountryName varchar(50),
@CountryID INT OUTPUT
AS
SET @CountryID = (SELECT Country_ID
                            FROM tblCOUNTRY 
                            WHERE Name = @CountryName)

GO


--Main Stored Procedure
GO
CREATE OR ALTER PROCEDURE insert_newrow_tblCUSTOMER
@i_CountryName varchar(50),
@i_CustTypeName VARCHAR(50),
@i_FirstName VARCHAR(50),
@i_LastName VARCHAR(50),
@i_UserName varchar(50)
AS 
DECLARE @i_CustTypeID INT, @i_CountryID INT 



EXECUTE get_CustTypeID
@CustomerTypeName = @i_CustTypeName,
@CustTypeID = @i_CustTypeID OUTPUT

IF @i_CustTypeID is NULL 
    BEGIN 
        PRINT '@i_CustTypeID is empty...check spelling';
        THROW 54321, '@i_CustTypeID CANNOT BE NULL, process is terminating', 1;
    END 


EXECUTE get_CountryID
@CountryName = @i_CountryName,
@CountryID = @i_CountryID OUTPUT

IF @i_CountryID is NULL 
    BEGIN 
        PRINT '@i_CountryID is empty...check spelling';
        THROW 54321, '@i_CountryID CANNOT BE NULL, process is terminating', 1;
    END 




BEGIN TRANSACTION G1
INSERT INTO tblCUSTOMER(FirstName, LastName, UserName, CustomerTypeID, CountryID)
VALUES (@i_FirstName, @i_LastName, @i_UserName, @i_CustTypeID, @i_CountryID)
IF @@ERROR <> 0
    BEGIN
        PRINT 'Something broke during commit'
        ROLLBACK TRANSACTION G1
    END
ELSE
    COMMIT TRANSACTION G1
GO
-- example execution of the stored procedure
EXECUTE insert_newrow_tblCUSTOMER
@i_CustTypeName = 'Premium',
@i_CountryName = 'America',
@i_FirstName = 'Carlos',
@i_LastName = 'Cura',
@i_UserName = 'Los206'


------------------SYNTHETHIC TRANSACTION FOR TBLCUSTOMER!!!!!!

-- EXEC wrapper_uspINSERT_ClassList 100


GO


CREATE PROCEDURE wrapper_insert_newrow_tblCUSTOMER
@RUN INT
AS
DECLARE @CustomerTypey varchar(50),@CountryNamey varchar(50), @Firsty varchar(50) = 'Carlos' , @Lasty varchar(50) = 'Cura', @Usery varchar(50) = 'Los206'

DECLARE @C_PK INT, @CT_PK INT
DECLARE @CustomerType_Count INT = (SELECT COUNT(*) FROM tblCUSTOMER_TYPE)
DECLARE @Country_Count INT = (SELECT COUNT(*) FROM tblCOUNTRY)
DECLARE @FirstyFigure VARCHAR(10)
DECLARE @LastyFigure VARCHAR(10)
DECLARE @UseryFigure VARCHAR(10)
DECLARE @FirstyFull VARCHAR(50)
DECLARE @LastyFull VARCHAR(50)
DECLARE @UseryFull VARCHAR(50)

-- use the @RUN parameter to control the number of iterations or cycles of WHILE loop
WHILE @Run > 0
BEGIN

SET @FirstyFigure = (SELECT RAND() * 10000)
SET @LastyFigure = (SELECT RAND() * 10000)
SET @UseryFigure = (SELECT RAND() * 10000)

SET @C_PK = (SELECT RAND() * @Country_Count + 1) 
SET @CT_PK = (SELECT RAND() * @Country_Count + 1)
SET @CountryNamey = (SELECT Name FROM tblCOUNTRY WHERE Country_ID = @C_PK)
SET @CustomerTypey = (SELECT CustomerTypeName FROM tblCUSTOMER_TYPE WHERE CustomerType_ID = @CT_PK)
SET @Firsty = (SELECT CustomerTypeName FROM tblCUSTOMER_TYPE WHERE CustomerType_ID = @CT_PK)
SET @Lasty = (SELECT CustomerTypeName FROM tblCUSTOMER_TYPE WHERE CustomerType_ID = @CT_PK)
SET @Usery = (SELECT CustomerTypeName FROM tblCUSTOMER_TYPE WHERE CustomerType_ID = @CT_PK)

SET @FirstyFull = @FirstyFigure + @Firsty
SET @LastyFull = @Lasty + @LastyFull
SET @UseryFull = @Usery + @UseryFigure



EXECUTE insert_newrow_tblCUSTOMER
@i_CustTypeName =  @CustomerTypey,
@i_CountryName = @CountryNamey,
@i_FirstName = @FirstyFull,
@i_LastName = @LastyFull,
@i_UserName = @UseryFull

SET @RUN = @RUN - 1

END


EXEC wrapper_insert_newrow_tblCUSTOMER 2






------------------SPROC FOR tblRECORD  (SYNTHETHIC TRANSACTION FOR TBLRECORDING IS DOWN BELOW!!!)
-- Get 2 nested ID's
GO
CREATE OR ALTER PROCEDURE get_GenreID
@GenreName varchar(50),
@GenreID INT OUTPUT
AS
SET @GenreID = (SELECT Genre_ID
                            FROM tblGENRE
                            WHERE GenreName = @GenreName)

GO

GO

CREATE OR ALTER PROCEDURE get_RecordingTypeID
@RecordingTypeName varchar(50),
@RecordingTypeID INT OUTPUT
AS
SET @RecordingTypeID = (SELECT RecordingType_ID
                            FROM tblRECORDING_TYPE
                            WHERE RecordingTypeName = @RecordingTypeName)

GO


--Main Stored Procedure
GO
CREATE OR ALTER PROCEDURE insert_newrow_tblRECORDING
@i_GenreName varchar(50),
@i_RecordingTypeName varchar(50),
@i_AudioTitleName VARCHAR(50), 
@i_Duration TIME(7)
AS 
DECLARE @i_GenreID INT, @i_RecordingTypeID INT 

EXECUTE get_GenreID
@GenreName = @i_GenreName,
@GenreID = @i_GenreID OUTPUT
IF @i_GenreID is NULL 
    BEGIN 
        PRINT '@i_GenreID is empty...check spelling';
        THROW 54321, '@i_GenreID CANNOT BE NULL, process is terminating', 1;
    END 

EXECUTE get_RecordingTypeID
@RecordingTypeName = @i_RecordingTypeName,
@RecordingTypeID = @i_RecordingTypeID OUTPUT
IF @i_RecordingTypeID is NULL 
    BEGIN 
        PRINT '@i_RecordingTypeID is empty...check spelling';
        THROW 54321, '@i_RecordingTypeID CANNOT BE NULL, process is terminating', 1;
    END 

BEGIN TRANSACTION G2
INSERT INTO tblRECORDING(Title, Duration, Genre_ID, RecordingType_ID)
VALUES (@i_AudioTitleName, @i_Duration, @i_GenreName, @i_RecordingTypeName)
IF @@ERROR <> 0
    BEGIN
        PRINT 'Something broke during commit'
        ROLLBACK TRANSACTION G2
    END
ELSE
    COMMIT TRANSACTION G2
GO


EXECUTE insert_newrow_tblRECORDING
@i_Duration = '00:04:00',
@i_GenreName = 'R&B',
@i_AudioTitleName = 'Can We Talk',
@i_RecordingTypeName = 'Song'





-------------------------------------------------SYNTHETHIC TRANSACTION #2 FOR TBLRECORDING!!
GO
CREATE PROCEDURE wrapper_insert_newrow_tblRECORDING
@RUN INT
AS
DECLARE @genre_namey varchar(50),@record_typey varchar(50), @Durationey TIME(7) , @AudioTitleNamey VARCHAR(50) = 'Can We Talk'

DECLARE @G_PK INT, @RT_PK INT, @A_PK INT
DECLARE @RecordingType_Count INT = (SELECT COUNT(*) FROM tblRECORDING_TYPE)
DECLARE @Genre_Count INT = (SELECT COUNT(*) FROM tblGENRE)
DECLARE @Artist_Count INT = (SELECT COUNT(*) FROM tblARTIST)
-- use the @RUN parameter to control the number of iterations or cycles of WHILE loop
WHILE @Run > 0
BEGIN

SET @G_PK = (SELECT RAND() * @Genre_Count + 1) 
SET @RT_PK = (SELECT RAND() * @RecordingType_Count + 1)
SET @genre_namey = (SELECT GenreName FROM tblGENRE WHERE Genre_ID = @G_PK)
SET @record_typey = (SELECT RecordingTypeName FROM tblRECORDING_TYPE WHERE RecordingType_ID = @RT_PK)
SET @Durationey = (SELECT RAND())


EXEC insert_newrow_tblRECORDING
@i_GenreName = @genre_namey,
@i_RecordingTypeName = @record_typey,
@i_Duration = @Durationey,
@i_AudioTitleName = @AudioTitleNamey

SET @RUN = @RUN - 1

END

EXEC wrapper_insert_newrow_tblRECORDING 2