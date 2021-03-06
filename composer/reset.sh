#!/bin/bash

composer card delete -n PeerAdmin@uga-network-polytech-only
composer card delete -n PeerAdmin@uga-network-polytech
composer card delete -n PeerAdmin@uga-network-iae-only
composer card delete -n PeerAdmin@uga-network-iae
composer card delete -n polytechadmin@uga-network
composer card delete -n iaeadmin@uga-network
rm *.card
rm ./iae/*.pem
rm ./iae/*_sk
rm ./polytech/*.pem
rm ./polytech/*_sk
rm -rf composer-logs/
rm -rf iaeadmin/

cd ..
rm -rf iaeadmin/
rm -rf polytechadmin/
rm -rf composer-logs/
