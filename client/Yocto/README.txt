Test avec Yocto 1.7.1 + noyau 3.18.5
====================================

- Pb wpa_supplicant + nl80211 sur Edimax -> utiliser wext voir https://wiki.archlinux.org/index.php/WPA_supplicant

# wpa_passphrase my_ssid my_pass > test.conf
# wpa_supplicant -i wlan0 -D wext -c test.conf -B
# udhcpc -i wlan0

-> démarrage automatique ne fonctionne pas (/etc/init.d/interfaces) => ajout d'un sleep 1 (?)

