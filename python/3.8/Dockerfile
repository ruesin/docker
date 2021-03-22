FROM python:3.8.8-buster

RUN set -eux; \
    # timezone
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone; \
    dpkg-reconfigure --frontend noninteractive tzdata; \