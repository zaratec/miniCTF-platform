# Terraform configuration to deploy picoCTF to AWS (testing)

###
# This configuration instantiates a single tier infrastructure for running the
# picoCTF platform on AWS. Once deployed this infrastructure can be
# provisioned, configured, and administered with ansible.
###

# These are the only variables you must explicitly configure as they determine
# where AWS will launch your resources.
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
# This demonstrates how the defaults for the single_tier_aws module can
# optionally be customized and overloaded for different environments.
###

# Create single tier infrastructure with environmental configuration
module "single_tier_aws" {
    source = "../modules/single_tier_aws"

    ## AWS Configuration
    region = "${var.region}"
    availability_zone = "${var.availability_zone}"

    ## SSH
    key_name = "pico_testing"
    public_key_path = "~/.ssh/picoCTF_testing_rsa.pub"

    ## Tags (use most module defaults)
    env_tag = "testing"

    ## Network (use module defaults, "10.0.0.0/16")
    ## Instances (use module defaults "t2.micro")
    ## EBS Volumes (use module defaults "10")
}

###
# Output:
# Return the following to the user for configuring the ansible inventory
###

output "Web Elastic IP address" {
    value = "${module.single_tier_aws.web_eip}"
}
output "Shell Elastic IP address" {
    value = "${module.single_tier_aws.shell_eip}"
}
