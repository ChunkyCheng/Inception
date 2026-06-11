FROM alpine:3.23

RUN apk add --no-cache python3

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY site/ /var/www/static/

WORKDIR /var/www/static

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
