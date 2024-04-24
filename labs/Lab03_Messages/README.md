# Kafka Messages

Kafka does not place any restrictions on the content of a message other
than the maximum size of the content.  In this lab we will use plain
unformatted text strings as the message content.  Common message formats
include JSON, Avro, and protobuf.  The message producers and consumers
of a topic must agree on how to interpret the message content if they
need to parse the message as structured data.
