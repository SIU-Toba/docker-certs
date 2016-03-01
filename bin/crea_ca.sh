#!/bin/bash

if [ -e /ca/index.txt ]; then
    echo 'CA existente';
    exit 0;
else
    if [ -z "$CA_KEY_LENGTH" ]; then
	CA_KEY_LENGHT=4096;
    fi
    if [ -z "$CA_DAYS" ]; then
	CA_DAYS=3650;
    fi
    if [ -z "$CA_PWD" ]; then
	echo 'Clave requerida, especifique CA_PWD';
	exit -1;
    fi
    if [ -z "$CA_DATA" ]; then
	CA_DATA="/C=AR/O=ROOTCA/OU=SIU/ST=Baires/CN=ROOTCA/";
    fi
fi

cd /ca
touch index.txt
#Generate CA private Key
openssl genpkey -algorithm RSA -out private/ca.key.pem -aes-256-cbc -pkeyopt rsa_keygen_bits:$CA_KEY_LENGTH -pass env:CA_PWD
chmod 400 private/ca.key.pem

#Generate CA certificate
openssl req -config openssl.cnf -key private/ca.key.pem -new -x509 -days $CA_DAYS -sha256 -extensions v3_ca -out certs/ca.cert.pem -subj "$CA_DATA" -passin env:CA_PWD
