#!/bin/bash

action=$1

if [ "$action" = "configure" ];
then
    echo 21 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio21/direction
    echo 1 > /sys/class/gpio/gpio21/value
elif [ "$action" = "reset" ];
then
    echo 0 > /sys/class/gpio/gpio21/value
    sleep 1
    echo 1 > /sys/class/gpio/gpio21/value
fi


