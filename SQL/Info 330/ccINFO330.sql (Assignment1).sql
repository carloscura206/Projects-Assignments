--1) Write the command to use the UNIVERSITY database.
USE UNIVERSITY

--2) We'll use just the tblSTUDENT table in this lab. Write a query to see 10 rows of data (all columns) from tblSTUDENT.
    SELECT TOP 10 *
    FROM tblSTUDENT


--3) Write the SQL code to return the first and last names of every student with a permanent address in the state of Rhode Island.

    SELECT StudentFname, StudentLname, StudentPermAddress
    FROM tblSTUDENT
    WHERE StudentPermState = 'Rhode Island, RI'

--4) Write the SQL code to find the number of students who have a phone number with the area code 206.
   
    SELECT COUNT(*) AS NumStudPhone
    FROM tblSTUDENT
    WHERE StudentAreaCode = 206

--5) Write the SQL code to find the earliest birthdate in the table.
    SELECT MIN(StudentBirth)
    FROM tblSTUDENT   

--6) Write the SQL code to find all of the students whose first name begins with 'Sh' and last name ends with 'on'.

    SELECT StudentFname, StudentLname
    FROM tblSTUDENT
    WHERE StudentFname LIKE 'Sh%' AND StudentLname LIKE '%on'

--7) Write the SQL code to find the name of every city in Wyoming that is listed in TblSTUDENT. Return the list of cities in alphabetical order with no repeats (list each city only once).

    SELECT DISTINCT StudentPermCity
    FROM tblSTUDENT
    WHERE StudentPermState = 'Wyoming, WY'
    ORDER BY StudentPermCity ASC

--8) Write the SQL code to find the email address of every student born between December 12, 1988 and January 14, 1989.

    SELECT StudentMail
    FROM tblSTUDENT
    WHERE StudentBirth BETWEEN '1988-12-12' AND '1989-01-14'

--9) Find all of the students with a permanent address in Minnesota, Wisconsin, or Iowa and a ZIP code that ends in 123. Return the student first and last names and permanent city.

    SELECT StudentFname, StudentLname, StudentPermCity, StudentPermState
    FROM tblSTUDENT
    WHERE StudentPermState IN ('Minnesota, MA', 'Wyoming, WY', 'Iowa, IA') AND StudentPermZip LIKE '%123'

--10) Find the 5 oldest living students with a permanent address in Seattle, WA. Return their first and last names and their birthdates.

    --Note: A quirk of this table is that living people have a DateOfDeath in the future instead of a NULL value.
    --Challenge: Calculate the age of the student and return that value instead of birthdate.
    --Hint: You might want to use the getDate() and dateDiff() functions.

    SELECT TOP 5 StudentFname, StudentLname, DATEDIFF(DAY, StudentBirth, GETDATE()) AS HOWOLDDAYS, StudentBirth, DateOfDeath, DATEDIFF(YEAR, StudentBirth, GETDATE()) AS HOWOLDYEARS
    FROM tblSTUDENT
    WHERE StudentPermCity = 'Seattle' AND StudentPermState = 'Washington, WA' AND GETDATE() < DateOfDeath
    ORDER BY HOWOLDDAYS DESC

