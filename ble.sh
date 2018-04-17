#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

SOURCE=ssb_${SCALE}_flat_orc
BEELINE="beeline -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u '${HS2}' --hivevar SCALE=${SCALE} --hivevar TYPE=${TYPE} --hivevar SOURCE=${SOURCE}"

${BEELINE}
