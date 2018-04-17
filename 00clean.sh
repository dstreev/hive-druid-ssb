#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

hdfs dfs -rm -r -skipTrash /tmp/ssb/${SCALE}

BEELINE_RAW="beeline -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u '${HS2}'"

echo ${BEELINE_RAW}

${BEELINE_RAW} -e "drop database if exists ssb_${SCALE}_raw cascade; drop database if exists ssb_${SCALE}_flat_orc cascade;drop database if exists ssb_${SCALE}_orc cascade;DROP DATABASE IF EXISTS druid_ssb_${SCALE}_FLAT;DROP DATABASE IF EXISTS druid_ssb_${SCALE}_NON_FLAT;"
