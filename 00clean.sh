#!/usr/bin/env bash

. ./init-env.sh $@
. ./check-env.sh

hdfs dfs -rmr -skipTrash /tmp/ssb/${SCALE}
