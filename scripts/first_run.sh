#!/bin/bash

if [ ! -f $DOCKER_CONFIG_PATH/CA_INITIALIZED ]; then
    echo "Inicializando numeros de serie ";
    openssl rand -hex 16  > /CAs/rootCA/serial;
    openssl rand -hex 16  > /CAs/intermediate/serial;
fi

