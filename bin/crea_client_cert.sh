#!/bin/bash

NOMBRE_SITIO=${1:-localhost};

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
    CRT_DATA="/C=AR/O=ROOTCA/OU=SIUTEST/ST=Baires/CN=$NOMBRE_SITIO/";
fi


if [ ! -f $dir_interCA/private/client/$NOMBRE_SITIO.key.pem ]; then
    #Generate Private key 
    openssl genpkey -algorithm RSA -out $dir_interCA/private/client/$NOMBRE_SITIO.key.pem -pkeyopt rsa_keygen_bits:$CRT_KEY_LENGTH
    chmod 400 $dir_interCA/private/client/$NOMBRE_SITIO.key.pem

    #Generate Certificate Request
    openssl req -config $dir_configCA/in_ssl.cnf -key $dir_interCA/private/client/$NOMBRE_SITIO.key.pem -new -sha256 -out $dir_interCA/csr/$NOMBRE_SITIO.csr.pem -subj $CRT_DATA

    #Generate Certificate
    yes | openssl ca -config $dir_configCA/in_ssl.cnf -extensions usr_cert -days $CRT_DAYS -notext -md sha256 -in $dir_interCA/csr/$NOMBRE_SITIO.csr.pem -out $dir_interCA/certs/client/$NOMBRE_SITIO.cert.pem -passin env:CA_INT_PWD
    
    chmod 444 $dir_interCA/certs/client/$NOMBRE_SITIO.cert.pem
fi


