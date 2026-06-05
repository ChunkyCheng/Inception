#!/bin/sh

if [ -z "$(ls -A /var/www/html 2>/dev/null)" ]; then
	echo "Installing WordPress..."
	cp -r /usr/src/wordpress/* /var/www/html/
else
	echo "Using wordpress volume at /var/www/html"
fi

if  [ ! -f /var/www/html/wp-config.php ]; then
	echo "Creating wp-config.php"
	
	envsubst '$WORDPRESS_DB_NAME $WORDPRESS_DB_USER $WORDPRESS_DB_HOST' \
		< /usr/local/share/wp-config.php.template \
		> wp-config.php
	
	sed -i "s|__DB_PASSWORD__|$(cat /run/secrets/db_password)|g" wp-config.php
fi

export WORDPRESS_DB_PASSWORD="$(cat /run/secrets/db_password)"

exec php-fpm84 -F
