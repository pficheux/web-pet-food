#!/bin/sh

echo 0 > /sys/class/gpio/gpio17/value 
echo 0 > /sys/class/gpio/gpio27/value 
sleep 2 
echo 1 > /sys/class/gpio/gpio17/value 
echo 1 > /sys/class/gpio/gpio27/value 
