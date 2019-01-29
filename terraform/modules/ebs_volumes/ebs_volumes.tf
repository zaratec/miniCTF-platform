# This module configures the EBS resources for running picoCTF on AWS

# Inputs:
variable "availability_zone" {}
variable "db_ebs_data_size" {}
variable "db_ebs_data_device_name" {}
variable "db_host_id" {}

variable "db_ebs_name" {}
variable "competition_tag" {}
variable "env_tag" {}

###
# Elastic Block Storage:
# This allows competition data such as the database and user home directories
# to be easily backed up, restored, and moved to new machines. This increases
# flexibility to easily scale.
###

# Create EBS volume for MongoDB data and journal
# having them on the same device allows backup with --journal
resource "aws_ebs_volume" "db_data_journal" {
    availability_zone = "${var.availability_zone}"
    size = "${var.db_ebs_data_size}"
    tags {
        Name = "${var.db_ebs_name}"
        Competition = "${var.competition_tag}"
        Environment =  "${var.env_tag}"
    }
}

# Attach data and journal volume to the instance running the database
resource "aws_volume_attachment" "db_data_journal" {
  device_name = "${var.db_ebs_data_device_name}"
  volume_id = "${aws_ebs_volume.db_data_journal.id}"
  instance_id = "${var.db_host_id}"
}
