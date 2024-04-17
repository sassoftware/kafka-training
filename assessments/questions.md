# Apache Kafka Training Assessment

The following questions are used to determine how well the user understands the
Kafka topics presented in the training material.  Users can choose to take the
assessment prior to the training in order to determine if there are any gaps in
their existing knowledge.  A score of 80% or greater indicates a sufficient grasp
of the material.

## Questions
---
Q1: Which term best describes a Kafka topic?

1. distributed transaction log
2. FIFO queue
3. database table
4. message schema

Answer: (1)

---
Q2: What topic configuration helps ensure that a Kafka topic is highly available?

1. a replication factor greater than one
2. a partition count greater than one
3. the minimum number of in-sync replicas
4. a message schema

Answer: (1)

---
Q3: What is the role of Zookeeper in a Kafka cluster?

1. leader election and consensus
2. coordinating locks
3. key/value store
4. configuration management

Answer: All of the above

---
Q4: Which one of the following is TRUE about a topic offset?

1. it is a unique ID number assigned to each message within a partition
2. it is a unique ID number assigned to each message within a topic
3. it guarantees the ordering of messages within a topic
4. a producer submits an offset ID along with the message

Answer: (1)

---
Q5: What is the role of a Schema Registry?

1. track each version of a message schema 
2. allow producers and consumers to validate message format
3. allow data verification to be performed external to the kafka brokers
4. allow producers and consumers to evolve independently over time

Answer: All of the above

---
Q6: What topic configuration item should be tuned to increase the number of
consumers that can operate in parallel within a single consumer group?

1. retention time
2. replication factor
3. segment size 
4. partition count

Answer: (4)

---
Q7: How can message order be guaranteed in Kafka?

1. It can't
2. By assigning a key to the messages
3. By sending the messages to the same broker
4. Message order is always guaranteed

Answer: (2)

---
Q8: What does "consumer lag" refer to with respect to Kafka?

1. The amount of time it takes to transmit a message from the broker to a consumer.
2. The number of messages between the latest offset and the consumer offset. 
3. The number of messages that have never been consumed by any consumer group.
4. The amount of time it takes a consumer to process a single message.

Answer: (2)

---
Q9: Kafka was originally developed at what company?

1. Yahoo!
2. Confluent
3. Linked-In
4. Landoop

Answer: (3)

---
Q10: What type of data can be written to a Kafka topic?

1. JSON
2. Any text or binary data
3. Only text strings
4. Avro

Answer: (2)

---
Q11: What is a Kafka KIP?

1. Kafka Inactive Partition - a partition which is no longer replicated
2. Kafka Invalid Protocol - an unsupported client connection format
3. Kafka Improvement Proposal - a proposal for a major change to Kafka
4. Kafka Inactive Producer - a producer which is no longer sending messages

Answer: (3)

---
Q12: How many brokers must be specified when connecting to a Kafka cluster?

1. All of them
2. At least one
3. At least three
4. No more than five

Answer: (2)

---
Q13: Why would a client specify multiple brokers when connecting to a Kafka cluster?

1. To allow messages to be produced or consumed in parallel
2. To perform load balancing across the specified brokers
3. In case there is a type-o in one of the hostnames
4. To ensure that a connection can be established if one broker is down

Answer: (4)

---
Q14: What should happen if the number of offline partitions is greater than zero?

1. The consumer should select a different topic
2. The offline partitions should be garbage collected
3. A monitoring alert should be triggered
4. Messages should be replicated to a different broker

Answer: (3)

---
Q15: When connecting to a Kafka topic which does not allow anonymous access,
clients must connect using:

1. HTTPS
2. SSL and SASL
3. PLAINTEXT
4. ACL

Answer: (2)

---
Q16: If you have a topic with 2 partitions and a consumer group with 3 consumers,
how will the consumers behave?

1. One consumer will be idle
2. All consumers will consume messages
3. Only one consumer will consume messages
4. One consumer will fail to connect to Kafka

Answer: (1)

---
Q17: How can a consumer group "reprocess" or consume messages that were already consumed?

1. Stop the brokers and restart them 
2. Stop the consumers and restart them
3. Messages cannot be consumed more than once
4. Update the consumer offset to a previous offset value

Answer: (1)

