# syntax=docker/dockerfile:1

ARG BASE_IMAGE_NAME=docker.io/library/alpine
ARG BASE_IMAGE_TAG=latest

FROM ${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}

ARG BASE_IMAGE_NAME=docker.io/library/alpine
ARG BASE_IMAGE_TAG=latest

# set version label
ARG GLPI_DOWNLOAD_URL

LABEL org.opencontainers.image.authors="damien-abos"
LABEL org.opencontainers.image.vendor="damien-abos"
LABEL org.opencontainers.image.source="https://github.com/damien-abos/docker-glpi"
LABEL org.opencontainers.image.documentation="https://github.com/damien-abos/docker-glpi/wiki"
LABEL org.opencontainers.image.url="https://github.com/damien-abos/docker-glpi/packages"
LABEL org.opencontainers.image.description="GLPI using LinuxServer.io Base Image"
LABEL org.opencontainers.image.title="docker-glpi"
LABEL org.opencontainers.image.licenses="GPL-3.0-or-later"
LABEL org.opencontainers.image.vendor="damien-abos"
LABEL org.opencontainers.image.base.name="${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}"

LABEL maintainer="damien-abos"

ENV GLPI_CONFIG_DIR=/data/glpi/config
ENV GLPI_VAR_DIR=/data/glpi/files
ENV GLPI_MARKETPLACE_DIR=/data/glpi/marketplace
ENV GLPI_PLUGINS_DIR=/var/wwww/glpi/plugins

ENV GLPI_TELEMETRY_URI=https://telemetry.glpi-project.org
ENV GLPI_NETWORK_MAIL=glpi@teclib.com
ENV GLPI_NETWORK_SERVICES=https://services.glpi-network.com
ENV GLPI_NETWORK_REGISTRATION_API_URL=https://services.glpi-network.com/api/registration/
ENV GLPI_MARKETPLACE_PLUGINS_API_URI=https://services.glpi-network.com/api/marketplace/

ENV GLPI_DATABASE_HOST=glpi-db
ENV GLPI_DATABASE_PORT=3306
ENV GLPI_DATABASE_NAME=glpi
ENV GLPI_DATABASE_USERNAME=glpi
ENV GLPI_DATABASE_PASSWORD=
ENV GLPI_DATABASE_INSTALL_FORCE=0
ENV GLPI_DEFAULT_LANGUAGE=fr_FR

ENV GLPI_SMTP_MODE=0
ENV GLPI_SMPT_HOST=
ENV GLPI_SMPT_PORT=
ENV GLPI_SMTP_USERNAME=
ENV GLPI_SMTP_PASSWORD=

ENV GLPI_ENABLE_API=0
ENV GLPI_ENABLE_API_LOGIN_CREDENTIALS=0
ENV GLPI_ENABLE_API_LOGIN_EXTERNAL_TOKEN=1
ENV GLPI_URL_BASE=https://localhost
ENV GLPI_URL_BASE_API=https://localhost/api

RUN \
  echo "**** install runtime packages ****" && \
  apk add -U --upgrade --no-cache \
    bash \
    ca-certificates \
    curl \
    jq \
    nginx \
    php83 \
    php83-bz2 \
    php83-common \
    php83-ctype \
    php83-curl \
    php83-dom \
    php83-exif \
    php83-fileinfo \
    php83-fpm \
    php83-gd \
    php83-iconv \
    php83-intl \
    php83-ldap \
    php83-mbstring \
    php83-mysqli \
    php83-mysqlnd \
    php83-opcache \
    php83-openssl \
    php83-phar \
    php83-session \
    php83-simplexml \
    php83-sodium \
    php83-xml \
    php83-xmlreader \
    php83-xmlwriter \
    php83-zip \
  && echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# copy glpi
# mount token for downloading in secret GLPI_DOWNLOAD_TOKEN
RUN \
  echo "**** install glpi ****" && \
  if [ -z "${GLPI_DOWNLOAD_URL}" ]; then \
    GLPI_DOWNLOAD_URL=$(curl -sX GET "https://api.github.com/repos/glpi-project/glpi/releases/latest" | jq -r '.assets[0].browser_download_url'); \
  fi && \
  if [ -f "/run/secrets/GLPI_DOWNLOAD_TOKEN" ]; then \
    curl \
    -fsS \
    -H "Authentication: $(cat /run/secrets/GLPI_DOWNLOAD_TOKEN)" \
    -o /tmp/glpi.tar.gz \
    -L ${GLPI_DOWNLOAD_URL}; \
  else \
    curl \
    -fsS \
    -o /tmp/glpi.tar.gz \
    -L ${GLPI_DOWNLOAD_URL}; \
  fi && \
  tar -xz -f /tmp/glpi.tar.gz -C /var/www/ && \
  rm /var/www/glpi/install/install.php && \
  echo "**** prepare nginx working directories ****" && \
  mkdir -p /data/nginx/{logs,tmp} && \
  rm -Rf /var/lib/nginx/logs /var/lib/nginx/tmp && \
  ln -s /data/nginx/logs /var/lib/nginx/logs  && \
  ln -s /data/nginx/tmp /var/lib/nginx/tmp && \
  echo "**** create glpi user ****" && \
  addgroup -g 1000 -S glpi && \
  adduser -S -D -H -u 1000 -s /sbin/nologin -h /data -G glpi glpi && \
  chown -R glpi:glpi /data && \
  chmod 755 /var/lib/nginx && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /
# fix rights
RUN \
  echo "**** Set executable files ****" && \
  chmod a+x /entrypoint.sh /livenessCheck.sh /readinessCheck.sh /usr/local/bin/glpi-console /usr/local/bin/glpi-db-ok

USER glpi

# ports and volumes
EXPOSE 8080
VOLUME [ "/data", "/var/www/glpi/plugins" ]


CMD [ "nginx" ]
ENTRYPOINT [ "/entrypoint.sh" ]