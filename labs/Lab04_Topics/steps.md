# Understanding Kafka Topics


## Step 1: Start the Kafka server

To start the Kafka server using the lab management script, execute the following
command from the `labs` directory of this repository:

```
./kafka-server.sh start Lab04_Topics
```

This will start Kafka as a background process, allowing you to continue
working in the current shell window after the Kafka server has started.
Take note of the "Bin Directory" indicated in the output of the command above.
The next few steps in this lab use the Kafka command-line utilities.

## Step 2: Create a Topic

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

Execute this command to create a new topic named "Lab04_Topics" with a default configuration:

```
bin/kafka-topics.sh --create --bootstrap-server=localhost:9092 --topic Lab04_Topics
```

## Step 3: List Topics

Use the following command to list all of the topics that currently exist:

```
bin/kafka-topics.sh --list --bootstrap-server=localhost:9092
```

At a minimum, the list should contain the topic creaed in the previous step.
If more topics exist, they will be displayed in the list as well.

## Step 4: Inspect a Topic

Once created, you can get information about the topic using the following command:

```
bin/kafka-topics.sh --describe --bootstrap-server=localhost:9092 --topic Lab04_Topics
```

For simple, single node Kafka clusters this information is not particularly interesting
because there is only one node that can act as the "leader" and the topic should only
be configured to use one replica.  In Kafka clusters with multiple nodes, the number
of replicas determines how resilient the topic is to the loss of a node.

The `kafka-configs` command will provide more detail about the configuration settings
that apply to the specified topic:

```
bin/kafka-configs.sh --bootstrap-server=localhost:9092 --topic Lab04_Topics --describe --all
```

## Step 5: Configure Data Retention

Retention policies can be define for each topic to restruct how much data is retained
on the server.  Retention policies can be defined based on the age of the messages or
the amount of storage consumed by the topic.  By default, Kafka will keep topic data
for 7 days.  The following command can be used to change the retention period for a
topic:

```
bin/kafka-configs.sh --bootstrap-server=localhost:9092 --alter --entity-type topics \
   --entity-name Lab04_Topics --add-config 'retention.ms=600000'
```

Kafka does not have a mechanism to "truncate" a topic similar to truncating a database
table, so the retention period is often set to zero (`0`) to force Kafka to purge
messages from a topic, and then immediately set back to the previous retention period.

## Step 6: Stop the Kafka server 

The lab is now complete.  Use the lab management script to terminate the Kafka server:

```
./kafka-server.sh stop Lab04_Topics
```