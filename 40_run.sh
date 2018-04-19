#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

BEELINE="beeline -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u '${HS2}'"

#${BEELINE} --hivevar SCALE=${SCALE} -f queries.druid/allqueries.sql

SCALE=bulk

${BEELINE} --hivevar SCALE=${SCALE} -f queries.druid/allqueries.sql

