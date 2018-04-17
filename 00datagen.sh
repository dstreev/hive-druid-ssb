#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

BEELINE_RAW="beeline -n $HIVE_USER -w $HIVE_PASSWORD_FILE -u "${HS2}/ssb_${SCALE}_raw"
BEELINE_ORC="beeline -n $HIVE_USER -w $HIVE_PASSWORD_FILE -u "${HS2}/ssb_${SCALE}_flat_orc"

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
	exec ${BEELINE_RAW} -e "create database ssb_${SCALE}_raw; create database ssb_${SCALE}_flat_orc;"
	exec ${BEELINE_RAW} --hivevar LOCATION=/tmp/ssb/${SCALE} -f ddl/text.sql
	exec ${BEELINE_ORC} --hivevar SOURCE=ssb_${SCALE}_raw -f ddl/orc_flat.sql
	exec ${BEELINE_ORC} --hivevar SOURCE=ssb_${SCALE}_raw -f ddl/analyze_flat.sql
else
	echo "SSB Data at scale ${SCALE}, already loaded."
fi
