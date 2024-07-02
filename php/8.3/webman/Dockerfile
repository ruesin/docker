FROM php:8.3.8-cli
# https://hub.docker.com/layers/library/php/8.3.8-cli/images/sha256-d464f5766e3ef2262f5536f7a12fefb6695fae057e5c518552f7125745e246d2?context=explore

# https://mirrors.tuna.tsinghua.edu.cn/help/debian/
RUN \
  echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list; \
  echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
  \
  echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
  echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
  \
  echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
  echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
  \
  echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
  echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list;

RUN set -eux; \
    \
    apt-get update; \
    # apt-get upgrade; \
    apt-get install -y --no-install-recommends \
    procps vim \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    unzip libzip-dev \
    libxml2-dev libxslt1-dev \
    libssl-dev \
    curl libcurl4-openssl-dev \
    unzip libzip-dev libicu-dev \
    ; \
    \
    apt-get autoclean && apt-get autoremove && apt-get clean; \
    rm -rf /var/lib/apt/lists/*; 

RUN \
    # extension # pdo,bz2,calendar,event,xlswriter
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/; \
    docker-php-ext-install -j$(nproc) iconv; \
    docker-php-ext-install -j$(nproc) gd; \
    docker-php-ext-install -j$(nproc) mysqli; \
    docker-php-ext-install -j$(nproc) pdo_mysql; \
    docker-php-ext-install -j$(nproc) pcntl; \
    docker-php-ext-install -j$(nproc) curl; \
    docker-php-ext-install -j$(nproc) zip; \ 
    docker-php-ext-install -j$(nproc) bcmath; \
    docker-php-ext-install -j$(nproc) gettext; \
    docker-php-ext-install -j$(nproc) intl; \
    docker-php-ext-install -j$(nproc) shmop; \
    docker-php-ext-install -j$(nproc) soap; \
    docker-php-ext-install -j$(nproc) sockets; \
    docker-php-ext-install -j$(nproc) sysvsem; \
    # 疑似无用
    docker-php-ext-install -j$(nproc) xmlrpc; \
    docker-php-ext-install -j$(nproc) xsl; \
    docker-php-ext-enable opcache; \
    docker-php-source delete; \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; \
    \
    # timezone
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone; \
    dpkg-reconfigure --frontend noninteractive tzdata; \
    echo "date.timezone=Asia/Shanghai" > ${PHP_INI_DIR}/conf.d/zzz-overrides-timezone.ini; \
    \
    # composer
    # ENV COMPOSER_ALLOW_SUPERUSER 1
    curl -sS https://getcomposer.org/installer | php; \
    mv composer.phar /usr/local/bin/composer; \
    composer self-update --clean-backups; \
    \
    # clean
    rm -rf /tmp/*;

RUN mkdir -p /app
VOLUME /app
USER root
WORKDIR /app
EXPOSE 8787
