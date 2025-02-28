# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:edge

LABEL org.opencontainers.image.source=https://github.com/damien-abos/docker-glpi
LABEL org.opencontainers.image.description="GLPI using LinuxServer.io"
LABEL org.opencontainers.image.licenses=GPL-3.0-or-later

LABEL maintainer="damien-abos"


RUN \ 
  echo "**** install runtime packages ****" && \
  apk add -U --upgrade --no-cache \
    php83 \
    php83-bz2 \
    php83-common \
    php83-curl \
    php83-dom \
    php83-exif \
    php83-fileinfo \
    php83-gd \
    php83-ldap \
    php83-intl \
    php83-mysqli \
    php83-opcache \
    php83-openssl \
    php83-phar \
    php83-session \
    php83-simplexml \
    php83-xmlreader \
    php83-xmlwriter \
    php83-zip \
    libxml2 \
    zlib \
  && echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# copy glpi
RUN \
  curl -fsSL https://github.com/glpi-project/glpi/releases/download/10.0.18/glpi-10.0.18.tgz | tar -xzv -C /var

# ports and volumes
EXPOSE 80
VOLUME [ "/config" ]