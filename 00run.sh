#!/bin/sh

TARGET=${1:-localhost:10000}
HIVE_USER=${2:-$USER}
HIVE_PASSWORD=${3:-hortonworks}

BEELINE="beeline -n $HIVE_USER -p $HIVE_PASSWORD -u jdbc:hive2://${TARGET}/default"

$BEELINE -f queries.druid/allqueries.sql
