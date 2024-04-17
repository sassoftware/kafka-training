# Lab Questions

The purpose of this lab is to be able to start a Kafka server and become familiar
with the following aspects of the running server:

* Log directory where server logs are written
* Data directory where topic data is written
* Bin directory containing shell scripts used to invoke Kafka commands

If you are using the `local-server.sh` script to start Kafka, you can get more
information about these locations by using the following command:

```
./local-server.sh info Lab01_Setup
```

## Identify the Kafka log directory

Kafka logs contain information about server activity such as broker communication
and user connections.  The log directory is passed in to the Java JVM on startup.
It can either be specified as an environment variable that the Kafka startup
script uses or it can be passed in as a JVM argument.

Identify and view the contents of the following logs:

* server.log
* controller.log

## Identify the Kafka data directory

The Kafka data directory contains all the metadata and topic information for
the Kafka server.  If this directory is deleted, all server data will be lost.
The directory will need to be initialized before starting the Kafka server for
the first time.  The `local-server.sh` script takes care of initializing this
directory if it detects that it does not already exist.

Browse the contents of the data directory, particularly the contents of the
following files:

* meta.properties 

## Identify the Kafka bin directory

