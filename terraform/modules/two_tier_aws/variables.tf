# Varaibles used by the two_tier_aws module

###
# Input Variables:
# These are sane defaults that can be overloaded in an environment specific 
# configuration (eg: production, testing).
###

# SSH
variable "key_name" {
    description = "SSH key used to insert as authorized on the machines"
    default = "pico_production"
}
variable "public_key_path" {
    description = "Local path to SSH public key"
    default = "~/.ssh/picoCTF_production_rsa.pub"
}

# AWS Configuration
variable "region" {
    description = "AWS Region to launch resources in"
    default = "us-east-1"
}
variable "availability_zone" {
    description = "AWS Availability zone to launch resources in"
    default = "us-east-1b"
}
variable "user" {
    description = "User to connect to machines with"
    default = "admin"
}

# Network
variable "vpc_cidr" {
    description = "CIDR Block for Virtual Private Cloud"
    default = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
    description = "CIDR Block for public subnet"
    default = "10.0.1.0/24"
}
variable "web_private_ip" {
    description = "Internal IP address for web server"
    default = "10.0.1.10"
}
variable "shell_private_ip" {
    description = "Internal IP address for shell server"
    default = "10.0.1.11"
}
variable "db_private_ip" {
    description = "Internal IP address for db"
    default = "10.0.1.20"
}

# Instances
variable "web_instance_type" {
    description = "AWS instance type for web server"
    default = "t2.micro"
}
variable "shell_instance_type" {
    description = "AWS instance type for shell server"
    default = "t2.micro"
}
variable "db_instance_type" {
    description = "AWS instance type for db"
    default = "t2.micro"
}

# EBS Volumes
variable "db_ebs_data_size" {
    description = "Size for database persistent store"
    default = "10"
}
variable "db_ebs_data_device_name" {
    description = "Device to map database persistent store to"
    default = "/dev/xvdf"
}

# Tags
variable "competition_tag" {
    default = "picoCTF"
}
variable "env_tag" {
    default = "production"
}
variable "web_name" {
    description = "Name tag for web server"
    default = "picoCTF-web"
}
variable "shell_name" {
    description = "Name tag for shell server"
    default = "picoCTF-shell"
}
variable "db_name" {
    description = "Name tag for db"
    default = "picoCTF-shell"
}
variable "db_ebs_name" {
    description = "Name tag of database Elastic Block Storage"
    default = "picoCTF-db-ebs"
}

# Default AMI mapping
# Debian Jessie 8.3 hvm x86_64 ebs
# https://wiki.debian.org/Cloud/AmazonEC2Image/Jessie
# http://docs.aws.amazon.com/general/latest/gr/rande.html#ec2_region
variable "amis" {
    description = "Debian Jessie 8.3 AMI to use"
    default = {
        ap-northeast-1 = "ami-899091e7"
        ap-southeast-1 = "ami-7bb47d18"
        ap-southeast-2 = "ami-9a7056f9"
        eu-central-1 = "ami-2638224a"
        eu-west-1 = "ami-11c57862"
        sa-east-1 = "ami-651f9c09"
        us-east-1 = "ami-f0e7d19a"
        us-west-1 = "ami-f28bfa92"
        us-west-2 = "ami-837093e3"
    }
}
