#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

BEELINE="beeline -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u '${HS2}'"

echo "-------------------"
echo "   Define Ext Druid Bulk SSB"
echo "-------------------"
SCALE=bulk
${BEELINE} --hivevar SCALE=${SCALE} -f queries.druid/ext_druid_ssb_def.sql
