#!/bin/sh

#sudo systemctl restart hive2-server2
#/vagrant/modules/maven/files/install_maven_manually.sh
#source /vagrant/modules/maven/files/maven.sh
./00datagen.sh 5 os03.streever.local:10000 os01.streever.local druid hortonworks
./00load.sh 5 os03.streever.local:10000 os01.streever.local druid hortonworks os10.streever.local os10.streever.local
./00run.sh os03.streever.local:10000
