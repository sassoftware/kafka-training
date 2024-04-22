#!/bin/bash
# This script is used to start and stop the Apache Directory Server
# used for testing the Kafka LDAP authentication plugin.
#
# Copyright © 2024, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0


# Get the directory containing this shell script so we can reference other scripts
workdir=`pwd`
basedir=`dirname $0`
SCRIPT_DIR=`cd $basedir; pwd`

TRUE=0
FALSE=1

# Root directory where the Kafka lab environment will reside
LAB_SRC_DIR="$SCRIPT_DIR/src"
mkdir -p $LAB_SRC_DIR

# ApacheDS locations
ADS_BIN_DIR="$SCRIPT_DIR/bin/apacheds"
ADS_TMP_DIR="$SCRIPT_DIR/tmp/apacheds"

ADS_DOWNLOAD_URL="https://dlcdn.apache.org/directory/apacheds/dist/2.0.0.AM27/apacheds-2.0.0.AM27.tar.gz"
ADS_ARCHIVE_FILE=`basename $ADS_DOWNLOAD_URL`

ADS_PORT="10389"

# ===================== JXplorer Git Repository ==================

# Determine whether to clone and build the JXplorer project from source
JXP_BUILD_ENABLED=$FALSE

JXP_BIN_DIR="$SCRIPT_DIR/bin/jxplorer"
JXP_TMP_DIR="$SCRIPT_DIR/tmp/jxplorer"

JXP_DOWNLOAD_URL="https://github.com/pegacat/jxplorer/releases/download/v3.3.1.2/jxplorer-3.3.1.2-project.zip"
JXP_ARCHIVE_FILE=`basename $JXP_DOWNLOAD_URL`

# The following variables are set in this section:
#   JXP_GIT_REPO  - Git URL of the JXplorer repository
#   JXP_REPO_NAME - Short name of the repo (without the .git extension)
#   JXP_REPO_DIR  - Path to the Git repo on the local filesystem

# If the repo directory is specified in the env file, use git to figure out the other stuff
if [ -n "$JXP_REPO_DIR" ]; then
    if [ ! -d "$JXP_REPO_DIR/.git" ]; then
        echo "ERROR: The JXplorer directory does not contain a valid git repository: $JXP_REPO_DIR"
        exit 1
    fi
    JXP_REPO_NAME=$(basename $JXP_REPO_DIR)
    JXP_GIT_REPO=$(cd $JXP_REPO_DIR; git config -l | grep "^remote.origin.url=" | awk -F = '{print $2}')
else
    JXP_GIT_REPO="https://github.com/pegacat/jxplorer.git"
    JXP_REPO_NAME=`basename $JXP_GIT_REPO .git`
    JXP_REPO_DIR="$LAB_SRC_DIR/$JXP_REPO_NAME"
fi


################################## FUNCTIONS ##################################

#
# Display the command-line usage
#
function displayUsage() {
    echo ""
    echo "USAGE: $0 <action>"
    echo ""
    echo "ACTION:"
    echo ""
    echo "   browse   Start the JXplorer UI to browse the contents of an LDAP server"
    echo "   info     Display information about the LDAP server environment"
    echo "   start    Start an ApacheDS LDAP server"
    echo "   stop     Stop the ApacheDS LDAP server"
    echo ""
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
# Download the ApacheDS distribution and extract it to the filesystem
#
function installApacheDS() {

    # Extract the contents of the archive into a temp location
    if [ ! -d $ADS_BIN_DIR ]; then
        tmpdownload="$ADS_TMP_DIR/$ADS_ARCHIVE_FILE"
        if [ ! -f $tmpdownload ]; then
            # Download the Apache DS binary from the internet
            mkdir -p $ADS_TMP_DIR
            curl --silent -L -o $tmpdownload $ADS_DOWNLOAD_URL
            failOnError $? "Failed to download Apache DS from $ADS_DOWNLOAD_URL"
        else
            echo "Using previously downloaded ApacheDS archive: $tmpdownload"
        fi

        echo "Extracting the contents of the ApacheDS archive: $tmpdownload"
        cd $ADS_TMP_DIR
        tar xzf $ADS_ARCHIVE_FILE
        failOnError $? "Failed to extract ApacheDS files from $tmpdownload"

        # Identify the path to the extracted
        extractDir=`find $ADS_TMP_DIR -type d -d 1`
        failOnError $? "Failed to locate the extracted ApacheDS files in $ADS_TMP_DIR"

        echo "Moving ApacheDS from temporary location: $ADS_TMP_DIR/$extractDir"
        rm -rf $ADS_BIN_DIR
        mv $extractDir $ADS_BIN_DIR
    else
        echo "Using previously extracted ApacheDS installation: $ADS_BIN_DIR"
    fi
}

# Install JXplorer
function installJXplorer() {
    if [ $JXP_BUILD_ENABLED -eq $TRUE ]; then
        # Clone and build the JXplorer application
        # If the source code does not exist, clone the repository
        if [ ! -d $JXP_REPO_DIR ]; then
            cd $LAB_SRC_DIR
            echo "Cloing JXplorer source code from GitHub to $JXP_REPO_DIR"
            git clone $JXP_GIT_REPO
            failOnError $? "Failed to fetch JXplorer source code."
        fi

        echo "ABORT - TODO Build from source: $JXP_REPO_DIR"
        exit 1
    else
        # Extract the contents of the archive into a temp location
        if [ ! -d $JXP_BIN_DIR ]; then
            tmpdownload="$JXP_TMP_DIR/$JXP_ARCHIVE_FILE"
            if [ ! -f $tmpdownload ]; then
                # Download the binary from the internet
                mkdir -p $JXP_TMP_DIR
                curl --silent -L -o $tmpdownload $JXP_DOWNLOAD_URL
                failOnError $? "Failed to download JXplorer from $JXP_DOWNLOAD_URL"
            else
                echo "Using previously downloaded JXplorer archive: $tmpdownload"
            fi

            echo "Extracting the contents of the JXplorer archive: $tmpdownload"
            cd $JXP_TMP_DIR
            unzip -q $JXP_ARCHIVE_FILE
            failOnError $? "Failed to extract JXplorer files from $tmpdownload"

            # Identify the path to the extracted
            extractDir=`find $JXP_TMP_DIR -type d -d 1`
            failOnError $? "Failed to locate the extracted JXplorer files in $JXP_TMP_DIR"

            echo "Moving JXplorer from temporary location: $JXP_TMP_DIR/$extractDir"
            rm -rf $JXP_BIN_DIR
            mv $extractDir $JXP_BIN_DIR
        else
            echo "Using previously extracted JXplorer installation: $JXP_BIN_DIR"
        fi
    fi

    chmod u+x $JXP_BIN_DIR/jxplorer.sh
}

#
# Display information about the LDAP server
#
function displayInfo() {
    echo ""
    echo "LDAP server information:"
    echo ""
    printf "   LADP Server URL: \tldap://localhost:$ADS_PORT\n"
    echo ""
}

#################################### MAIN #####################################

# Get the action to perform
if [ $# -eq 0 ]; then
    displayUsage
    exit
elif [ $# -lt 1 ]; then
    displayUsage
    echo ""
    echo "ERROR: You must provide an <action> argument."
    exit 1
elif [ $# -gt 1 ]; then
    displayUsage
    echo ""
    echo "ERROR: You have provided too many arguments.  Only the <action> required."
    exit 1
fi

# Get the user arguments
SERVER_ACTION=$1

installApacheDS
installJXplorer

# Perform the lab action
case $SERVER_ACTION in
    browse)
        cd $JXP_BIN_DIR; $JXP_BIN_DIR/jxplorer.sh
        ;;
    info)
        displayInfo
        ;;
    start)
        $ADS_BIN_DIR/bin/apacheds.sh $SERVER_ACTION
        ;;
    stop)
        $ADS_BIN_DIR/bin/apacheds.sh $SERVER_ACTION
        ;;
    *)
        displayUsage
        echo ""
        echo "ERROR: Invalid action.  Valid actions are: start, stop"
        echo ""
        ;;
esac
