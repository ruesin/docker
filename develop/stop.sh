#!/bin/sh

# Stop services
APP_NAME=$1

if [ ! -n "$APP_NAME" ] ;then
    APP_NAME="php"
fi

cd $(cd $(dirname $0); pwd) && docker-compose -f "src/docker-compose-${APP_NAME}.yml" -p ${APP_NAME} stop