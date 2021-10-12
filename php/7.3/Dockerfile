FROM php:7.3.29-fpm

RUN set -eux; \
    \
    ## mirrors
    # sed -i "s@http://deb.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
    # sed -i "s@http://security.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
    \
    apt-get update; \
    # Necessary software
    apt-get install -y --no-install-recommends \
        procps vim \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        unzip libzip-dev \
        libxml2-dev libxslt1-dev; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    # Build dependencies
    apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libssl-dev \
        curl libcurl4-openssl-dev \
        unzip libzip-dev libicu-dev libxml2-dev libxslt1-dev; \
        \
        apt-get autoclean && apt-get autoremove && apt-get clean; \
        rm -rf /var/lib/apt/lists/*; \
        \
    # extension
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
    docker-php-ext-install -j$(nproc) iconv gd mysqli pdo_mysql \
        pcntl curl zip bcmath gettext intl shmop soap sockets sysvsem xmlrpc xsl; \
    # swoole
    curl -SL "https://github.com/swoole/swoole-src/archive/v4.4.7.tar.gz" -o /tmp/swoole.tar.gz; \
    mkdir -p /tmp/swoole; \
    tar -xf /tmp/swoole.tar.gz -C /tmp/swoole --strip-components=1; \
    cd /tmp/swoole && phpize; \
    ./configure --enable-mysqlnd --enable-openssl --enable-http2 --enable-sockets; \
    make -j$(nproc) && make install && docker-php-ext-enable swoole && make clean; \
    \
    # redis
    pecl install redis-5.0.0 && docker-php-ext-enable redis; \
    \
    # xdebug
    pecl install xdebug-2.7.2 && docker-php-ext-enable xdebug; \
    \
    # Unable to load dynamic library
    echo "/usr/lib64" >> /etc/ld.so.conf && \
    echo "/usr/lib" >> /etc/ld.so.conf && \
    echo "/usr/local/lib" >> /etc/ld.so.conf && \
    echo "/usr/local/lib64" >> /etc/ld.so.conf; \
    \
    # timezone
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone; \
    dpkg-reconfigure --frontend noninteractive tzdata; \
    echo "date.timezone=Asia/Shanghai" > ${PHP_INI_DIR}/conf.d/zzz-overrides-timezone.ini; \
    \
    # config
    echo "error_log=/php_errors.log" > ${PHP_INI_DIR}/conf.d/zzz-overrides-errors.ini; \
    \
    # composer
    # ENV COMPOSER_ALLOW_SUPERUSER 1
    curl -sS https://getcomposer.org/installer | php; \
    mv composer.phar /usr/local/bin/composer; \
    composer self-update --clean-backups; \
    php -v; \
    # clean
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark > /dev/null; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /tmp/*;