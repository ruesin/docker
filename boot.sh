#!/bin/sh

peoject_path=$1
workdir=$(cd $(dirname $0); pwd)

if [ ! -f "${workdir}/src/docker-compose.yml" ];then
    cp ${workdir}/src/docker-compose.example.yml ${workdir}/src/docker-compose.yml
fi

if [ ! -d "${workdir}/projects/" ];then
    if [ ! -z "$peoject_path" ]; then
        if [ -d "$peoject_path" ]; then
            ln -s ${peoject_path} ${workdir}/projects
        else 
            mkdir ${workdir}/projects
        fi
    else
        mkdir ${workdir}/projects
    fi
fi

cd ${workdir} && docker-compose -f "src/docker-compose.yml" up -d
