docker rm -f $(docker ps -aq)
docker network prune
rm channel-artifacts/*
rm -rf crypto-config/
rm docker-compose-e2e.yaml