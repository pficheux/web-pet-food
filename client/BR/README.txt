Test avec BR 2015.0.1 + noyau 3.18.16
=====================================

- Idem Yocto pour wpa_supplicant

# wpa_passphrase my_ssid my_pass > test.conf
# wpa_supplicant -i wlan0 -D wext -c test.conf -B
# udhcpc -i wlan0

- Ajout EUDEV -> chargement pilotes

- Ajout /etc/network/if-pre-up.d/wpa_supplicant (trouvé sur Yocto !)

- Ajout /etc/network/if-pre-down.d/wpa_supplicant (lien symbolique sur le précédent)

- Ajout dropbear (mdp 'hanae')

- Test InitRD

* construction rootfs.cpio.gz -> copier sur /boot (augmentation la taille dans build_sdcard.sh)
* modif cmdline.txt -> console=ttyAMA0,115200 rootwait
* modif config.txt -> initramfs rootfs.cpio.gz
