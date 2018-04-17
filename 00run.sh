#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

BEELINE="beeline --hivevar SCALE=${SCALE} -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u ${HS2}

$BEELINE -f queries.druid/allqueries.sql
