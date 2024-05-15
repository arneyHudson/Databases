DROP TABLE IF EXISTS associated_with;
DROP TABLE IF EXISTS actor;
DROP TABLE IF EXISTS director;
DROP TABLE IF EXISTS recording;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS rating;

ALTER TABLE Director AUTO_INCREMENT = 0;
ALTER TABLE Rating AUTO_INCREMENT = 0;

CREATE TABLE Actor
(
  Actor_ID INT NOT NULL,
  Name VARCHAR(50) NOT NULL,
  Recording_ID INT NOT NULL,
  PRIMARY KEY (Actor_ID)
) 
ENGINE=INNODB;


CREATE TABLE Category
(
  Name VARCHAR(50) NOT NULL,
  Category_ID INT NOT NULL,
  PRIMARY KEY (Category_ID)
)
ENGINE=INNODB;

CREATE TABLE Director
(
  Name VARCHAR(50) NOT NULL,
  Director_ID INT AUTO_INCREMENT,
  PRIMARY KEY (Director_ID)
)
ENGINE=INNODB;

CREATE TABLE Rating
(
  Name VARCHAR(50) NOT NULL,
  Rating_ID INT AUTO_INCREMENT,
  PRIMARY KEY (Rating_ID)
)
ENGINE=INNODB;

CREATE TABLE Recording
(
  Recording_ID INT NOT NULL,
  Director VARCHAR(50) NOT NULL,
  Title VARCHAR(50) NOT NULL,
  Category VARCHAR(50) NOT NULL,
  Image_Name VARCHAR(50) NOT NULL,
  Duration INT NOT NULL,
  Rating VARCHAR(10) NOT NULL,
  Year_Released INT NOT NULL,
  Price DOUBLE NOT NULL,
  Stock_Count INT NOT NULL,
  PRIMARY KEY (Recording_ID)
)
ENGINE=INNODB;

-- ------------------------------------------------------------------------------------------------

CREATE TABLE Associated_With
(
  Recording_ID INT NOT NULL,
  Actor_ID INT NOT NULL,
  PRIMARY KEY (Recording_ID, Actor_ID),
  FOREIGN KEY (Recording_ID) REFERENCES Recording(Recording_ID),
  FOREIGN KEY (Actor_ID) REFERENCES Actor(Actor_ID)
)
ENGINE=INNODB;

-- ------------------------------------------------------------------------------------------------

-- Populate Actor table
INSERT INTO Actor (Actor_ID, Name, Recording_ID)
SELECT DISTINCT Actor_ID, Name, Recording_ID
FROM video_actors;

-- Populate Recording table
INSERT INTO Recording (Recording_ID, Director, Title, Category, Image_Name, Duration, Rating, Year_Released, Price, Stock_Count)
SELECT DISTINCT Recording_ID, Director, Title, Category, Image_Name, Duration, Rating, Year_Released, Price, Stock_Count
FROM video_recordings;

INSERT INTO Category (Category_ID, Name)
SELECT DISTINCT Category_ID, Name
FROM video_categories;

INSERT INTO Director (Name)
SELECT DISTINCT TRIM(Director)
FROM video_recordings;

INSERT INTO Rating (Name)
SELECT DISTINCT TRIM(Rating)
FROM video_recordings;

INSERT INTO Associated_With (Recording_ID, Actor_ID)
SELECT Recording_ID, Actor_ID
FROM Actor;

