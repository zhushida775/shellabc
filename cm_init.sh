#!/bin/bash



rm -rf /opt/cloudera  /opt/cm-5.14.2
tar zxvf ./cdh-hadoop/cm5142/cloudera-manager-centos7-cm5.14.2_x86_64.tar.gz  -C /opt/
rm -rf /usr/share/java/mysql-connector-java.jar
rm -rf /opt/cm-5.14.2/share/cmf/lib/mysql-connector-java.jar
cp ./cdh-hadoop/mysql-connector-java.jar /usr/share/java/mysql-connector-java.jar
cp ./cdh-hadoop/mysql-connector-java.jar /opt/cm-5.14.2/share/cmf/lib/mysql-connector-java.jar

/opt/cm-5.14.2/share/cmf/schema/scm_prepare_database.sh mysql cm -hlocalhost -uroot -pSuntendy@505! --scm-host localhost scm scm scm

sed -i 's/server_host=localhost/server_host=CM00/g' /opt/cm-5.14.2/etc/cloudera-scm-agent/config.ini

