# Lab Exercises

This directory contains directories corresponding to each training lab,
as well as a set of shell scripts that will help manage the Kafka cluster
or any additional services required to complete the lab exercises.
The shell scripts are:

* `kafka-server.sh` - Used to start, stop, and manage the Kafka service
* `ldap-server.sh`  - (Optional) Used to manage an LDAP server for specific lab exercises

Each lab sub-directory contains a guided set of steps that help demonstrate
a Kafka concept.  Each directory contains the following files:

* README.md - An overview of the lab objective and any core concepts
* steps.md - Instructions for performing each step of the lab exercise
* config - Directory containing the Kafka server configuration files 

When starting each lab, review the README file to understand the lab
objectives and then follow each step in the `steps.md` file to complete
the lab.  Take time at each step in the lab to expore and ensure that
you understand the concept being presented.
 
## Starting and Stopping Services

Each lab requires starting a local Kafka server, and sometimes additional
services, to interact with during the lab.  It is important to start each
lab with a new Kafka process and finish the lab by shutting down the
services.  Since each lab may introduce Kafka configuration changes,
attempting to re-use a Kafka instance from a different lab may result in
incorrect behavior.

