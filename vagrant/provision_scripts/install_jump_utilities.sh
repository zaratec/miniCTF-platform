#!/bin/bash

# Minimal script to install utilities on the jump_box that are necessary
# to complete the tasks described in the documentation to deploy picoCTF
# to a live environment on AWS.

sudo apt-get update

# Utilities to generate passwords
# whois gives mkpasswd
sudo apt-get install -y pwgen whois

# AWS Command Line Utility
sudo pip install awscli
