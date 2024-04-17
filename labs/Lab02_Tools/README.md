# Command-line Tools

In this lab you will experiment with some of the commonly used command-line
utilities that ship with Kafka.  You will use the command-line tools to
interact with a running Kafka server to perform the following tasks:

* Create a new Kafka topic
* View information about an existing Kafka topic
* Publish messages to a Kafka topic
* Consume messages from a Kafka topic

## Kafka Topics

Kafka topics are used to categorize and organize messages.  Typically a
single topic should only contain messages of the same format and type.
For example, a "log" topic might contain individual JSON messages
corresponding to a single line or "event" from a system log.  Producers
write messages to the topic and consumers read messages from the topic.
If the message needs to be parsed, both the producer and consumer should
have a consistent way to handle the message parsing.  Kafka access controls
are enforced at the topic level.

## Kafka Messages

Kafka does not place any restrictions on the content of a message other
than the maximum size of the content.  In this lab we will use plain
unformatted text strings as the message content.  Common message formats
include JSON, Avro, and protobuf.  The message producers and consumers
of a topic must agree on how to interpret the message content if they
need to parse the message as structured data.
