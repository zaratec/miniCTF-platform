# Terraform configuration to deploy picoCTF to AWS (production)

###
# This configuration instantiates a single tier infrastructure for running the
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
# All variables are currently commented out because the defaults for the
# single_tier_aws module match a production deployment configuration.
# See the testing environment for an example of variables being overloaded.
###

# Create single tier infrastructure with environmental configuration
module "single_tier_aws" {
    source = "../modules/single_tier_aws"
    
    ## AWS Configuration
    #user = "admin"                                 # Default username for Debian AMIs
    region = "${var.region}"                        # configured above
    availability_zone = "${var.availability_zone}"  # configured above

    ## SSH
    #key_name = "pico_production"
    #public_key_path = "~/.ssh/picoCTF_production_rsa.pub"     # Ensure this is created

    ## Network
    #vpc_cidr = "10.0.0.0/16"
    #public_subnet_cidr = "10.0.1.0/24"
    #web_private_ip = "10.0.1.10"           # Update ansible config if changed
    #shell_private_ip = "10.0.1.11"         # Update ansible config if changed

    ## Instances
    #web_instance_type = "t2.micro"         # For a live competition consider upgrading
    #shell_instance_type = "t2.micro"       # For a live competition consider upgrading

    ## EBS Volumes
    #db_ebs_data_size = "10"                # Size accordingly
    #db_ebs_data_device_name = "/dev/xvdf"  # update ansible config if changed

    ## Tags                                 # These tags are for convenience
    #competition_tag = "picoCTF"            # update according to your needs
    #env_tag = "production"
    #web_name  = "picoCTF-web"
    #shell_name = "picoCTF-shell"
    #db_ebs_name = "picoCTF-db-ebs"
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
