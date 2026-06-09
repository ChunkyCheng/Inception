FROM alpine:3.22

RUN apk add --no-cache nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir -p /var/www/adminer && touch /var/www/adminer/adminer.php

CMD ["/usr/local/bin/entrypoint.sh"]
