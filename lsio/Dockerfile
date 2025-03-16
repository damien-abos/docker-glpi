# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.21

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
LABEL org.opencontainers.image.base.name="ghcr.io/linuxserver/baseimage-alpine-nginx:3.21"

LABEL maintainer="damien-abos"

ENV GLPI_CONFIG_DIR=/config/glpi/config
ENV GLPI_VAR_DIR=/config/glpi/files
ENV GLPI_MARKETPLACE_DIR=/config/glpi/marketplace
ENV GLPI_PLUGINS_DIR=/config/glpi/plugins

ENV GLPI_TELEMETRY_URI=https://telemetry.glpi-project.org
ENV GLPI_NETWORK_MAIL=glpi@teclib.com
ENV GLPI_NETWORK_SERVICES=https://services.glpi-network.com
ENV GLPI_NETWORK_REGISTRATION_API_URL=https://services.glpi-network.com/api/registration/
ENV GLPI_MARKETPLACE_PLUGINS_API_URI=https://services.glpi-network.com/api/marketplace/

ENV GLPI_DATABASE_HOST=database
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
    php83-bz2 \
    php83-common \
    php83-dom \
    php83-exif \
    php83-gd \
    php83-ldap \
    php83-intl \
    php83-mysqli \
    php83-opcache \
    php83-sodium \
    php83-xmlreader \
  && echo "**** configure php-fpm to pass env vars ****" && \
  sed -E -i 's/^;?clear_env ?=.*$/clear_env = no/g' /etc/php83/php-fpm.d/www.conf && \
  grep -qxF 'clear_env = no' /etc/php83/php-fpm.d/www.conf || echo 'clear_env = no' >> /etc/php83/php-fpm.d/www.conf \
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
    -H "Authentication: $(cat /run/secrets/GLPI_DOWNLOAD_TOKEN)" \
    -o /tmp/glpi.tar.gz \
    -L ${GLPI_DOWNLOAD_URL}; \
  else \
    curl \
    -o /tmp/glpi.tar.gz \
    -L ${GLPI_DOWNLOAD_URL}; \
  fi && \
  mkdir -p /app/www && \
  tar -xz -f /tmp/glpi.tar.gz -C /app/www && \
  rm -Rf "/app/www/glpi/config" "/app/www/glpi/files" "/app/www/glpi/marketplace" "/app/www/glpi/plugins" "/app/www/glpi/install/install.php" && \
  ln -s "/config/glpi/config" "/app/www/glpi/config" && \
  ln -s "/config/glpi/files" "/app/www/glpi/files" && \
  ln -s "/config/glpi/marketplace" "/app/www/glpi/marketplace" && \
  ln -s "/config/glpi/plugins" "/app/www/glpi/plugins" \
  && echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME [ "/config" ]