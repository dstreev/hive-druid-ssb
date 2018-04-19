#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

BEELINE="beeline -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u '${HS2}'"


echo "-------------------"
echo "   Build Bulk Output"
echo "-------------------"
${BEELINE} --hivevar SOURCE=ssb_${SCALE}_flat_orc --hivevar SCALE=${SCALE} -f queries.druid/consolidated-to-csv.sql

