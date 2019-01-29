# Ansible Notes

These notes cover how we use [Ansible](https://www.ansible.com/) to provision, configure, and administer the picoCTF platform.

The goal is that nothing should have to be done as a one off on the command line. Every dependency, configuration, or process should be documented in code or a configuration and then applied using Ansible.

This automation drastically simplifies the process of getting blank machines to run the picoCTF platform. By using the same playbooks across the board we achieve a robust, repeatable, and consistent experience across development and production.  Additionally this allows the picoCTF platform to be deployed in a wide variety of configurations with minor configuration changes.

## Work Flow

### Provisioning Production on AWS 
If you are using the included Terraform configurations to create your infrastructure on AWS, these are the steps necessary to actually install, configure and launch the picoCTF platform.

1. Update the inventory (`inventories/remote_testing`) matches what Terraform has deployed.
    - This is required until we pull a dynamic inventory. 
    - `terraform show`
2. Check that syntax is correct and that playbooks and roles will all run
    - `ansible-playbook site.yml --check -i inventories/remote_testing`
3. Run the playbook for the site with on the remote testing hosts
    - `ansible-playbook site.yml -i inventories/remote_testing`

### For use with private repos
In order to deploy the picoCTF platform from a private repository you will need a read only deploy key added to the repo.

Generate a key with no passphrase and place in deploy_keys:
`ssh-keygen -f deploy.picoCTF.public-repo.id_rsa -C "deploy@picoCTF.public-repo" -N ""`
