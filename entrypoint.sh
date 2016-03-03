#!/bin/bash

DOCKER_STATUS_PATH=/var/local/docker-data/containers-status;
export DOCKER_CONFIG_PATH=/CAs/rootCA;

#Si no hay marca de inicializacion borro los contenidos anteriores
if [ ! -f $DOCKER_CONFIG_PATH/CA_INITIALIZED ] && [ -f $dir_rootCA/index.txt ]; then
    #Elimino los certs de la CA intermedia, CA root queda por si es externa
    rm -f $dir_interCA/csr/*.pem $dir_interCA/private/*.pem $dir_interCA/certs/*.pem
    #Elimino los certificados generados
    rm -f $dir_interCA/private/server/*.pem
    rm -f $dir_interCA/private/client/*.pem
    rm -f $dir_interCA/certs/server/*.pem
    rm -f $dir_interCA/certs/client/*.pem
fi

mkdir -p $DOCKER_STATUS_PATH $DOCKER_CONFIG_PATH
if [ -z ${DOCKER_WAIT_FOR+x} ]; then
	echo "Starting $DOCKER_NAME...";
else
	while : ; do
		[[ -f "$DOCKER_STATUS_PATH/$DOCKER_WAIT_FOR" ]] && break
		#echo "."
		sleep 1
	done
	echo "Starting $DOCKER_NAME...";
fi
chmod -R a+rw $DOCKER_STATUS_PATH

for entrypoint in /entrypoint.d/*.sh
do
    if [ -f $entrypoint -a -x $entrypoint ]
    then
        $entrypoint
    fi
done

if [ ! -z $DOCKER_WEB_SCRIPT ]; then
	if [ -f $DOCKER_WEB_SCRIPT -a -x $DOCKER_WEB_SCRIPT ]; then
		$DOCKER_WEB_SCRIPT
	fi
fi

#Dejo marca de inicializacion completada
if [ ! -f $DOCKER_CONFIG_PATH/CA_INITIALIZED ] && [ -f $dir_rootCA/index.txt -a -s $dir_rootCA/index.txt ]; then
    echo "true" > $DOCKER_CONFIG_PATH/CA_INITIALIZED
fi

if [ ! -z $DOCKER_NAME ]; then
	echo $HOSTNAME > $DOCKER_STATUS_PATH/$DOCKER_NAME
fi

exec "$@"
