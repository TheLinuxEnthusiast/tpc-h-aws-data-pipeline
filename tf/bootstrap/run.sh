#!/bin/bash

sudo yum update
sudo yum install -y postgresql
sudo yum install -y telnet

mkdir -p /home/ec2-user/data/
mkdir -p /home/ec2-user/sql

aws s3 cp s3://tpc-h-raw-data-df/raw/customer.tbl data/
aws s3 cp s3://tpc-h-raw-data-df/raw/lineitem.tbl data/
aws s3 cp s3://tpc-h-raw-data-df/raw/nation.tbl data/
aws s3 cp s3://tpc-h-raw-data-df/raw/orders.tbl	data/
aws s3 cp s3://tpc-h-raw-data-df/raw/part.tbl data/
aws s3 cp s3://tpc-h-raw-data-df/raw/partsupp.tbl data/
aws s3 cp s3://tpc-h-raw-data-df/raw/region.tbl data/
aws s3 cp s3://tpc-h-raw-data-df/raw/supplier.tbl data/



