index.cgi		page principale dynamique
set_time.html		forme de saisie des h/mn
refresh.sh		affiche current.html + set_time.html
action.cgi		CGI associée à la forme -> crée la table CRON
cron.tab		table CRON initiale
feed.sh			script appelé par CRON
variables		paramètres

display_values.sh 	script utilisé pour produire la liste des h/mn


1- Modifier la config Apache2 afin d'accepter l'exécution des CGI dans
/var/www + les noms de CGI en '.cgi' (ExecCGI + AddHandler)

Dans /etc/apache2/sites-available/default

	<Directory /var/www/>
		Options Indexes FollowSymLinks MultiViews +ExecCGI
		...
		AddHandler cgi-script .cgi
	</Directory>

2- Copier index.cgi, refresh.sh et action.cgi dans /var/www/wpf

3- Ouvrir http://localhost/wpf/index.cgi et configurer les heures/mn

Le script "action.cgi" crée un fichier "/var/www/wpf/cron.tab" chargé par 'crontab' :

* * * * * crontab /var/www/wpf/cron.tab
00 00 * * * /var/www/wpf/feed.sh
50 20 * * * /var/www/wpf/feed.sh
20 21 * * * /var/www/wpf/feed.sh
10 21 * * * /var/www/wpf/feed.sh

Le fichier cron.tab doit être initialisé à 

* * * * * crontab /var/www/wpf/cron.tab

et appartenir à www-data:www-data (voir /etc/apache2/envvars), mode 0666

-rw-rw-rw- 1 www-data www-data   73 janv.  7 11:13 cron.tab

Le fichier current.html doit être vide (au départ) et appartenir à www-data:www-data

# echo > current.html
# chown www-data:www-data current.html
# chmod 666 current.html


Le script /home/wpf/bin/feed.sh contient;

#!/bin/sh

# Should call the real script here



Le système (utilisateur 'root') doit être initialisé par une table CRON 
permettant de mettre à jour les heures d'appel (appel à crontab).

* * * * * crontab /var/www/wpf/cron.tab

Le fichier /etc/rc.local contient l'appel à l'init des relais.

# WPF
/home/wpf/bin/init_relay.sh


4- Voir les résultats dans /var/log/syslog

# grep CMD /var/log/syslog
Jan  6 21:10:01 XPS-pf CRON[14582]: (pierre) CMD (/home/wpf/bin/feed.sh)
Jan  6 21:20:01 XPS-pf CRON[14885]: (pierre) CMD (/home/wpf/bin/feed.sh)
...
