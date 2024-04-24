# Kafka Performance

Kafka comes with a command-line utility for executing performance tests against
the server by producing or consuming high volumes of data.

## Step 1: Start the Kafka server

To start the Kafka server using the lab management script, execute the following
command from the `labs` directory of this repository:

```
./kafka-server.sh start Lab05_Performance
```

This will start Kafka as a background process, allowing you to continue
working in the current shell window after the Kafka server has started.
Take note of the "Bin Directory" indicated in the output of the command above.
The next few steps in this lab use the Kafka command-line utilities.

## Step 2: Create a Topic

Change to the Kafka `bin` directory and execute the following command:

```
./kafka-topics.sh --create --if-not-exists --topic Lab05_Performance \
  --bootstrap-server localhost:9092 \
  --replication-factor 1 \
  --partitions 20
```

## Step 3: Configure Data Retention

In order to ensure that the performance data is cleaned up shortly after
being generated, use the following command to set the retention time on
the topic to 10 minutes (60k ms):

```
./kafka-configs.sh --bootstrap-server localhost:9092 --alter --entity-type topics \
  --entity-name Lab05_Performance --add-config retention.ms=600000
```

## Step 4: Produce Data

Use the following command to execute a performance test against the Kafka server.
The command will publish dummy content to a Kafka topic.

```
./kafka-producer-perf-test.sh --topic Lab05_Performance \
  --num-records 200 \
  --throughput 50 \
  --record-size 1024 \
  --producer-props bootstrap.servers=localhost:9092 batch.size=16384 acks=1 linger.ms=0
```

## Step 5: Consume Data

Consumer performance can also be measured by executing the following command to
consume messages:

```
./kafka-consumer-perf-test.sh --bootstrap-server localhost:9092 --topic Lab05_Performance \
  --messages 200
```

## Step 6: Stop the Kafka server

The lab is now complete.  Use the lab management script to terminate the Kafka server:

```
./kafka-server.sh stop Lab05_Performance
```