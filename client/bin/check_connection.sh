#!/bin/sh

ping -q -c 1 www.google.fr 1> /dev/null 2>&1
if [ $? -ne 0 ]; then
    ifup wlan0
fi	
