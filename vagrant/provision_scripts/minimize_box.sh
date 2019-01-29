#!/bin/bash

# Techniques to reduce base box size per:
# https://github.com/mitchellh/vagrant/issues/343
# https://gist.github.com/ADRIENBRAULT/3775253

# Remove APT cache
apt-get clean -y
apt-get autoclean -y

# Zero free space to aid VM compression
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
