#!/bin/bash

#Genera una CA intermedia, solo una esta disponible
if [ -e /ca/intermediate/index.txt ]; then
    echo 'CA Intermedia existente.. prosiguiendo';
    exit 0;
else
    if [ -z "$CA_KEY_LENGTH" ]; then
	CA_KEY_LENGHT=4096;
    fi
    if [ -z "$CA_DAYS" ]; then
	CA_DAYS=1825;
    fi
    if [ -z "$CA_INT_PWD" ]; then
	echo 'Clave requerida, especifique CA_INT_PWD';
	exit -1;
    fi    
    if [ -z "$CA_PWD" ]; then
	echo 'Clave requerida, especifique CA_PWD';
	exit -1;
    fi
    if [ -z "$CA_INT_DATA" ]; then
	CA_INT_DATA="/C=AR/O=ROOTCA/OU=SIU/ST=Baires/CN=MEDIUMCA/";
    fi
fi

cd /ca/intermediate
touch index.txt
#Generate CA intermediate private Key
openssl genpkey -algorithm RSA -out private/intermediate.key.pem -aes-256-cbc -pkeyopt rsa_keygen_bits:$CA_KEY_LENGTH -pass env:CA_INT_PWD
chmod 400 private/intermediate.key.pem

#Generate CA certificate request
openssl req -config openssl.cnf -new -sha256 -key private/intermediate.key.pem -out csr/intermediate.csr.pem -subj "$CA_INT_DATA" -passin env:CA_INT_PWD

#Generate CA certificate
cd /ca
yes | openssl ca -config openssl.cnf -extensions v3_intermediate_ca -days $CA_DAYS -notext -md sha256 -in intermediate/csr/intermediate.csr.pem -out intermediate/certs/intermediate.cert.pem -passin env:CA_PWD
chmod 444 intermediate/certs/intermediate.cert.pem
