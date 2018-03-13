## UGA-Network
If you want run our project, this explanation will drive you how install correctly prerequities.
Firstly you have to clone this repository into fabric-sample repository

```
npm install -g composer-cli@0.16.5
npm install -g composer-rest-server@0.16.5
npm install -g generator-hyperledger-composer
npm install -g yo
```
```
git clone -b issue-6978 https://github.com/sstone1/fabric-samples.git
curl -sSL https://goo.gl/kFFqh5 | bash -s 1.0.6
cd fabric-samples
```
If you want test this install (optional) :
```
cd first-network
./byfn.sh -m generate
./byfn.sh -m up
./byfn.sh -m down
cd ..
```
Now UGAChain part (verify your in fabric-samples/) :
```
git clone https://github.com/RICM5-BlockChain/uganetwork.git
```

```
./generate.sh 
```
to generate certs and network artifacts then. This script should not generate an error
```
./up.sh 
```
to launch an End-to-End test. If the script finished without error you must see next line :
```
========= All GOOD, BYFN execution completed =========== 


 _____   _   _   ____   
| ____| | \ | | |  _ \  
|  _|   |  \| | | | | | 
| |___  | |\  | | |_| | 
|_____| |_| \_| |____/  

```

```
cd composer
./deploy.sh
```
to run blockchain. When this script finish without error, there is 1 blockchain is running, 2 organizations (polytech, iae), compose of 2 peers (peer0, peer1) by organizations. And API rest running in your navigator.

Now before restart you have to now how clean your env :
there is 2 files (in fabric-samples/uganetwork/)
```
#to delete dockers
./clear.sh
#to clean blockchain in dockers
cd composer
./reset.sh
```

