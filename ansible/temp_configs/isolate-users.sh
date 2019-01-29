#!/bin/bash

mount -o remount,hidepid=2 /proc
chmod 1773 /tmp /var/tmp /dev/shm
chmod -R o-r /var/log /var/crash
chmod o-w /proc

chmod 1111 /home/
chmod 700 /vagrant
