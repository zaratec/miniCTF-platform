# This module configures persistent public IP addresses running picoCTF on AWS

# Inputs:
variable "web_id" {}
variable "shell_id" {}

# Outputs:
output "web_eip" {
    value = "${aws_eip.web.public_ip}"
}
output "shell_eip" {
    value = "${aws_eip.shell.public_ip}"
}

###
# Elastic IP:
# This simplifies configuration and administration by allowing us to rebuild
# and recreate the servers while maintaining the same public ip.
###

# Create Elastic IP for web server
resource "aws_eip" "web" {
    instance = "${var.web_id}"
    vpc = true
}

# Create Elastic IP for shell server
resource "aws_eip" "shell" {
    instance = "${var.shell_id}"
    vpc = true
}
