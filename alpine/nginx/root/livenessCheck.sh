#!/usr/bin/env bash
# shellcheck shell=bash

# script return failed on first error
set -e

# check php-fpm status
NGINX_PID=1
NGINX_CMDLINE=$(tr -d '\0' < /proc/$NGINX_PID/cmdline)
[ "$NGINX_CMDLINE" == "nginx: master process nginx" ]

# check nginx status
PHP_FPM_PID=$(cat /data/php-fpm.pid)
PHP_FPM_CMDLINE=$(tr -d '\0' < /proc/$PHP_FPM_PID/cmdline)
[ "$PHP_FPM_CMDLINE" == "php-fpm: master process (/etc/php83/php-fpm.conf)" ]
