# FROM stakater/base-alpine:3.5
FROM alpine:3.9

###
### ARGS
###
ARG HTTP_PROXY=""
ARG HTTPS_PROXY=""
###
### Envs
###
ENV http_proxy=${HTTP_PROXY} \
	https_proxy=${HTTPS_PROXY} \
	CA_SUBJECT=${CA_SUBJECT} \
	CA_EXPIRE=${CA_EXPIRE} \
	MY_HOST_NAME=${MY_HOST_NAME} \
	SSL_DNS=${MY_HOST_NAME} \
	SSL_SUBJECT=${MY_HOST_NAME} \
    COUNTRY_ISO=${COUNTRY_ISO} \
	COUNTRY_NAME=${COUNTRY_NAME} \
    ORGANISATION_NAME=${ORGANISATION_NAME} \
	EMAIL_ADDRESS=${EMAIL_ADDRESS}

RUN apk --update add openssl bash

WORKDIR /certs
RUN mkdir -p /usr/local/bin
COPY generate-certs /usr/local/bin/generate-certs
RUN dos2unix /usr/local/bin/generate-certs
RUN chmod +x /usr/local/bin/generate-certs
CMD /usr/local/bin/generate-certs
VOLUME /certs
VOLUME /ca

