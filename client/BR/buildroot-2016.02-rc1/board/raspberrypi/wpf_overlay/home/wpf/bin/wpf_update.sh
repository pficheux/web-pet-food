#!/bin/sh

. /home/wpf/config/variables.txt

# Test network
set $(route | grep default)

ping -q -c 1 $2 1> /dev/null 2>&1
if [ $? -ne 0 ]; then
    ifdown wlan0
    ifup wlan0
fi	

# Get time from NTP
ntpdate pool.ntp.org

# Get CRON table
CF=${HOME}/cron.tab

mv ${CF} ${CF}.old
wget -O ${CF} ${WWW_CRON}

# load CRON table if no error, else replace by the old one 

if [ -r ${CF} -a $? -eq 0 ]; then
    crontab ${CF}
else
    mv ${CF}.old ${CF}
fi
