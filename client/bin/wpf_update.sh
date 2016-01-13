#!/bin/sh

. /home/wpf/config/variables

wget -q -O ${HOME}/cron.tab ${WWW_CRON}
crontab ${HOME}/cron.tab
