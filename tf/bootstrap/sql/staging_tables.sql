CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS production;

/*
customer.tbl 
lineitem.tbl 
nation.tbl 
orders.tbl 
partsupp.tbl  
part.tbl 
region.tbl 
supplier.tbl
*/
drop table if exists staging.stg_customer;
drop table if exists staging.stg_lineitem;
drop table if exists staging.stg_nation;
drop table if exists staging.stg_orders;
drop table if exists staging.stg_partsupp;
drop table if exists staging.stg_part;
drop table if exists staging.stg_region;
drop table if exists staging.stg_supplier;


CREATE TABLE IF NOT EXISTS staging.stg_customer (
	"custkey" integer primary key,
	"name" varchar(255),
	"address" varchar(255),
	"nationkey" varchar(255),
	"phone" varchar(255),
	"accbal" varchar(255),
	"mktsegment" varchar(255),
	"comment" varchar(255),
	"x" varchar(10)
);
CREATE TABLE IF NOT EXISTS staging.stg_lineitem (
	"orderkey"  integer,
	"partkey" integer,
	"suppkey" integer,
	"linenumber" integer,
	"quantity" varchar(255),
	"extendedprice" varchar(255),
	"discount" varchar(255),
	"tax" varchar(255),
	"returnflag" varchar(255),
	"linestatus" varchar(255),
	"shipdate" varchar(255),
	"commitdate" varchar(255),
	"receiptdate" varchar(255),
	"shipinstruct" varchar(255),
	"shipmode" varchar(255),
	"comment" varchar(255),
	"x" varchar(10),
	PRIMARY KEY(orderkey, partkey, suppkey, linenumber)
);
CREATE TABLE IF NOT EXISTS staging.stg_nation (
	"nationkey" integer primary key,
	"name" varchar(255),
	"regionkey" integer,
	"comment" varchar(255),
	"x" varchar(10)
);
CREATE TABLE IF NOT EXISTS staging.stg_orders (
	"orderkey" integer primary key,
	"custkey" integer,
	"orderstatus" varchar(255),
	"totalprice" varchar(255),
	"orderdate" varchar(255),
	"orderpriority" varchar(255),
	"clerk" varchar(255),
	"shippriority" varchar(255),
	"comment" varchar(255),
	"x" varchar(10)
);
CREATE TABLE IF NOT EXISTS staging.stg_partsupp (
	"partkey" integer,
	"suppkey" integer,
	"availqty" varchar(255),
	"supplycost" varchar(255),
	"comment" varchar(255),
	"x" varchar(10),
	PRIMARY KEY(partkey, suppkey)
);
CREATE TABLE IF NOT EXISTS staging.stg_part (
	"partkey" integer primary key,
	"name" varchar(255),
	"mfgr" varchar(255),
	"brand" varchar(255),
	"type" varchar(255),
	"size" varchar(255),
	"container" varchar(255),
	"retailprice" varchar(255),
	"comment" varchar(255),
	"x" varchar(10)
);
CREATE TABLE IF NOT EXISTS staging.stg_region (
	"regionkey" integer primary key,
	"name" varchar(255),
	"comment" varchar(255),
	"x" varchar(10)
);
CREATE TABLE IF NOT EXISTS staging.stg_supplier (
	"suppkey" integer primary key,
	"name" varchar(255),
	"address" varchar(255),
	"nationkey" integer,
	"phone" varchar(255),
	"acctbal" varchar(255),
	"comment" varchar(255),
	"x" varchar(10)
);

-------------------------
-- \copy is used to load files from local file system
/*customer.tbl 
lineitem.tbl 
nation.tbl 
orders.tbl 
partsupp.tbl  
part.tbl 
region.tbl 
supplier.tbl
*/

delete from staging.stg_customer;
delete from staging.stg_lineitem;
delete from staging.stg_nation;
delete from staging.stg_orders;
delete from staging.stg_partsupp;
delete from staging.stg_part;
delete from staging.stg_region;
delete from staging.stg_supplier;


------------------------

select count(*) from staging.stg_customer;
select count(*) from staging.stg_lineitem;
select count(*) from staging.stg_nation;
select count(*) from staging.stg_orders;
select count(*) from staging.stg_partsupp;
select count(*) from staging.stg_part;
select count(*) from staging.stg_region;
select count(*) from staging.stg_supplier;





-----------------
SELECT 
   table_name, 
   column_name, 
   data_type 
FROM 
   information_schema.columns
WHERE 
   table_name in ('dimgeography', 'stg_nation', 'stg_region','stg_supplier')
   order by column_name;

