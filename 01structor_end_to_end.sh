#!/bin/sh

#sudo systemctl restart hive2-server2
#/vagrant/modules/maven/files/install_maven_manually.sh
#source /vagrant/modules/maven/files/maven.sh
./00datagen.sh 5 os03.streever.local:10000 os01.streever.local druid hortonworks
./00load.sh 5 "jdbc:hive2://os02.streever.local:2181,os03.streever.local:2181,os04.streever.local:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2-hive2"
./00run.sh "jdbc:hive2://os02.streever.local:2181,os03.streever.local:2181,os04.streever.local:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2-hive2"
