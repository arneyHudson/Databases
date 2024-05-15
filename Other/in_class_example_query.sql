# hello
CREATE TABLE admitsource(
ID int, 
Code char(1),
Name varchar(50),
primary key(ID))
engine MEMORY;

drop table admitsource;
drop table chr_train;

INSERT INTO admitsource(ID, Code, Name) values (9, 
'B', "Transfer from student rehab");

select * from admitsource;

DELETE FROM admitsource