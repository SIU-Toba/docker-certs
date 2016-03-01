#!/bin/bash

NOMBRE_SITIO=${1:-localhost};
cd /ca/intermediate

if [ -z "$CRT_KEY_LENGTH" ]; then
    CRT_KEY_LENGTH=2048;
fi
if [ -z "$CRT_DAYS" ]; then
    CRT_DAYS=365;
fi
if [ -z "$CA_INT_PWD" ]; then
    echo 'Clave requerida, especifique CA_INT_PWD';
    exit -1;
fi

if [ -z "$CRT_DATA" ]; then
    CRT_DATA="/C=AR/O=ROOTCA/OU=SIU/ST=Baires/CN=$NOMBRE_SITIO/";
fi

if [ ! -e csr/$NOMBRE_SITIO.csr.pem ]; then
    #Generate Private key 
    openssl genpkey -algorithm RSA -out private/server/$NOMBRE_SITIO.key.pem -pkeyopt rsa_keygen_bits:$CRT_KEY_LENGTH
    chmod 400 private/server/$NOMBRE_SITIO.key.pem

    #Generate Certificate Request
    openssl req -config openssl.cnf -key private/server/$NOMBRE_SITIO.key.pem -new -sha256 -out csr/$NOMBRE_SITIO.csr.pem -subj $CRT_DATA

    #Generate Certificate
    yes | openssl ca -config openssl.cnf -extensions server_cert -days $CRT_DAYS -notext -md sha256 -in csr/$NOMBRE_SITIO.csr.pem -out certs/server/$NOMBRE_SITIO.cert.pem  -passin env:CA_INT_PWD
    chmod 444 certs/server/$NOMBRE_SITIO.cert.pem
fi
