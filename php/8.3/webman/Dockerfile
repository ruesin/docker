# 2026-10-23 PHP2Shell CVE-2026-109618/109619 应急升级：8.3.8 → 8.3.36（CVSS 9.2 未认证 RCE，官方修复版）
# -bookworm 后缀必须保留：8.3.36 起官方默认底座换成 Debian 13 (trixie)，下方清华源写死 bookworm，跨套件装包必挂（1023 实证 apt exit 100）
FROM php:8.3.36-cli-bookworm

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

# phpredis 扩展（1023 加）：装而不切，config/redis.php 的 client 仍是 predis；
# 将来切 phpredis 只改 config 不动镜像。Fiber 协程下 phpredis 为同步阻塞 IO，无协程竞争（官方文档口径）。
RUN pecl install redis \
    && docker-php-ext-enable redis

# 生产 ini 固化（1023 加）：与 1022 线上 php_dy 容器内手写配置对齐，重建容器不再丢
# - memory_limit=512M    对齐线上 zz-dy-memory-limit.ini（1022 素材大包 OOM 修复，勿回退 256M）
# - opcache.enable_cli=1 对齐线上 zz-opcache-cli.ini（0920 webman 常驻 worker 性能项）
# - upload_progress 关   CVE-2026-109619 官方缓解（webman 下本就惰性，防御纵深）
# - expose_php=Off       响应头不暴露 PHP 版本
RUN printf 'memory_limit = 512M\nopcache.enable_cli = 1\nsession.upload_progress.enabled = 0\nexpose_php = Off\n' \
    > ${PHP_INI_DIR}/conf.d/zzz-dy-overrides.ini

# ext-event 备忘（1023 拍板本批不装）：
# 装了 revolt 会自动把事件驱动从 stream_select 切到 libevent（摆脱单 worker 1024 fd 上限，利好 SSE/长连接），
# 是本批唯一"装了就改变运行行为"的项，故单独推迟。
# 未来安装：apt-get install -y --no-install-recommends libevent-dev && pecl install event && docker-php-ext-enable event
# 装完必测：常规请求、SSE 流式输出（深度诊断）、workerman/crontab 定时触发。

RUN mkdir -p /app
VOLUME /app
USER root
WORKDIR /app
EXPOSE 8787
