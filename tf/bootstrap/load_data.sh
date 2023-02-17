#!/bin/bash

export PGPASSWORD="${1}"
DATABASE_HOST="${2}"
DATABASE_NAME="tpchdb01"
DATABASE_USER="awsuser"
DATABASE_PORT="5432"

# Example client call
#psql -h tpch20230216213159024400000001.cxc3hxjomrkf.eu-west-1.rds.amazonaws.com -U awsuser -d tpchdb01 -p 5432

load_data_file() {
	
	psql -h ${2} \
		-d ${DATABASE_NAME} -U ${DATABASE_USER} -p ${DATABASE_PORT} \
		-c "DELETE FROM production.${1};" \
		-c "\copy production.${1} FROM '/home/ec2-user/data/${1}.tbl' WITH DELIMITER AS '|'"

}

main() {

	load_data_file "customer" "${1}"
	load_data_file "lineitem" "${1}"
	load_data_file "nation" "${1}"
	load_data_file "orders" "${1}"
	load_data_file "partsupp" "${1}"
	load_data_file "part" "${1}"
	load_data_file "region" "${1}"
	load_data_file "supplier" "${1}"
	
}
main "${DATABASE_HOST}"
