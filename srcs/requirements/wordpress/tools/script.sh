#!/bin/bash

if [ -f /run/secrets/admin_password ]; then
	WORDPRESS_BD_ADMIN_PASS=$(cat /run/secrets/adminpassword)
fi
if [ -z "$WORDPRESS_BD_ADMIN_PASS"  ]; then
	WORDPRESS_BD_ADMIN_PASS="adminpassword"
fi
if [ -f /run/secrets/user_password ]; then
	WORDPRESS_DB_PASSWORD=$(cat /run/secrets/user_password)
fi
if [ -z "$WORDPRESS_DB_PASSWORD" ]; then
	WORDPRESS_DB_PASSWORD="user_password"
fi

cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
./wp-cli.phar core download \
	--allow-root

./wp-cli.phar config create \
	--dbname="$WORDPRESS_BD_NAME" \
	--dbuser="$WORDPRESS_BD_USER" \
	--dbpass="$USER_PASSWORD" \
	--dbhost="$WORDPRESS_BD_HOST" \
	--allow-root

./wp-cli.phar core install \
	--url="$WORDPRESS_SITE_URL" \
	--title="$TITLE" \
	--admin_user="$WORDPRESS_BD_ADMIN_USER" \
	--admin_password="$ADMIN_PASSWORD" \
	--admin_email="$WORDPRESS_BD_ADMIN_EMAIL" \
	--allow-root

./wp-cli.phar user create "$WORDPRESS_BD_USER" "$WORDPRESS_EMAIL" \
	--role='editor' \
	--user_pass="$WORDPRESS_DB_PASSWORD" \
	--allow-root

php-fpm8.2 -F