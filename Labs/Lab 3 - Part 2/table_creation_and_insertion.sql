-- Drop tables if they exist in the video schema
DROP TABLE IF EXISTS video.Video_Actors;
DROP TABLE IF EXISTS video.Video_Categories;
DROP TABLE IF EXISTS video.Video_Recordings;

-- Create Video_Recordings table in the video schema
CREATE TABLE video.Video_Recordings (
    Recording_ID int,
    Director varchar(50),
    Title varchar(50),
    Category varchar(50),
    Image_Name varchar(50),
    Duration int,
    Rating varchar(10),
    Year_Released int,
    Price double,
    Stock_Count int,
    primary key (Recording_ID)
);

-- Create Video_Categories table in the video schema
CREATE TABLE video.Video_Categories (
    Category_ID int,
    Name varchar(50),
    primary key (Category_ID)
);

-- Create Video_Actors table in the video schema
CREATE TABLE video.Video_Actors (
    Actor_ID int,
    Name varchar(70),
    Recording_ID int,
    primary key (Actor_ID)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\arneyh\\OneDrive - Milwaukee School of Engineering\\CSC 3320 - Databases\\Labs\\Lab 3\\videodb2022\\Video_Recordings.txt'
INTO TABLE video.Video_Recordings
FIELDS TERMINATED BY '\t'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA LOCAL INFILE 'C:\\Users\\arneyh\\OneDrive - Milwaukee School of Engineering\\CSC 3320 - Databases\\Labs\\Lab 3\\videodb2022\\Video_Categories.txt'
INTO TABLE video.Video_Categories
FIELDS TERMINATED BY '\t'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA LOCAL INFILE 'C:\\Users\\arneyh\\OneDrive - Milwaukee School of Engineering\\CSC 3320 - Databases\\Labs\\Lab 3\\videodb2022\\Video_Actors.txt'
INTO TABLE video.Video_Actors
CHARACTER SET latin1
FIELDS TERMINATED BY '\t'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';