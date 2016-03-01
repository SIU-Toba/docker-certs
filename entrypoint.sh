#!/bin/bash

DOCKER_STATUS_PATH=/var/local/docker-data/containers-status
mkdir -p $DOCKER_STATUS_PATH
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

if [ ! -z $DOCKER_NAME ]; then
	echo $HOSTNAME > $DOCKER_STATUS_PATH/$DOCKER_NAME
fi

exec "$@"