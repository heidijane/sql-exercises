--dbdiagra.io ERD
--https://dbdiagram.io/d/5ed693c439d18f5553002175

--Query all of the entries in the Genre table
SELECT * FROM Genre;

--Query all the entries in the Artist table and order by the artist's name. HINT: use the ORDER BY keywords
SELECT * FROM Artist ORDER BY ArtistName;

--Write a SELECT query that lists all the songs in the Song table and include the Artist name
SELECT s.Title, a.ArtistName FROM Song s JOIN Artist a ON s.ArtistId = a.Id;

--Write a SELECT query that lists all the Artists that have a Pop Album
SELECT ArtistName AS 'Artist with a Pop Album' FROM (SELECT a.ArtistName, g.Label FROM Artist a JOIN Album al ON a.Id = al.ArtistId JOIN Genre g ON g.Id = al.GenreId) AS query WHERE Label = 'Pop' GROUP BY (ArtistName);

--Write a SELECT query that lists all the Artists that have a Jazz or Rock Album
SELECT ArtistName AS 'Artist' FROM (SELECT a.ArtistName, g.Label FROM Artist a JOIN Album al ON a.Id = al.ArtistId JOIN Genre g ON g.Id = al.GenreId) AS query WHERE Label = 'Rock' OR Label = 'Jazz' GROUP BY (ArtistName);

--Write a SELECT statement that lists the Albums with no songs
SELECT a.Title AS 'Album with No Songs' FROM Album a LEFT JOIN Song s ON s.AlbumId = a.Id WHERE s.Id IS NULL;

--Using the INSERT statement, add one of your favorite artists to the Artist table.
--INSERT INTO Artist (ArtistName, YearEstablished) VALUES ('Tears for Fears', 1981);

--Using the INSERT statement, add one, or more, albums by your artist to the Album table.
--INSERT INTO Album (Title, ReleaseDate, AlbumLength, [Label], ArtistId, GenreId) VALUES ('The Hurting', '07/03/1983', 2460, 'Mercury', 28, 15);
--INSERT INTO Album (Title, ReleaseDate, AlbumLength, [Label], ArtistId, GenreId) VALUES ('Songs from the Big Chair', '02/25/1985', 2460, 'Mercury', 28, 15);
--INSERT INTO Album (Title, ReleaseDate, AlbumLength, [Label], ArtistId, GenreId) VALUES ('The Seeds of Love', '02/25/1985', 2940, 'Mercury', 28, 7);

--Using the INSERT statement, add some songs that are on that album to the Song table.
--INSERT INTO Song (Title, SongLength, ReleaseDate, GenreId, ArtistId, AlbumId) VALUES ('The Hurting', 260, '07/03/1983', 15, 28, 23);
--INSERT INTO Song (Title, SongLength, ReleaseDate, GenreId, ArtistId, AlbumId) VALUES ('Mad World', 212, '09/20/1982', 15, 28, 23);
--INSERT INTO Song (Title, SongLength, ReleaseDate, GenreId, ArtistId, AlbumId) VALUES ('Pale Shelter', 274, '07/03/1983', 15, 28, 23);
--INSERT INTO Song (Title, SongLength, ReleaseDate, GenreId, ArtistId, AlbumId) VALUES ('Shout', 392, '11/19/1984', 15, 28, 24);
--INSERT INTO Song (Title, SongLength, ReleaseDate, GenreId, ArtistId, AlbumId) VALUES ('Everybody Wants to Rule the World', 251, '03/18/1985', 15, 28, 24);
--INSERT INTO Song (Title, SongLength, ReleaseDate, GenreId, ArtistId, AlbumId) VALUES ('Head Over Heels', 301, '02/25/1985', 15, 28, 24);
--INSERT INTO Song (Title, SongLength, ReleaseDate, GenreId, ArtistId, AlbumId) VALUES ('Woman In Chains', 390, '11/06/1989', 7, 28, 25);
--INSERT INTO Song (Title, SongLength, ReleaseDate, GenreId, ArtistId, AlbumId) VALUES ('Sowing the Seeds of Love', 379, '09/21/1989', 7, 28, 25);

--Write a SELECT query that provides the song titles, album title, and artist name for all of the data you just entered in. Use the LEFT JOIN keyword sequence to connect the tables, and the WHERE keyword to filter the results to the album and artist you added.
SELECT s.Title, al.Title, art.ArtistName FROM Song s LEFT JOIN Album al ON al.Id = s.AlbumId LEFT JOIN Artist art ON art.Id = s.ArtistId WHERE art.ArtistName = 'Tears for Fears';


--Write a SELECT statement to display how many songs exist for each album. You'll need to use the COUNT() function and the GROUP BY keyword sequence.
SELECT a.Title AS 'Album', COUNT(s.Id) AS 'Song Count' FROM Album a JOIN Song s ON a.Id = s.AlbumId GROUP BY (a.Title); 

--Write a SELECT statement to display how many songs exist for each artist. You'll need to use the COUNT() function and the GROUP BY keyword sequence.
SELECT a.ArtistName AS 'Artist', COUNT(s.Id) AS 'Song Count' FROM Artist a JOIN Song s ON a.Id = s.ArtistId GROUP BY (a.ArtistName); 

--Write a SELECT statement to display how many songs exist for each genre. You'll need to use the COUNT() function and the GROUP BY keyword sequence.
SELECT g.[Label] AS 'Genre', COUNT(s.Id) AS 'Song Count' FROM Genre g JOIN Song s ON g.Id = s.GenreId GROUP BY (g.[Label]);

--Write a SELECT query that lists the Artists that have put out records on more than one record label. Hint: When using GROUP BY instead of using a WHERE clause, use the HAVING keyword
SELECT ArtistName, COUNT([Label]) AS 'Label Number' FROM (SELECT Artist.ArtistName, Album.[Label] FROM Album JOIN Artist ON Artist.Id = Album.ArtistId GROUP BY Artist.ArtistName, Album.[Label]) AS query GROUP BY ArtistName HAVING COUNT([Label]) > 1;

--Using MAX() function, write a select statement to find the album with the longest duration. The result should display the album title and the duration.
SELECT Title, AlbumLength FROM Album WHERE AlbumLength = (SELECT MAX(Album.AlbumLength) FROM Album);

--Using MAX() function, write a select statement to find the song with the longest duration. The result should display the song title and the duration.
SELECT Title, SongLength FROM Song WHERE SongLength = (SELECT MAX(SongLength) FROM Song);

--Modify the previous query to also display the title of the album.
SELECT Song.Title, Song.SongLength, Album.Title FROM Song JOIN Album ON Song.AlbumId = Album.Id WHERE Song.SongLength = (SELECT MAX(SongLength) FROM Song);
