#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

TYPE=FLAT

BEELINE="beeline --hivevar SCALE=${SCALE} --hivevar TYPE=${TYPE} -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u '${HS2}'"

${BEELINE} -f queries.druid/allqueries.sql

# TYPE=NON_FLAT
#
# BEELINE="beeline --hivevar SCALE=${SCALE} --hivevar TYPE=${TYPE} -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u '${HS2}'"
#
# ${BEELINE} -f queries.druid/allqueries.sql
