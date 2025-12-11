#!/bin/bash

DOMAIN=${DOMAIN:-"localhost"}

echo "DOMAIN is set to '$DOMAIN'"

sed -i "s/~{DOMAIN}/$DOMAIN/g" /etc/nginx/sites-available/default
cat /etc/nginx/sites-available/default