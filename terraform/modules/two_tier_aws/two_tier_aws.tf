# A Terraform configuration that composes the picoCTF components into a two
# tier deployed configuration.
# This creates three machines
# 1. web,  hosts the web server
# 2. shell hosts challenges and provides competitor shell access
# 3. db

###
# Input Variables:
# Defaults are set in variables.tf and can be overloaded in the instantiating
# environmental configuration.
###

###
# Output:
# Return the following to the instantiating environment.
###

output "web_eip" {
    value = "${module.elastic_ip.web_eip}"
}
output "shell_eip" {
    value = "${module.elastic_ip.shell_eip}"
}
output "db_eip" {
    value = "${module.standalone_db.db_eip}"
}


###
# Infrastructure Components:
# The following sections use the specified variables to create the resources
# necessary to run the picoCTF platform in a single tier environment.
###

# Add SSH key which will be inserted as authorized in each machine
resource "aws_key_pair" "auth" {
    key_name   = "${var.key_name}"
    public_key = "${file(var.public_key_path)}"
}

# Create virtual network
module "network" {
    source = "../network"

    # Inputs can be overloaded in environment (eg: production, testing)
    vpc_cidr = "${var.vpc_cidr}"
    public_subnet_cidr = "${var.public_subnet_cidr}"
    availability_zone = "${var.availability_zone}"
}

# Create virtual firewall rules
module "security_groups" {
    source = "../security_groups"

    # Variables output from prior modules
    vpc_id = "${module.network.vpc_id}"
}

# Create virtual machines
module "servers" {
    source = "../servers"

    # Inputs can be overloaded in environment (eg: production, testing)
    user = "${var.user}"
    key_pair_id = "${aws_key_pair.auth.id}"

    ami = "${lookup(var.amis, var.region)}"
    availability_zone = "${var.availability_zone}"

    web_instance_type = "${var.web_instance_type}"
    web_private_ip = "${var.web_private_ip}"
    web_name = "${var.web_name}"

    shell_instance_type = "${var.shell_instance_type}"
    shell_private_ip = "${var.shell_private_ip}"
    shell_name = "${var.shell_name}"

    competition_tag = "${var.competition_tag}"
    env_tag = "${var.env_tag}"

    # Variables output from prior modules
    subnet_id = "${module.network.public_subnet_id}"
    sg_web_id = "${module.security_groups.sg_web_id}"
    sg_shell_id = "${module.security_groups.sg_shell_id}"
    sg_db_access_id = "${module.security_groups.sg_db_access_id}"
}

# Create stand alone database in a second tier
module "standalone_db" {
    source = "../standalone_db"

    # Inputs can be overloaded in environment (eg: production, testing)
    user = "${var.user}"
    key_pair_id = "${aws_key_pair.auth.id}"

    ami = "${lookup(var.amis, var.region)}"
    availability_zone = "${var.availability_zone}"

    db_instance_type = "${var.db_instance_type}"
    db_private_ip = "${var.db_private_ip}"
    db_name = "${var.db_name}"

    competition_tag = "${var.competition_tag}"
    env_tag = "${var.env_tag}"

    # Variables output from prior modules
    vpc_id = "${module.network.vpc_id}"
    subnet_id = "${module.network.public_subnet_id}"
    sg_db_access_id = "${module.security_groups.sg_db_access_id}"

}

# Create persistent IP addresses
module "elastic_ip" {
    source = "../elastic_ip"

    # Variables output from prior modules
    web_id= "${module.servers.web_id}"
    shell_id="${module.servers.shell_id}"
}

# Create persistent data stores
module "ebs_volumes" {
    source = "../ebs_volumes"

    # Variables from varaibles.tf and terraform.tfvars
    availability_zone = "${var.availability_zone}"
    db_ebs_data_size = "${var.db_ebs_data_size}"
    db_ebs_data_device_name = "${var.db_ebs_data_device_name}"

    db_ebs_name = "${var.db_ebs_name}"
    competition_tag = "${var.competition_tag}"
    env_tag = "${var.env_tag}"

    # Variables output from prior modules
    db_host_id ="${module.standalone_db.db_id}"
}
