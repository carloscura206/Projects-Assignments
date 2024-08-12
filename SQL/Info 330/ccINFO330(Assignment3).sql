USE UNIVERSITY

--1)Write the SQL code to determine how many classes from the department of Informatics were taught in 2012, listed by quarter.
--lIST THE CLASSES BY QUARTER (Divide into 4 quarters)
SELECT COUNT(tblCLASS.ClassID) AS ClassCount, tblQUARTER.QuarterName 
FROM tblCLASS
INNER JOIN tblQUARTER
ON tblQUARTER.QuarterID =  tblCLASS.QuarterID
INNER JOIN tblCOURSE
ON tblCOURSE.CourseID = tblCLASS.CourseID
INNER JOIN tblDEPARTMENT
ON tblDEPARTMENT.DeptID = tblCOURSE.DeptID
WHERE tblCLASS.YEAR = 2012 AND tblDEPARTMENT.CollegeID = 9
GROUP BY tblQUARTER.QuarterName, tblQUARTER.QuarterName
ORDER BY ClassCount DESC



--2)Write the SQL code to return the departments with more than 50 credits worth of classes taught in Spring of 2008.
SELECT SUM(c.Credits) AS TotalCredits, d.DeptName
FROM  tblCourse c
INNER JOIN tblDepartment d ON d.DeptID = c.DeptID
INNER JOIN tblCLASS cl ON cl.CourseID = c.CourseID
INNER JOIN tblQUARTER q ON q.QuarterID = cl.QuarterID
WHERE cl.YEAR = 2008 AND q.QuarterID = 2
GROUP BY d.DeptName
HAVING SUM(c.Credits) >= 50
ORDER BY TotalCredits DESC


--3)Write the SQL to CREATE and EXECUTE a stored procedure to SELECT the first and last name of every student with a permanent address in a specific city. Pass the name of three different cities and their states--one city and state pair per EXECUTE statement--as parameters to test your stored procedure.
GO

CREATE OR ALTER PROCEDURE StudentLocationIdentifier 
    @ct VARCHAR(75),
    @state VARCHAR(25)
AS
    SELECT StudentFname, StudentLname, StudentPermAddress
    FROM tblSTUDENT
    WHERE StudentPermCity = @ct 
        AND StudentPermState = @state
GO

EXEC StudentLocationIdentifier 
    @ct = 'Seattle',
    @state = 'Washington, WA';
EXEC StudentLocationIdentifier 
    @ct = 'Los Angeles',
    @state = 'California, CA';
EXEC StudentLocationIdentifier 
    @ct = 'Austin',
    @state = 'Texas, TX';

--4)Write the SQL to CREATE and EXECUTE a stored procedure to INSERT a new row into tblINSTRUCTOR_OFFICE. Use values from tblINSTRUCTOR and tblOFFICE to fetch foreign keys. Write a SELECT statement to confirm that your stored procedure worked.
--Input their office type
--Input the insutrctors name
--Find the foreign key
GO
CREATE PROCEDURE CCuspINSERT_INSTRUCTOR_ROW 
    --Taken from tblINSTRUCTOR_OFFICE
    --Email address due to uniqueness
    --Instructor Email
    @InstructEmail VARCHAR(80),
    --OfficeName
    @OffName VARCHAR(50),
    --Begin Date
    @BeginD DATE,
    --EndDATE
    @EndD DATE
AS
        --Instructor_OfficeID
    DECLARE @SetInstructorID INT, @SetOfficeID INT
    --Set Instructor ID
    SET @SetInstructorID = (SELECT InstructorID FROM tblINSTRUCTOR 
               
                WHERE InstructorEmail = @InstructEmail
                )

    SET @SetOfficeID = (SELECT OfficeID FROM tblOFFICE
                WHERE OfficeName = @OffName
    )

    BEGIN TRANSACTION insertrow
        INSERT INTO tblINSTRUCTOR_OFFICE (InstructorID, OfficeID, BeginDate, EndDate)
        VALUES (@SetInstructorID, @SetOfficeID, @BeginD, @EndD)
    COMMIT TRANSACTION insertrow
GO

EXEC CCuspINSERT_INSTRUCTOR_ROW 
    @InstructEmail = 'Rachal.Bonnick150@uw.edu',
    @OffName = 'MGH370D',
    @BeginD = '2000-01-01 00:00:00.000',
    @EndD = '2000-12-31 00:00:00.000'

SELECT *, InstructorEmail
    FROM tblINSTRUCTOR_OFFICE
    INNER JOIN tblINSTRUCTOR 
        ON tblINSTRUCTOR.InstructorID = tblINSTRUCTOR_OFFICE.InstructorID 
    INNER JOIN tblOFFICE 
        ON tblOFFICE.OfficeID = tblINSTRUCTOR_OFFICE.OfficeID
    WHERE BeginDate = '2000-01-01 00:00:00.000' 
        AND EndDate = '2000-12-31 00:00:00.000' 
        AND InstructorEmail = 'Rachal.Bonnick150@uw.edu' 
        AND tblOFFICE.OfficeID = 1
        AND tblOFFICE.OfficeName = 'MGH370D'



--5)Write the SQL code to determine the difference in number of seats between the classroom type with the largest seating capacity and the classroom type with the smallest seating capacity.

SELECT MAX(SeatingCapacity) - MIN(SeatingCapacity) AS DiffSeatCap
FROM tblCLASSROOM_TYPE


--6)Write the SQL code to determine which state has had the fewest students attend UW that were born after September 9, 1945.
SELECT TOP 1 COUNT(StudentID) AS StudentCount, StudentPermState
FROM tblSTUDENT
WHERE StudentBirth > '1945-09-09'
GROUP BY StudentPermState
ORDER BY StudentCount ASC


--7)Write the SQL code to find the five staff with the position of “Office Manager” who have worked at UW the longest. make sure to account for ties.
SELECT TOP 5 WITH TIES tblSTAFF.StaffFName AS StaffName, DATEDIFF(DAY, tblSTAFF_POSITION.BeginDate, tblSTAFF_POSITION.EndDate) AS TIMEWORKEDDAYS
FROM tblSTAFF
INNER JOIN tblSTAFF_POSITION 
    ON tblSTAFF_POSITION.StaffID = tblSTAFF.StaffID
INNER JOIN tblPOSITION 
    ON tblPOSITION.PositionID = tblSTAFF_POSITION.PositionID
WHERE tblPOSITION.PositionName = 'Office Manager' 
ORDER BY TIMEWORKEDDAYS DESC



--8)Write the SQL to CREATE and EXECUTE a stored procedure to UPDATE which instructor is assigned to teach a particular class. Use values from tblINSTRUCTOR, tblCLASS, tblQUARTER, and tblCOURSE to fetch foreign keys. Write a SELECT statement to confirm that your stored procedure worked.
--update instructors assigned class
GO

CREATE OR ALTER PROCEDURE CCuspUPDATE_INSTRUCTOR_ROW 
  
    
    --tblInstructor column (InstructorEmail)
    @InstructEmail VARCHAR(80),
    --tblClass column (Classroom ID)
    @QuartName VARCHAR(30),
    --tblCourse column (CourseName)
    @Coursetitle VARCHAR(75),
    --DONT FORGET to remove comma above
    @Year CHAR(4)

AS
            --Instructors email, Classroom Number ID, Quarter Name, CourseName
    DECLARE @setInstructID INT, @setClassID INT
    SET  @setInstructID = (SELECT InstructorID 
                        FROM tblINSTRUCTOR
                        WHERE InstructorEmail = @InstructEmail
                        )

    SET @setClassID = (SELECT cl.ClassID 
                        FROM tblClass cl
                        INNER JOIN tblCOURSE c ON c.CourseID = cl.CourseID
                        INNER JOIN tblQUARTER q ON q.QuarterID = cl.QuarterID
                        WHERE c.CourseName = @Coursetitle AND 
                              q.QuarterName = @QuartName AND 
                              cl.[YEAR] = @Year
                              )

            BEGIN TRANSACTION update_row
                UPDATE tblINSTRUCTOR_CLASS
                SET InstructorID = @setInstructID 
                WHERE ClassID = @setClassID
                
            
            COMMIT TRANSACTION update_row
GO 

--For Debugging purposes below
    --SELECT * FROM tblINSTRUCTOR_CLASS 


    --SELECT InstructorID 
            --FROM tblINSTRUCTOR
            --WHERE InstructorEmail = 'Roxanna.Valazquez625@uw.edu'

    --SELECT cl.ClassID 
                        --FROM tblClass cl
                        --INNER JOIN tblCOURSE c ON c.CourseID = cl.CourseID
                        --INNER JOIN tblQUARTER q ON q.QuarterID = cl.QuarterID
                    --WHERE c.CourseName = 'MEDCH195' AND 
                              --q.QuarterName = 'Spring' AND 
                              --cl.[YEAR] = '1894'

--SELECT cl.ClassID 
                        --FROM tblClass cl
                        --INNER JOIN tblCOURSE c ON c.CourseID = cl.CourseID
                        --INNER JOIN tblQUARTER q ON q.QuarterID = cl.QuarterID
                        --WHERE c.CourseName = 'MEDCH195' AND 
                              --q.QuarterName = 'Spring' AND 
                              --cl.[YEAR] = '1894'


--For Debugging purposes on the codes above

EXECUTE CCuspUPDATE_INSTRUCTOR_ROW 
    @InstructEmail = 'Roxanna.Valazquez625@uw.edu',
    @CourseTitle = 'MEDCH195',
    @Year = '1894' ,
    @QuartName = 'Spring';

SELECT *
FROM tblINSTRUCTOR i
INNER JOIN tblINSTRUCTOR_CLASS ic ON i.InstructorID = ic.InstructorID
INNER JOIN tblCLASS c ON c.ClassID = ic.ClassID
INNER JOIN tblCOURSE co ON co.CourseID = c.CourseID
WHERE i.InstructorEmail = 'Roxanna.Valazquez625@uw.edu' AND co.CourseID = 13 AND c.[YEAR] = 1894



--9)Write the SQL code to return the colleges and their number of classes since 1973 that have had at least 56 students enrolled.

SELECT COUNT(c.ClassID) as ClassCount, cl.CollegeID, cl.CollegeName
FROM tblCollege cl
INNER JOIN tblDepartment d on d.CollegeID = cl.CollegeID
INNER JOIN tblCOURSE co ON d.DeptID = co.DeptID
INNER JOIN tblCLASS c on co.CourseID = c.CourseID
WHERE c.ClassID IN ( 
    SELECT clist.ClassID
    FROM tblCLASS_LIST 
    INNER JOIN tblCLASS_LIST clist ON clist.ClassID = c.ClassID
    WHERE c.[YEAR] >= 1973
    GROUP BY clist.ClassID
    HAVING COUNT(Distinct clist.StudentID) >= 56
) 
GROUP BY cl.CollegeID, cl.CollegeName 
order by ClassCount DESC





--10)Write the SQL to CREATE and EXECUTE a stored procedure to INSERT a new row into tblCLASS_LIST. Use values from tblCLASS, tblSTUDENT, tblQUARTER, and tblCOURSE to fetch foreign keys. Write a SELECT statement to confirm that your stored procedure worked.
GO

CREATE OR ALTER PROCEDURE CCuspINSERT_CLASSLIST_ROW 
  
    --tblSTUDENT
    @StudentsEmail VARCHAR(80),
    --tblQUARTER
    @QuarterName VARCHAR(30),
    --tblCOURSE
    @Coursetitle VARCHAR(75),
    @Year CHAR(4),
    @GradeGPA DECIMAL(3, 2),
    @StartDate DATE, 
    @Fee DECIMAL(7, 2)
 
AS

    DECLARE @SetClassID INT, @SetStudentID INT
    
    SET @SetClassID = (SELECT cl.ClassID 
                        FROM tblClass cl
                        INNER JOIN tblCOURSE c ON c.CourseID = cl.CourseID
                        INNER JOIN tblQUARTER q ON q.QuarterID = cl.QuarterID
                        WHERE c.CourseName = @Coursetitle AND 
                            q.QuarterName = @QuarterName AND
                            cl.[YEAR] = @Year)

    SET @SetStudentID = (SELECT StudentID 
                        FROM tblSTUDENT 
                        WHERE StudentMail = @StudentsEmail)

    BEGIN TRANSACTION  class_list_process
        INSERT INTO tblCLASS_LIST (ClassID, StudentID, Grade, RegistrationDate, RegistrationFee)
        VALUES(@SetClassID, @SetStudentID, @GradeGPA, @StartDate, @Fee)
    COMMIT TRANSACTION class_list_process
GO

EXECUTE CCuspINSERT_CLASSLIST_ROW 
    --tblSTUDENT
    @StudentsEmail = 'Damien.Rusiecki069@uw.edu',
    --tblQUARTER
    @QuarterName = 'Spring',
    --tblCOURSE
    @Coursetitle = 'MEDCH195',
    @Year = '1894',
    @GradeGPA = 4.0,
    @StartDate = '2000/01/01',
    @Fee = 4700.00;



SELECT *
FROM tblINSTRUCTOR i
INNER JOIN tblINSTRUCTOR_CLASS ic ON i.InstructorID = ic.InstructorID
INNER JOIN tblCLASS c ON c.ClassID = ic.ClassID
INNER JOIN tblCOURSE co ON co.CourseID = c.CourseID
WHERE i.InstructorEmail = 'Damien.Rusiecki069@uw.edu' AND c.[YEAR] = 1894





--11)Write the SQL to enforce the following business rule: 'No student older than 34 years old may register for a 400-level class in Johnson Hall any Winter quarter."


CREATE OR ALTER FUNCTION fn_agerestrict()
RETURNS INT
--Dont forget to remove comma above
AS 
BEGIN 
DECLARE @ret INT = 0
IF EXISTS ( SELECT DATEDIFF(YEAR, s.StudentBirth, GETDATE()) AS HOWOLDYEARS 
            FROM tblSTUDENT s
            INNER JOIN tblCLASS_LIST cl ON cl.StudentID = s.StudentID
            INNER JOIN tblCLASS c ON c.ClassID = cl.ClassID
            INNER JOIN tblQUARTER q ON q.QuarterID = c.QuarterID
            INNER JOIN tblCOURSE co ON co.CourseID = c.CourseID
            INNER JOIN tblCLASSROOM cr ON cr.ClassroomID = c.ClassroomID
            INNER JOIN tblBUILDING b ON b.BuildingID = cr.BuildingID
            WHERE co.CourseNumber Like '4%' AND b.BuildingName = 'Johnson Hall' AND q.QuarterName = 'Winter' AND  s.StudentBirth < DATEADD([YEAR] , -34, getdate())


              )
SET @ret = 1
RETURN @ret 
END 

ALTER TABLE tblCLASS_LIST WITH NOCHECK
ADD CONSTRAINT chk_student_age_400_class
CHECK(dbo.fn_agerestrict() = 0)

ALTER TABLE tblCLASS_LIST 
DROP CONSTRAINT chk_student_age_400_class


