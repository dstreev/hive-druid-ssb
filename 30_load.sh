#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

BEELINE="beeline -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u '${HS2}'"

###################
# Process currently fails while creating druid table.
###################
# echo "-------------------"
# echo "   Create and Load Druid Cubes "
# echo "-------------------"

SOURCE=ssb_${SCALE}_orc

#${BEELINE} --hivevar SOURCE=${SOURCE} -f queries.druid/index_ssb.sql
