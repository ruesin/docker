FROM ruesin/python:3.8

RUN set -eux; \
    \
    sed -i "s@http://deb.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
    sed -i "s@http://security.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
    echo "color_prompt=yes" >> /root/.bashrc; \
    echo "PS1='\[\e[31m\]\$ \[\e[m\]\[\033[01;34m\]\w\[\033[00m\]\n\[\e[31m\]\$ \[\e[m\]'" >> /root/.bashrc; \
    echo "alias ll='ls \$LS_OPTIONS -l'" >> /root/.bashrc; \
    \
    apt update; \
    \
    # timezone
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone; \
    dpkg-reconfigure --frontend noninteractive tzdata; \
    \
    \
    mkdir -p /root/.pip/; \
    echo "[global]" > /root/.pip/pip.conf; \
    echo "index-url = http://mirrors.aliyun.com/pypi/simple/" >> /root/.pip/pip.conf; \
    echo "trusted-host = mirrors.aliyun.com" >> /root/.pip/pip.conf


RUN pip install mitmproxy>=5.1.1 PyMySQL==0.9.3 redis==2.10.5 requests==2.23.0