export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}

# Obtain the OS and Architecture string that will be used to select the correct
# native binaries for your platform
OS_ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}')
# timeout duration - the duration the CLI should wait for a response from
# another container before giving up
CLI_TIMEOUT=10
#default for delay
CLI_DELAY=3
# channel name defaults to "mychannel"
CHANNEL_NAME="ugachannel"
# use this as the default docker-compose yaml definition
COMPOSE_FILE=docker-compose-cli.yaml

# Génération des certification-------------------------------------------
cryptogen generate --config=./crypto-config.yaml

# Génération des clés privées--------------------------------------------

# Copy the template to the file that will be modified to add the private key
cp docker-compose-e2e-template.yaml docker-compose-e2e.yaml

# sed on MacOSX does not support -i flag with a null extension. We will use
# 't' for our back-up's extension and depete it at the end of the function
ARCH=`uname -s | grep Darwin`
if [ "$ARCH" == "Darwin" ]; then
  OPTS="-it"
else
  OPTS="-i"
fi

# The next steps will replace the template's contents with the
# actual values of the private key file names for the two CAs.
CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/polytech.ugachain.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml
cd crypto-config/peerOrganizations/iae.ugachain.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA2_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml
# If MacOSX, remove the temporary backup of the docker-compose file
if [ "$ARCH" == "Darwin" ]; then
  rm docker-compose-e2e.yamlt
fi

# Génération des artéfacts---------------------------------------------

# ORDERER GENESIS BLOCK
# Note: For some unknown reason (at least for now) the block file can't be
# named orderer.genesis.block or the orderer will fail to launch!
configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

# CHANNEL CONFIGURATION TRANSACTION "channel.tx"
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

# ANCHOR PEER UPDATE FOR POLYTECH_MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/PolytechMSPanchors.tx -channelID $CHANNEL_NAME -asOrg PolytechMSP

# ANCHOR PEER UPDATE FOR IAEMSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/IAEMSPanchors.tx -channelID $CHANNEL_NAME -asOrg IAEMSP
