FROM php:7.3.6-fpm

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        procps \
        curl libcurl4-openssl-dev
        
RUN docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install curl

RUN pecl install redis-4.2.0 swoole-4.2.12\
    && docker-php-ext-enable redis swoole

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata \
    && sed -i "s#;date.timezone =.*#date.timezone = ${TZ}#g" ${PHP_INI_DIR}/php.ini-production \
    && sed -i "s#;date.timezone =.*#date.timezone = ${TZ}#g" ${PHP_INI_DIR}/php.ini-development \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"