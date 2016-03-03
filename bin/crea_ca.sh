#!/bin/bash

if [ -f $DOCKER_CONFIG_PATH/CA_INITIALIZED ]; then
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
	CA_DATA="/C=AR/O=ROOTCA/OU=SIUTEST/ST=Baires/CN=ROOTCA/";
    fi
fi

touch $dir_rootCA/index.txt
#Generate CA private Key
openssl genpkey -algorithm RSA -out $dir_rootCA/private/ca.key.pem -aes-256-cbc -pkeyopt rsa_keygen_bits:$CA_KEY_LENGTH -pass env:CA_PWD
chmod 400 $dir_rootCA/private/ca.key.pem

#Generate CA certificate
openssl req -config $dir_rootCA/openssl.cnf -key $dir_rootCA/private/ca.key.pem -new -x509 -days $CA_DAYS -sha256 -extensions v3_ca -out $dir_rootCA/certs/ca.cert.pem -subj "$CA_DATA" -passin env:CA_PWD
