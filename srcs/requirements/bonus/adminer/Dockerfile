FROM alpine:3.22

RUN apk update && apk add --no-cache \
    php84-fpm \
    php84-session \
    php84-pdo \
    php84-pdo_mysql \
    php84-mysqli \
    php84-json

RUN mkdir -p /var/www/adminer/ && \
	wget -q \
	"https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php" \
    -O /var/www/adminer/adminer.php

RUN sed -i 's|listen = .*|listen = 0.0.0.0:9000|' /etc/php84/php-fpm.d/www.conf

CMD ["php-fpm84", "-F"]
