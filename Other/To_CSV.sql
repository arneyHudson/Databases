SELECT * FROM portfolio
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/portfolio.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

