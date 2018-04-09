#!/bin/sh

SCALE=${1:-2}
HSI=${2:-"jdbc:hive2://localhost:10000/default"}
# DRUID_META_HOST=${3:-localhost}
# DRUID_META_USERNAME=${4:-druid}
# DRUID_META_PASSWORD=${5:-password}
# DRUID_BROKER_HOST=${6:-localhost}
# DRUID_COORD_HOST=${7:-localhost}
HIVE_USER=${3:-$USER}
HIVE_PASSWORD_FILE=${4:-.hive_password}
BEELINE="beeline -n ${HIVE_USER} -w ${HIVE_PASSWORD_FILE} -u ${HSI} -f queries.druid/index_ssb.sql"

echo $BEELINE

$BEELINE
