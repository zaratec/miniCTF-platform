# This module configures security groups (firewall rules) for running picoCTF on AWS

# Inputs:
variable "vpc_id" {}

# Outputs:
output "sg_web_id" {
    value = "${aws_security_group.web.id}"
}
output "sg_shell_id" {
    value = "${aws_security_group.shell.id}"
}
output "sg_db_access_id" {
    value = "${aws_security_group.db_access.id}"
}

###
# Security Group configuration:
# These security groups serve to restrict access to the machines launched into
# our virtual network. Specifically it provides an HTTP/HTTPS role for web 
# servers, an allow all rule for shell servers, and a group to restrict access to
# the database.
###

# Default security group to access instances over SSH, HTTP, and HTTPS
resource "aws_security_group" "web" {
    name        = "web"
    description = "Allows SSH, HTTP, and HTTPS to web servers"
    vpc_id      = "${var.vpc_id}"

    # SSH access from anywhere
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # HTTP access from anywhere
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # HTTPS access from anywhere
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow outbound internet access
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Default security group to enable unfederated access. Should be used
# for the shell server only, and further locked down if possible.
resource "aws_security_group" "shell" {
    name        = "shell"
    description = "Allows full access from internet to shell servers"
    vpc_id      = "${var.vpc_id}"

    # Allow inbound access to all ports from anywhere 
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow outbound internet access
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Security group for servers to access the database.
# This is typically only web.
resource "aws_security_group" "db_access" {
    name        = "db_access"
    description = "Identifies servers allowed access to the database"
    vpc_id      = "${var.vpc_id}"
}
