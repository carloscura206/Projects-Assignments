--1) Write the command to use the UNIVERSITY database. (Note: You can reference the UNIVERSITY ERDActions  to look up table and column names.)
USE UNIVERSITY

--2) Write the SQL query to determine which students were born after November 5, 1996.
SELECT StudentFname, StudentLname
FROM tblSTUDENT
WHERE StudentBirth > '1996-11-05' 

--3) Write the SQL query to determine which buildings are on West Campus.
SELECT tblLOCATION.LocationName, tblBUILDING.BuildingName
FROM tblLOCATION
INNER JOIN tblBUILDING 
ON tblLOCATION.LocationID = tblBUILDING.LocationID
WHERE tblLOCATION.LocationName = 'West Campus'

--4)Write the SQL query to determine how many libraries are at UW.
        --How do i involve count?

SELECT COUNT(*) AS TotalLibraries, tblBUILDING_TYPE.BuildingTypeName
FROM tblBUILDING_TYPE
INNER JOIN tblBUILDING
ON tblBUILDING_TYPE.BuildingTypeID = tblBUILDING.BuildingTypeID
WHERE tblBUILDING_TYPE.BuildingTypeName = 'Library'
GROUP BY tblBUILDING_TYPE.BuildingTypeName


--5)Write the code to return the 10 youngest students enrolled in a course from Information School during winter quarter 2009.
    
SELECT TOP 10 tblSTUDENT.StudentBirth , tblDEPARTMENT.DeptName, tblDEPARTMENT.DeptAbbrev , tblDEPARTMENT.CollegeID, tblCLASS.QuarterID, tblCLASS.YEAR AS ClassYear,tblQUARTER.QuarterName
FROM tblSTUDENT
INNER JOIN tblCLASS_LIST
ON tblCLASS_LIST.StudentID = tblSTUDENT.StudentID
INNER JOIN tblCLASS
ON tblCLASS.ClassID = tblCLASS_LIST.ClassID
INNER JOIN tblQUARTER
ON tblQUARTER.QuarterID = tblCLASS.QuarterID
INNER JOIN tblCOURSE
ON tblCOURSE.CourseID = tblCLASS.COURSEID
INNER JOIN tblDEPARTMENT
ON tblDEPARTMENT.DeptID = tblCOURSE.DeptID
WHERE tblDEPARTMENT.CollegeID = 9 AND tblCLASS.QuarterID = 1 AND tblCLASS.[YEAR] = 2009
ORDER BY StudentBirth DESC


--6)Write the code to determine the 5 most-common states listed as permanent addresses for students who registered for at least one course(CLASS) in the 1930's.
    --find the states with the most addresses in each one for students regiester in ATLEAST ONE COURSE in 1930s 
        --GROUP BY states
        --Collecting the permanant addresses
        --IN 1930s
        --left join 
        --group by students by each year
            ---group all the students to their corresponding year

--SELECT TOP 5 tblSTUDENT.StudentPermState, tblCLASS.YEAR

SELECT TOP 5 COUNT(*) AS TOPFIVECOMMONSTATES, tblSTUDENT.StudentPermState
FROM tblSTUDENT
INNER JOIN tblCLASS_LIST
ON tblCLASS_LIST.StudentID = tblSTUDENT.StudentID
INNER JOIN tblCLASS
ON tblCLASS.ClassID = tblCLASS_LIST.ClassID
WHERE tblCLASS.[YEAR] BETWEEN 1930 AND 1939
GROUP BY tblSTUDENT.StudentPermState
ORDER BY TOPFIVECOMMONSTATES DESC



--7) Write the SQL query to determine which current instructor has been a Senior Lecturer the longest. 
--Had to take into account that the longest lecturers have been working for the same year so I had to do it in days worked
SELECT TOP 1 tblINSTRUCTOR.InstructorFName, tblINSTRUCTOR.InstructorLName, tblINSTRUCTOR_INSTRUCTOR_TYPE.BeginDate, DATEDIFF(DAY, tblINSTRUCTOR_INSTRUCTOR_TYPE.BeginDate, GETDATE()) AS TIMEWORKEDDAYS, DATEDIFF(YEAR, tblINSTRUCTOR_INSTRUCTOR_TYPE.BeginDate, GETDATE()) AS TIMEWORKEDYEARS
FROM tblINSTRUCTOR
INNER JOIN tblINSTRUCTOR_INSTRUCTOR_TYPE
ON tblINSTRUCTOR_INSTRUCTOR_TYPE.InstructorID = tblINSTRUCTOR.InstructorID
INNER JOIN tblINSTRUCTOR_TYPE ON
tblINSTRUCTOR_TYPE.InstructorTypeID = tblINSTRUCTOR_INSTRUCTOR_TYPE.InstructorTypeID
WHERE (GETDATE() < tblINSTRUCTOR_INSTRUCTOR_TYPE.EndDate OR tblINSTRUCTOR_INSTRUCTOR_TYPE.EndDate IS NULL) AND tblINSTRUCTOR_TYPE.InstructorTypeName = 'Senior Lecturer'
ORDER BY TIMEWORKEDDAYS DESC


 --8)Write the SQL query to determine which College offered the most courses Spring quarter 2014.
SELECT TOP 1 COUNT(tblCOURSE.CourseID) AS Course, tblCOLLEGE.CollegeName as CollegeName, tblCLASS.YEAR, tblQUARTER.QuarterID
FROM tblCOURSE 
INNER JOIN tblCLASS 
ON tblCLASS.CourseID = tblCOURSE.CourseID
INNER JOIN tblQUARTER
ON tblQUARTER.QuarterID = tblCLASS.QuarterID
INNER JOIN tblDEPARTMENT 
ON tblDEPARTMENT.DeptID = tblCOURSE.DeptID
INNER JOIN tblCOLLEGE 
ON tblCOLLEGE.CollegeID = tblDEPARTMENT.CollegeID
WHERE tblCLASS.QuarterID = 2 AND tblCLASS.[YEAR] = 2014
GROUP BY CollegeName, tblCLASS.YEAR, tblQUARTER.QuarterID
ORDER BY Course DESC


--9) Write the SQL query to determine which courses were held in large lecture halls or auditorium type classrooms summer 2016. 
    --Courses in either large lecture halls or auditorium type classrooms
    --Summer 
    --2016

SELECT tblCOURSE.CourseName, tblCLASSROOM_TYPE.ClassroomTypeName, tblCLASS.YEAR, tblCLASS.QuarterID
FROM tblCLASSROOM_TYPE
INNER JOIN tblCLASSROOM
ON tblCLASSROOM.ClassroomTypeID = tblCLASSROOM_TYPE.ClassroomTypeID
INNER JOIN tblCLASS
ON tblCLASS.ClassroomID = tblCLASSROOM.ClassroomID
INNER JOIN tblQUARTER
ON tblQUARTER.QuarterID = tblCLASS.QuarterID
INNER JOIN tblCOURSE
ON tblCOURSE.CourseID = tblCLASS.CourseID
WHERE tblCLASSROOM_TYPE.ClassroomTypeName IN('Large Lecture Hall', 'Auditorium') AND tblCLASS.[YEAR] = 2016 AND tblQUARTER.QuarterName = 'Summer' 
ORDER by tblCOURSE.CourseName ASC


--10) Write the SQL query to find all of the students AND instructors with the first name 'Gwen' and a last name that starts with 'B'. Order the results alphabetically by last name and add a column to the results that indicates whether the person is a student or instructor.
    --UNION
    --make a column that labels people as instructor or student

(
SELECT StudentFname AS FirstName, StudentLname AS LastName, 'Student' AS PersonIdentifier
FROM tblSTUDENT
WHERE StudentFname LIKE 'Gwen' AND StudentLName LIKE 'B%' 
)
UNION
(
SELECT InstructorFname, InstructorLname , 'Instructor' AS PersonLabel
FROM tblINSTRUCTOR
WHERE InstructorFname LIKE 'Gwen' AND InstructorLname LIKE 'B%' 
)
ORDER BY LastName ASC



--11) Write the SQL query to find the names of the 20 students who have taken the most classes and who have a permanent address in Washington state. Order the result by the number of classes taken and display the numbers in your result. Hint: Use a subquery. 
--How is a subquery used when we arent comparing a specific value of classes to a set avg number of classes to take?
        --Count the number of classes each student took
        --Outer would be in washington state
        --Order by DESC

SELECT TOP 20 StudentID, StudentFname, StudentLname,(
   --Counts the number of classes each student took
   SELECT COUNT(ClassID)
   FROM tblCLASS_LIST cl
   WHERE s.StudentID = cl.StudentID) AS NumClassesTook
FROM tblSTUDENT s
WHERE StudentPermState = 'Washington, WA'
ORDER BY NumClassesTook DESC

