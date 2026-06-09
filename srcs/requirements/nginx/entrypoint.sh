#!/bin/sh

sed -i "s|__DOMAIN_NAME__|$DOMAIN_NAME|g" /etc/nginx/nginx.conf

nginx -g "daemon off;"
