# Kafka Messages

Kafka comes with a command-line utility for producing and consuming messages
entered by the user from the console.  The objective of this lab is to learn how to: 

* Publish messages to a topic 
* Consume messages from a topic

## Step 1: Start the Kafka server

To start the Kafka server using the lab management script, execute the following
command from the `labs` directory of this repository:

```
./kafka-server.sh start Lab03_Messages
```

This will start Kafka as a background process, allowing you to continue
working in the current shell window after the Kafka server has started.

## Step 2: Produce a Message

Kafka comes with a command-line utilities to produce and consume messages from the
console.  This is a convenient way to test out the producer/consumer functionality
or debug topics that contain low-volume, plain text messages.

Use the following command to start an interactive message producer where you can
type messages and send them to a Kafka topic:

```
bin/kafka-console-producer.sh --bootstrap-server=localhost:9092 --topic Lab03_Messages
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

Entering this text results in two messages being published to the Kafka `Lab03_Messages`
topic:

* Message 1:  The quick brown fox
* Message 2:  jumps over the lazy dog.

Keep this console session open for the next step to observe the interaction between
a producer and consumer.

## Step 3: Consume a Message

Now that messages have been published to a topic, the console consumer can be used
to read those messages from the topic and display them to the user.  For this step,
open a second terminal window and invoke the console consumer like this:

```
cd $KAFKA_REPO_DIR
bin/kafka-console-consumer.sh --bootstrap-server=localhost:9092 --topic Lab03_Messages
```

The console consumer will not display any previously published messages, but any
new messages published to the `Lab03_Messages` topic will be displayed in real-time.
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
bin/kafka-console-consumer.sh --bootstrap-server=localhost:9092 --topic Lab03_Messages --from-beginning
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

## Step 4: Stop the Kafka server 

The lab is now complete.  You can use the "Control - C" keys to terminate any console
producers and consumers that are still running.  Use the lab management script to
terminate the Kafka server:

```
./kafka-server.sh stop Lab03_Messages
```