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
 
