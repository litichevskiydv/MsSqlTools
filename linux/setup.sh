#!/bin/bash

/opt/mssql/bin/sqlservr --force-setup -q $MSSQL_COLLATION &
pid=$!

FILE_TO_WATCH=/var/opt/mssql/log/errorlog
SEARCH_PATTERN="Recovery is complete"

cat $FILE_TO_WATCH | grep -qe "$SEARCH_PATTERN"
while [[ $? != 0 ]]; do
	sleep 1
	cat $FILE_TO_WATCH | grep -qe "$SEARCH_PATTERN"
done

kill -9 $pid