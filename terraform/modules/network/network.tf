# This module configures the network resources for running picoCTF on AWS

# Inputs:
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "availability_zone" {}

# Outputs:
output "vpc_id" {
    value = "${aws_vpc.private_network.id}"
}
output "public_subnet_id" {
    value = "${aws_subnet.public.id}"
}

###
# Network configuration:
# This is a simple network configuration where all machines are on a virtual network
# that is attached via an gateway to the internet. All machines placed in this public
# subnet receive a public IP address
###


# Create a VPC (private netork) to launch our instances into
resource "aws_vpc" "private_network" {
    cidr_block = "${var.vpc_cidr}"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "private_network" {
    vpc_id = "${aws_vpc.private_network.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
    route_table_id         = "${aws_vpc.private_network.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.private_network.id}"
}

# Create a public facing subnet to launch our instances into
# Maps public ip automatically so every instance gets a public ip
# Security Groups are then used to restrict access
resource "aws_subnet" "public" {
    vpc_id                  = "${aws_vpc.private_network.id}"
    cidr_block              = "${var.public_subnet_cidr}"
    map_public_ip_on_launch = true
    availability_zone = "${var.availability_zone}"
}
