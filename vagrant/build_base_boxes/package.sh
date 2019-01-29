#!/bin/bash

# Packages the base boxes for upload to https://atlas.hashicorp.com/picoCTF/boxes/

echo "Removing old boxes..."
rm *.box

echo "Packaging latest boxes"
vagrant package --base picoCTF-web-base-builder --output picoCTF-web-base.box
vagrant package --base picoCTF-shell-base-builder --output picoCTF-shell-base.box

DATE=`date +"%Y-%m-%d"` 
COMMIT=`git log --oneline| head -n 1 |awk '{print $1}'`
echo "Dependencies updated as of $DATE and commit $COMMIT."
