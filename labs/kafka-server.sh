#!/bin/bash
#
# This script is used to perform lab operations such as starting or stopping the Kafka service.
#
# Copyright © 2024, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0


# Get the directory containing this shell script so we can reference other scripts
workdir=`pwd`
basedir=`dirname $0`
SCRIPT_BASE=`basename $0 .sh`
SCRIPT_DIR=`cd $basedir; pwd`
SCRIPT_ENV="$SCRIPT_DIR/${SCRIPT_BASE}.env"

TRUE=0
FALSE=1

# Source an environment file with overrides for the global variables
if [ -f $SCRIPT_ENV ]; then
    source $SCRIPT_ENV
fi

# Root directory where the Kafka lab environment will reside
LAB_SRC_DIR="$SCRIPT_DIR/src"
mkdir -p $LAB_SRC_DIR

# Determine whether to rebuild the Kafka libraries from source
BUILD_ENABLED=$FALSE

# Specify the minimum Java version required to run Kafka
MINIMUM_JAVA_VERSION="15"


# ================== Kafka Monitoring ==================
#JMX_PORT="9001"
KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote.port=9001 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false -javaagent:/etc/prometheus/jmx_exporter_javaagent.jar=9404:/etc/prometheus/jmx_exporter.yml"

# ================ Kafka Git Repository ================

DEFAULT_KAFKA_REPO_URL="https://github.com/apache/kafka.git"

# The following variables are set in this section:
#   KAFKA_GIT_REPO  - Git URL of the Kafka repository
#   KAFKA_REPO_NAME - Short name of the repo (without the .git extension)
#   KAFKA_REPO_DIR  - Path to the Git repo on the local filesystem

# If the repo directory is specified in the env file, use git to figure out the other stuff
if [ -n "$KAFKA_REPO_DIR" ]; then
    if [ ! -d "$KAFKA_REPO_DIR/.git" ]; then
        echo "ERROR: The Kafka directory does not contain a valid git repository: $KAFKA_REPO_DIR"
        exit 1
    fi
    KAFKA_REPO_NAME=$(basename $KAFKA_REPO_DIR)
    KAFKA_GIT_REPO=$(cd $KAFKA_REPO_DIR; git config -l | grep "^remote.origin.url=" | awk -F = '{print $2}')
else
    KAFKA_GIT_REPO="$DEFAULT_KAFKA_REPO_URL"
    KAFKA_REPO_NAME=`basename $KAFKA_GIT_REPO .git`
    KAFKA_REPO_DIR="$LAB_SRC_DIR/$KAFKA_REPO_NAME"
fi

# ========== Kafka Authentication Plugin Git Repository ==========

# The following variables are set in this section:
#   AUTH_GIT_REPO  - Git URL of the Kafka Authentication Plugin repository
#   AUTH_REPO_NAME - Short name of the repo (without the .git extension)
#   AUTH_REPO_DIR  - Path to the Git repo on the local filesystem

# If the repo directory is specified in the env file, use git to figure out the other stuff
if [ -n "$AUTH_REPO_DIR" ]; then
    if [ ! -d "$AUTH_REPO_DIR/.git" ]; then
        echo "ERROR: The Kafka Authentication Plugin directory does not contain a valid git repository: $AUTH_REPO_DIR"
        exit 1
    fi
    AUTH_REPO_NAME=$(basename $AUTH_REPO_DIR)
    AUTH_GIT_REPO=$(cd $AUTH_REPO_DIR; git config -l | grep "^remote.origin.url=" | awk -F = '{print $2}')
else
    AUTH_GIT_REPO="https://github.com/sassoftware/kafka-authentication-plugin.git"
    AUTH_REPO_NAME=`basename $AUTH_GIT_REPO .git`
    AUTH_REPO_DIR="$LAB_SRC_DIR/$AUTH_REPO_NAME"
fi



################################## FUNCTIONS ##################################

#
# Display the command-line usage
#
function displayUsage() {
    echo ""
    echo "USAGE: $0 [options] <action> <lab>"
    echo ""
    echo "OPTIONS:"
    echo ""
    echo "   -b       Rebuild Kafka from source"
    echo "   -h       Display this usage information"
    echo ""
    echo "ACTION:"
    echo ""
    echo "   clean    Remove Kafka server log files"
    echo "   diff     Compare the server propeties against a known baseline"
    echo "   info     Display information about the Kafka server environment"
    echo "   start    Start a Kafka server"
    echo "   status   Display information about the running Kafka server"
    echo "   stop     Stop any running Kafka servers"
    echo ""
    echo "LAB:"
    echo ""
    echo "   Name of the lab settings to use when starting Kafka"
    ls -1 -d Lab??_* | sed 's/^Lab/  - Lab/g'
    echo ""
    echo "ENV:"
    echo ""
    echo "   The following variables can be defined in ${SCRIPT_BASE}.env or set as"
    echo "   environment variables to override default script behavior:"
    echo ""
    echo "   AUTH_REPO_DIR    Directory containing the Kafka Authentication Plugin git repository"
    echo "   KAFKA_REPO_DIR   Directory containing the Kafka git repository"
    echo ""
    echo "EXAMPLES:"
    echo ""
    echo "   The following example executes kafka using Lab01 settings:"
    echo ""
    echo "      $0 info Lab01" 
    echo ""
}

#
# Display information about the Kafka server
#
function displayInfo() {
    datadir=$(printPropertyValue "log.dirs")
    bootstrap=$(printPropertyValue "advertised.listeners" | sed 's#[^:]*://##')

    if [ -n "$LOG_DIR" ]; then
        logdir="$LOG_DIR"
    else
        logdir="$KAFKA_REPO_DIR/logs"
    fi

    echo ""
    echo "Kafka server information:"
    echo ""
    printf "   Bootstrap Server: \t$bootstrap\n"
    printf "   Data Directory: \t$datadir\n"
    printf "   Logs Directory: \t$logdir\n"
    printf "   Bin Directory: \t$KAFKA_REPO_DIR/bin\n"
    echo ""
    echo "Starting Kafka:"
    echo ""
    echo "   cd $KAFKA_REPO_DIR"
    echo "   export LOG_DIR=\"$LOG_DIR\""
    echo "   ./bin/kafka-server-start.sh -daemon $LAB_PROPFILE"
    echo ""
    echo "Kafka commands:"
    echo ""
    echo "   cd $KAFKA_REPO_DIR"
    echo "   ./bin/kafka-topics.sh --bootstrap-server=localhost:9092 --list"
    echo "   ./bin/kafka-console-producer.sh --bootstrap-server=localhost:9092 --topic $LAB_NAME"
    echo "   ./bin/kafka-console-consumer.sh --bootstrap-server=localhost:9092 --topic $LAB_NAME" 
    echo ""
}

#
# Display the differences between the original prop file and the lab configuration
#
function diffPropertyFiles() {
    diff $ORIG_PROPFILE $LAB_PROPFILE
    result=$?
    if [ $result -eq 0 ]; then
        echo "The lab property file is identical to the original."
    fi
}

#
# Parse the property file to get the property value 
#
function printPropertyValue() {
    property=$1
    grep "^${property}=" $LAB_PROPFILE | awk -F = '{print $2}'
}

#
# Check the result code and exit with an error message if it is not zero
#
function failOnError() {
    result=$1
    msg=$2

    if [ $result -ne 0 ]; then
        echo "ERROR: $msg"
        exit 1
    fi
}

#
# Initialize the Kafka evironment.
# If the Kafka data directories do not exist, they will be created and initialized. 
#
function initLabEnv() {
    # Determine if a JDK is available
    if [ -n "$JAVA_HOME" ]; then
        echo "Using JAVA_HOME = $JAVA_HOME"
        if [ -x $JAVA_HOME/bin/java ]; then
            majorVersion=$($JAVA_HOME/bin/java --version | head -1 | awk '{print $2}' | awk -F . '{print $1}')
        else
            echo "Java command is not executable: $JAVA_HOME/bin/java"
            exit
        fi
    else
        echo "Unable to find an installed JDK.  Please install one or set JAVA_HOME to point to an existing location."
        exit 1
    fi
}

#
# Remove any log files or other temporary data
#
function cleanLabEnv() {
    echo "Removing log files from $LOG_DIR"
    rm -f $LOG_DIR/*.log
}

#
# Build the Kafka jar file from source code
#
function buildKafka() {
    forceBuild=$BUILD_ENABLED

    # If the jar file does not exist, force a build
    ls $KAFKA_REPO_DIR/build/libs/${KAFKA_REPO_NAME}-*.jar > /dev/null 2>&1
    result=$?
    if [ $result -ne 0 ]; then
        forceBuild=$TRUE
    fi

    # If the source code does not exist, clone the repository
    if [ ! -d $KAFKA_REPO_DIR ]; then
        cd $LAB_SRC_DIR
        echo "Cloing Kafka source code from GitHub to $KAFKA_REPO_DIR"
        git clone $KAFKA_GIT_REPO
        failOnError $? "Failed to fetch Kafka source code."
    fi

    # Build the Kafka jar file from source
    if [ $forceBuild -eq $TRUE ]; then
        cd $KAFKA_REPO_DIR
        echo "Updating Kafka source from GitHub..."
        git pull --rebase
        ./gradlew --no-daemon clean jar
        failOnError $? "Failed to build Kafka source code."
    else
        echo "Using previously built Kafka jar files."
    fi
}

#
# Build the Kafka Authentication plugin jar file from source code
#
function buildAuth() {
    forceBuild=$BUILD_ENABLED
    authRepoJar="$AUTH_REPO_DIR/build/libs/${AUTH_REPO_NAME}-*.jar"

    # If the jar file does not exist, force a build
    ls $authRepoJar > /dev/null 2>&1
    result=$?
    if [ $result -ne 0 ]; then
        forceBuild=$TRUE
    fi

    # If the source code does not exist, clone the repository
    if [ ! -d $AUTH_REPO_DIR ]; then
        cd $LAB_SRC_DIR
        echo "Cloing Kafka Authentication Plugin source code from GitHub to $AUTH_REPO_DIR"
        git clone $AUTH_GIT_REPO
        failOnError $? "Failed to fetch Kafka Authentication Plugin source code."
    fi

    # Build the Kafka Authentication Plugin jar file from source 
    if [ $forceBuild -eq $TRUE ]; then
        cd $AUTH_REPO_DIR
        echo "Updating Kafka Authentication Plugin source from GitHub..."
        git pull --rebase
        ./gradlew --no-daemon clean jar
        failOnError $? "Failed to build Kafka Authentication Plugin source code."
    else
        echo "Using previously built Kafka Authentication Plugin jar files."
    fi
}

#
# Start the Kafka server
#
function startKafka() {
    # Include the Authentication jar in the classpath
    authJar=$(ls -1 $AUTH_REPO_DIR/build/libs/${AUTH_REPO_NAME}-*.jar)
    if [ -n "$authJar" ]; then
        echo "Adding Authentication Jar to the classpath: $authJar"
        export CLASSPATH="$authJar"
    else 
        echo "Authentication Jar not found.  Unable to add it to the Kafka server CLASSPATH"
    fi

    # Determine if the storage directory has been initialized
    formatStorage=$FALSE
    if [ ! -f $LAB_PROPFILE ]; then
        echo "Kafka property file does not exist: $LAB_PROPFILE"
        exit 1
    else
        datadir=$(printPropertyValue "log.dirs")
        if [ ! -d $datadir ]; then
            formatStorage=$TRUE
        elif [ ! -f $datadir/meta.properties ]; then
            formatStorage=$TRUE
        fi

        if [ $formatStorage -eq $TRUE ]; then
            echo "Initializing Kafka data directory: $datadir"
            cd $KAFKA_REPO_DIR
            KAFKA_CLUSTER_ID=$(./bin/kafka-storage.sh random-uuid 2>/dev/null)
            failOnError $? "Failed to generate a random UUID for Kafka storage."
            # Clean up the cluster ID in case there was other junk in the stdout
            KAFKA_CLUSTER_ID=$(echo "$KAFKA_CLUSTER_ID" | grep "^[[:alnum:]]")
            # Calculate the size of the UUID string so we can catch cases where the UUID is invalid
            idSize=$(echo "$KAFKA_CLUSTER_ID" | wc -c | tr -d '[:space:]')
            expectedSize=23
            if [ $idSize -ne $expectedSize ]; then
                echo "Invalid cluster ID: $KAFKA_CLUSTER_ID (expected $expectedSize characters, found $idSize characters)"
                exit 1
            fi
            echo "Cluster ID: $KAFKA_CLUSTER_ID"
            ./bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c $LAB_PROPFILE
            failOnError $? "Failed to format Kafka storage."
        else
            echo "Kafa data directory already exists: $datadir"
        fi
    fi

    echo "Starting Kafka..."
    cd $KAFKA_REPO_DIR
    ./bin/kafka-server-start.sh -daemon $LAB_PROPFILE 
    failOnError $? "Failed to start Kafka server."
}

#
# Stop the Kafka server
#
function stopKafka() {
    echo "Stopping Kafka..."
    cd $KAFKA_REPO_DIR
    ./bin/kafka-server-stop.sh
}

#
# Display server status
#
function displayStatus() {
    echo "TODO display server status"
}

#################################### MAIN #####################################

# Process the arguments
while getopts "bdhi" opt; do
    case $opt in
        b) BUILD_ENABLED=$TRUE;;
        h) displayUsage
           exit;;
        *) displayUsage 
           exit;;
    esac
done 
shift $((OPTIND - 1))

# Get the action to perform
if [ $# -eq 0 ]; then
    displayUsage
    exit
elif [ $# -lt 2 ]; then
    displayUsage
    echo ""
    echo "ERROR: You must provide an <action> and a <lab> argument."
    exit 1
elif [ $# -gt 2 ]; then
    displayUsage
    echo ""
    echo "ERROR: You have provided too many arguments.  Only the <action> and <lab> are required."
    exit 1
fi

# Get the user arguments
LAB_ACTION=$1
LAB_NAME=$2

# Get the lab name command-line argument
if [ ! -d $SCRIPT_DIR/$LAB_NAME ]; then
    echo ""
    echo "An invalid lab name has been provided.  Here are the list of avaiable options:"
    echo ""
    cd $SCRIPT_DIR
    ls -1 -d Lab??_* | sed 's/^Lab/  - Lab/g'
    firstlab=$(ls -1 -d Lab??_* | head -1)
    echo ""
    echo "EXAMPLE:"
    echo ""
    echo "      $0 $LAB_ACTION $firstlab"
    echo ""
    exit 1
fi

ORIG_PROPFILE="$SCRIPT_DIR/Lab01_Setup/config/server.properties"
if [ ! -f $ORIG_PROPFILE ]; then
    echo ""
    echo "ERROR: Original Kafka property file does not exist: $ORIG_PROPFILE"
    echo ""
    exit 1
fi

# Set the Kafka server config file
LAB_PROPFILE="$SCRIPT_DIR/$LAB_NAME/config/server.properties"
if [ ! -f $LAB_PROPFILE ]; then
    echo ""
    echo "ERROR: Lab Kafka property file does not exist: $LAB_PROPFILE"
    echo ""
    exit 1
fi

# Set the Kafka server log4j config file
LAB_LOG4J_CONFIG="$SCRIPT_DIR/$LAB_NAME/config/log4j.properties"
if [ -f $LAB_LOG4J_CONFIG ]; then
    export KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:$LAB_LOG4J_CONFIG"
fi

# Set the log directory for Kafka server logs
export LOG_DIR="$SCRIPT_DIR/$LAB_NAME/logs"

# Perform the lab action
case $LAB_ACTION in
    clean)
        cleanLabEnv
        ;;
    diff)
        diffPropertyFiles
        ;;
    info)
        displayInfo
        ;;
    start)
        initLabEnv
        buildKafka
        buildAuth
        displayInfo
        startKafka
        ;;
    status)
        displayStatus
        ;;
    stop)
        stopKafka
        ;;
    *)
        displayUsage
        echo ""
        echo "ERROR: Invalid action.  Valid actions are: diff, info, start, status, stop"
        echo ""
        ;;
esac


