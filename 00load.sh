#!/bin/sh

SCALE=${1:-2}
HS2=${2:-localhost:10000}
DRUID_META_HOST=${3:-$(hostname)}
DRUID_META_USERNAME=${4:-druid}
DRUID_META_PASSWORD=${5:-password}
DRUID_BROKER_HOST=${5:-localhost}
DRUID_COORD_HOST=${5:-localhost}
HIVE_USER=${6:-$USER}
HIVE_PASSWORD_FILE=${7:-.hive_password}
BEELINE="beeline -n $HIVE_USER -w $HIVE_PASSWORD_FILE -u jdbc:hive2://$HS2/default -f queries.druid/index_ssb.sql --hivevar DRUID_COORD_HOST=${DRUID_COORD_HOST} --hivevar DRUID_BROKER_HOST=${DRUID_BROKER_HOST} --hivevar DRUID_META_HOST=${DRUID_META_HOST} --hivevar DRUID_META_USERNAME=${DRUID_META_USERNAME} --hivevar DRUID_META_PASSWORD=${DRUID_META_PASSWORD} --hivevar SCALE=${SCALE}"

echo $BEELINE

$BEELINE
