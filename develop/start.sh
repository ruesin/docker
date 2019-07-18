#!/bin/sh

# Create and start containers

workdir=$(cd $(dirname $0); pwd)

APP_NAME=$1

if [ ! -n "$APP_NAME" ] ;then
    APP_NAME="lnmp"
fi

PROJECT_PATH="${HOME}/projects/"

if [ "$APP_NAME" == "golang" ] ;then
    PROJECT_PATH="${HOME}/go/"
fi


if [ ! -f "${workdir}/src/docker-compose-${APP_NAME}.yml" ];then
    cp ${workdir}/src/docker-compose-${APP_NAME}.example.yml ${workdir}/src/docker-compose-${APP_NAME}.yml
fi

if [ ! -d "${workdir}/projects/" ];then
    if [ ! -z "$PROJECT_PATH" ]; then
        if [ -d "$PROJECT_PATH" ]; then
            ln -s ${PROJECT_PATH} ${workdir}/projects
        else 
            mkdir ${workdir}/projects
        fi
    else
        mkdir ${workdir}/projects
    fi
fi

cd ${workdir} && docker-compose -f "src/docker-compose-${APP_NAME}.yml" -p ${APP_NAME} up -d
