#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

BEELINE="beeline -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u '${HS2}'"

echo "-------------------"
echo "   Create and Load Druid Cubes (orc flat)"
echo "-------------------"

SOURCE=ssb_${SCALE}_flat_orc

#${BEELINE} --hivevar SOURCE=${SOURCE} -f queries.druid/index_ssb.sql

# echo "-------------------"
# echo "   Create and Load Druid Cubes (orc non-flat)"
# echo "-------------------"

SOURCE=ssb_${SCALE}_orc

# Process currently fails while creating druid table.
#${BEELINE} --hivevar SOURCE=${SOURCE} -f queries.druid/index_ssb2.sql
