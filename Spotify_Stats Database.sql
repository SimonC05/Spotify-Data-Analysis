CREATE DATABASE spotify_stats;
USE spotify_stats;

CREATE TABLE Songs (
SongId INT PRIMARY KEY,
SongName VARCHAR(50),
Album VARCHAR(50),
Artist VARCHAR(50),
ReleaseDate VARCHAR(10),
SongLength INT,
TimesPlayed INT
);

INSERT IGNORE INTO Songs (SongId, SongName, Album, Artist, ReleaseDate, SongLength, TimesPlayed)
VALUES
(0, 'SUPA DUPA LUV', 'WE GO UP', 'BABYMONSTER', '10-10-2025', 172, 23),
(1, 'Miniskirt', 'MINISKIRT', 'AOA', '16-01-2014', 179, 12),
(2, 'Elevator', 'Essence of Reverie', 'BAEKHYUN', '19-05-2025', 186, 4),
(3, 'Perfume', 'First Street', 'ToppDogg', '07-11-2016', 187, 6),
(4, 'intentions', 'alone tonight', 'starfall', '26-04-2024', 224, 7),
(5, 'Promise', 'Promise', 'JUNNY', '16-12-2023', 175, 4),
(6, 'Love, Maybe', 'DRIP', 'BABYMONSTER', '01-11-2024', 187, 5),
(7, 'Rainy Day', 'First Street', 'ToppDogg', '07-11-2016', 217, 2),
(8, 'venus', 'venus', 'Regina Song', '22-12-2023', 249, 10),
(9, 'DRIP', 'DRIP', 'BABYMONSTER', '01-11-2024', 180, 3),
(10, 'Spring Day', 'You Never Walk Alone', 'BTS', '13-02-2017', 274, 6),
(11, 'Off My Face', 'Justice', 'Justin Bieber', '19-03-2021', 156, 8),
(12, 'Marigold', 'Momentary Sixth Sense', 'Aimyon', '13-02-2019', 306, 14),
(13, 'Roses (ISA)', 'Metamorphic', 'STAYC', '01-07-2024', 161, 5),
(14, 'BILLIONAIRE', 'DRIP', 'BABYMONSTER', '01-11-2024', 157, 2),
(15, 'I WANT IT', 'I WANT IT', 'STAYC', '23-07-2025', 184, 16),
(16, 'DRIP', 'N/a', 'izna', '25-11-2024', 142, 3),
(17, 'again', 'Green Garden Pop', 'YUI', '05-12-2012', 255, 9);

CREATE TABLE Artists (
ArtistName VARCHAR(50) PRIMARY KEY,
Country VARCHAR(50),
Gender VARCHAR(6),
Followers INT
);

INSERT IGNORE INTO Artists
VALUES
('BABYMONSTER', 'Korea', 'Female', 5891697),
('AOA', 'Korea', 'Female', 879731),
('BAEKHYUN', 'Korea', 'Male', 2839554),
('ToppDogg', 'Korea', 'Male', 144650),
('starfall', 'United States of America', 'Male', 153326),
('JUNNY', 'Korea', 'Male', 427600),
('Regina Song', 'Singapore', 'Female', 156499),
('BTS', 'Korea', 'Male', 81261415),
('Justin Bieber', 'Canada', 'Male', 85122067),
('Aimyon', 'Japan', 'Female', 6011384),
('STAYC', 'Korea', 'Female', 2127175),
('izna', 'Korea', 'Female', 372275),
('YUI', 'Japan', 'Female', 593185);

-- creates a foreign key constraint
ALTER TABLE Songs
ADD CONSTRAINT fk_artist
FOREIGN KEY (Artist)
REFERENCES Artists(ArtistName);

SELECT *
FROM Songs;

SELECT * 
FROM Artists;

-- checks for my top 5 most streamed songs
SELECT SongName, TimesPlayed
FROM Songs
ORDER BY TimesPlayed DESC
LIMIT 5;

-- checks my top 3 most streamed artist
SELECT Artist, SUM(TimesPlayed) AS Streamed
FROM Songs
GROUP BY Artist
ORDER BY Streamed DESC
LIMIT 3;

-- checks the longest song duration for each artist
SELECT s.Artist, s.SongName, CONCAT(FLOOR(s.SongLength/60), ':', LPAD(s.SongLength%60, 2, '0')) AS SongDuration
FROM Songs s
WHERE s.SongLength IN (
SELECT MAX(s2.SongLength)
FROM Songs s2
WHERE s.Artist = s2.Artist
)
ORDER BY s.SongLength DESC;

-- list songs that are less than 3 minutes
SELECT Artist, SongName, CONCAT(FLOOR(SongLength/60), ':', LPAD(SongLength%60, 2, '0')) AS SongDuration
FROM Songs
WHERE FLOOR(SongLength/60) < 3
ORDER BY Artist;

-- checks for most popular korean female artist
SELECT *
FROM Artists
WHERE Gender = 'Female' 
AND Country = 'Korea'
GROUP BY ArtistName
ORDER BY Followers DESC
LIMIT 1;

-- checks average amount of followers among male artists
SELECT FLOOR(AVG(Followers)) AS AverageFollowers
FROM Artists
WHERE Gender = 'Male';

-- checks how many streams each country has
SELECT a.Country, SUM(s.TimesPlayed) AS Streams
FROM Artists a
JOIN Songs s 
ON a.ArtistName = s.Artist
GROUP BY a.Country
ORDER BY Streams DESC;

-- checks how many songs each female artist has
SELECT a.ArtistName, COUNT(*) AS Songs
FROM Artists a
JOIN Songs s
ON a.ArtistName = s.Artist
WHERE Gender = 'Female'
GROUP BY a.ArtistName
ORDER BY Songs DESC;

-- selects songs where the album has at least 2 words
SELECT SongId, SongName, Album
FROM Songs
WHERE Album LIKE '% %'
ORDER BY SongId;

-- create a view for korean female artists
CREATE VIEW FemaleKoreanArtists AS
SELECT a.ArtistName AS Artist, CONCAT(FLOOR(SUM(s.SongLength)/60), ':', LPAD(SUM(s.SongLength)%60, 2, '0')) AS TotalDuration, SUM(s.TimesPlayed) AS TotalStreams, a.Followers
FROM Artists a
JOIN Songs s 
ON a.ArtistName = s.Artist
WHERE a.Gender = 'Female'
AND a.Country = 'Korea'
GROUP BY a.ArtistName, a.Followers
ORDER BY a.Followers DESC;

SELECT *
FROM FemaleKoreanArtists;