#!/bin/bash -e

# Simple script for starting up maxwell

# Location to store temporary files.
export MAXWELL_SERVER_FILES=/tmp/maxwell-server-files
# Port to use for webserver.
PORT=9041
# Number of GPUS per solve.
NGPUS=1

# Main directory for Maxwell source code.
BASEDIR=.
SERVER_DIR=maxwell-server
PYTHON=python3

cd $BASEDIR

$PYTHON $SERVER_DIR/simserver.py $NGPUS &> $BASEDIR/simserver.log
