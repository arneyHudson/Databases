###############################
# CSC 3320
# data analytics lab load script to read script
# imports csv stock quotes from finance.yahoo.com

###############################

create database data_analytics_2017;

use data_analytics_2017;

# ï»¿Date	Open	High	Low	Close	Volume
drop table IF EXISTS spy;
create table spy(
date date,	 
open float,	
high float,	
low float,
close float,	
volume float
);

load data local infile "C:/Users/arneyh/OneDrive - Milwaukee School of Engineering/CSC 3320 - Databases/Labs/Lab 5/LabStockAnalytics/spy_10042017.csv" 
into table spy fields terminated by ',' lines terminated by '\n' ignore 1 lines
(@datevar, @openvar, @highvar, @lowvar, @closevar, volume)
SET date = STR_TO_DATE(@datevar, '%d-%M-%y'),
open = ROUND(@openvar, 2),
high = ROUND(@highvar, 2),  
low = ROUND(@lowvar, 2), 
close = ROUND(@closevar, 2);

show warnings;

select * from spy;

###############################

drop table IF EXISTS goog;
create table goog(
date date,	 
open float,	
high float,	
low float,
close float,	
volume float
);

load data local infile "C:/Users/arneyh/OneDrive - Milwaukee School of Engineering/CSC 3320 - Databases/Labs/Lab 5/LabStockAnalytics/goog_10042017.csv" 
into table goog fields terminated by ',' lines terminated by '\n' ignore 1 lines
(@datevar, @openvar, @highvar, @lowvar, @closevar, volume)
SET date = STR_TO_DATE(@datevar, '%d-%M-%y'),
open = ROUND(@openvar, 2),
high = ROUND(@highvar, 2),  
low = ROUND(@lowvar, 2), 
close = ROUND(@closevar, 2);

show warnings;

select * from goog;

###############################

drop table if exists celg;
create table celg(
date date,	 
open float,	
high float,	
low float,
close float,	
volume float
);

load data local infile "C:/Users/arneyh/OneDrive - Milwaukee School of Engineering/CSC 3320 - Databases/Labs/Lab 5/LabStockAnalytics/celg_10042017.csv" 
into table celg fields terminated by ',' lines terminated by '\n' ignore 1 lines
(@datevar, @openvar, @highvar, @lowvar, @closevar, volume)
SET date = STR_TO_DATE(@datevar, '%d-%M-%y'),
open = ROUND(@openvar, 2),
high = ROUND(@highvar, 2),  
low = ROUND(@lowvar, 2), 
close = ROUND(@closevar, 2);

show warnings;

select * from celg;

###############################

drop table IF EXISTS nvda;
create table nvda(
date date,	 
open float,	
high float,	
low float,
close float,	
volume float
);

load data local infile "C:/Users/arneyh/OneDrive - Milwaukee School of Engineering/CSC 3320 - Databases/Labs/Lab 5/LabStockAnalytics/nvda_10042017.csv" 
into table nvda fields terminated by ',' lines terminated by '\n' ignore 1 lines
(@datevar, @openvar, @highvar, @lowvar, @closevar, volume)
SET date = STR_TO_DATE(@datevar, '%d-%M-%y'),
open = ROUND(@openvar, 2),
high = ROUND(@highvar, 2),  
low = ROUND(@lowvar, 2), 
close = ROUND(@closevar, 2);

show warnings;

select * from nvda;

###############################

drop table IF EXISTS fb;
create table fb(
date date,	 
open float,	
high float,	
low float,
close float,	
volume float
);

load data local infile "C:/Users/arneyh/OneDrive - Milwaukee School of Engineering/CSC 3320 - Databases/Labs/Lab 5/LabStockAnalytics/fb_10042017.csv" 
into table fb fields terminated by ',' lines terminated by '\n' ignore 1 lines
(@datevar, @openvar, @highvar, @lowvar, @closevar, volume)
SET date = STR_TO_DATE(@datevar, '%d-%M-%y'),
open = ROUND(@openvar, 2),
high = ROUND(@highvar, 2),  
low = ROUND(@lowvar, 2), 
close = ROUND(@closevar, 2);

show warnings;

select * from fb;
