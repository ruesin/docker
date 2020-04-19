FROM debian:10.3-slim

RUN set -eux; \
    \
    ## mirrors
    sed -i "s@http://deb.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
    sed -i "s@http://security.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
        git \
    ; \
	rm -rf /var/lib/apt/lists/*;