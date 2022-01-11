#!/bin/bash

systemctl stop mysqld
yum remove -y *mariadb*
yum remove -y mysql-community*
#rm -rf /var/log/mysqld.log
rm -rf /root/.mysql_history
rm -rf /var/lib/mysql
rm -rf /var/lib/mysql/mysql
rm -rf /var/log/mysqld.log
sleep 4
rpm -ivh ./cdh-hadoop/mysql5.7/mysql-community-common-5.7.22-1.el7.x86_64.rpm
rpm -ivh ./cdh-hadoop/mysql5.7/mysql-community-libs-5.7.22-1.el7.x86_64.rpm
rpm -ivh ./cdh-hadoop/mysql5.7/mysql-community-libs-compat-5.7.22-1.el7.x86_64.rpm
rpm -ivh ./cdh-hadoop/mysql5.7/mysql-community-devel-5.7.22-1.el7.x86_64.rpm
rpm -ivh ./cdh-hadoop/mysql5.7/mysql-community-client-5.7.22-1.el7.x86_64.rpm
rpm -ivh ./cdh-hadoop/mysql5.7/mysql-community-server-5.7.22-1.el7.x86_64.rpm

systemctl start mysqld
systemctl enable mysqld
systemctl status mysqld

mysql_pass=`grep "password is generated for root@localhost:" /var/log/mysqld.log | awk -F ':' '{print $4}'|tr -d '\n\r'`
mysql_pass2=`echo $mysql_pass|tr -d '\n\r'`

mysql --connect-expired-password -uroot --password=$mysql_pass2 <<EOF

set password = password('Suntendy@505!');
grant all on *.* to root@'%' identified by 'Suntendy@505!';
grant all on *.* to root@'CM00' identified by 'Suntendy@505!';
grant all on *.* to root@'localhost' identified by 'Suntendy@505!';
flush privileges;
select current_date();
exit

EOF

echo "validate_password=off" >> /etc/my.cnf
systemctl restart mysqld
