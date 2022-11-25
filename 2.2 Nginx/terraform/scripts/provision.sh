#!/bin/bash

set -e
app_path="/var/www/html"

apt update -y -qq

################
# installation #
################

# nginx
echo "Installing nginx"
apt install nginx=1.18.* -y
systemctl enable nginx
service nginx start


# MySQL
echo "Installing MySQL"
apt install mysql-server -y
systemctl enable mysql

# PHP
echo "Installing PHP-FPM/SQL"
apt install php8.1-fpm  -y
apt install php-mysql -y
apt install -y \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-xmlrpc \
    php-soap \
    php-intl \
    php-zip

# WordPress
curl -O --output-dir /tmp https://wordpress.org/latest.tar.gz
tar xavf /tmp/latest.tar.gz -C ${app_path}
rm /tmp/latest.tar.gz -v


#################
# CONFIGURATION #
#################

# nginx
cp /tmp/nginx.conf /etc/nginx/nginx.conf
cp /tmp/nginx-wordpress /etc/nginx/sites-available/nginx-wordpress

mkdir -p /var/cache/nginx/wordpress && chown -R www-data:www-data /var/cache/nginx

rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/nginx-wordpress /etc/nginx/sites-enabled/nginx-wordpress


# mysql
mysql < /tmp/db.sql
rm /tmp/db.sql

# wordpress
touch ${app_path}/wordpress/.htaccess
mkdir ${app_path}/wordpress/wp-content/upgrade
cp /tmp/wp-config.php ${app_path}/wordpress/wp-config.php

chown -R www-data:www-data ${app_path}/wordpress
find ${app_path}/wordpress/ -type d -exec chmod 750 {} \;
find ${app_path}/wordpress/ -type f -exec chmod 640 {} \;


# Restarting
systemctl restart nginx && systemctl restart php8.1-fpm

# Adding cron job
echo "0 0 * * * /usr/bin/find /tmp  -type f -ctime +14  -size +5M -exec rm -rf {} \;" >> /etc/crontab
