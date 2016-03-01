#!/bin/bash

crea_ca.sh
test1=$?

crea_ca_intermedia.sh
test2=$?

if [ $test1 == 0 ] && [ $test2 == 0 ]; then
    crea_cadena.sh;
    if [ ! -z "$LISTA_SERVER" ]; then
        for servidor in $LISTA_SERVER 
        do
            crea_server_cert.sh $servidor;
        done;
    fi

    if [ ! -z "$LISTA_CLIENTES" ]; then
        for cliente in $LISTA_CLIENTES 
        do
            crea_client_cert.sh $cliente;
        done;
    fi
fi
