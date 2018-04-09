#!/bin/sh

HSI=${1:-"jdbc:hive2://localhost:10000/default"}
HIVE_USER=${2:-$USER}
HIVE_PASSWORD_FILE=${3:-.hive_password}

BEELINE="beeline -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u ${HSI}

$BEELINE -f queries.druid/allqueries.sql
