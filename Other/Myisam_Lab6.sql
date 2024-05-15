SET GLOBAL local_infile=1;

/*
# record variables
SHOW VARIABLES LIKE 'max_heap_table_size';
# 16777216
SHOW VARIABLES LIKE 'tmp_table_size';
# 87031808

select @@max_heap_table_size;
# 16777216
select @@tmp_table_size;
# 87031808
*/
# set global heap size to 2G
set @@max_heap_table_size=1024 * 1024 * 1024 * 2;
# 2147483648
set @@tmp_table_size=1024 * 1024 * 1024 * 2;

/*
select @@max_heap_table_size;
# 2147483648
select @@tmp_table_size;
# 2147483648

#set @@max_heap_table_size=1024 * 1024 * 16;
#set @@max_heap_table_size=1024 * 1024 * 16;
*/
SET GLOBAL tmp_table_size = 1024 * 1024 * 1024 * 2;
SET GLOBAL max_heap_table_size = 1024 * 1024 * 1024 * 2;


# create gene_info
drop table if exists gene_info; 
create table gene_info ( 
tax_id int, 
GeneID int, 
Symbol varchar(48), 
LocusTag varchar(48), 
Synonyms varchar(1000), 
dbXrefs varchar(512), 
chromosome varchar(48), 
map_location varchar(48), 
description varchar(4000), 
type_of_gene varchar(48), 
Symbol_from_nomenclature_authority varchar(64), 
Full_name_from_nomenclature_authority varchar(256), 
Nomenclature_status varchar(24), 
Other_designations varchar(4000),
Modification_date varchar(24)) ENGINE=MYISAM; 

# load
#Load Data local Infile 

Load Data local Infile 
'C:/Users/arneyh/OneDrive - Milwaukee School of Engineering/Current Classes/CSC 3320 - Databases/Labs/Lab 6/files/gene_info50000.csv' into table 
genomics.gene_info fields terminated by ',' lines terminated by '\n' ignore 1 lines; 

# note the number of records loaded

# verify
desc gene_info;
select * from gene_info order by tax_id;

drop table if exists gene2pubmed; 
create table gene2pubmed ( 
tax_id int, 
GeneID int, 
PMID int)  ENGINE=MYISAM;

Load Data local Infile 
'C:/Users/arneyh/OneDrive - Milwaukee School of Engineering/Current Classes/CSC 3320 - Databases/Labs/Lab 6/files/gene2pubmed' into table 
genomics.gene2pubmed fields terminated by '\t' lines terminated by '\n' IGNORE 1 LINES; 
# this takes a while

# note the number of records loaded

# verify
desc gene2pubmed;
select * from gene2pubmed limit 100;

# note row count
select count(*) from gene_info;
select count(*) from gene2pubmed;


#####################################################
# Q1 - join
# first, set profiling on
SET @@profiling = 0;
SET @@profiling_history_size = 0;
SET @@profiling_history_size = 10;
SET @@profiling = 1;
select * 
from gene_info gi, gene2pubmed gp 
where gi.geneid=gp.geneid 
and gi.geneid=4126706;
# list each query with duration 
show profiles;

# note execution time, you should compare it to the final time for Q1 in your observations. 

# analyze query plan
explain select * 
from gene_info gi, gene2pubmed gp 
where gi.geneid=gp.geneid 
and gi.geneid=4126706; # 1047684

select * 
from gene_info gi, gene2pubmed gp 
where gi.geneid=gp.geneid 
and gi.geneid=4126706; 

# note what keys are being used and the number of rows accessed from each table


#lets try adding primary keys 
alter table gene_info add constraint primary key (geneid);

alter table gene2pubmed add constraint primary key (pmid, geneid);

# note the time to create each primary key

# re-execute the same query

SET @@profiling = 0;
SET @@profiling_history_size = 0;
SET @@profiling_history_size = 10;
SET @@profiling = 1;

select * 
from gene_info gi, gene2pubmed gp
where gi.geneid=gp.geneid
and gi.geneid=4126706;

show profiles;

# note execution time (but this doesn't go in table for Q1) 
# you should compare it to the final time for Q1 in your observations

# analyze query plan
explain select * 
from gene_info gi, gene2pubmed gp
where gi.geneid=gp.geneid
and gi.geneid=4126706;

# record what keys are being used and the number of rows accessed from each table

# record your observations! Why is the PK not being used for gene2pubmed??

# lets re-create the gene2pubmed PK based on join criteria.


alter table gene2pubmed drop primary key;
alter table gene2pubmed add constraint primary key (geneid, pmid);

# re-execute the same query
SET @@profiling = 0;
SET @@profiling_history_size = 0;
SET @@profiling_history_size = 10;
SET @@profiling = 1;

-----
select * 
from gene_info gi, gene2pubmed gp 
where gi.geneid=gp.geneid 
and gi.geneid=4126706;

show profiles;

# note execution time (record this time for the table for Q1)

# analyze query plan
explain select * 
from gene_info gi, gene2pubmed gp 
where gi.geneid=gp.geneid 
and gi.geneid=4126706;

# note what keys are being used and the number of rows accessed from each table

# record your observations

####################################################################

# Q2 - restriction
SET @@profiling = 0;
SET @@profiling_history_size = 0;
SET @@profiling_history_size = 10;
SET @@profiling = 1;

select * 
from gene_info gi 
where gi.locustag='p49879_1p15';
show profiles;

# note execution time, you should compare it to the final time for Q2 in your observations. 

# analyze query plan
explain select * 
from gene_info gi
where gi.locustag='p49879_1p15';

# note what keys are being used and the number of rows accessed from each table


# create index
create index gene_info_locustag on gene_info( locustag );

# note this time
/*
# re-execute the query

SET @@profiling = 0;
SET @@profiling_history_size = 0;
SET @@profiling_history_size = 10;
SET @@profiling = 1;

select * 
from gene_info gi 
where gi.locustag='p49879_1p15';
show profile;

# note execution time (record this time for the table for Q2)
*/
# analyze query plan
explain select * 
from gene_info gi
where gi.locustag='p49879_1p15';

# note what keys are being used and the number of rows accessed from each table

# record your observations


####################################################################

# Q3 - range query
SET @@profiling = 0;
SET @@profiling_history_size = 0;
SET @@profiling_history_size = 10;
SET @@profiling = 1;

select * 
from gene_info
where geneid between '5961931' and '5999886';
show profiles;

# note execution time (record this time for the table for Q3)

# analyze query plan
explain select * 
from gene_info
where geneid between '5961931' and '5999886';

# note what keys are being used and the number of rows accessed from each table

# record your observations

####################################################################

# Q4 - insert
SET @@profiling = 0;
SET @@profiling_history_size = 0;
SET @@profiling_history_size = 10;
SET @@profiling = 1;
insert into gene2pubmed values (9606, 5555, 6666);
show profiles;

# note execution time (record this time for the table for Q4)

# analyze query plan
explain insert into gene2pubmed values (9606, 5555, 6666);

# note what keys are being used and the number of rows accessed from each table

# record your observations

####################################################################

# Q5 - update
SET @@profiling = 0;
SET @@profiling_history_size = 0;
SET @@profiling_history_size = 10;
SET @@profiling = 1;
update gene_info set locustag='No Locus Tag' where locustag='-';
show profiles;

# note execution time (record this time for the table for Q5)

# analyze query plan
explain update gene_info set locustag='No Locus Tag' where locustag='-';

# note what keys are being used and the number of rows accessed from each table

# record your observations

# make sure to drop both tables before moving on to recreate the tables with a different
# indexing method