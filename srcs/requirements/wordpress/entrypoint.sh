#!/bin/sh

if [ -z "$(ls -A /var/www/html 2>/dev/null)" ]; then
	echo "Installing WordPress..."
	cp -r /usr/src/wordpress/* /var/www/html/
else
	echo "Using wordpress volume at /var/www/html"
fi

if  [ ! -f /var/www/html/wp-config.php ]; then
	echo "Creating wp-config.php"
	envsubst < wp-config.php.template > /var/www/html/wp-config.php
fi

export WORDPRESS_DB_PASSWORD="$(cat /run/secrets/db_password)"

exec php-fpm84 -F
