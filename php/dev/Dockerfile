FROM ruesin/php:7.2

RUN set -eux; \
    \
    sed -i "s@http://deb.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
    sed -i "s@http://security.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
    echo "color_prompt=yes" >> /root/.bashrc; \
    echo "PS1='\[\e[31m\]\$ \[\e[m\]\[\033[01;34m\]\w\[\033[00m\]\n\[\e[31m\]\$ \[\e[m\]'" >> /root/.bashrc; \
    echo "alias ll='ls \$LS_OPTIONS -l'" >> /root/.bashrc; \
    \
    apt update; \
    apt install -y git; \
    \
    \
    echo "start..." && \
    mv ${PHP_INI_DIR}/php.ini-development ${PHP_INI_DIR}/php.ini && \
    ls -al ${PHP_INI_DIR} && \
    sed -i "s#;error_log = php_errors.log*#derror_log = /tmp/php_errors.log#g" ${PHP_INI_DIR}/php.ini && \
    sed -i "s#cgi.fix_pathinfo=1*#cgi.fix_pathinfo=0#g" ${PHP_INI_DIR}/php.ini && \
    composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

RUN mkdir -p /root/.ssh

ADD ./.ssh/ /root/.ssh/

RUN chmod 600 /root/.ssh/id_rsa