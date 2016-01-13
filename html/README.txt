index.cgi		page principale (dynamique)
set_time.html		formulaire de saisie des h/mn
current.html		horaires "courants" (exemple)
refresh.sh		affiche current.html + set_time.html
action.cgi		CGI associée au formulaire -> crée la table CRON
cron.tab		table CRON initiale -> mise à jour par wpf_update.sh toutes les 5 mn

display_values.sh 	script utilisé au départ pour produire la liste des h/mn
