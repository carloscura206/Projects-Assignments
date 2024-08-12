USE MovieDB


-- 1) What is the shortest movie?
SELECT movieRuntime, movieTitle
FROM tblMovie
WHERE movieRuntime IS NOT NULL
ORDER BY movieRuntime asc



-- 2) What is the movie with the most number of votes?

SELECT top 1 movieVoteCount, movieTitle
FROM tblMovie
WHERE movieVoteCount IS NOT NULL
ORDER BY movieVoteCount DESC
 


-- 3) Which movie made the most net profit?
--MOVIE REVENUE - MOVIEBUDGET
SELECT top 1 movieVoteCount, movieTitle
FROM tblMovie
WHERE movieVoteCount IS NOT NULL


-- 4) Which movie lost the most money?  
-- Revenue- Budget
SELECT Top 1 (movieRevenue - movieBudget) as profit, movieTitle
FROM tblMovie
ORDER BY profit desc

--5) How many movies were made in the 80’s?
Select COUNT(movieID) AS totalMovies80s
FROM tblMovie
WHERE tblMovie.movieReleaseDate  >= CONVERT(datetime, '1980-01-01')
AND tblMovie.movieReleaseDate  <= CONVERT(datetime, '1989-12-31')


--6) What is the most popular movie released in the year 1980?
Select TOP 1 movieVoteCount, movieTitle
FROM tblMovie
WHERE tblMovie.movieReleaseDate  >= CONVERT(datetime, '1980-01-01')
AND tblMovie.movieReleaseDate  <= CONVERT(datetime, '1980-12-31')
AND movieVoteCount IS NOT NULL
ORDER BY movieVoteCount DESC

--7) How long was the longest movie made before 1900?
Select top 1 movieRuntime, movieTitle
FROM tblMovie
WHERE tblMovie.movieReleaseDate  < CONVERT(datetime, '1900-01-01')
AND movieRuntime IS NOT NULL
ORDER BY movieRuntime DESC


--8) Which language has the shortest movie?
--GRoup by language id
--inner join
-- NEED HELP
SELECT TOP 1 WITH TIES m.movieRuntime AS ShortestLengthMovie, l.languageName
FROM tblLanguage l
JOIN tblMovie m ON m.languageID = l.languageID
WHERE m.movieRuntime IS NOT NULL AND l.languageName IS NOT NULL
ORDER BY ShortestLengthMovie ASC




--9) Which collection has the highest total popularity? 
--sum the total popularty
--do an avg because 
SELECT TOP 1 WITH TIES count(m.moviePopularity) as TotalPopularity, c.collectionName
FROM tblCollection c
INNER JOIN tblMovie m ON m.collectionID = c.collectionID
GROUP BY c.collectionName
ORDER BY TotalPopularity DESC

SELECT TOP 1 *
FROM tblMovie

--10) Which language has the most movies in production or post-production?
SELECT top 1 with ties count(m.movieID) as TotalMovies, l.languageName
FROM tblMovie m 
INNER JOIN tblStatus s ON s.statusID = m.statusID
INNER JOIN tblLanguage l ON l.languageID = m.languageID
WHERE s.statusName IN ('In Production', 'Post Production')
GROUP BY l.languageName
ORDER BY TotalMovies DESC


--11)What was the most expensive movie that ended up getting canceled?
SELECT top 1 m.movieBudget, m.movieTitle
FROM tblMovie m 
INNER JOIN tblStatus s ON s.statusID = m.statusID
WHERE s.statusName = 'Canceled' 
ORDER BY m.movieBudget DESC 

select * 
from tblStatus

--12) How many collections have movies that are in production for the language French (FR)
--Never suma  rpimary key
--never do math ona  primary key
SELECT COUNT(c.collectionID) as CollectionCount, l.languageName as FrenchCollection
FROM tblCollection c
INNER JOIN tblMovie m ON m.collectionID = c.collectionID
INNER JOIN tblStatus s ON s.statusID = m.statusID
INNER JOIN tblLanguage l ON l.languageID = m.languageID
WHERE s.statusName = 'In Production' AND l.languageName = 'FR'
GROUP BY l.languageName



--13) List the top ten rated movies that have received more than 5000 votes
SELECT TOP 10 movieVoteCount, MovieTitle
FROM tblMovie
WHERE movieVoteCount >= 5000
ORDER BY movieVoteCount DESC


--14) Which collection has the most movies associated with it?
--do I do a max or pick the top 2 since its tied
Select c.collectionName, COUNT(m.movieID) as movieCount
FROM tblCollection c
INNER JOIN tblMovie m ON m.collectionID = c.collectionID
GROUP BY c.collectionName
Order By movieCount Desc 


--15) What is the collection with the longest total duration? --explain longest total duration
Select TOP 5 c.collectionName, SUM(m.movieRuntime) as totalMovieDuration
FROM tblCollection c
INNER JOIN tblMovie m ON m.collectionID = c.collectionID
GROUP BY c.collectionName
Order By totalMovieDuration Desc

--16) Which collection has made the most net profit?
Select TOP 1 c.collectionName, SUM(m.movieRevenue) as totalRevenue
FROM tblCollection c
INNER JOIN tblMovie m ON m.collectionID = c.collectionID
GROUP BY c.collectionName
Order By totalRevenue Desc


--17)List the top 100 movies by their duration from longest to shortest


SELECT TOP 100 movieTitle, movieRuntime
FROM tblMovie
ORDER BY movieRuntime DESC




--18) Which languages have more than 25,000 movies associated with them?
--HAVING 
SELECT COUNT(m.movieID), l.languageName
FROM tblMovie m
INNER JOIN tblLanguage l ON m.languageID = l.languageID
GROUP BY l.languageName
HAVING COUNT(m.movieID) > 25000

 




--19) Which collections had all their movies made in the 80’s?
SELECT c.collectionName
FROM tblCollection c
INNER JOIN tblMovie m ON m.languageID = c.collectionID
WHERE m.movieReleaseDate BETWEEN '1980-01-01' AND '1989-12-31' 
GROUP BY c.collectionName





--20) In the language that has the most number of movies in the database, A
--how many movies start with “The”? (You may not hard-code a language, B
--COUNT -DONT READ VALUES
--SUM - Add the values from row 1, row 2, etc continuing
--write thq euery if the most popular language
--outer query - number of movies that have that langauge  


SELECT COUNT(*) AS NumMovies_THE
FROM tblMOVIE m
JOIN 
        (SELECT TOP 1 l.LanguageID, l.LanguageName, COUNT(*) AS NumMovies 
        FROM tblLANGUAGE l
            INNER JOIN tblMOVIE m ON l.languageId = m.languageID 
        GROUP BY l.LanguageID, L.LanguageName
        ORDER BY NumMovies DESC) AS subquery1 ON M.languageID = subquery1.languageID

WHERE MovieTitle like 'The%'

