--Write the SQL to determine the 300 students with the lowest GPA (all students/classes) during years 1975 -1981 partitioned by StudentPermState.
USE UNIVERSITY
--#1 cte 
With studentRank (ID, FirstName, LastName, StudentPermState, GPATotal, RankState)
AS (
    SELECT S.StudentID, S.StudentFname, S.StudentLname, S.StudentPermState,(SUM(CO.Credits * CL.Grade)) / (SUM(CO.Credits)), RANK() OVER(PARTITION BY StudentPermState ORDER BY SUM(CO.Credits * CL.Grade) / SUM(CO.Credits) DESC ) 
    FROM tblSTUDENT S 
    INNER JOIN tblCLASS_LIST CL ON CL.StudentID = S.StudentID
    INNER JOIN tblCLASS C ON C.ClassID = CL.ClassID
    INNER JOIN tblCOURSE CO ON C.CourseID = CO.CourseID
    WHERE C.[YEAR] BETWEEN 1975 AND 1981
    GROUP BY S.StudentID, S.StudentFname, S.StudentLname, S.StudentPermState
)

SELECT TOP 300 ID, FirstName, LastName, StudentPermState, GPATotal, RankState
FROM studentRank 
ORDER BY GPATotal ASC


 
--#2 table variable

DECLARE @GPALows TABLE (
    PKID INT IDENTITY (1,1) PRIMARY KEY, 
    Identification INT,
    StudentFname VARCHAR(50), 
    StudentLname VARCHAR(50),
    StudentPermState VARCHAR(50),
    GPA DECIMAL(3, 2),
    RankStater INT
)

INSERT INTO @GPALows (Identification, StudentFname,StudentLname, StudentPermState, GPA, RankStater)
SELECT S.StudentID, S.StudentFname, S.StudentLname, S.StudentPermState, (SUM(CO.Credits * CL.Grade)) / (SUM(CO.Credits)),  RANK() OVER(PARTITION BY StudentPermState ORDER BY SUM(CO.Credits * CL.Grade) / SUM(CO.Credits) DESC )
FROM tblSTUDENT S 
INNER JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
INNER JOIN tblCLASS C ON CL.ClassID = C.ClassID
INNER JOIN tblCOURSE CO ON C.CourseID = CO.CourseID
WHERE C.[YEAR] BETWEEN 1975 AND 1981
GROUP BY S.StudentID, S.StudentFname, S.StudentLname, S.StudentPermState


SELECT TOP 300 WITH TIES Identification, StudentFname,StudentLname, StudentPermState, GPA, RankStater
FROM @GPALows
ORDER BY GPA ASC


--#3 #temp
CREATE TABLE #GPALowsTemp (
    PKID INT IDENTITY (1,1) PRIMARY KEY,
    Identification INT,
    StudentFname VARCHAR(50), 
    StudentLname VARCHAR(50),
    StudentPermState VARCHAR(50),
    GPA DECIMAL(3, 2),
    RankStater INT     
)

INSERT INTO #GPALowsTemp (Identification, StudentFname,StudentLname, GPA, RankStater)
SELECT S.StudentID, S.StudentFname, S.StudentLname, (SUM(CO.Credits * CL.Grade)) / (SUM(CO.Credits)), RANK() OVER(PARTITION BY StudentPermState ORDER BY SUM(CO.Credits * CL.Grade) / SUM(CO.Credits) DESC )
FROM tblSTUDENT S 
INNER JOIN tblCLASS_LIST CL ON CL.StudentID = S.StudentID
INNER JOIN tblCLASS C ON C.ClassID = CL.ClassID
INNER JOIN tblCOURSE CO ON C.CourseID = CO.CourseID
WHERE C.[YEAR] BETWEEN 1975 AND 1981
GROUP BY S.StudentID, S.StudentFname, S.StudentLname, S.StudentPermState

SELECT TOP 300 Identification, StudentFname,StudentLname, GPA, RankStater
FROM #GPALowsTemp 
ORDER BY GPA ASC

GO 
   
--* Write the SQL to determine the 26th highest GPA during the 1970's for all business classes



--#4 CTE 
WITH RankedStudents (ID, FirstName, LastName, GPATotal, College, Dranky)
AS (
    
    SELECT S.StudentID, S.StudentFname, S.StudentLname, SUM(CO.Credits * CL.Grade) / SUM(CO.Credits), CollegeName, DENSE_RANK() OVER(PARTITION BY CollegeName ORDER BY SUM(CO.Credits * CL.Grade) / SUM(CO.Credits) DESC ) 
    FROM tblSTUDENT S 
    JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
    JOIN tblCLASS C ON CL.ClassID = C.ClassID
    JOIN tblCOURSE CO ON C.CourseID = CO.CourseID
    JOIN tblDEPARTMENT D ON CO.DeptID = D.DeptID
    JOIN tblCOLLEGE COL ON D.CollegeID = COL.CollegeID
    WHERE C.[YEAR] BETWEEN 1970 AND 1979
    AND CollegeName LIKE '%Business%'
    GROUP BY S.StudentID, S.StudentFname, S.StudentLname, CollegeName
)


SELECT ID, FirstName, LastName, GPATotal, College, Dranky
FROM RankedStudents
WHERE Dranky = 26
ORDER BY GPATotal DESC

--#5
DECLARE @HighestGpaBusiness TABLE (
    PKID INT IDENTITY (1,1) PRIMARY KEY,
    Identification INT,
    StudentFname VARCHAR(50), 
    StudentLname VARCHAR(50),
    College VARCHAR(50),
    GPA DECIMAL(3, 2),
    Dranky INT
)

INSERT INTO @HighestGpaBusiness (Identification, StudentFname,StudentLname, GPA, College, Dranky)
    SELECT S.StudentID, S.StudentFname, S.StudentLname, SUM(CO.Credits * CL.Grade) / SUM(CO.Credits), CollegeName, DENSE_RANK() OVER(PARTITION BY CollegeName ORDER BY SUM(CO.Credits * CL.Grade) / SUM(CO.Credits) DESC ) 
    FROM tblSTUDENT S 
    JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
    JOIN tblCLASS C ON CL.ClassID = C.ClassID
    JOIN tblCOURSE CO ON C.CourseID = CO.CourseID
    JOIN tblDEPARTMENT D ON CO.DeptID = D.DeptID
    JOIN tblCOLLEGE COL ON D.CollegeID = COL.CollegeID
    WHERE C.[YEAR] BETWEEN 1970 AND 1979
    AND CollegeName LIKE '%Business%'
    GROUP BY S.StudentID, S.StudentFname, S.StudentLname, CollegeName


SELECT Identification, StudentFname,StudentLname, GPA, Dranky
FROM @HighestGpaBusiness
WHERE Dranky = 26
ORDER BY GPA DESC


--#6
CREATE TABLE #GPABusiness (
    PKID INT IDENTITY (1,1) PRIMARY KEY,
    Identification INT,
    StudentFname VARCHAR(50), 
    StudentLname VARCHAR(50),
    College VARCHAR(50),
    GPA DECIMAL(3, 2),
    Dranky INT    
)

INSERT INTO #GPABusiness (Identification, StudentFname,StudentLname, GPA, College, Dranky)
    SELECT S.StudentID, S.StudentFname, S.StudentLname, SUM(CO.Credits * CL.Grade) / SUM(CO.Credits), CollegeName, DENSE_RANK() OVER(PARTITION BY CollegeName ORDER BY SUM(CO.Credits * CL.Grade) / SUM(CO.Credits) DESC ) 
    FROM tblSTUDENT S 
    JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
    JOIN tblCLASS C ON CL.ClassID = C.ClassID
    JOIN tblCOURSE CO ON C.CourseID = CO.CourseID
    JOIN tblDEPARTMENT D ON CO.DeptID = D.DeptID
    JOIN tblCOLLEGE COL ON D.CollegeID = COL.CollegeID
    WHERE C.[YEAR] BETWEEN 1970 AND 1979
    AND CollegeName LIKE '%Business%'
    GROUP BY S.StudentID, S.StudentFname, S.StudentLname, CollegeName

SELECT Identification, StudentFname,StudentLname, GPA, Dranky
FROM #GPABusiness
WHERE Dranky = 26
ORDER BY GPA DESC

GO

--* Write the SQL to divide ALL students into 100 groups based on GPA for Arts & Sciences classes during 1980's



--#7 CTE 
With studentRankGrouped (ID, FirstName, LastName, GPATotal, College, Nranked)
AS (
SELECT S.StudentID, S.StudentFName, S.StudentLName, (SUM(CO.Credits * CL.Grade)) / (SUM(CO.Credits)), COL.CollegeName, NTILE(100) OVER (PARTITION BY CollegeName ORDER BY SUM(CO.Credits * CL.Grade) / SUM(CO.Credits) DESC ) 
FROM tblSTUDENT S
INNER JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
INNER JOIN tblCLASS C ON C.ClassID = CL.ClassID
INNER JOIN tblCOURSE CO ON CO.CourseID = C.CourseID
INNER JOIN tblDEPARTMENT D ON D.DeptID = CO.DeptID
INNER JOIN tblCOLLEGE COL ON COL.CollegeID = D.CollegeID
WHERE C.[YEAR] LIKE '198_'
AND COL.CollegeName = 'Arts and Sciences'
GROUP BY S.StudentID, S.StudentFname, S.StudentLname, CollegeName
)

SELECT * FROM studentRankGrouped 

--#8


DECLARE @studentGrouping TABLE (
    PKID INT IDENTITY (1,1) PRIMARY KEY,
    Identification INT,
    StudentFname VARCHAR(50), 
    StudentLname VARCHAR(50),
    College VARCHAR(50),
    GPA DECIMAL(3, 2),
    Nranked INT
)

INSERT INTO @studentGrouping (Identification, StudentFname,StudentLname, GPA, College, Nranked)
SELECT S.StudentID, S.StudentFName, S.StudentLName, (SUM(CO.Credits * CL.Grade)) / (SUM(CO.Credits)), COL.CollegeName, NTILE(100) OVER (PARTITION BY CollegeName ORDER BY SUM(CO.Credits * CL.Grade) / SUM(CO.Credits) DESC ) 
FROM tblSTUDENT S
INNER JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
INNER JOIN tblCLASS C ON C.ClassID = CL.ClassID
INNER JOIN tblCOURSE CO ON CO.CourseID = C.CourseID
INNER JOIN tblDEPARTMENT D ON D.DeptID = CO.DeptID
INNER JOIN tblCOLLEGE COL ON COL.CollegeID = D.CollegeID
WHERE C.[YEAR] LIKE '198_'
AND COL.CollegeName = 'Arts and Sciences'
GROUP BY S.StudentID, S.StudentFname, S.StudentLname, CollegeName


SELECT * FROM @studentGrouping





--#9

   
CREATE TABLE #studentGroupedSocialScience(
    PKID INT IDENTITY (1,1) PRIMARY KEY,
    Identification INT,
    StudentFname VARCHAR(50), 
    StudentLname VARCHAR(50),
    College VARCHAR(50),
    GPA DECIMAL(3, 2),
    Nranked INT   
)

INSERT INTO #studentGroupedSocialScience (Identification, StudentFname,StudentLname, GPA, College, Nranked)
SELECT S.StudentID, S.StudentFName, S.StudentLName, (SUM(CO.Credits * CL.Grade)) / (SUM(CO.Credits)), COL.CollegeName, NTILE(100) OVER (PARTITION BY CollegeName ORDER BY SUM(CO.Credits * CL.Grade) / SUM(CO.Credits) DESC ) 
FROM tblSTUDENT S
INNER JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
INNER JOIN tblCLASS C ON C.ClassID = CL.ClassID
INNER JOIN tblCOURSE CO ON CO.CourseID = C.CourseID
INNER JOIN tblDEPARTMENT D ON D.DeptID = CO.DeptID
INNER JOIN tblCOLLEGE COL ON COL.CollegeID = D.CollegeID
WHERE C.[YEAR] LIKE '198_'
AND COL.CollegeName = 'Arts and Sciences'
GROUP BY S.StudentID, S.StudentFname, S.StudentLname, CollegeName


SELECT * FROM #studentGroupedSocialScience




