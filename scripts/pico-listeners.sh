#! /bin/bash

# Based off of f0xtr0t's listeners script for 15-330

listen () {
    socat -T 1800 tcp-listen:${1},reuseaddr,fork tcp:${2} &
    echo "Listening for ${3} on port ${1}. Connected to ${2}."
}

listen 80 192.168.2.2:80 web
listen 2123 192.168.2.3:80 shell
listen 2124 192.168.2.3:22 ssh-shell
