#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

hdfs dfs -rmr -skipTrash /tmp/ssb/${SCALE}

BEELINE_RAW="beeline -n $HIVE_USER -w $HIVE_PASSWORD_FILE -u "${HS2}"

$BEELINE_RAW -e "drop database if exists ssb_${SCALE}_raw cascade; drop database if exists ssb_${SCALE}_flat_orc cascade;"
