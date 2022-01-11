1、将文件INS_HBASE.tar.gz及系统镜像上传到集群各个节点/home 目录下；

2、安装前确保集群节点root密码一致,由于本节点有中文输出，请保证终端xshell等其他工具Encoding配置为Unicode(UTF-8)；

3、本安装脚本只支持HBASE 5节点模式的部署，部署操作系统环境限制在CentOS7+ 不支持CentOS8

4、保证CM节点系统时间正确；

5、将文件INS_HBASE.tar.gz上传到集群各个节点后执行以下命令

    tar  zxvf   /home/INS_HBASE.tar.gz -C /home/

6、解压后切换到INS_HBASE目录，执行hbase_env_INSTALL.sh脚本，如下：

   ./hbase_env_INSTALL.sh

   注意：执行该脚本顺序为先执行CM节点，执行完成后，在执行其他节点，否则安装失败；

7、脚本部署完成后：cm节点自动部署了mysql（mysql root用户密码为Suntendy@505!）以及ntp服务，同时cm控制端以及agent端为启动状态；

8、登陆cm节点 http://CMIP地址:7180 进行后续安装，web界面用户：admin 密码：admin 

常用命令  cm节点重启
          /opt/cm-5.14.2/etc/init.d/cloudera-scm-agent restart
          /opt/cm-5.14.2/etc/init.d/cloudera-scm-server restart

          agent节点重启
          /opt/cm-5.14.2/etc/init.d/cloudera-scm-agent restart