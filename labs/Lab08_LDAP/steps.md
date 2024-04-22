# LDAP Authentication

When Kafka is configured to use SASL authentication, clients will need to provide
authentication credentials to connect to the Kafka server.  Upon connecting to
the server, the Kafka client must provide a username and password which the server
will use to determine if the user is allowed to connect to the server.

## Step 1: Start an LDAP Server

Start a local LDAP server using the management script located in the `lab`
directory:

```
./ldap-server.sh start
```

The LDAP server will be started in the background.  You can also obtain
information about the server such as the port or connection string by
using the `info` argument:

```
./ldap-server.sh info
```

Once the LDAP server is running, start the JExplorer UI and use it to
import user data:

```
./ldap-server.sh browse
```

Connect to the LDAP server by navigating to `File -> Connect` and specify
the following values:

* Host: localhost
* Port: 10389

Once connected, use the menu at the top of the screen to import an LDIF file:
`LDIF -> Import File`

A sample LDIF file has been provided in the `Lab08_LDAP/config/pirates.ldif`
file.  Select this file and click the `Import` button to load the data.

Once the LDAP user information has been populated, you can exit the JXplorer
application by navigating to `File -> Exit JXplorer`


## Step 2: Configure the Authentication Plugin

Review the Kafka configuration changes required to enable and configure the
authentication plugin.  You can use the lab management script located in the
`lab` directory to view the config file changes:

```
./kafka-server.sh diff Lab08_LDAP
```

This will display the diff between the original baseline configuration
found in Lab01.  In particular, note the use of a handler to override
the default behavior for the `sasl_plaintext` listener:

```
listener.name.sasl_plaintext.plain.sasl.server.callback.handler.class=\
  com.sas.kafka.auth.KafkaAuthenticationHandler
```

This tells Kafka to use the `KafkaAuthenticationHandler` class to perform
user authentication whenever a client connects to the `sasl_plaintext`
listener.  The full Kafka configuration file can be found in:

```
Lab08_LDAP/config/server.properties
```

## Step 2: Start the Kafka server

Start the Kafka server using the lab management script:

```
./kafka-server.sh start Lab08_LDAP
```

This will start Kafka as a background process, allowing you to continue
working in the current shell window after the Kafka server has started.

## Step 3: Follow the Server Logs

Use the lab management script to locate the Kafka log directory:

```
./kafka-server.sh info Lab08_LDAP
```

The "Kafka server information" section of output indicates the directory
where Kafka logs can be found:

```
Logs Directory:     /home/yourname/kafka-training/labs/Lab08_LDAP/logs
Bin Directory: 	    /home/yourname/kafka-training/labs/src/kafka/bin
```

Make note of the `bin` directory as this will be used in subsequent steps.
View the contents of the `logs` directory to see a list of logs generated
by the Kafka server:

```
ls -1 /home/yourname/kafka-training/labs/Lab08_LDAP/logs
```

You can monitor the output of the server log in real time using the `tail`
command:

```
tail -f /home/yourname/kafka-training/labs/Lab08_LDAP/logs/server.log
```

Leave this terminal window open and continue tailing the output of the
server log for the remainder of this lab.

## Step 4: Connect without Credentials

While continuing to tail the server log, open a new terminal and use
the Kafka tools to connect to the server without providing user credentials.
To do this, change to the `bin` directory noted in the previous step:

```
cd /home/yourname/kafka-training/labs/src/kafka/bin
./kafka-console-producer.sh \
   --bootstrap-server localhost:9092 \
   --topic Lab08_LDAP
```

Notice that the console client attempts to connect but repeatedly prints
a warning message to the console indicating that authentication failed:

```
WARN [Producer clientId=console-producer] Bootstrap broker localhost:9092 (id: -1 rack: null) disconnected
```

While this is running, view the output of the `server.log` in the other
terminal window and you should see authentication failures in the server
log as well:

```
INFO [SocketServer listenerType=BROKER, nodeId=1] Failed authentication with /127.0.0.1
```

In the console producer terminal, use the `Control - C` hotkey sequence to
terminate the client.

## Step 5: Connect with Credentials

In order for the client to authenticate with LDAP, a username and password
must be provided by specifying a config file.  A sample config file has been
provided as part of this lab exercise:

```
Lab08_LDAP/config/client.properties
```

The contents of the config file should look something like this:

```
security.protocol=SASL_PLAINTEXT
sasl.mechanism=PLAIN

sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="kafkaadmin" password="Kafka1234";
```

Invoke the console producer using the `--producer-config` argument
when starting the console producer to use the authentication credentials:

```
./kafka-console-producer.sh \
   --producer.config /home/yourname/kafka-training/labs/Lab08_LDAP/config/client.properties \
   --bootstrap-server localhost:9092 \
   --topic Lab08_LDAP
```

This time notice that the output of the `server.log` contains additional log
messages about each authentication attempt as the client attempts to connect
to the Kafka server using SASL authentication.

In the console producer terminal, use the `Control - C` hotkey sequence to
terminate the client.

## Step 6: Stop the Kafka server

The lab is now complete.  Use the lab management script to terminate the Kafka server:

```
./kafka-server.sh stop Lab08_LDAP
```

## Step 7: Stop the LDAP server

```
./ldap-server.sh stop
```
