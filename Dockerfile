FROM python:3.6-alpine

VOLUME /etc/letsencrypt /var/lib/letsencrypt
WORKDIR /opt/certbot

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
COPY docker-entrypoint-multiple.sh /usr/local/bin/docker-entrypoint-multiple.sh
RUN chmod +x /usr/local/bin/docker-entrypoint-multiple.sh

RUN apk add --no-cache --virtual .certbot-deps \
    libffi \
    libssl1.1 \
    ca-certificates \
    binutils

# TODO: Had to update these lines to get rust installing correctly.
# See https://github.com/pyca/cryptography/blob/main/docs/installation.rst#alpine
# From https://github.com/docker/compose/issues/8105#issuecomment-776141927
RUN apk add --no-cache --virtual .build-deps \
    gcc \
    linux-headers \
    openssl-dev \
    musl-dev \
    libffi-dev \
    python3-dev \
    cargo \
    && pip3 install urllib3==1.25.11 \
    && pip3 install certbot-s3front \
    && apk del .build-deps


# Previously I had this commented out...
# ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint-multiple.sh" ]
