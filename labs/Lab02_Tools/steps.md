# Exploring Command-Line Tools

Kafka comes with a collection of command-line tools that can be used to interact
with the server.  The objective of this lab is to learn how to use a few of these
tools go get started experimenting with Kafka.  The command-line tools are located
in the Kafka bin directory.  In this lab you will use command-line tools to: 

* Create and inspect topics 
* Produce and consume messages

## Step 1: Start the Kafka server

To start the Kafka server using the lab management script, execute the following
command from the `labs` directory of this repository:

```
./kafka-server.sh start Lab02_Tools
```

This will start Kafka as a background process, allowing you to continue
working in the current shell window after the Kafka server has started.

## Step 2: Locate the Kafka command-line tools

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

## Step 3: Create a Topic

Kafka can be configured to auto-create topics by default as soon as the first message
is published, so this step may not be necessary depending on your Kafka configuration.
However, the command does help demonstrate how a topic can be created explicitly if
there is a need to customize the topic configuration.

Execute this command to view the various command-line options available when creating
topics:

```
cd $KAFKA_REPO_DIR
bin/kafka-topics.sh --help
```

Execute this command to create a new topic named "Lab02_Tools" with a default configuration:

```
bin/kafka-topics.sh --create --bootstrap-server=localhost:9092 --topic Lab02_Tools
```

## Step 4: List Topics

Use the following command to list all of the topics that currently exist:

```
bin/kafka-topics.sh --list --bootstrap-server=localhost:9092
```

At a minimum, the list should contain the topic creaed in the previous step.
If more topics exist, they will be displayed in the list as well.

## Step 5: Inspect a Topic

Once created, you can get information about the topic using the following command:

```
bin/kafka-topics.sh --describe --bootstrap-server=localhost:9092 --topic Lab02_Tools
```

For simple, single node Kafka clusters this information is not particularly interesting
because there is only one node that can act as the "leader" and the topic should only
be configured to use one replica.  In Kafka clusters with multiple nodes, the number
of replicas determines how resilient the topic is to the loss of a node.

## Step 6: Produce a Message

Kafka comes with a command-line utilities to produce and consume messages from the
console.  This is a convenient way to test out the producer/consumer functionality
or debug topics that contain low-volume, plain text messages.

Use the following command to start an interactive message producer where you can
type messages and send them to a Kafka topic:

```
bin/kafka-console-producer.sh --bootstrap-server=localhost:9092 --topic Lab02_Tools
```

This will create a connection to the Kafka server.  The command will display a
prompt and wait for user input.  Each line of text entered at this prompt will
be submitted to the Kafka topic as a new message.  Here is an example of two lines
of text being entered at the prompt:

```
> The quick brown fox
> jumps over the lazy dog.
>
```

Entering this text results in two messages being published to the Kafka `Lab02_Tools`
topic:

* Message 1:  The quick brown fox
* Message 2:  jumps over the lazy dog.

Keep this console session open for the next step to observe the interaction between
a producer and consumer.

## Step 7: Consume a Message

Now that messages have been published to a topic, the console consumer can be used
to read those messages from the topic and display them to the user.  For this step,
open a second terminal window and invoke the console consumer like this:

```
cd $KAFKA_REPO_DIR
bin/kafka-console-consumer.sh --bootstrap-server=localhost:9092 --topic Lab02_Tools
```

The console consumer will not display any previously published messages, but any
new messages published to the `Lab02_Tools` topic will be displayed in real-time.
Go back to your original console producer terminal and type additional text at
the prompt.  As each new line of text is entered in the producer console, it should
be displayed as output in the consumer console.

Now press the "Control - C" keys to terminate the console consumer and observe that
no new output is displayed until new messages are published to the topic.  When the
console consumer starts a new session, it tells the Kafka server to start consuming
messages at that point in time.  If you would like to consume all previous messages,
you can use the `--from-beginning` argument to start consuming at the earliest available
message:

```
bin/kafka-console-consumer.sh --bootstrap-server=localhost:9092 --topic Lab02_Tools --from-beginning
```

You should see all of the historical messages on this topic printed to the console
immediately once the consumer connects to the Kafka server.  You can invoke the `--help`
argument to view all of the options that can be used to consume messages with the
console consumer.

It is important to understand the relationship between producers, consumers, and the
Kafka server itself.  The Kafka server keeps track of each consumer (or consumer group)
that connects to the server and what message offset was last consumed.  This allows
consumers to resume at the same point they left off even if the consumer process
terminates and a new process is started.

## Step 8: Stop the Kafka server 

The lab is now complete.  You can use the "Control - C" keys to terminate any console
producers and consumers that are still running.  Use the lab management script to
terminate the Kafka server:

```
./kafka-server.sh stop Lab02_Tools
```