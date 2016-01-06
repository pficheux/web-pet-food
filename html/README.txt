1- Modifier la config Apache2 afin d'accepter l'exécution des CGI dans
/var/www + les noms de CGI en '.cgi' (ExecCGI + AddHandler)

Dans /etc/apache2/sites-available/default

	<Directory /var/www/>
		Options Indexes FollowSymLinks MultiViews +ExecCGI
		...
		AddHandler cgi-script .cgi
	</Directory>

2- Copier time.html et action.cgi dans /var/www/wpf

3- Ouvrir http://localhost/wpf/time.html et configurer les heures/mn

Le script "action.cgi" crée un fichier "/var/www/wpf/cron.tab" chargé par 'crontab' :

* * * * * crontab /var/www/wpf/cron.tab
00 00 * * * /var/www/wpf/feed.sh
50 20 * * * /var/www/wpf/feed.sh
20 21 * * * /var/www/wpf/feed.sh
10 21 * * * /var/www/wpf/feed.sh

feed.sh contient;

#!/bin/sh

# Should call the real script here


Le système doit être initialisé par un crontab contenant:

* * * * * crontab /var/www/wpf/cron.tab

4- Voir les résultats dant /var/log/syslog

# grep feed /var/log/syslog
Jan  6 21:10:01 XPS-pf CRON[14582]: (pierre) CMD (/var/www/wpf/feed.sh)
Jan  6 21:20:01 XPS-pf CRON[14885]: (pierre) CMD (/var/www/wpf/feed.sh)
...

