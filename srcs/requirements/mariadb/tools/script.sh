#!/bin/bash
if [ -f /run/secrets/root_password ]; then
	MYSQL_ROOT_PASSWORD=$(cat /run/secrets/root_password)
fi

if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
	MYSQL_ROOT_PASSWORD="root"
fi

if [ -f /run/secrets/user_password ]; then
	MYSQL_PASSWORD=$(cat /run/secrets/user_password)
fi

if [ -z "$MYSQL_PASSWORD" ]; then
	MYSQL_PASSWORD="user"
fi

sed -i "s/MYSQL_DATABASE/${MYSQL_DATABASE}/g" /etc/mysql/init.sql
sed -i "s/MYSQL_USER/${MYSQL_USER}/g" /etc/mysql/init.sql
sed -i "s/USER_PASSWORD/${MYSQL_PASSWORD}/g" /etc/mysql/init.sql
sed -i "s/MYSQL_ROOT_PASSWORD/${MYSQL_ROOT_PASSWORD}/g" /etc/mysql/init.sql

cat /etc/mysql/init.sql

mysql_install_db
mysqld