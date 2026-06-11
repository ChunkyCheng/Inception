FROM alpine:3.23

RUN apk add --no-cache redis

COPY redis.conf /etc/redis/redis.conf

CMD ["redis-server", "/etc/redis/redis.conf"]
