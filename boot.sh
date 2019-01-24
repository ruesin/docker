#!/bin/sh

peoject_path=$1
workdir=$(cd $(dirname $0); pwd)

if [ ! -f "${workdir}/src/docker-compose.yml" ];then
    cp ${workdir}/src/docker-compose.example.yml ${workdir}/src/docker-compose.yml
fi

if [ ! -d "${workdir}/projects/" ];then
    if [ ! -z "$peoject_path" ]; then
        if [ -d "$peoject_path" ]; then
            echo 1
            ln -s ${peoject_path} ${workdir}/projects
        else 
        echo 2
            mkdir ${workdir}/projects
        fi
    else
    echo 3
        mkdir ${workdir}/projects
    fi
fi

cd ${workdir}/src && docker-compose up -d
