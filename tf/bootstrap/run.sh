#!/bin/bash

sudo yum update -y
sudo yum install -y telnet
sudo yum install -y amazon-linux-extras
sudo amazon-linux-extras install postgresql10

mkdir -p /home/ec2-user/data/
mkdir -p /home/ec2-user/sql

sudo aws s3 cp s3://tpc-h-raw-data-df/raw/customer.tbl data/
sudo aws s3 cp s3://tpc-h-raw-data-df/raw/lineitem.tbl data/
sudo aws s3 cp s3://tpc-h-raw-data-df/raw/nation.tbl data/
sudo aws s3 cp s3://tpc-h-raw-data-df/raw/orders.tbl	data/
sudo aws s3 cp s3://tpc-h-raw-data-df/raw/part.tbl data/
sudo aws s3 cp s3://tpc-h-raw-data-df/raw/partsupp.tbl data/
sudo aws s3 cp s3://tpc-h-raw-data-df/raw/region.tbl data/
sudo aws s3 cp s3://tpc-h-raw-data-df/raw/supplier.tbl data/

sudo aws s3 cp s3://tpc-h-raw-data-df/sql/tables.sql sql/
sudo aws s3 cp s3://tpc-h-raw-data-df/sql/load_data.sh sql/










