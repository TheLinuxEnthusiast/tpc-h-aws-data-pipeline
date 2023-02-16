#!/bin/bash

export PGPASSWORD="$1"

load_data_file() {
	
	psql -h localhost \
		-d dwhuser -U dwhuser -p 5432 \
		-c "DELETE FROM staging.stg_${1};" \
		-c "\copy staging.stg_${1} FROM 'tpch-dbgen/${1}.tbl' WITH DELIMITER AS '|'"

	
}

main() {
	load_data_file "customer"
	load_data_file "lineitem"
	load_data_file "nation"
	load_data_file "orders"
	load_data_file "partsupp"
	load_data_file "part"
	load_data_file "region"
	load_data_file "supplier"
	
}
main
