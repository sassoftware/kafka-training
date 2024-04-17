# Local Deployment

The objective of this lab is to run Kafka processes on the local host using
a locally installed Java JVM.  To do this you will need to to the following: 

* Download and install a Java JVM such as OpenJDK for your operating system 
* Download the Kafka source code
* Start the Kafka server 

## Step 1: Download and install the Java JDK 

Kafka is writting in Java, so you must have a Java JDK installed locally
in order to run Kafka.  Typically OpenJDK is the best option for most
operating systems.  Use a search engine to get information on how to install
OpenJDK for your operating system or you can download a tar.gz from the
OpenJDK website containing the JDK binaries.

## Step 2: Download the Kafka source code

If you plan to modify or debug the Kafka source code, you may want to
clone the Git repository:

[https://github.com/apache/kafka.git](https://github.com/apache/kafka.git)

For convenience, the `kafka-server.sh` script included with these labs will
clone the repository for you using a local git client and compile the source
using the installed JDK.  This makes it convenient to debug or inspect the
Kafka source code in later labs if you wish to dig deeper into Kafka
internals.

## Step 3: Execute the `kafka-server.sh` script

The bash shell script included in this repository under `labs/kafka-server.sh`
is used to manage the Kafka server used in these labs.  Basic usage information
can be viewed for the script by executing the following from the root of the
`kafka-training` repository:

```
cd labs
./kafka-server.sh -h
```

This displays information about the command-line arguments used by the script
as well as information about environment variables that can be defined to
modify script behavior.

## Step 3: Start the Kafka server

While you can download the Kafka binaries directly and start the Kafka server
using the command-line tools provided with the Kafka distribution, this lab
and all future labs assume that you are using the `kafka-server.sh` script
to manage Kafka.  This helps simplify the lab instructions by ensuring that
Kafka is started consistently using the `server.properties` file available
in each lab under the `config` directory.  There is nothing magical about this
script, it just automates some of the mundane tasks like obtaining Kafka,
keeping track of the `server.properties` file, and managing more advanced
configurations used in later labs.

To start the Kafka server using this shell script, execute the following
command from the `labs` directory of this repository:

```
./kafka-server.sh start Lab01_Setup
```

This will start Kafka as a background process, allowing you to continue
working in the current shell window after the Kafka server has started.

## Step 4: Get Information about the Kafka Server

The following command can be used to get information about how the Kafka
instance will be configured for the specified lab.  For example:

```
./kafka-server.sh info Lab01_Setup
```

This will display information such as:
* The list of Kafka bootstrap servers (used to connect to the Kafka brokers)
* The log, data, and bin directories for the current lab
* Examples of how to invoke Kafka commands directly without using the `kafka-server.sh` script

## Step 5: Review the Kafka server log

The Kafka server log is the primary way to determine if the Kafka cluster
is working correctly.  You can view this log after starting the Kafka server
to determine if the server started correctly.  You can monitor the log
in real time using:

```
tail -f Lab01_Setup/logs/server.log
```

If the Kafka server fails to start, information in the log file should help
you determine the source of the problem.
