#!/bin/sh 

echo 17 > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio17/direction 
echo 1 > /sys/class/gpio/gpio17/value

echo 27 > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio27/direction 
echo 1 > /sys/class/gpio/gpio27/value
