index.cgi		page principale dynamique
set_time.html		formulaire de saisie des h/mn
refresh.sh		affiche current.html + set_time.html
action.cgi		CGI associée au formulaire -> crée la table CRON
cron.tab		table CRON initiale

display_values.sh 	script utilisé au départ pour produire la liste des h/mn

0- Introduction

Le système est constitué :

- d'un serveur Web (PC Linux + Apache) permettant de produire les h/mn sous la forme d'une table CRON

- d'une carte RPi pilotant le distributeur. La RPi récupère la table CRON disponible sur le serveur toutes les
N mn

1- Installation du serveur Web

* Modifier la config Apache2 afin d'accepter l'exécution des CGI dans /var/www + les noms de CGI en '.cgi'
(ExecCGI + AddHandler)

* Dans /etc/apache2/sites-available/default

	<Directory /var/www/>
		Options Indexes FollowSymLinks MultiViews +ExecCGI
		...
		AddHandler cgi-script .cgi
	</Directory>

Dans le cas d'Apache 2.7 (Ubuntu 14.03) ->

* Activer module CGI

$ sudo a2enmod cgi

* Ajouter ces lignes à /etc/apache2/apache2.conf (pour ExecCGI)

<Directory /var/www/html>
        Options Indexes FollowSymLinks ExecCGI
        AllowOverride None
        Require all granted
</Directory>

* Décommenter:

AddHandler cgi-script .cgi

dans /etc/apache2/mods-available/mime.conf 


2- Copier index.cgi, refresh.sh et action.cgi dans /var/www/wpf (si /var/www correspond au 'DocumentRoot' Apache)

Le fichier current.html doit être vide (au départ) et appartenir à www-data:www-data

# echo > current.html
# chown www-data:www-data current.html
# chmod 666 current.html


3- Ouvrir http://<server_addr>/wpf/index.cgi et configurer les heures/mn

Le script "action.cgi" crée un fichier "/var/www/wpf/cron.tab"

* * * * * crontab /home/wpf/bin/wpf_update.sh
00 00 * * * /home/wpf/bin/feed.sh
50 20 * * * /home/wpf/bin/feed.sh
20 21 * * * /home/wpf/bin/feed.sh
10 21 * * * /home/wpf/bin/feed.sh

La zone géographique doit être correctmenet configurée:

# rm /etc/localtime
# ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtimer

Le script wpf_update.sh (exécuté sur la RPi) récupère la table CRON puis l'active avec 'crontab'.

#!/bin/sh

. /home/wpf/config/variables

wget -q -O ${HOME}/cron.tab ${WWW_CRON}
crontab ${HOME}/cron.tab


Le fichier cron.tab doit être initialisé à : 

* * * * * /home/wpf/bin/wpf_update.sh

et appartenir à www-data:www-data (voir /etc/apache2/envvars), mode 0666

-rw-rw-rw- 1 www-data www-data   73 janv.  7 11:13 cron.tab

Le script /home/wpf/bin/feed.sh contient :

#!/bin/sh

# Should call the real script here -> press VOL/SET
/home/wpf/bin/relay.sh


L'utilisateur 'root' de la RPi doit être initialisé par une table CRON appelant wpf_update.sh .

* * * * * /home/wpf/bin/wpf_update.sh

Le fichier /etc/rc.local (sur la RPi) contient l'appel à l'init des relais.

# WPF
/home/wpf/bin/init_relay.sh


4- Voir les résultats dans /var/log/syslog

# grep CMD /var/log/syslog
Jan  6 21:10:01 XPS-pf CRON[14582]: (pierre) CMD (/home/wpf/bin/feed.sh)
Jan  6 21:20:01 XPS-pf CRON[14885]: (pierre) CMD (/home/wpf/bin/feed.sh)
...
