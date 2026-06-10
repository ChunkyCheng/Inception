#!/bin/sh

adduser -S -D -H "$VSFTPD_USER" 
echo "$VSFTPD_USER:$(cat /run/secrets/vsftpd_password)" | chpasswd
mkdir -p /home/jchuah_ftp
chown jchuah_ftp:nobody /home/jchuah_ftp

chown -R "$VSFTPD_USER":nobody /var/www/html

echo "/sbin/nologin" >> /etc/shells

sed -i "s|__HOST_VSFTPD__|$PASV_ADDRESS|g" /etc/vsftpd/vsftpd.conf
sed -i "s|__USER__|$VSFTPD_USER|g" /etc/vsftpd/vsftpd.conf

exec vsftpd /etc/vsftpd/vsftpd.conf
