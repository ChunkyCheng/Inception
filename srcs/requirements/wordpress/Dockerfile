FROM alpine:3.22

RUN apk add --no-cache \
	php84 \
	php84-fpm \
	php84-mysqli \
	php84-curl \
	php84-gd \
	php84-intl \
	php84-mbstring \
	php84-opcache \
	php84-openssl \
	php84-session \
	php84-xml \
	php84-xmlreader \
	php84-xmlwriter \
	php84-zip \
	curl \
	tar \
	envsubst

RUN ln -s /usr/bin/php84 /usr/bin/php

RUN mkdir -p /usr/src/wordpress && \
	curl -L https://wordpress.org/latest.tar.gz \
	| tar -xz --strip-components=1 -C /usr/src/wordpress

RUN getent group www-data || addgroup -S www-data && \
	getent passwd www-data || adduser -S www-data -G www-data

RUN sed -i \
	-e 's|^user = .*|user = www-data|' \
	-e 's|^group = .*|group = www-data|' \
	-e 's|listen = .*|listen = 0.0.0.0:9000|' \
	/etc/php84/php-fpm.d/www.conf

COPY wp-config.php.template /var/www/html/wp-config.php.template 
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
