#!/bin/sh

. /home/wpf/config/variables

wget -o ${HOME}/cron.tab ${WWW_CRON}
crontab ${HOME}/cron.tab
