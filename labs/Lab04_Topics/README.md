# Kafka Topics

Kafka topics are used to categorize and organize messages.  Typically a
single topic should only contain messages of the same format and type.
For example, a "log" topic might contain individual JSON messages
corresponding to a single line or "event" from a system log.  Producers
write messages to the topic and consumers read messages from the topic.
If the message needs to be parsed, both the producer and consumer should
have a consistent way to handle the message parsing.  Kafka access controls
are enforced at the topic level.

