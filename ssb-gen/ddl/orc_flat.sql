use ssb_${SCALE}_flat_orc;

drop table customer;
drop table dates;
drop table part;
drop table supplier;
drop table lineorder;
create table customer stored as orc as select * from ${SOURCE}.customer ;
create table dates stored as orc as select * from ${SOURCE}.dates;
create table part stored as orc as select * from ${SOURCE}.part ;
create table supplier stored as orc as select * from ${SOURCE}.supplier ;
create table lineorder stored as orc as select * from ${SOURCE}.lineorder;
