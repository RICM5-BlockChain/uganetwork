## UGA-Network

Firstly you have to clone this repository into fabric-sample repository

```
git clone -b issue-6978 https://github.com/sstone1/fabric-samples.git
cd fabric-sample
git clone https://github.com/RICM5-BlockChain/uganetwork.git
```

```
./generate.sh 
```
to generate certs and network artifacts then 
```
./up.sh 
```
to launch an End-to-End test

You must have already downloaded the hyperledger docker images :
```
curl -sSL https://goo.gl/kFFqh5 | bash -s 1.0.6
```
