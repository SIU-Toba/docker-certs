FROM ubuntu
MAINTAINER rdalinger@siu.edu.ar

RUN apt-get update && apt-get install openssl \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

#Define una variable para poder usar mc
RUN echo "export TERM=xterm" >> /root/.bashrc

COPY entrypoint.sh /
COPY bin /bin
RUN mkdir /entrypoint.d
COPY ./scripts/* /entrypoint.d/


RUN chmod +x /entrypoint.sh
RUN chmod +x /entrypoint.d/*.sh

ENV CA_KEY_LENGTH=4096
ENV CA_DAYS=7300

RUN mkdir -p /ca/intermediate
COPY ./configs/ca_ssl /ca/openssl.cnf
COPY ./configs/in_ssl /ca/intermediate/openssl.cnf

VOLUME /ca/intermediate/certs

ENTRYPOINT [ "/entrypoint.sh" ]


