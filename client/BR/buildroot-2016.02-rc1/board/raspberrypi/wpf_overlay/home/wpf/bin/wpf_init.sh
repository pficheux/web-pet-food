#!/bin/sh 

. /home/wpf/config/variables.txt

if [ -r /boot/variables.txt ]; then
    . /boot/variables.txt
fi


# GPIO
echo 17 > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio17/direction 
echo 1 > /sys/class/gpio/gpio17/value

echo 27 > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio27/direction 
echo 1 > /sys/class/gpio/gpio27/value

# Network
wpa_passphrase ${WPA_SSID} ${WPA_PSK} >> /etc/wpa_supplicant.conf
