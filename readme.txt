1�����ļ�INS_HBASE.tar.gz��ϵͳ�����ϴ�����Ⱥ�����ڵ�/home Ŀ¼�£�

2����װǰȷ����Ⱥ�ڵ�root����һ��,���ڱ��ڵ�������������뱣֤�ն�xshell����������Encoding����ΪUnicode(UTF-8)��

3������װ�ű�ֻ֧��HBASE 5�ڵ�ģʽ�Ĳ��𣬲������ϵͳ����������CentOS7+ ��֧��CentOS8

4����֤CM�ڵ�ϵͳʱ����ȷ��

5�����ļ�INS_HBASE.tar.gz�ϴ�����Ⱥ�����ڵ��ִ����������

    tar  zxvf   /home/INS_HBASE.tar.gz -C /home/

6����ѹ���л���INS_HBASEĿ¼��ִ��hbase_env_INSTALL.sh�ű������£�

   ./hbase_env_INSTALL.sh

   ע�⣺ִ�иýű�˳��Ϊ��ִ��CM�ڵ㣬ִ����ɺ���ִ�������ڵ㣬����װʧ�ܣ�

7���ű�������ɺ�cm�ڵ��Զ�������mysql��mysql root�û�����ΪSuntendy@505!���Լ�ntp����ͬʱcm���ƶ��Լ�agent��Ϊ����״̬��

8����½cm�ڵ� http://CMIP��ַ:7180 ���к�����װ��web�����û���admin ���룺admin 

��������  cm�ڵ�����
          /opt/cm-5.14.2/etc/init.d/cloudera-scm-agent restart
          /opt/cm-5.14.2/etc/init.d/cloudera-scm-server restart

          agent�ڵ�����
          /opt/cm-5.14.2/etc/init.d/cloudera-scm-agent restart