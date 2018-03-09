#!/bin/bash

docker rm -f $(docker ps -aq)
docker network prune --force
rm channel-artifacts/*
rm -rf crypto-config/
rm docker-compose-e2e.yaml
rm docker-compose-cas.yaml
