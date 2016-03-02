#!/bin/bash


#Generate certificate chain
cat $dir_interCA/certs/intermediate.cert.pem $dir_rootCA/certs/ca.cert.pem > $dir_interCA/certs/ca-chain.cert.pem
chmod 444 $dir_interCA/certs/ca-chain.cert.pem
