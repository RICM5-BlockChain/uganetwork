#!/bin/bash

CHANNEL_NAME="ugachannel"
CLI_TIMEOUT=10
CLI_DELAY=3
COMPOSE_FILE=docker-compose-cli.yaml




CHANNEL_NAME=$CHANNEL_NAME TIMEOUT=$CLI_TIMEOUT DELAY=$CLI_DELAY docker-compose -f $COMPOSE_FILE -f docker-compose-cas.yaml up -d 2>&1

echo "Printing CLI logs :"


docker logs -f cli
