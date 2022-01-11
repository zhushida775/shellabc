#!/bin/bash


rm -rf  /var/log/cloudera-scm-headlamp 
rm -rf  /var/log/cloudera-scm-firehose 
rm -rf  /var/log/cloudera-scm-alertpublisher 
rm -rf  /var/log/cloudera-scm-eventserver 
rm -rf  /var/lib/cloudera-scm-headlamp 
rm -rf  /var/lib/cloudera-scm-firehose 
rm -rf  /var/lib/cloudera-scm-alertpublisher 
rm -rf  /var/lib/cloudera-scm-eventserver
rm -rf  /var/cm_logs/cloudera-scm-headlamp
rm -rf /var/lib/cloudera-host-monitor
rm -rf /var/lib/cloudera-scm-server
rm -rf /var/lib/cloudera-service-monitor

mkdir -p /var/lib/cloudera-host-monitor
mkdir -p /var/lib/cloudera-scm-server
mkdir -p /var/lib/cloudera-service-monitor
mkdir -p /var/cm_logs/cloudera-scm-headlamp
mkdir -p /var/log/cloudera-scm-headlamp 
mkdir -p /var/log/cloudera-scm-firehose 
mkdir -p /var/log/cloudera-scm-alertpublisher 
mkdir -p /var/log/cloudera-scm-eventserver 
mkdir -p /var/lib/cloudera-scm-headlamp 
mkdir -p /var/lib/cloudera-scm-firehose 
mkdir -p /var/lib/cloudera-scm-alertpublisher 
mkdir -p /var/lib/cloudera-scm-eventserver 
mkdir -p /opt/cloudera/parcel-repo

chown -R cloudera-scm:cloudera-scm /var/log/cloudera-scm-headlamp
chown -R cloudera-scm:cloudera-scm /var/cm_logs/cloudera-scm-headlamp
chown -R cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo
chown -R cloudera-scm:cloudera-scm /opt/cloudera/
chown -R cloudera-scm:cloudera-scm /var/log/cloudera-scm-headlamp
chown -R cloudera-scm:cloudera-scm /var/cm_logs/cloudera-scm-headlamp
chown -R cloudera-scm:cloudera-scm /var/lib/cloudera-*
chown -R cloudera-scm:cloudera-scm /var/log/cloudera-*
chown -R cloudera-scm:cloudera-scm /opt/cm-5.14.2
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag
