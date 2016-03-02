#!/bin/bash

openssl rand -hex 16  > /CAs/rootCA/serial
openssl rand -hex 16  > /CAs/intermediate/serial

mv /entrypoint.d/first_run.sh /entrypoint.d/first_run.old
