#!/usr/bin/env bash
# shellcheck shell=bash

# script return failed on first error
set -e 

# retrieve glpi status
STATUS=$(/usr/local/bin/glpi-console system:status --format json)

# Check glpi status
[ $(echo $STATUS | jq -r '.glpi.status') == "OK" ]
