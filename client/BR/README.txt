Test avec BR 2015.0.1 + noyau 3.18.16
=====================================

- Idem Yocto pour wpa_supplicant

# wpa_passphrase my_ssid my_pass > test.conf
# wpa_supplicant -i wlan0 -D wext -c test.conf -B
# udhcpc -i wlan0

- Ajout EUDEV -> chargement pilotes

- ifup/ifdown Busybox ne gèrent pas wpa_supplicant -> tester avec les versions Debian


