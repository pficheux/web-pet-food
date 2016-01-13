#!/bin/sh

. /home/wpf/config/variables

CF=${HOME}/cron.tab

mv ${CF} ${CF}.old
wget -O ${CF} ${WWW_CRON}

# load CRON table if no error, else do nothing

if [ -r ${CF} -a $? -eq 0 ]; then
    crontab ${CF}
else
    mv ${CF}.old ${CF}
fi
