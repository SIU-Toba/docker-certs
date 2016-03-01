#!/bin/bash

cd /
mkdir -p /ca/certs /ca/crl /ca/private /ca/newcerts

openssl rand -hex 16  > /ca/serial
chmod 700 /ca/private

mkdir -p /ca/intermediate/crl /ca/intermediate/csr /ca/intermediate/newcerts /ca/intermediate/private/server /ca/intermediate/private/client
mkdir -p /ca/intermediate/certs/server /ca/intermediate/certs/client

openssl rand -hex 16  > /ca/intermediate/serial
chmod 700 /ca/intermediate/private
echo 1000 > /ca/intermediate/crlnumber

mv /entrypoint.d/init_image.sh /entrypoint.d/init_image.old
