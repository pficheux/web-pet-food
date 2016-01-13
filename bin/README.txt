init_relay.sh		init des GPIO -> à appeler dans /etc/rc.local
relay.sh		action VOL/SET

feed.sh			script appelé par CRON (exécute relay.sh)
wpf_update.sh		téléchargement table CRON (wget) + chargement (crontab)

