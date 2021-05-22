#!/bin/bash
THEME_NAME=$1
DB_NAME=$2
DB_USERNAME=$3
HOST=$4
BLOG_TITLE=$5
BLOG_ADMIN_LOGIN=$6
BLOG_ADMIN_PASSWORD=$7
BLOG_ADMIN_EMAIL=$8
WP_LOCALE=$9

DB_PASSWORD=`cat ~/.dbpassword`

usermod -a -G www-data vagrant

rm ~/.dbpassword

if [ -d /var/www/wordpress ]; 
then  
    rm -rf /var/www/wordpress/
fi
mkdir -p /var/www/wordpress
sudo chown -R vagrant:vagrant /var/www/wordpress/
chmod 0775 /var/www/wordpress/

sudo rm -rf /etc/apache2/sites-enabled/*
sudo rm -rf /etc/apache2/sites-available/*
sudo cp /srv/$THEME_NAME/.provision/wordpress.conf /etc/apache2/sites-available/wordpress.conf
sudo ln -s /etc/apache2/sites-available/wordpress.conf /etc/apache2/sites-enabled/wordpress.conf

sudo service apache2 restart


#
# Installation
#
curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
echo "WP download"
sudo -u vagrant -i -- wp core download --locale="${WP_LOCALE}" --path="/var/www/wordpress/"

cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php

echo "Set DB Name"
sed -i "s/database_name_here/${DB_NAME}/" /var/www/wordpress/wp-config.php
echo "Set DB username"
sed -i "s/username_here/${DB_USERNAME}/" /var/www/wordpress/wp-config.php
echo "Set DB password"
sed -i "s/password_here/${DB_PASSWORD}/" /var/www/wordpress/wp-config.php

ln -s /srv/$THEME_NAME /var/www/wordpress/wp-content/themes/$THEME_NAME

echo "WP install"
sudo -u vagrant -i -- wp core install --url="${HOST}" \
                --title="${BLOG_TITLE}" \
                --admin_user="${BLOG_ADMIN_LOGIN}" \
                --admin_password="${BLOG_ADMIN_PASSWORD}" \
                --admin_email="${BLOG_ADMIN_EMAIL}" \
                --path="/var/www/wordpress/" \
                --skip-email

sudo chown -R www-data:www-data /var/www/wordpress/