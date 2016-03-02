#!/bin/bash

#Genera una CA intermedia, solo una esta disponible
if [ -e $dir_interCA/index.txt ]; then
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
	CA_INT_DATA="/C=AR/O=ROOTCA/OU=SIUTEST/ST=Baires/CN=MEDIUMCA/";
    fi
fi

touch $dir_interCA/index.txt
#Generate CA intermediate private Key
openssl genpkey -algorithm RSA -out $dir_interCA/private/intermediate.key.pem -aes-256-cbc -pkeyopt rsa_keygen_bits:$CA_KEY_LENGTH -pass env:CA_INT_PWD
chmod 400 $dir_interCA/private/intermediate.key.pem

#Generate CA certificate request
openssl req -config $dir_interCA/openssl.cnf -new -sha256 -key $dir_interCA/private/intermediate.key.pem -out $dir_interCA/csr/intermediate.csr.pem -subj "$CA_INT_DATA" -passin env:CA_INT_PWD

#Generate CA certificate
yes | openssl ca -config $dir_rootCA/openssl.cnf -extensions v3_intermediate_ca -days $CA_DAYS -notext -md sha256 -in $dir_interCA/csr/intermediate.csr.pem -out $dir_interCA/certs/intermediate.cert.pem -passin env:CA_PWD
chmod 444 $dir_interCA/certs/intermediate.cert.pem
