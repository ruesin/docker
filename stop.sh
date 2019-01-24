#!/bin/sh

workdir=$(cd $(dirname $0); pwd)

cd ${workdir}/src && docker-compose stop