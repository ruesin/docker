#!/bin/sh

cd $(cd $(dirname $0); pwd) && docker-compose -f "src/docker-compose.yml" stop