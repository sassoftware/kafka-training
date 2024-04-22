# Implement LDAP Authentication

By default, Kafka SASL authentication supports defining credentials in the Kafka
property file or in the Kafka metadata when using KRaft.  This approach is not
very flexible because adding new users can be difficult in the case of property
files or impossible in the case of KRaft metadata.  For this reason, authentication
is typically handled by Kafka plugins.

This lab demonstrates how to implement client authentication using an Open Source
[Kafka Authentication Plugin](https://github.com/sassoftware/kafka-authentication-plugin).
The `kafka-server.sh` script used in previous labs will clone this repository and produce
a jar file that is added to the Kafka classpath when the server is started.  This
automation makes it easy to quickly experiment with the authentication plugin or make
changes without executing a complicated series of commands.  However, all of the
actions performed by the shell script can be executed individually from the command-line
for more granular control of the process.

## Using an LDAP Server

If you do not have an existing LDAP server to connect to, or would like to use
a local server for testing, the `ldap-server.sh` management script has been provided
in the same directory as the `kafka-server.sh` script.  This script will download
the ApacheDS LDAP server, a Java implementation which can be run on any operating
system.  The script will also download JXplorer, a Java UI which can be used to
connect to the LDAP server and browse or modify the data.


## References

* [KIP-86](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=65874679): Configurable SASL callback handlers

