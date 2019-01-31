#!/bin/bash

ssh -i .vagrant/machines/web/virtualbox/private_key -t vagrant@192.168.2.2 "python /picoCTF/scripts/update-db.py"

