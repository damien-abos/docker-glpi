#!/usr/bin/env bash
# shellcheck shell=bash

# create folders
mkdir -p \
    /data/glpi/config \
    /data/glpi/files/{_cache,_cron,_dumps,_graphs,_inventories,_locales,_lock,_log,_pictures,_plugins,_rss,_sessions,_themes,_tmp,_uploads} \
    /data/glpi/marketplace \
    /data/log \
    /data/nginx/{logs,tmp}

# install database if required
glpi-db-ok || glpi-console database:install \
    --db-host=$GLPI_DATABASE_HOST \
    --db-port=$GLPI_DATABASE_PORT \
    --db-name=$GLPI_DATABASE_NAME \
    --db-user=$GLPI_DATABASE_USERNAME \
    --db-password=$GLPI_DATABASE_PASSWORD \
    --default-language=fr_FR \
    --reconfigure \
    --no-telemetry \
    --no-interaction \
    --verbose

# set 
glpi-console config:set -- smtp_mode $GLPI_SMTP_MODE
glpi-console config:set -- smtp_host $GLPI_SMTP_HOST
glpi-console config:set -- smtp_port $GLPI_SMTP_PORT
glpi-console config:set -- smtp_username $GLPI_SMTP_USERNAME
glpi-console config:set -- smtp_passwd $GLPI_SMTP_PASSWORD

glpi-console config:set -- enable_api $GLPI_ENABLE_API
glpi-console config:set -- enable_api_login_credentials $GLPI_ENABLE_API_LOGIN_CREDENTIALS
glpi-console config:set -- enable_api_external_token $GLPI_ENABLE_API_EXTERNAL_TOKEN

glpi-console config:set -- url_base $GLPI_URL_BASE
glpi-console config:set -- url_base_api $GLPI_URL_BASE_API

# start php-fpm
/usr/sbin/php-fpm83 -F -O &

exec $*