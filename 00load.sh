#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

SOURCE=ssb_${SCALE}_flat_orc
TYPE=FLAT

BEELINE="beeline -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u '${HS2}'"

echo "-------------------"
echo "   Create and Load Druid Cubes (orc flat)"
echo "-------------------"
SOURCE=ssb_${SCALE}_flat_orc
TYPE=FLAT
exec ${BEELINE} --hivevar SOURCE=${SOURCE} --hivevar TYPE=${TYPE} -f queries.druid/index_ssb.sql

echo "-------------------"
echo "   Create and Load Druid Cubes (orc non-flat)"
echo "-------------------"
SOURCE=ssb_${SCALE}_orc
TYPE=NON_FLAT
exec ${BEELINE} --hivevar SOURCE=${SOURCE} --hivevar TYPE=${TYPE} -f queries.druid/index_ssb.sql
