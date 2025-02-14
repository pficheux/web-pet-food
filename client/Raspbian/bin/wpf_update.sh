#!/bin/sh

. /home/wpf/config/variables

ping -q -c 1 ${TEST_ADDR} 1> /dev/null 2>&1
if [ $? -ne 0 ]; then
    ifup wlan0
fi	

CF=${HOME}/cron.tab

mv ${CF} ${CF}.old
wget -O ${CF} ${WWW_CRON}

# load CRON table if no error, else do nothing

if [ -r ${CF} -a $? -eq 0 ]; then
    crontab ${CF}
else
    mv ${CF}.old ${CF}
fi
