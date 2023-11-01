CREATE DATABASE TASK_2NOV
USE TASK_2NOV

CREATE TABLE Genders(
Id INT PRIMARY KEY IDENTITY,
Gender NVARCHAR(25)
)

INSERT INTO Genders VALUES
('Male'),
('Female')

CREATE TABLE Users(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(25) NOT NULL,
Username VARCHAR(25) UNIQUE NOT NULL,
Password VARCHAR(50) NOT NULL,
GenderId INT REFERENCES Genders(Id)
)

INSERT INTO Users VALUES
('Nigar','nigarglm','nigar123',1),
('Zulfiyye','zuzu','zuzu123',2),
('Sabuhi','sabuhi','sabuhi123',1)


CREATE TABLE Artists(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(25) NOT NULL,
Surname NVARCHAR(25) NOT NULL,
Birthday VARCHAR(10) NOT NULL,
GenderId INT REFERENCES Genders(Id)
)


INSERT INTO Artists VALUES
('Aygun','Kazimova','26.01.1971',2),
('Roya','Ayxan','14.06.1982',1)

CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(25) NOT NULL
)

INSERT INTO Categories VALUES
('Pop'),
('Slow')


CREATE TABLE Musics(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(100) NOT NULL,
Duration INT CHECK (Duration>0),
CategoryId INT REFERENCES Categories(Id)
)

INSERT INTO Musics VALUES
('Parol',307,1),
('Sene gore',445,2)

CREATE TABLE MusicArtist(
MusicId INT REFERENCES Musics(Id),
ArtistId INT REFERENCES Artists(Id)
)

INSERT INTO MusicArtist VALUES
(1,1),
(2,2)


CREATE TABLE UserMusics(
UserId INT REFERENCES Users(Id),
MusicId INT REFERENCES Musics(Id)
)

INSERT INTO UserMusics VALUES (1,1),(2,2)

CREATE VIEW MusicLibary
AS
SELECT m.Name Music,m.Duration,c.Name Category,a.Name+' '+a.Surname Artist FROM Musics m
JOIN Categories c
ON m.CategoryId=c.Id
JOIN MusicArtist ma
ON m.Id=ma.MusicId
JOIN Artists a
ON ma.ArtistId=a.Id

CREATE VIEW Playlist
AS
SELECT u.Id, u.Username,m.Name, a.Name Artist FROM UserMusics um
JOIN Users u
ON um.UserId=u.Id
JOIN Musics m
ON um.MusicId=m.Id
JOIN MusicArtist ma
ON ma.MusicId=m.Id
JOIN Artists a
ON ma.ArtistId=a.Id

SELECT * FROM MusicLibary

SELECT * FROM Playlist

--TASK2.1

CREATE PROCEDURE usp_CreateMusic @MusicName VARCHAR(150), @MusicDuration INT, @CategoryId INT
AS
INSERT INTO Musics VALUES
(@MusicName, @MusicDuration, @CategoryId)
EXEC usp_CreateMusic 'thank u, next',307,1


CREATE PROCEDURE usp_CreateUser @Name VARCHAR(25), @UserName VARCHAR(25), @Password VARCHAR(8), @GenderId INT
AS
INSERT INTO Users VALUES
(@Name,@UserName,@Password,@GenderId)
EXEC usp_CreateUser 'Nigar','Nigarglm','glm*123',2


CREATE PROCEDURE usp_CreateCategory @Name VARCHAR(25)
AS
INSERT INTO Categories VALUES
(@Name)
EXEC usp_CreateCategory 'POP'


--TASK 2.2


ALTER TABLE Musics ADD IsDeleted BIT DEFAULT 0

CREATE TRIGGER delete_music_trigger ON Musics
INSTEAD OF DELETE
AS
DECLARE @Result BIT
DECLARE @Id INT
SELECT @Result = IsDeleted, @Id=Deleted.Id FROM DELETED
IF (@Result=0)
  BEGIN
  UPDATE Musics SET IsDeleted=1 WHERE Id=@Id
  END
ELSE
  BEGIN
  DELETE FROM Musics WHERE Id=@Id
  END



--TASK2.3

CREATE FUNCTION GetArtistCount(@UserId INT)
RETURNS INT
BEGIN
DECLARE @Result INT
SELECT @Result = COUNT(Artist) FROM Playlist
WHERE Id=@UserId
RETURN @Result
END

SELECT dbo.GetArtistCount(1) AS COUNT



