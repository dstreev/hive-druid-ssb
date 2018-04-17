#!/bin/sh

. ./init-env.sh $@

# SCALE=${1:-5}
# HS2=${2:-localhost:10000}
# DRUID_META_HOST=${3:-$(hostname)}
# DRUID_META_USERNAME=${4:-druid}
# DRUID_META_PASSWORD=${5:-password}
# HIVE_USER=${6:-$USER}
# HIVE_PASSWORD_FILE=${7:-.hive_password}
echo "----------------------------------------"
echo "Check env: "
echo "	SCALE:${SCALE}"
echo "	HIVE_USER:${HIVE_USER}"
echo "	HIVE_PASSWORD_FILE:${HIVE_PASSWORD_FILE}"
echo "	HS2:${HS2}"
echo "	DRUID_META_HOST:${DRUID_META_HOST}"
echo "----------------------------------------"

BEELINE_RAW="beeline -n $HIVE_USER -w $HIVE_PASSWORD_FILE -u jdbc:hive2://${HS2}/ssb_${SCALE}_raw"
BEELINE_ORC="beeline -n $HIVE_USER -w $HIVE_PASSWORD_FILE -u jdbc:hive2://${HS2}/ssb_${SCALE}_flat_orc"

# Pre-flight checks.
for f in gcc javac mvn; do
	which $f > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo "Required program $f is missing. Please install or fix your path and try again."
		exit 1
	fi
done

# Don't do anything if the data is already loaded.
hdfs dfs -ls /apps/hive/warehouse/ssb_${SCALE}_flat_orc.db >/dev/null

if [ $? -ne 0 ];  then
	# Generate and optimize the Hive data.
	echo "Building the data generator"
	pushd ssb-gen
	make clean all

	echo "Generate the data at scale $SCALE"
	hadoop jar target/ssb-gen-1.0-SNAPSHOT.jar -d /tmp/ssb/${SCALE}/ -s ${SCALE}
	$BEELINE_RAW -e "create database ssb_${SCALE}_raw; create database ssb_${SCALE}_flat_orc;"
	$BEELINE_RAW --hivevar LOCATION=/tmp/ssb/${SCALE} -f ddl/text.sql
	$BEELINE_ORC --hivevar SOURCE=ssb_${SCALE}_raw -f ddl/orc_flat.sql
	$BEELINE_ORC --hivevar SOURCE=ssb_${SCALE}_raw -f ddl/analyze_flat.sql
else
	echo "SSB Data at scale ${SCALE}, already loaded."
fi
