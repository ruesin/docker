FROM php:5.6-fpm

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        procps \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install curl

RUN pecl install swoole-1.9.5\
    && docker-php-ext-enable swoole

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata \
    && sed -i "s#;date.timezone =.*#date.timezone = ${TZ}#g" ${PHP_INI_DIR}/php.ini-production \
    && sed -i "s#;date.timezone =.*#date.timezone = ${TZ}#g" ${PHP_INI_DIR}/php.ini-development 