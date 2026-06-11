FROM alpine:3.23

RUN apk add --no-cache \
	php84 \
	php84-fpm \
	php84-mysqli \
	php84-curl \
	php84-gd \
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
	unzip

RUN mkdir -p /usr/src/wordpress && \
	curl -L https://wordpress.org/latest.tar.gz \
	| tar -xz --strip-components=1 -C /usr/src/wordpress

RUN mkdir -p /usr/src/redis-cache && \
    wget -q "https://downloads.wordpress.org/plugin/redis-cache.latest-stable.zip" \
        -O /tmp/redis-cache.zip && \
    unzip -q /tmp/redis-cache.zip -d /usr/src/ && \
    rm /tmp/redis-cache.zip

RUN getent group www-data || addgroup -S www-data && \
	getent passwd www-data || adduser -S www-data -G www-data

RUN sed -i \
	-e 's|^user = .*|user = www-data|' \
	-e 's|^group = .*|group = www-data|' \
	-e 's|listen = .*|listen = 0.0.0.0:9000|' \
	/etc/php84/php-fpm.d/www.conf

COPY wp-config.php.template /usr/local/share/wp-config.php.template 
COPY entrypoint.sh tools/ /usr/local/bin/

RUN chmod -R +x /usr/local/bin

WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
