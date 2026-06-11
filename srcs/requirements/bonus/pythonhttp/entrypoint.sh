#!/bin/sh

sed -i "s|__DOMAIN_NAME__|$DOMAIN_NAME|g" /var/www/static/*

exec python3 -m http.server 9000
