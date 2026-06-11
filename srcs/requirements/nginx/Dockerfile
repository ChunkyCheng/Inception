FROM alpine:3.23

RUN apk add --no-cache nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir -p /var/www/adminer && touch /var/www/adminer/adminer.php

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
