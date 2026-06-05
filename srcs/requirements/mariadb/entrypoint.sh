#!/bin/sh

mkdir -p /run/mysqld

chown -R mysql:mysql /run/mysqld

#For initialising database volume the first time
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initialising system database..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

	mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking & pid="$!"
	until mariadb -u root -e "SELECT 1;" &>/dev/null; do
    	sleep 1
	done

	mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
	mariadb -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '$(cat $MYSQL_PASSWORD_FILE)';"
	mariadb -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
	mariadb -e "FLUSH PRIVILEGES;"	
	
	kill -s TERM "$pid"
	wait "$pid"
else
	echo "Using database volume at /var/lib/mysql"
fi

exec mariadbd --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0 --skip-networking=0
