#!/bin/sh

if [ -z "$(ls -A /var/www/html 2>/dev/null)" ]; then
	echo "Installing WordPress..."
	cp -r /usr/src/wordpress/* /var/www/html/
else
	echo "Using wordpress volume at /var/www/html"
fi

if  [ ! -f /var/www/html/wp-config.php ]; then
	echo "Creating wp-config.php"
	cat /usr/local/share/wp-config.php.template > wp-config.php

	sed -i "s|__DB_NAME__|$WORDPRESS_DB_NAME|g" wp-config.php
	sed -i "s|__DB_USER__|$WORDPRESS_DB_USER|g" wp-config.php
	sed -i "s|__DB_PASSWORD__|$(cat /run/secrets/db_password)|g" wp-config.php
	sed -i "s|__DB_HOST__|$WORDPRESS_DB_HOST|g" wp-config.php
fi

if [ ! -d /var/www/html/wp-content/plugins/redis-cache ]; then
    echo "Installing Redis Cache plugin"
    cp -r /usr/src/redis-cache /var/www/html/wp-content/plugins/
fi

echo "Waiting for MariaDB"
while ! php84 /usr/local/bin/wp-db-check.php; do
    sleep 1
done
echo "MariaDB is ready."

if ! php84 /usr/local/bin/wp-is-installed.php; then
	echo "Running automated installation"
	php84 /usr/local/bin/wp-install.php
	echo "Installation complete"
fi

if [ ! -f /var/www/html/wp-content/object-cache.php ]; then
    echo "Setting up Redis plugin"
    php84 /usr/local/bin/wp-redis-install.php
    echo "Redis setup complete."
fi

exec php-fpm84 -F
