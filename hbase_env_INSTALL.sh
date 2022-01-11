#!/bin/bash

echo "在安装前保证cm节点系统安装镜像iso文件放到/home/目录下,统一所有节点root密码"

while :
do
   read -p "请确保执行本脚本的前提条件：
           （1）、保证集群所有节点时间一致。
           （2）、保证系统安装镜像上传至集群所有节点/home目录下。
           （3）、尽量保证集群所有节点密码一致。
            是否满足以上条件:（输入y/n注意小写）:" CONDITION
   if [[ $CONDITION == y ]];
   then
      break
   elif [[ $CONDITION == n ]];
   then
      echo "请输入Ctrl +C结束当前程序，调整后再执行"
   else
      echo "输入的信息不符合要求，请重启输入"
   fi
done

######################配置ntp服务###############################################
timedatectl set-timezone Asia/Shanghai
sed -i '/vm.swappiness=10/d' /etc/sysctl.conf
echo "vm.swappiness=10" >> /etc/sysctl.conf
sysctl -p

echo "配置ntp服务"
while :
do
   read -p "当前主机是否为CM节点:（输入y/n注意小写）" CM_HOST5
   if [[ $CM_HOST5 == y ]];
   then
      rm -rf /etc/yum.repos.d/*
      cp ./CentOS-Media.repo /etc/yum.repos.d/
      umount /media/
      mount -o loop /home/CentOS*.iso /media/
      rpm --import /media/RPM-GPG-KEY-CentOS-*
      yum install ntp-* *ntp* *httpd* psmisc* -y
      rm -rf /etc/ntp.conf
      cp ./ntp.conf /etc/
      systemctl enable ntpd.service 
      systemctl start ntpd.service 
      systemctl status ntpd.service 
      break
   elif [[ $CM_HOST5 == n ]];
   then
      rm -rf /etc/yum.repos.d/*
      cp ./CentOS-Media.repo /etc/yum.repos.d/
      umount /media/
      mount -o loop /home/CentOS*.iso /media/
      rpm --import /media/RPM-GPG-KEY-CentOS-*
      yum install *ntp* psmisc* -y
      break
   else
      echo "输入的信息不符合要求，请重启输入"
   fi

done

###################配置主机基本信息#####################################
sed -i '/CM00/d' /etc/hosts
sed -i '/NN00/d' /etc/hosts
sed -i '/DN01/d' /etc/hosts
sed -i '/DN02/d' /etc/hosts
sed -i '/DN03/d' /etc/hosts


sed -i '/cm00/d' /etc/hosts
sed -i '/nn00/d' /etc/hosts
sed -i '/dn01/d' /etc/hosts
sed -i '/dn02/d' /etc/hosts
sed -i '/dn03/d' /etc/hosts


read -p "请输入CM主机IP地址:" CMIP
read -p "请输入NN主机IP地址:" NNIP
read -p "请输入DN01主机IP地址:" DN01IP
read -p "请输入DN02主机IP地址:" DN02IP
read -p "请输入DN03主机IP地址:" DN03IP

echo $CMIP "cm00" >> /etc/hosts
echo $NNIP "nn00" >> /etc/hosts
echo $DN01IP "dn01" >> /etc/hosts
echo $DN02IP "dn02" >> /etc/hosts
echo $DN03IP "dn03" >> /etc/hosts

crontab -l | grep -v "ntp" | crontab 
(crontab -l;echo "*/1 * * * *  /usr/sbin/ntpdate $CMIP > /home/ntpdate.log")|crontab

systemctl disable firewalld && systemctl stop firewalld
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

#######################配置jdk##################################

sed -i '/JAVA_HOME/d' /etc/profile
sed -i '/CLASSPATH/d' /etc/profile
sed -i '/jre/d' /etc/profile
sed -i '/hdfs/d' /etc/security/limits.conf
sed -i '/hbase/d' /etc/security/limits.conf
rm -rf /opt/jdk1.7.0_80/
tar zxvf ./cdh-hadoop/jdk-7u80-linux-x64.tar.gz -C /opt/

cat <<EOF >> /etc/profile
export JAVA_HOME=/opt/jdk1.7.0_80
export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/jre/lib
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
export JAVA_HOME CLASSPATH TOMCAT_HOME PATH

EOF



cat <<EOF >> /etc/security/limits.conf

hdfs  -       nofile  32768
hdfs  -       nproc   2048
hbase -       nofile  32768
hbase -       nproc   2048

EOF
#######################配置ssh#########################################
sed -i '/Port 22/d' /etc/ssh/sshd_config 
sed -i '/Port 22505/d' /etc/ssh/sshd_config
echo "Port 22"  >> /etc/ssh/sshd_config 
echo "Port 22505"  >> /etc/ssh/sshd_config 
useradd --system --home=/opt/cm-5.14.2/run/cloudera-scm-server/ --no-create-home --shell=/bin/false --comment "Cloudera SCM User" cloudera-scm
#####################配置cmssh互信##################################
echo "配置节点互信"
while :
do
   read -p "当前主机是否为CM节点:（输入y/n注意小写）" CM_HOST
   if [[ $CM_HOST == y ]];
   then
      echo "输入三次回车键生成公私钥"
      ssh-keygen -t rsa
      echo "发送公钥到集群节点，即将逐个输入集群节点root密码"
      for i in nn00 dn01 dn02 dn03; do ssh-copy-id -i /root/.ssh/id_rsa.pub $i;done
      for ii in nn00 dn01 dn02 dn03; do ssh $ii "rm -rf /opt/cm-5.14.2.tar.gz";done
      break
   elif [[ $CM_HOST == n ]];
   then
      break
   else
      echo "输入的信息不符合要求，请重启输入"
   fi

done

##########################配置mysql######################################


echo "配置mysql"
while :
do
   read -p "当前主机是否为CM节点:（输入y/n注意小写）" CM_HOSTm
   if [[ $CM_HOSTm == y ]];
   then
      /bin/bash ./mysql_init.sh
      sleep 5
      break
   elif [[ $CM_HOSTm == n ]];
   then
      break
   else
      echo "输入的信息不符合要求，请重启输入"
   fi

done




#######################配置cdh###########################################

if [ -f /opt/cm-5.14.2/etc/init.d/cloudera-scm-server ];then
   echo "停止scm server"
   /opt/cm-5.14.2/etc/init.d/cloudera-scm-server stop
elif [ -f /opt/cm-5.14.2/etc/init.d/cloudera-scm-agent ];then
   echo "停止scm agent"
   /opt/cm-5.14.2/etc/init.d/cloudera-scm-agent stop
else
   echo "初次安装"
fi


echo "配置集群节点"
while :
do
   read -p "当前主机是否为CM节点:（输入y/n注意小写）" CM_HOST2
   if [[ $CM_HOST2 == y ]];
   then
      rm -rf /opt/cloudera  /opt/cm-5.14.2  /opt/cm-5.14.2.tar.gz
      tar zxvf ./cdh-hadoop/cm5142/cloudera-manager-centos7-cm5.14.2_x86_64.tar.gz  -C /opt/
      rm -rf /usr/share/java/mysql-connector-java.jar
      rm -rf /opt/cm-5.14.2/share/cmf/lib/mysql-connector-java.jar
      cp ./cdh-hadoop/mysql-connector-java.jar /usr/share/java/mysql-connector-java.jar
      cp ./cdh-hadoop/mysql-connector-java.jar /opt/cm-5.14.2/share/cmf/lib/mysql-connector-java.jar
      source /etc/profile
      /opt/cm-5.14.2/share/cmf/schema/scm_prepare_database.sh mysql cm -hlocalhost -uroot -pSuntendy@505! --scm-host localhost scm scm scm   
      
      while :
      do
        read -p "CM链接mysql是否配置成功
                 成功状态：

                  ---确保上一行输出信息包含INFO  Successfully connected to database---

                     如包含成功状态信息输入y继续运行:（输入y/n注意小写）" MYSQL_SUCC
        if [[ $MYSQL_SUCC == y ]];
        then
           break
        elif [[ $MYSQL_SUCC == n ]];
        then
           echo "输入Ctrl +C 结束当前脚本，重新执行"
        else
           echo "请重新输入信息"
        fi
      done

      sed -i 's/server_host=localhost/server_host=CM00/g' /opt/cm-5.14.2/etc/cloudera-scm-agent/config.ini
      tar zcvf /opt/cm-5.14.2.tar.gz  /opt/cm-5.14.2
      for i in nn00 dn01 dn02 dn03; do scp -r /opt/cm-5.14.2.tar.gz $i:/opt/;done
      rm -rf /opt/cloudera/parcel-repo/*
      cp ./cdh-hadoop/cdh5142/CDH-5.14.2-1.cdh5.14.2.p0.3-el7.parcel /opt/cloudera/parcel-repo/
      cp ./cdh-hadoop/cdh5142/CDH-5.14.2-1.cdh5.14.2.p0.3-el7.parcel.sha1 /opt/cloudera/parcel-repo/CDH-5.14.2-1.cdh5.14.2.p0.3-el7.parcel.sha
      cp ./cdh-hadoop/cdh5142/manifest.json /opt/cloudera/parcel-repo/
      /bin/bash ./cm_mkdir.sh
      source /etc/profile
      ag=`ps -ef | grep cloudera-scm-agent.pid | grep -v grep | awk '{print $2}'`
      kill -9 $ag
      kill -9 $(pgrep -f supervisord)
      sleep 3
      /opt/cm-5.14.2/etc/init.d/cloudera-scm-agent start
      /opt/cm-5.14.2/etc/init.d/cloudera-scm-server start
      break
   elif [[ $CM_HOST2 == n ]];
   then
      rm -rf /opt/cm-5.14.2 /opt/cloudera
      tar zxvf /opt/cm-5.14.2.tar.gz -C /
      /bin/bash ./cm_mkdir.sh
      source /etc/profile
      ag=`ps -ef | grep cloudera-scm-agent.pid | grep -v grep | awk '{print $2}'`
      kill -9 $ag
      kill -9 $(pgrep -f supervisord)
      sleep 3
      /opt/cm-5.14.2/etc/init.d/cloudera-scm-agent start
      break
   else
      echo "输入的信息不符合要求，请重启输入"
   fi

done


echo "---脚本执行完成等待其他脚本执行完成后重启集群所有节点服务器---"
echo "   重启服务器后在CM节点执行命令：
    --- /opt/cm-5.14.2/etc/init.d/cloudera-scm-agent start && /opt/cm-5.14.2/etc/init.d/cloudera-scm-server start --"
echo "重启服务器后在除CM节点外执行命令：
    --- /opt/cm-5.14.2/etc/init.d/cloudera-scm-agent start ---"


