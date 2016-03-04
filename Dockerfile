FROM ubuntu
MAINTAINER rdalinger@siu.edu.ar

RUN apt-get update && apt-get install openssl nano \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

#Define una variable para poder usar mc y un par de directorios basicos
RUN echo "export TERM=xterm" >> /root/.bashrc \

ENV dir_rootCA=/CAs/rootCA 
ENV dir_interCA=/CAs/intermediate
ENV CA_KEY_LENGTH=4096
ENV CA_DAYS=7300


RUN mkdir -p /entrypoint.d \
      /CAs/rootCA/certs \ 
      /CAs/rootCA/crl \
      /CAs/rootCA/private \
      /CAs/rootCA/newcerts \
      /CAs/intermediate/crl \
      /CAs/intermediate/csr \
      /CAs/intermediate/newcerts \
      /CAs/intermediate/private/server \      
      /CAs/intermediate/private/client \
      /CAs/intermediate/certs/server \
      /CAs/intermediate/certs/client

COPY entrypoint.sh /
COPY bin /bin
COPY ./scripts/* /entrypoint.d/

RUN chmod +x /entrypoint.sh \
    && chmod +x /entrypoint.d/*.sh \
    && chmod 700 /CAs/rootCA/private \
    && chmod 700 /CAs/intermediate/private \
    && echo 1000 > /CAs/intermediate/crlnumber


COPY ./configs/ca_ssl /CAs/rootCA/openssl.cnf
COPY ./configs/in_ssl /CAs/intermediate/openssl.cnf

#VOLUME /CAs/rootCA
#VOLUME /CAs/intermediate

ENTRYPOINT [ "/entrypoint.sh" ]


