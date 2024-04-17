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
LDAP_BIN_DIR="$SCRIPT_DIR/bin/apacheds"
LDAP_TMP_DIR="$SCRIPT_DIR/tmp/apacheds"

LDAP_DOWNLOAD_URL="https://dlcdn.apache.org/directory/apacheds/dist/2.0.0.AM27/apacheds-2.0.0.AM27.tar.gz"
LDAP_ARCHIVE_FILE=`basename $LDAP_DOWNLOAD_URL`

################################## FUNCTIONS ##################################

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


#################################### MAIN #####################################


tmpdownload="$LDAP_TMP_DIR/$LDAP_ARCHIVE_FILE"
if [ ! -f $tmpdownload ]; then
    # Download the Apache DS binary from the internet
    mkdir -p $LDAP_TMP_DIR
    curl --silent -o $tmpdownload $LDAP_DOWNLOAD_URL
    failOnError $? "Failed to download Apache DS from $LDAP_DOWNLOAD_URL"

    # Extract the contents of the archive into a temp location
    cd $LDAP_TMP_DIR
    tar xzf $LDAP_ARCHIVE_FILE
    rm $tmpdownload

    # Remove the previously extracted binary files and move the download files into place
    rm -rf $LDAP_BIN_DIR
    mv $LDAP_TMP_DIR/apacheds-* $LDAP_BIN_DIR
fi

