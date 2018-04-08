#!/bin/sh

TARGET=${1:-localhost:10000}
HIVE_USER=${2:-$USER}
HIVE_PASSWORD_FILE=${3:-.hive_password}

BEELINE="beeline -n $HIVE_USER -w $HIVE_PASSWORD_FILE -u jdbc:hive2://${TARGET}/default"

$BEELINE -f queries.druid/allqueries.sql
