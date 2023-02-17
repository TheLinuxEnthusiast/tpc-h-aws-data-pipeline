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
drop table if exists production.customer;
drop table if exists production.lineitem;
drop table if exists production.nation;
drop table if exists production.orders;
drop table if exists production.partsupp;
drop table if exists production.part;
drop table if exists production.region;
drop table if exists production.supplier;



CREATE TABLE IF NOT EXISTS production.region (
	"regionkey" integer not null primary key,
	"name" varchar(255),
	"comment" varchar(255),
	"desc" varchar(10)
);

CREATE TABLE IF NOT EXISTS production.nation (
	"nationkey" integer not null primary key,
	"name" varchar(255),
	"regionkey" integer,
	"comment" varchar(255),
	"desc" varchar(10)
);

CREATE TABLE IF NOT EXISTS production.supplier (
	"suppkey" integer not null primary key,
	"name" varchar(255),
	"address" varchar(255),
	"nationkey" integer,
	"phone" varchar(255),
	"acctbal" varchar(255),
	"comment" varchar(255),
	"desc" varchar(10)
);

CREATE TABLE IF NOT EXISTS production.customer (
	"custkey" integer not null primary key,
	"name" varchar(255),
	"address" varchar(255),
	"nationkey" integer ,
	"phone" varchar(255),
	"accbal" varchar(255),
	"mktsegment" varchar(255),
	"comment" varchar(255),
	"desc" varchar(10)
);

CREATE TABLE IF NOT EXISTS production.orders (
	"orderkey" integer not null primary key,
	"custkey" integer,
	"orderstatus" varchar(255),
	"totalprice" varchar(255),
	"orderdate" varchar(255),
	"orderpriority" varchar(255),
	"clerk" varchar(255),
	"shippriority" varchar(255),
	"comment" varchar(255),
	"desc" varchar(10)
);

CREATE TABLE IF NOT EXISTS production.part (
	"partkey" integer not null primary key,
	"name" varchar(255),
	"mfgr" varchar(255),
	"brand" varchar(255),
	"type" varchar(255),
	"size" varchar(255),
	"container" varchar(255),
	"retailprice" varchar(255),
	"comment" varchar(255),
	"desc" varchar(10)
);

CREATE TABLE IF NOT EXISTS production.partsupp (
	"partkey" integer,
	"suppkey" integer,
	"availqty" varchar(255),
	"supplycost" varchar(255),
	"comment" varchar(255),
	"desc" varchar(10),
	PRIMARY KEY(partkey, suppkey)
);


CREATE TABLE IF NOT EXISTS production.lineitem (
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
	"desc" varchar(10),
	PRIMARY KEY(orderkey, partkey, suppkey, linenumber)
);




