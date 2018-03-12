#!/bin/bash

# Script permettant de déployer composer sur le réseau 
# Nécessite d'avoir crée les fichiers connection....json

# Copie des clés publiques (certs) et des clés privés des Admins des orgs
cp ../crypto-config/peerOrganizations/polytech.ugachain.com/users/Admin@polytech.ugachain.com/msp/signcerts/Admin@polytech.ugachain.com-cert.pem ./polytech
cp ../crypto-config/peerOrganizations/polytech.ugachain.com/users/Admin@polytech.ugachain.com/msp/keystore/*_sk ./polytech

cp ../crypto-config/peerOrganizations/iae.ugachain.com/users/Admin@iae.ugachain.com/msp/signcerts/Admin@iae.ugachain.com-cert.pem ./iae
cp ../crypto-config/peerOrganizations/iae.ugachain.com/users/Admin@iae.ugachain.com/msp/keystore/*_sk ./iae

# Création des cartes des Admins de polytech:
# - avec seulement les peers de polytech
composer card create -p ./polytech/connection-polytech-only.json -u PeerAdmin \
    -c ./polytech/Admin@polytech.ugachain.com-cert.pem -k ./polytech/*_sk \
    -r PeerAdmin -r ChannelAdmin

# - avec tout les peers
composer card create -p ./polytech/connection-polytech.json -u PeerAdmin \
    -c ./polytech/Admin@polytech.ugachain.com-cert.pem -k ./polytech/*_sk \
    -r PeerAdmin -r ChannelAdmin

# Création des cartes des Admins de l'iae:
# - avec seulement les peers de de l'iae
composer card create -p ./iae/connection-iae-only.json -u PeerAdmin \
    -c ./iae/Admin@iae.ugachain.com-cert.pem -k ./iae/*_sk \
    -r PeerAdmin -r ChannelAdmin

# - avec tout les peers
composer card create -p ./iae/connection-iae.json -u PeerAdmin \
    -c ./iae/Admin@iae.ugachain.com-cert.pem -k ./iae/*_sk \
    -r PeerAdmin -r ChannelAdmin

# Import des cartes dans le wallet de composer
composer card import -f PeerAdmin@uga-network-polytech-only.card
composer card import -f PeerAdmin@uga-network-polytech.card

composer card import -f PeerAdmin@uga-network-iae-only.card
composer card import -f PeerAdmin@uga-network-iae.card

# Installation du runtime Hyperledger composer dans les peer
cd ..
composer runtime install -c PeerAdmin@uga-network-polytech-only -n uga-network
composer runtime install -c PeerAdmin@uga-network-iae-only -n uga-network

# Récupération du bna pour chaque org
composer identity request -c PeerAdmin@uga-network-polytech-only -u admin -s adminpw -d polytechadmin
composer identity request -c PeerAdmin@uga-network-iae-only -u admin -s adminpw -d iaeadmin

# Demarrage du business network
composer network start -c PeerAdmin@uga-network-polytech -a uga-network@0.0.1.bna \
    -o endorsementPolicyFile=endorsement-policy.json -A polytechadmin \
    -C polytechadmin/admin-pub.pem -A iaeadmin -C iaeadmin/admin-pub.pem \
    -l "DEBUG"


# Création et importation d'une nouvelle business network card (Polytech Admin)
composer card create -p composer/polytech/connection-polytech.json -u polytechadmin -n uga-network \
    -c polytechadmin/admin-pub.pem -k polytechadmin/admin-priv.pem
composer card import -f polytechadmin@uga-network.card

# Ping PolytechAdmin
composer network ping -c polytechadmin@uga-network

# Création et importation d'une nouvelle business network card (Iae Admin)
composer card create -p composer/iae/connection-iae.json -u iaeadmin -n uga-network \
    -c iaeadmin/admin-pub.pem -k iaeadmin/admin-priv.pem
composer card import -f iaeadmin@uga-network.card

# Ping IAEAdmin
composer network ping -c iaeadmin@uga-network
