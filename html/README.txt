1- Modifier la config Apache2 afin d'accepter l'exécution des CGI dans
/var/www + les noms de CGI en '.cgi' (ExecCGI + AddHandler)

Dans /etc/apache2/sites-available/default

	<Directory /var/www/>
		Options Indexes FollowSymLinks MultiViews +ExecCGI
		...
		AddHandler cgi-script .cgi
	</Directory>

2- Copier time.html et action.cgi dans /var/www

3- Ouvrir http://localhost/time.html et configurer les heures/mn

Le script "action.cgi" crée un fichier "/tmp/cron.tab" chargé par 'crontab' :

* * * * * crontab /tmp/cron.tab
45 00 * * * echo "PROG1 $(date)" >> /tmp/cron.txt
00 01 * * * echo "PROG2 $(date)" >> /tmp/cron.txt
00 02 * * * echo "PROG3 $(date)" >> /tmp/cron.txt
20 03 * * * echo "PROG4 $(date)" >> /tmp/cron.txt

Le système doit être initialisé par un crontab contenant:

* * * * * crontab /tmp/cron.tab

4- Voir les résultats dant /tmp/cron.txt

# cat /tmp/cron.txt 
PROG4 lundi 4 janvier 2016, 23:30:01 (UTC+0100)
PROG3 lundi 4 janvier 2016, 23:40:01 (UTC+0100)
PROG1 mardi 5 janvier 2016, 00:45:02 (UTC+0100)

=> à terme on remplace 'echo' par le script de distribution des croquettes !
