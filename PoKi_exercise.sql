--Query the PoKi database using SQL SELECT statements to answer the following questions.

--1. What grades are stored in the database?
SELECT Grade.Name, COUNT(Author.Id) AS 'Kids in Each Grade'
FROM Author JOIN Grade ON Author.GradeId = Grade.Id
GROUP BY Grade.Name
ORDER BY Grade.Name;
--First through Fifth Grade

--2. What emotions may be associated with a poem?
SELECT [Name] FROM Emotion;
-- Anger, fear, sadness, joy

--3. How many poems are in the database?
SELECT COUNT(Id) AS 'Total Poems'
FROM Poem;
-- 32,842 Poems Total

--4. Sort authors alphabetically by name. What are the names of the top 76 authors?
SELECT TOP 76 [Name] 
FROM Author
ORDER BY [Name];

--5. Starting with the above query, add the grade of each of the authors.
SELECT TOP 76 Author.[Name], Grade.Name AS 'Grade'
FROM Author JOIN Grade ON Author.GradeId = Grade.Id
ORDER BY [Name];

--6. Starting with the above query, add the recorded gender of each of the authors.
SELECT TOP 76 Author.[Name], Grade.Name AS 'Grade', Gender.Name AS 'Gender'
FROM Author JOIN Grade ON Author.GradeId = Grade.Id
JOIN Gender ON Gender.Id = Author.GenderId
ORDER BY [Name];

--7. Which poem has the fewest characters?
SELECT Poem.Title, Poem.TEXT
FROM Poem
WHERE Poem.CharCount = (
	SELECT MIN(Poem.CharCount)
	FROM Poem
);
-- Shortest poem is called 'Hi'

--8. How many authors are in the third grade?
SELECT Grade.Name, COUNT(Author.Id) AS 'Number of Kids'
FROM Author JOIN Grade ON Author.GradeId = Grade.Id
WHERE Grade.Name = '3rd Grade'
GROUP BY Grade.Name;
--2344 kids in the 3rd grade

--9. How many authors are in the first, second or third grades?
SELECT Grade.Name, COUNT(Author.Id) AS 'Number of Kids'
FROM Author JOIN Grade ON Author.GradeId = Grade.Id 
WHERE Grade.Name = '1st Grade' OR Grade.Name = '2nd Grade' OR Grade.Name = '3rd Grade' 
GROUP BY Grade.Name;
-- 623 kids in 1st grade, 1437 in 2nd grade, 2344 in 3rd grade

--10. What is the total number of poems written by fourth graders?
SELECT Grade.Name AS 'Grade', COUNT(Poem.Id) AS 'Number of Poems'
FROM Poem JOIN Author ON Author.Id = Poem.AuthorId
JOIN Grade ON Grade.Id = Author.GradeId
WHERE Grade.Name = '4th Grade'
GROUP BY Grade.Name;
--10806 poems by 4th graders

--11. How many poems are there per grade?
SELECT Grade.Name AS 'Grade', COUNT(Poem.Id) AS 'Number of Poems'
FROM Poem JOIN Author ON Author.Id = Poem.AuthorId
JOIN Grade ON Grade.Id = Author.GradeId
GROUP BY Grade.Name;
--1st grade: 886, 2nd Grade 3160, 3rd Grade: 6636, 4th Grade: 10806, 5th Grade: 11354

--12. How many authors are in each grade? (Order your results by grade starting with 1st Grade)
SELECT Grade.Name, COUNT(Author.Id) AS 'Kids in Each Grade'
FROM Author JOIN Grade ON Author.GradeId = Grade.Id
GROUP BY Grade.Name
ORDER BY Grade.Name;
-- 1st grade: 623, 2nd Grade: 1437, 3rd Grade: 2344, 4th Grade: 3288, 5th Grade: 3464

--13. What is the title of the poem that has the most words?
SELECT Poem.Title, Poem.WordCount, Poem.TEXT
FROM Poem
WHERE Poem.WordCount = (
	SELECT MAX(Poem.WordCount)
	FROM Poem
);
-- "The Misterious Black" has the most words

--14. Which author(s) have the most poems? (Remember authors can have the same name.)
SELECT TOP 10 Author.Name, query.NumOfPoems AS 'Number of Poems'
FROM (
	SELECT Poem.AuthorId, COUNT(Poem.Id) AS NumOfPoems
	FROM Poem GROUP BY Poem.AuthorId
) AS query
JOIN Author ON Author.Id = AuthorId
ORDER BY 'Number of Poems' DESC;
--Jessica has submitted the most poems at 118

--15. How many poems have an emotion of sadness?
SELECT Emotion.Name AS 'Emotion', EmotionCount AS 'Number of Poems'
FROM (
	SELECT PoemEmotion.EmotionId, COUNT(PoemEmotion.ID) AS EmotionCount 
	FROM PoemEmotion
	GROUP BY PoemEmotion.EmotionId
) AS query
JOIN Emotion ON Emotion.Id = query.EmotionId
WHERE Emotion.Name = 'Sadness';

--16. How many poems are not associated with any emotion?
SELECT Poem.Id, COUNT(PoemEmotion.Id) AS NumOfEmotions 
FROM Poem 
LEFT JOIN PoemEmotion ON Poem.Id = PoemEmotion.PoemId 
WHERE PoemEmotion.Id = NULL
GROUP BY Poem.Id
ORDER BY NumOfEmotions;
--From what I can tell, it looks like all poems have at least one emotion

--17. Which emotion is associated with the least number of poems?
SELECT Emotion.Name 
FROM (SELECT EmotionId, COUNT(PoemEmotion.Id) 
AS EmotionCount FROM PoemEmotion 
GROUP BY PoemEmotion.EmotionId) AS EmotionCountQuery 
JOIN Emotion 
ON Emotion.Id = EmotionCountQuery.EmotionId 
WHERE EmotionCountQuery.EmotionCount = (
	SELECT MIN(EmotionCount) 
	FROM (
		SELECT EmotionId, COUNT(PoemEmotion.Id) AS EmotionCount 
		FROM PoemEmotion 
		GROUP BY PoemEmotion.EmotionId) AS EmotionCountQuery);
--Anger has the least number of poems

--18. Which grade has the largest number of poems with an emotion of joy?
SELECT TOP 1 Grade.Name, COUNT(PoemEmotion.EmotionId) AS PoemCount
FROM Poem 
JOIN Author 
ON Poem.AuthorId = Author.Id 
JOIN PoemEmotion 
ON PoemEmotion.PoemId = Poem.Id 
JOIN Emotion 
ON Emotion.Id = PoemEmotion.EmotionId 
JOIN Grade ON Grade.Id = Author.GradeId
WHERE Emotion.Name = 'joy' 
GROUP BY Grade.Name 
ORDER BY PoemCount DESC;
--5th grade has the highest

--19. Which gender has the least number of poems with an emotion of fear?
SELECT TOP 1 Gender.Name, COUNT(PoemEmotion.EmotionId) AS PoemCount
FROM Poem JOIN Author
ON Poem.AuthorId = Author.Id
JOIN PoemEmotion
ON PoemEmotion.PoemId = Poem.Id
JOIN Emotion
ON Emotion.Id = PoemEmotion.EmotionId
JOIN Gender
ON Gender.Id = Author.GenderId 
WHERE Emotion.Name = 'fear'
GROUP BY Gender.Name 
ORDER BY PoemCount DESC;
--females have the highest emotion of fear :(