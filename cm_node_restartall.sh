#!/bin/bash


/opt/cm-5.14.2/etc/init.d/cloudera-scm-server restart
/opt/cm-5.14.2/etc/init.d/cloudera-scm-agent restart
ssh NN00 "/opt/cm-5.14.2/etc/init.d/cloudera-scm-agent stop"
ssh NN00 "/opt/cm-5.14.2/etc/init.d/cloudera-scm-agent start"
ssh DN01 "/opt/cm-5.14.2/etc/init.d/cloudera-scm-agent stop"
ssh DN01 "/opt/cm-5.14.2/etc/init.d/cloudera-scm-agent start"
#ssh DN02 "/opt/cm-5.14.2/etc/init.d/cloudera-scm-agent stop"
#ssh DN02 "/opt/cm-5.14.2/etc/init.d/cloudera-scm-agent start"
#ssh DN03 "/opt/cm-5.14.2/etc/init.d/cloudera-scm-agent stop"
#ssh DN03 "/opt/cm-5.14.2/etc/init.d/cloudera-scm-agent start"

