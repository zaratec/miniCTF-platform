# Terraform configuration to deploy picoCTF to AWS (production two tier)

###
# This configuration instantiates a two tier infrastructure for running the
# picoCTF platform on AWS. Once deployed this infrastructure can be
# provisioned, configured, and administered with ansible.
###

# These are the only variables you must explicitly configure as they determine
# where AWS will launch your resources
variable "region" {
    # Choose best for where your CTF is
    default = "us-east-1"
}
variable "availability_zone" {
    # Determine using the AWS CLI or Dashboard
    default = "us-east-1b"
}

# AWS Specific config (single region)
# Configured to get access_key and secret_key from  environment variables
# For additional methods: https://www.terraform.io/docs/providers/aws/
provider "aws" {
    region = "${var.region}"
    #access_key = "${var.access_key}"
    #secret_key = "${var.secret_key}"
}

###
# Environmental Configuration
# See the testing environment for an example of variables being overloaded.
###

# Create two tier infrastructure with default configuration
module "two_tier_aws" {
    source = "../modules/two_tier_aws"
}

###
# Output:
# Return the following to the user for configuring the ansible inventory
###

output "Web Elastic IP address" {
    value = "${module.two_tier_aws.web_eip}"
}
output "Shell Elastic IP address" {
    value = "${module.two_tier_aws.shell_eip}"
}
output "DB Elastic IP address" {
    value = "${module.two_tier_aws.db_eip}"
}

