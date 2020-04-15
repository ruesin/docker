FROM debian:10.3-slim

RUN set -eux; \
    \
    ## mirrors
    sed -i "s@http://deb.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
    sed -i "s@http://security.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
    \
	apt-get update; \
	apt-get install -y --no-install-recommends \
        git \
    ; \
	rm -rf /var/lib/apt/lists/*; \
    \
    apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
	find /usr/local -type f -executable -exec ldd '{}' ';' \
		| awk '/=>/ { print $(NF-1) }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -r apt-mark manual \
	; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false;

# CMD [ "tail", "-f", "/dev/null" ]