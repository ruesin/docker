FROM node:15.12.0-buster

RUN set -eux; \
    # timezone
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone; \
    dpkg-reconfigure --frontend noninteractive tzdata; \
    
