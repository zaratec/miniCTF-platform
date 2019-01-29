#!/bin/bash

# Minimal script to install Terraform as described:
# https://www.terraform.io/intro/getting-started/install.html

# This will get the jump box to where it can deploy infrastrucutre to AWS

TERRAFORM_URL=https://releases.hashicorp.com/terraform/0.6.14/terraform_0.6.14_linux_amd64.zip
TERRAFORM_ZIP=terraform_0.6.14_linux_amd64.zip


sudo apt-get install -y unzip

sudo mkdir -p /usr/local/terraform

# Check if Terraform is already installed
if [ ! -f /usr/local/terraform/terraform ]
then
    # remove any failed downloads
    rm $TERRAFORM_ZIP
    echo "Downloading Terraform Binary"
    wget $TERRAFORM_URL
    sudo unzip $TERRAFORM_ZIP -d /usr/local/terraform
else
    echo "Terraform is already installed"
fi

if [[ ! $(grep terraform ~/.profile) ]]
then
    echo "Adding Terraform to PATH"
    echo "#Add Terraform to path" >> $HOME/.profile
    echo "PATH=$PATH:/usr/local/terraform" >> $HOME/.profile
else
    echo "Terraform already in PATH" 
fi
