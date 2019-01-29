# picoCTF-shell-manager

The picoCTF-shell-manager project consists of the `hacksport` library and the `shell_manager` utility which are used to create, package, and deploy challenges for use in a CTF.  During a competition these components can be used to run a shell-server where competitors are given access to the necessary command line tools and challenge related files.

This project has two goals:

1. To reduce the overhead associated with CTF challenges.
    - Prior to a competition during challenge creation.
    - During a competition for system administration and management.
2. To allow reproducible challenge sharing and reuse.

## Components

### hacksport

The hacksport library consists of a number of convenience functions related to challenge creations.  Specifically it provides the following features:

- Templating to support auto-generated challenge instances from a single problem source.
- Creation of Debian packages (.deb) from problem sources to ease sharing and reuse.
- Dependency management for challenges.
- Common challenge functionality such as random flags, file permissions, and remotely accessible services.

Examples of how to use the hacksport library to create picoCTF compatible challenges are available in the [picoCTF-problems](../picoCTF-problems/) directory.  Additionally end-to-end documentation examples are covered on the wiki under [Adding Your Own Content](https://github.com/picoCTF/picoCTF/wiki/Adding-Your-Own-Content).

### shell_manager

The `shell_manager` is the utility that a competition organizer would use to package, deploy, and manage challenge instances on a picoCTF-platform shell-server.  This tool builds on the hacksport library and problem specification metadata to turn challenge sources into deployed instances which a competitor will face in a CTF.

The [picoCTF-web](../picoCTF-web) integrates with the `shell_manager` utility to expose deployed challenges to competitors.
