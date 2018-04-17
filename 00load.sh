#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

BEELINE="beeline --hivevar SCALE=${SCALE} -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u ${HS2} -f queries.druid/index_ssb.sql"

echo $BEELINE

$BEELINE
