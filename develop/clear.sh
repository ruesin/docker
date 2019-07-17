#!/bin/sh

# Stop and remove containers, networks, images, and volumes
cd $(cd $(dirname $0); pwd) && docker-compose -f "src/docker-compose.yml" down