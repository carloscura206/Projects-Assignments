USE UNIVERSITY

--1)Write the SQL to INSERT a new row into tblSTAFF_POSITION, using three nested "getid" stored procedures and one main stored procedure that executes the other three. 
--Pass the following input values: the staff member's first and last name, the staff member's birthdate, the name of the position, the department the position is in, and a begin and end date. 
--To fetch foreign keys in your nested "getid" stored procedures, use real values from tblSTAFF and tblPOSITION, and tblDEPARTMENT for the staff member's name and birthdate, the position, and the department. 
--You can choose any begin and end date. No TRY and CATCH error-handling required, but use an explicit transactions in the main stored procedure. Write a SELECT statement to confirm that your INSERT worked.

--1ST Stored procedure
GO
CREATE OR ALTER PROCEDURE get_staffID 
@staffsFname VARCHAR(60),
@staffsLname VARCHAR(60),
@staffBirthday DATE,
@staffID INT OUTPUT
AS
SET @staffID = (SELECT StaffID FROM tblSTAFF
                WHERE StaffFName = @staffsFname 
                AND StaffLName = @staffsLname 
                AND StaffBirth = @staffBirthday 
                )
GO 

--2nd Stored Procedure
GO 
CREATE OR ALTER PROCEDURE get_positionID 
@positionName VARCHAR(50),
@positionID INT OUTPUT
AS 
SET @positionID = (SELECT PositionID FROM tblPOSITION
                    WHERE PositionName = @positionName)
GO 

--3rd Stored Procedure
GO
CREATE OR ALTER PROCEDURE get_departmentID
@deptName VARCHAR(75),
@departmentID INT OUTPUT
AS 
SET @departmentID = (SELECT DeptID FROM tblDEPARTMENT
                    WHERE DeptName = @deptName)
GO 


--Main procedure
GO 
CREATE OR ALTER PROCEDURE insert_newrow_staffposition
@i_staffsFname VARCHAR(60),
@i_staffsLname VARCHAR(60),
@i_staffBirthday DATE,
@i_positionName VARCHAR(50),
@i_deptName VARCHAR(75),
@Bdate DATETIME,
@Edate DATETIME

AS 
DECLARE @i_staffid INT, @i_positionid INT, @i_deptid INT 
BEGIN TRANSACTION 

EXECUTE get_staffid
 @staffsFname = @i_staffsFname ,
 @staffsLname = @i_staffsLname,
 @staffBirthday = @i_staffBirthday,
 @staffID = @i_staffid OUTPUT

EXECUTE get_positionid 
 @positionName = @i_positionName,
 @positionID = @i_positionid OUTPUT

EXECUTE get_departmentID
 @deptName = @i_deptName, 
 @departmentID = @i_deptid OUTPUT

INSERT INTO tblSTAFF_POSITION (StaffID, PositionID, BeginDate, EndDate, DeptID)
VALUES (@i_staffid,  @i_positionid , @Bdate, @Edate , @i_deptid)
COMMIT TRANSACTION


EXECUTE insert_newrow_staffposition
@i_staffsFname = 'Neville',
@i_staffsLname = 'Pieri',
@i_staffBirthday = '1943-08-02',
@i_positionName = 'Administrative-Assistant',
@i_deptName = 'American Ethnic Studies',
@Bdate = '1980-03-21',
@Edate = '1984-07-25';

SELECT * FROM tblSTAFF WHERE StaffLName = 'Pieri'

--I applied neville's position as an Administrative-Assistant which is a positionID of 1
SELECT * FROM tblSTAFF_POSITION WHERE StaffID = 1





--2)Write the SQL to create a stored procedure that updates a row into tblSTAFF_POSITION by modifying the endDate for the row. 
--Pass five parameters @PositionName, @StaffFName, @StaffLname, @StaffBirth, @EndDate. 
--Use variables to capture FK values as needed using the same nested 'GetID' stored procedures from the previous question. 
--Write the code to EXECUTE your stored procedure and write a SELECT statement to confirm that your stored procedure worked.
GO
CREATE OR ALTER PROCEDURE CCStaffPosition
@i_staffsFname VARCHAR(60),
@i_staffsLname VARCHAR(60),
@i_staffBirthday DATE,
@i_positionName VARCHAR(50),
@i_deptName VARCHAR(75),
@i_Bdate DATETIME,
@i_Edate DATETIME

AS 
DECLARE @i_staffid INT, @i_positionid INT, @i_deptid INT 


EXECUTE get_staffid
 @staffsFname = @i_staffsFname ,
 @staffsLname = @i_staffsLname,
 @staffBirthday = @i_staffBirthday,
 @staffID = @i_staffid OUTPUT

EXECUTE get_positionid 
 @positionName = @i_positionName,
 @positionID = @i_positionid OUTPUT

EXECUTE get_departmentID
 @deptName = @i_deptName, 
 @departmentID = @i_deptid OUTPUT

BEGIN TRANSACTION CCuspUpdateStaffPositionRow
UPDATE tblSTAFF_POSITION
    SET EndDate = @i_Edate
    WHERE StaffID = @i_staffid AND
    PositionID = @i_positionid AND
    DeptID = @i_deptid

COMMIT TRANSACTION CCuspUpdateStaffPositionRow
GO


EXECUTE CCStaffPosition
@i_staffsFname = 'Carmina',
@i_staffsLname = 'Sicola',
@i_staffBirthday = '1992-01-04',
@i_positionName = 'Resident Advisor',
@i_deptName = 'Bioresource and Science Engineering',
@i_Bdate = '1980-03-21',
@i_Edate = '2000-11-05';

--Down below is my code for finding carmina sicola and her information, 
-- the 1st code below will designate that I changed her Enddate

SELECT * FROM tblSTAFF_POSITION WHERE StaffID = 41
SELECT * FROM tblSTAFF WHERE StaffLName = 'Sicola'
SELECT * FROM tblSTAFF_POSITION WHERE StaffID = 41
SELECT * FROM tblDEPARTMENT WHERE DeptID = 102


--3)Write the SQL to determine which instructors have taught at least 3 classes in Johnson Hall before 2005 
--who also…taught more than 25 credits of classes held in buildings located on Stevens Way after 2003.


--Split the question into 2 secitons (2 subquiries)
    --1st section (instructor and classes) (REFERENCE CODE FOR 1ST HALF OF QUESTION ONLY)
        --Write the SQL to determine which instructors have taught at least 3 classes in Johnson Hall before 2005 
            --SELECT i.InstructorFName, i.InstructorLName, i.InstructorID, COUNT(ic.ClassID) as NumClassesTaught
            --FROM tblINSTRUCTOR i
            --INNER JOIN tblINSTRUCTOR_CLASS ic ON ic.InstructorID = i.InstructorID
            --INNER JOIN tblCLASS c ON c.ClassID = ic.ClassID
            --WHERE c.[YEAR] > 2005 
            --GROUP BY i.InstructorFName, i.InstructorLName, i.InstructorID
            --HAVING COUNT(ic.ClassID) >= 3
     
    --2nd section (taught more than 25 credits located in stevesn way) (REFERENCE CODE FOR 2ND HALF OF QUESTION)
        --taught more than 25 credits of classes held in buildings located on Stevens Way after 2003.
            --SELECT i.InstructorFName, i.InstructorLName, i.InstructorID, SUM(co.Credits) as TotalCreditsEarned
            --FROM tblINSTRUCTOR i
            --INNER JOIN tblINSTRUCTOR_CLASS ic ON ic.InstructorID = i.InstructorID
            --INNER JOIN tblCLASS c ON c.ClassID = ic.ClassID
            --INNER JOIN tblCOURSE co ON co.CourseID = c.CourseID
            --INNER JOIN tblCLASSROOM cr ON cr.ClassroomID = c.ClassroomID
            --INNER JOIN tblBUILDING b ON b.BuildingID = cr.BuildingID
            --INNER JOIN tblLOCATION l on l.LocationID = b.LocationID
            --WHERE c.[YEAR] > 2003 AND l.LocationName = 'Stevens Way'
            --GROUP BY i.InstructorFName, i.InstructorLName, i.InstructorID
            --HAVING SUM(co.Credits) > 25
   
--Intersect (Combine by instructorID) [COMPLETE CODE FOR QUESTION #3]
SELECT A.InstructorFName, A.InstructorLName, A.InstructorID, A.NumClassesTaught, B.TotalCreditsEarned
FROM 
(
    SELECT i.InstructorFName, i.InstructorLName, i.InstructorID, COUNT(ic.ClassID) as NumClassesTaught
        FROM tblINSTRUCTOR i
        INNER JOIN tblINSTRUCTOR_CLASS ic ON ic.InstructorID = i.InstructorID
        INNER JOIN tblCLASS c ON c.ClassID = ic.ClassID
        INNER JOIN tblCLASSROOM cr ON cr.ClassroomID = c.ClassroomID
        INNER JOIN tblBUILDING b ON b.BuildingID = cr.BuildingID
        WHERE c.[YEAR] < 2005 AND b.BuildingName = 'Johnson Hall'
        GROUP BY i.InstructorFName, i.InstructorLName, i.InstructorID
        HAVING COUNT(ic.ClassID) >= 3
) A,
(
   SELECT i.InstructorFName, i.InstructorLName, i.InstructorID, SUM(co.Credits) as TotalCreditsEarned
        FROM tblINSTRUCTOR i
        INNER JOIN tblINSTRUCTOR_CLASS ic ON ic.InstructorID = i.InstructorID
        INNER JOIN tblCLASS c ON c.ClassID = ic.ClassID
        INNER JOIN tblCOURSE co ON co.CourseID = c.CourseID
        INNER JOIN tblCLASSROOM cr ON cr.ClassroomID = c.ClassroomID
        INNER JOIN tblBUILDING b ON b.BuildingID = cr.BuildingID
        INNER JOIN tblLOCATION l on l.LocationID = b.LocationID
        WHERE c.[YEAR] > 2003 AND l.LocationName = 'Stevens Way'
        GROUP BY i.InstructorFName, i.InstructorLName, i.InstructorID
        HAVING SUM(co.Credits) > 25  
) B
WHERE A.InstructorID = B.InstructorID





--4)Write the SQL to determine which courses have been delivered in ClassroomType 'auditorium' in buildings located on West Campus at least 2 times since 1995 that 
--also...received over $1 million in registration fees before 2012.

--Split the question into 2 sections (2 subqueires)
    --1st section (classroom types) (REFERENCE CODE FOR 1ST HALF OF QUESTION ONLY)
    --Write the SQL to determine which courses have been delivered in ClassroomType 'auditorium' in buildings located on West Campus at least 2 times since 1995 
        --SELECT COUNT(c.CourseID) as ClassesInWestCampus, co.CourseName, co.CourseID
        --FROM tblCOURSE co
        --INNER JOIN tblCLASS c ON c.CourseID = co.CourseID
        --INNER JOIN tblCLASSROOM cl ON cl.ClassroomID = c.ClassroomID
        --INNER JOIN tblCLASSROOM_TYPE ct ON ct.ClassroomTypeID = cl.ClassroomTypeID
        --INNER JOIN tblBUILDING b ON b.BuildingID = cl.BuildingID
        --INNER JOIN tblLOCATION l ON l.LocationID = b.LocationID
        --WHERE c.[YEAR] >= '1995' AND ct.ClassroomTypeName = 'Auditorium' AND l.LocationName = 'West Campus'
        --GROUP BY co.CourseID, co.CourseName
        --HAVING COUNT(c.CourseID) >= 2
  

    --2nd section (receing iover 1 million dollars) (REFERENCE CODE FOR 2ND HALF OF QUESTION)
    --received over $1 million in registration fees before 2012.
        --SELECT SUM(cl.RegistrationFee) as RegistrationFee, co.CourseName , co.CourseID
        --FROM tblCLASS_LIST cl
        --INNER JOIN tblClass c ON c.ClassID = cl.ClassID
        --INNER JOIN tblCOURSE co ON co.CourseID = c.CourseID
        --WHERE c.[YEAR] <= 2012
        --GROUP BY co.CourseID, co.CourseName
        --HAVING SUM(cl.RegistrationFee) >= 1000000
        --ORDER BY RegistrationFee DESC



--Combine each query by the class ID [COMPLETE CODE FOR QUESTION #4]
SELECT A.CourseName, A.CourseID, A.ClassesInWestCampus, B.RegistrationFee
FROM
    (
        SELECT COUNT(co.CourseID) as ClassesInWestCampus, co.CourseName, co.CourseID
        FROM tblCOURSE co
        INNER JOIN tblCLASS c ON c.CourseID = co.CourseID
        INNER JOIN tblCLASSROOM cl ON cl.ClassroomID = c.ClassroomID
        INNER JOIN tblCLASSROOM_TYPE ct ON ct.ClassroomTypeID = cl.ClassroomTypeID
        INNER JOIN tblBUILDING b ON b.BuildingID = cl.BuildingID
        INNER JOIN tblLOCATION l ON l.LocationID = b.LocationID
        WHERE c.[YEAR] >= '1995' AND ct.ClassroomTypeName = 'Auditorium' AND l.LocationName = 'West Campus'
        GROUP BY co.CourseID, co.CourseName
        HAVING COUNT(co.CourseID) >= 2  
    ) A,

    (
        SELECT SUM(cl.RegistrationFee) as RegistrationFee, co.CourseName , co.CourseID
        FROM tblCLASS_LIST cl
        INNER JOIN tblClass c ON c.ClassID = cl.ClassID
        INNER JOIN tblCOURSE co ON co.CourseID = c.CourseID
        WHERE c.[YEAR] <= 2012
        GROUP BY co.CourseID, co.CourseName
        HAVING SUM(cl.RegistrationFee) >= 1000000

   
    ) B
WHERE A.CourseID = B.CourseID
ORDER BY B.RegistrationFee


--5)Write the SQL to create a stored procedure to insert a new row into tblOFFICE. Pass three parameters @BuildingName, @OfficeTypeName and @OfficeName (such as 'MGH370'). 
--Use two nested stored procedures to obtain foreign key values. No error-handling, but use an explicit transaction. 
--Write the code to EXECUTE your stored procedure and write a SELECT statement to confirm that your stored procedure worked.

GO 
CREATE OR ALTER PROCEDURE ch_get_officetypeid 
@officetypename VARCHAR (50),
@officetypeid INT OUTPUT
AS 
SET @officetypeid = ( SELECT OfficeTypeID 
                        FROM tblOFFICE_TYPE
                        WHERE OfficeTypeName = @officetypename
                        )

GO 

CREATE OR ALTER PROCEDURE ch_get_buildingid 
@buildingname VARCHAR(125),
@buildingid INT OUTPUT 
AS 
SET @buildingid = (SELECT BuildingID FROM tblBUILDING
                    WHERE BuildingName = @buildingname)
GO 


CREATE OR ALTER PROCEDURE ch_insert_office 
@iofficetypename VARCHAR(50),
@ibuildingname VARCHAR(125),
@iofficename VARCHAR(50)
AS

DECLARE @iofficetypeid INT, @ibuildingid INT 
    
    BEGIN TRANSACTION

    EXECUTE ch_get_officetypeid
    @officetypename = @iofficetypename,
    @officetypeid = @iofficetypeid OUTPUT

    EXECUTE ch_get_buildingid
    @buildingname = @ibuildingname,
    @buildingid = @ibuildingid

    INSERT tblOFFICE
    VALUES(@iofficename, @iofficetypeid, @ibuildingid)
    COMMIT TRANSACTION
GO

EXECUTE ch_insert_office
@iofficetypename = 'Executive Suite',
@ibuildingname = 'Mary Gates Hall',
@iofficename = 'MGH370'




GO

CREATE OR ALTER PROCEDURE kzw_getOfficeTypeID
@OfficeTypeName VARCHAR(40),
@OfficeTypeID INT OUTPUT
AS
SET @OfficeTypeID = (SELECT OfficeTypeID FROM tblOFFICE_TYPE
WHERE OfficeTypeName = @OfficeTypeName)
 

GO
-- small stored procedure to get BuildingID
CREATE OR ALTER PROCEDURE kzw_getBuildingID
@BuildingName VARCHAR(40),
@BuildingID INT OUTPUT
AS
SET @BuildingID = (SELECT BuildingID FROM tblBUILDING
WHERE BuildingName = @BuildingName)
GO
 

-- main stored procedure (3 input parameters, 2 variables)
CREATE OR ALTER PROCEDURE kzw_INSERT_into_tblOFFICE
@i_officename VARCHAR(40),
@i_OfficeTypeName VARCHAR(40),
@i_BuildingName VARCHAR(40)
AS
DECLARE @i_OT_ID INT, @i_B_ID INT
 

EXEC kzw_getBuildingID
@BuildingName = @i_BuildingName,
@BuildingID = @i_B_ID OUTPUT
 

EXEC kzw_getOfficeTypeID
@OfficeTypeName = @i_OfficeTypeName,
@OfficeTypeID = @i_OT_ID OUTPUT
 

BEGIN TRAN T1
INSERT INTO tblOFFICE (OfficeName, OfficeTypeID, BuildingID)
VALUES (@i_officename, @i_OT_ID, @i_B_ID)
COMMIT TRAN T1
 

GO
 

EXEC kzw_INSERT_into_tblOFFICE
@i_officename = 'DEN396H', -- decide ourself, a new office name
@i_OfficeTypeName = 'Single Staff', -- real value from tblOFFICE_TYPE, officetypeID is 2 for Single Staff
@i_BuildingName = 'Denny Hall' -- real value from tblBUILDING, BuildingID is 25 for Denny Hall
-- Confirm that we inserted our new row

SELECT *
FROM tblOFFICE o
JOIN tblBUILDING b ON o.BuildingID = b.BuildingID
JOIN tblOFFICE_TYPE ot ON o.OfficeTypeID = ot.OfficeTypeID
WHERE b.BuildingName = 'Denny Hall'
AND ot.OfficeTypeName = 'Single Staff'



--6)Write the SQL for a stored procedure to insert a new row into tblCLASSROOM. Pass 3 parameters @BuildingName, @ClassroomName, @ClassroomTypeName and call two nested stored procedures to obtain foreign key values. No error-handling, but use an explicit transaction. Write the code to EXECUTE your stored procedure and write a SELECT statement to confirm that your stored procedure worked.


GO
--1nd stored procedure (BuildingID)
CREATE OR ALTER PROCEDURE kzw_getBuildingID
@BuildingName VARCHAR(40),
@BuildingID INT OUTPUT
AS
SET @BuildingID = (SELECT BuildingID FROM tblBUILDING
WHERE BuildingName = @BuildingName)
GO

--2nd stored procedure (Retrieving classroomtypeID)
GO 
CREATE OR ALTER PROCEDURE get_Classroom_Type_ID 
@classroomTypeName VARCHAR(125),
@classroomtypeID INT OUTPUT
AS 
SET @classroomtypeID = (
    SELECT ClassroomTypeID
    FROM tblCLASSROOM_TYPE
    WHERE ClassroomTypeName = @classroomTypeName
)
GO

--Main Procedure

GO
CREATE OR ALTER PROCEDURE uspInsertRowClassroom
@i_classroomName VARCHAR(125),
@i_buildingnamesake VARCHAR(125),
@i_@classroomTypeName VARCHAR(125)
AS  
DECLARE @i_buildid INT, @i_classroomtypeid INT 
BEGIN TRANSACTION 



--building id execution
EXECUTE ch_get_buildingid 
@BuildingName = @i_buildingnamesake,
@BuildingID = @i_buildid OUTPUT


--classroomtype id execution
EXECUTE get_Classroom_Type_ID 
 @classroomTypeName = @i_@classroomTypeName,
 @classroomtypeID = @i_classroomtypeid OUTPUT


INSERT INTO tblCLASSROOM (ClassroomName, BuildingID, ClassroomTypeID)
VALUES (@i_classroomName,  @i_buildid , @i_classroomtypeid)
COMMIT TRANSACTION

EXECUTE uspInsertRowClassroom
@i_buildingnamesake = 'Bagley Hall',
@i_classroomName = 'CSE142',
@i_@classroomTypeName = 'Standard Classroom';

--Added cse 142 to bagley hall while stationed in a standard classroom capacity
SELECT * FROM tblCLASSROOM WHERE ClassroomName = 'CSE142' AND BuildingID = 4


--7)Write the SQL to enforce the following business rule 
--"No Student with the last name beginning with letter 'H' who has a permanent state of residence of 'California, CA' 
--may register for any 400-level course from the Information School in any summer quarter after 2021." 
--Hint: Do not forget to ALTER table to cement the function on the appropriate table!


GO

CREATE OR ALTER FUNCTION residency_registration()
RETURNS INT 
AS
BEGIN
DECLARE @ret INT = 0 
IF EXISTS (
            SELECT *
            FROM tblSTUDENT s
            INNER JOIN tblCLASS_LIST cl ON cl.StudentID = s.StudentID
            INNER JOIN tblCLASS c ON c.ClassID = cl.ClassID
            INNER JOIN tblQUARTER q on q.QuarterID = cl.ClassID
            INNER JOIN tblCOURSE co ON co.CourseID = c.CourseID
            INNER JOIN tblDEPARTMENT d ON d.DeptID = co.DeptID
            INNER JOIN tblCOLLEGE college ON college.CollegeID = d.CollegeID
            WHERE s.StudentLname LIKE 'H%'
                AND s.StudentPermState = 'California, CA'
                AND q.QuarterName = 'Summer'
                AND c.[YEAR] > 2021
                AND co.CourseNumber Like '4%'
                AND college.CollegeName = 'Information School'
            
)
SET @ret = 1
RETURN @ret
END

ALTER TABLE tblCLASS_LIST WITH NOCHECK
ADD CONSTRAINT chk_student_state_400_class
CHECK(dbo.residency_registration() = 0)

ALTER TABLE tblCLASS_LIST 
DROP CONSTRAINT chk_student_state_400_class



--8)Write the SQL to enforce the following business rule: 
--"No 500-level course in the School of Medicine may be instructed by any person younger than 24 years old." 
--Hint: Do not forget to ALTER table to cement the function on the appropriate table!
GO

CREATE OR ALTER FUNCTION instruct_age_registration()
RETURNS INT 
AS
BEGIN
DECLARE @ret INT = 0 
IF EXISTS (
    SELECT *
    FROM tblSTUDENT s
    INNER JOIN tblCLASS_LIST cl ON cl.StudentID = s.StudentID
            INNER JOIN tblCLASS c ON c.ClassID = cl.ClassID
            INNER JOIN tblINSTRUCTOR_CLASS ic ON ic.ClassID = c.ClassID
            INNER JOIN tblINSTRUCTOR i ON i.InstructorID = ic.InstructorID
            INNER JOIN tblCOURSE co ON co.CourseID = c.CourseID
            INNER JOIN tblDEPARTMENT d ON d.DeptID = co.DeptID
            INNER JOIN tblCOLLEGE college ON college.CollegeID = d.CollegeID
            WHERE i.InstructorBirth > DATEADD([YEAR] , -24, getdate())
            AND co.CourseNumber Like '5%'
            AND college.CollegeName = 'Medicine'
)    
SET @ret = 1
RETURN @ret
END

ALTER TABLE tblCLASS_LIST WITH NOCHECK
ADD CONSTRAINT chk_instructor_age_500_class
CHECK(dbo.instruct_age_registration() = 0)

ALTER TABLE tblCLASS_LIST 
DROP CONSTRAINT chk_instructor_age_500_class

--Check function




EXECUTE insert_newrow_staffposition
@i_staffsFname = 'Neville',
@i_staffsLname = 'Pieri',
@i_staffBirthday = '1943-08-02',
@i_positionName = 'Administrative-Assistant',
@i_deptName = 'Medicine',
@Bdate = '1980-03-21',
@Edate = '1984-07-25';



