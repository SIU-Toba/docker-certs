#!/bin/bash

mkdir -p /CAs/rootCA/certs /CAs/rootCA/crl /CAs/rootCA/private /CAs/rootCA/newcerts 
mkdir -p /CAs/intermediate/crl /CAs/intermediate/csr /CAs/intermediate/newcerts /CAs/intermediate/private/server /CAs/intermediate/private/client /CAs/intermediate/certs/server /CAs/intermediate/certs/client
chmod 700 /CAs/rootCA/private 
chmod 700 /CAs/intermediate/private 
echo 1000 > /CAs/intermediate/crlnumber
 
