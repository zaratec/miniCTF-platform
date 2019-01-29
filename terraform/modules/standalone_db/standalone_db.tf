# This module configures a remote database option for running picoCTF on AWS

# Inputs:
variable "user" {}
variable "key_pair_id" {}

variable "ami" {}
variable "availability_zone" {}

variable "db_instance_type" {}
variable "db_private_ip" {}
variable "db_name" {}

variable "vpc_id" {}
variable "subnet_id" {}
variable "sg_db_access_id" {}

variable "competition_tag" {}
variable "env_tag" {}

# Outputs:
output "db_id" {
    value = "${aws_instance.db.id}"
}
output "db_eip" {
    value = "${aws_eip.db.public_ip}"
}

###
# Remote Database:
# This provides the option to run the backend database on a separate machine
# than the web server. This can be used to increase scale or easily support
# multiple competitions.
###

resource "aws_instance" "db" {
    connection {
        user = "${var.user}"
    }

    ami = "${var.ami}"
    instance_type = "${var.db_instance_type}"
    availability_zone = "${var.availability_zone}"
    key_name = "${var.key_pair_id}"
    vpc_security_group_ids = ["${aws_security_group.db.id}"]
    subnet_id = "${var.subnet_id}"
    private_ip = "${var.db_private_ip}"

    tags {
        Name = "${var.db_name}"
        Competition = "${var.competition_tag}"
        Environment =  "${var.env_tag}"
    }
}


# Create Elastic IP for db server 
resource "aws_eip" "db" {
    instance = "${aws_instance.db.id}"
    vpc = true
}

# Database security group. Only allows SSH, Mongo, outbound
resource "aws_security_group" "db" {
    name        = "db"
    description = "Allows SSH from web, and Mongo access from machines in db_acess"
    vpc_id      = "${var.vpc_id}"

    # SSH access from anywhere
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    # Mongo access only from db_acess servers
    ingress {
        from_port   = 27017
        to_port     = 27017
        protocol    = "tcp"
        security_groups = ["${var.sg_db_access_id}"]
    }

    # Allow outbound internet access for provisioning and updates
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
