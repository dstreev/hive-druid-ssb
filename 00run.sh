#!/bin/sh

TARGET=${1:-localhost:10000}
BEELINE="beeline -u jdbc:hive2://${TARGET}/default"

$BEELINE -f queries.druid/allqueries.sql
