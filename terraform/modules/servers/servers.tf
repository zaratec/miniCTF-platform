# This module configures the virtual machines for running picoCTF on AWS

# Inputs:
variable "user" {}
variable "key_pair_id" {}

variable "ami" {}
variable "availability_zone" {}

variable "web_instance_type" {}
variable "web_private_ip" {}
variable "web_name" {}

variable "shell_instance_type" {}
variable "shell_private_ip" {}
variable "shell_name" {}

variable "subnet_id" {}
variable "sg_web_id" {}
variable "sg_shell_id" {}
variable "sg_db_access_id" {}

variable "competition_tag" {}
variable "env_tag" {}

# Outputs:
output "web_id" {
    value = "${aws_instance.web.id}"
}
output "shell_id" {
    value = "${aws_instance.shell.id}"
}

###
# Instance Configuration:
# There are two primary servers necessary to run picoCTF (web, shell). This is
# the same configuration used in the default development setup.
###

resource "aws_instance" "web" {
    # Use the local SSH agent for authentication as user
    connection {
        user = "${var.user}"
    }

    ami = "${var.ami}"
    instance_type = "${var.web_instance_type}"
    availability_zone = "${var.availability_zone}"

    # SSH keypair for authentication
    key_name = "${var.key_pair_id}"

    # Security group to allow HTTP, HTTPS and SSH access, also tag for db access
    vpc_security_group_ids = ["${var.sg_web_id}", "${var.sg_db_access_id}"]

    # Launch into the internet facing subnet
    subnet_id = "${var.subnet_id}"

    # Fix private_ip
    private_ip = "${var.web_private_ip}"

    tags {
        Name = "${var.web_name}"
        Competition = "${var.competition_tag}"
        Environment =  "${var.env_tag}"
    }
}

resource "aws_instance" "shell" {
    connection {
        user = "${var.user}"
    }

    ami = "${var.ami}"
    instance_type = "${var.shell_instance_type}"
    availability_zone = "${var.availability_zone}"
    key_name = "${var.key_pair_id}"

    vpc_security_group_ids = ["${var.sg_shell_id}"]
    subnet_id = "${var.subnet_id}"
    private_ip = "${var.shell_private_ip}"

    tags {
        Name = "${var.shell_name}"
        Competition = "${var.competition_tag}"
        Environment =  "${var.env_tag}"
    }
}
