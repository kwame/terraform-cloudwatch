#!/bin/bash
yum-config-manager --enable epel
yum -y update 
sudo -u ec2-user pip install --upgrade --user awscli
yum -y install git screen httpd tmux awslogs perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https irssi httpd
hostname informatux-test.local
curl -o /opt/CloudWatchMonitoringScripts-1.2.1.zip http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip -O
unzip /opt/CloudWatchMonitoringScripts-1.2.1.zip -d /opt/
cd /opt/aws-scripts-mon
echo "*/1 * * * * ec2-user /opt/aws-scripts-mon/mon-put-instance-data.pl --swap-used --mem-util --swap-util --mem-used --disk-space-util --disk-path=/ --disk-space-used --from-cron" >> /etc/crontab
/etc/init.d/awslogs restart
chkconfig --level 345 awslogs on
