FROM php:7.2.14-fpm

ENV TZ=Asia/Shanghai

RUN apt-get update && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        procps \
        curl libcurl4-openssl-dev \
        unzip libicu-dev libxml2-dev libxslt1-dev \
        && apt-get autoclean \
        && rm -rf /var/lib/apt/lists/*

# php extension
RUN docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) mysqli \
    pdo_mysql \
    pcntl \
    curl \
    zip \
    bcmath \
    gettext \
    intl \
    shmop \
    soap \
    sockets \
    sysvsem \
    xmlrpc \
    xsl \
    && echo "==> Install swoole 4.3.5 extension..." \ 
    && pecl install swoole-4.3.5\
    && docker-php-ext-enable swoole \
    && echo "==> Install redis 5.0.0 extension..." \ 
    && pecl install redis-5.0.0 \
    && docker-php-ext-enable redis \
    && echo "==> Install xdebug 2.7.2 extension..." \ 
    && pecl install xdebug-2.7.2 \
    && docker-php-ext-enable xdebug

# timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata \
    && sed -i "s#;date.timezone =.*#date.timezone = ${TZ}#g" ${PHP_INI_DIR}/php.ini-production \
    && sed -i "s#;date.timezone =.*#date.timezone = ${TZ}#g" ${PHP_INI_DIR}/php.ini-development \
    # composer
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"