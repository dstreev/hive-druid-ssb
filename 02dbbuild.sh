#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

BEELINE="beeline -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u '${HS2}'"

${BEELINE} -e "create database if not exists ssb_${SCALE}_raw; create database if not exists ssb_${SCALE}_flat_orc;create database if not exists ssb_${SCALE}_orc;"

echo "-------------------"
echo "   Define RAW Tables"
echo "-------------------"
${BEELINE} --hivevar LOCATION=/tmp/ssb/${SCALE} --hivevar SCALE=${SCALE} -f ssb-gen/ddl/text.sql

echo "-------------------"
echo "   Build ORC Flat Tables"
echo "-------------------"
${BEELINE} --hivevar SOURCE=ssb_${SCALE}_raw --hivevar SCALE=${SCALE} -f ssb-gen/ddl/orc_flat.sql

echo "-------------------"
echo "   Analyze ORC Flat Tables"
echo "-------------------"
${BEELINE} --hivevar SOURCE=ssb_${SCALE}_raw --hivevar SCALE=${SCALE} -f ssb-gen/ddl/analyze_flat.sql

# Process currently ends in issues with creating Druid Table.
# echo "-------------------"
# echo "   Build ORC Tables"
# echo "-------------------"
# ${BEELINE} --hivevar SOURCE=ssb_${SCALE}_raw --hivevar SCALE=${SCALE} -f ssb-gen/ddl/orc.sql

# echo "-------------------"
# echo "   Analyze ORC Tables"
# echo "-------------------"
# ${BEELINE} --hivevar SOURCE=ssb_${SCALE}_raw --hivevar SCALE=${SCALE} -f ssb-gen/ddl/analyze.sql
