# Vagrantfiles

This project uses [Vagrant](https://www.vagrantup.com/) to configure a reproducible development environment.  The Vagrantfile in the top level of this repository will launch a minimal two machine setup (web and shell) configured for easy local development. This will most likely be the primary setup you are interested in.

## Alternative Configurations
Since Vagrant makes virtual machines so inexpensive to create and destroy, this directory has a number of different configurations you might find also find useful. In order to use these alternative configurations simply change into the directory and run `vagrant up`.  The majority of these configurations will automatically be provisioned using the provided [ansible](../ansible) playbooks. Those that don't, to simulate the production full workflow, will explain what configuration is required.

### [LAN Competition](./lan_competition)
This configuration deploys a two machine setup similar to the development environment, but with the appropriate hardening and configurations you would expect in a production setting. 

[TODO] Not yet implemented.

### [Local Testing](./local_testing)
This configuration matches the two tier testing/production configuration that is defined in [terraform](../terraform).  It is useful to ensure the competition could deploy to the cloud without having to incur any expense or network overhead. Also, even with terraform, local vms are much easier to create and destroy than AWS instances.

Since this configuration is intended for end to end testing of the automation process, it does not automatically conduct any provisioning. Once you have brought the virtual machines up with `vagrant up` you should provision it with the following command from the `ansible` directory:
    
    ansible-playbook -i inventories/local_testing site.yml

If you are on a Windows host, you will not be able to use `ansible` directly, but thanks to vagrant we have you taken care of with the [Deployment Jump Box](#deployment-jump-box).

### [Deployment Jump Box](./jump_box)
This is a simple machine that has all the necessary deployment tools already installed (ansible, terraform, and dependencies).  Anyone can use it, but it is particularly useful for those on Windows hosts who cannot use `ansible` directly.  You might consider this to deploy picoCTF to Amazon Web Services. This does not actually host any element of the picoCTF platform.

## Other Configurations?
As these examples hopefully illustrate the platform can be deployed in a large number of ways. The great thing is that they are all based off the exact same codebase and provisioning scripts. If there is a configuration that you think would be useful but don't see represented here, feel free to tweak one of the existing ones.  Or, make a new directory for it and submit a pull request.  Port the platform to a different OS base? Multiple shell servers?  All could be interesting and useful.

The goal is for these Vagrantfiles to remain minimal and all the configuration to be generalized in the ansible playbooks.

## Resource Considerations
Another great feature of Vagrant is it allows you to make the most of your computer's resources, no matter how large or small. It certainly isn't necessary, or advisable, to run all of these configurations at the same time, they are only here to serve specific development and testing use cases.

Since it is so easy to start and stop the virtual machines, it is recommended that when you are not using them you stop them with `vagrant halt`. This will prevent your CPU and Memory from being used. When you want to use it again it's just a `vagrant up` away.

If you want to try an alternative configuration but are concerned all the virtual machines will take up too much space, you can always completely remove them with `vagrant destroy`.  You will always be able to get the machines back to the previous state, with a `vagrant up` and whatever provisioning is necessary.  The only exception to this is if you destroy a virtual machine that is hosting the database (mongodb) you will loose all competition progress.
