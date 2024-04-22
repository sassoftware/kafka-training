# Exploring Command-Line Tools

Kafka comes with a collection of command-line tools that can be used to interact
with the server.  The objective of this lab is to learn how to use a few of these
tools go get started experimenting with Kafka.  The command-line tools are located
in the Kafka bin directory.  In this lab you will use command-line tools to: 

* Starting and Stopping the Kafka server
* View information about the server

## Step 1: Locate the Kafka command-line tools

The Kafka command-line tools are part of the Kafka distribution.  They are distributed
with the binary download archive or are available after building Kafka from source code.
by default, the `kafka-server.sh` script will clone the Kafka repository from GitHub
and build it from source.  Run the following command to identify where the Kafka
command-line tools are located:

```
./kafka-server.sh info Lab02_Tools
```

The output of the `info` acount should provide information about the location of the
Kafka `bin` directory as well as some examples of how to invoke the command-line tools.
Here is an example of the line of script output that shows the location of the Kafka
command-line tools directory:

```
Bin Directory: 	/home/yourname/kafka-training/labs/src/kafka/bin
```

View the contents of the `bin` directory to see a list of commands used to interact
with the Kafka server:

```
ls -1 /home/yourname/kafka-training/labs/src/kafka/bin
```

For readability, all future steps in this lab will use the following variable to refer
to the location of the Kafka repository as:

```
KAFKA_REPO_DIR = /home/yourname/kafka-training/labs/src/kafka
```
## Step 2: Start the Kafka server

To start the Kafka server using the lab management script, execute the following
command from the `labs` directory of this repository:

```
./kafka-server.sh start Lab02_Tools
```

This will start Kafka as a background process, allowing you to continue
working in the current shell window after the Kafka server has started.


## Step 3: Stop the Kafka server 

The lab is now complete.  Use the lab management script to terminate the Kafka server:

```
./kafka-server.sh stop Lab02_Tools
```