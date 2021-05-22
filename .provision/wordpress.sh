#!/bin/bash

#
# VARIABLES
#
THEME_NAME=$1
THEME_NICENAME=$2
DB_NAME=$3
DB_USERNAME=$4
HOST=$5
BLOG_TITLE=$6
BLOG_ADMIN_LOGIN=$7
BLOG_ADMIN_PASSWORD=$8
BLOG_ADMIN_EMAIL=$9
WP_LOCALE=${10}
DB_PASSWORD=`cat ~/.dbpassword`
rm ~/.dbpassword
#
# END VARIABLES
#

usermod -a -G www-data vagrant

#
# Create wordpress dir
#
echo "Create Wordpress directory"
if [ -d /var/www/wordpress ]; 
then  
    rm -rf /var/www/wordpress/
fi
mkdir -p /var/www/wordpress
sudo chown -R vagrant:vagrant /var/www/wordpress/
chmod 0775 /var/www/wordpress/
#
# END Create wordpress dir
# Configure Apache2
#
echo "Apache2 configuration"
sudo rm -rf /etc/apache2/sites-enabled/*
sudo rm -rf /etc/apache2/sites-available/*
sudo cp /srv/theme/.provision/wordpress.conf /etc/apache2/sites-available/wordpress.conf
sudo ln -s /etc/apache2/sites-available/wordpress.conf /etc/apache2/sites-enabled/wordpress.conf
sudo service apache2 restart
#
# END Configure Apache2
#


#
# WPI CLI Installation
#
echo "wp-cli installation"
curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
#
# END WPI CLI Installation
# Download wordpress
#
echo "Wordpress downloading"
sudo -u vagrant -i -- wp core download --locale="${WP_LOCALE}" --path="/var/www/wordpress/"
#
# END Download wordpress
# Configure wordpress
#
echo "Wordpress configuring"
cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
sed -i "s/database_name_here/${DB_NAME}/" /var/www/wordpress/wp-config.php
sed -i "s/username_here/${DB_USERNAME}/" /var/www/wordpress/wp-config.php
sed -i "s/password_here/${DB_PASSWORD}/" /var/www/wordpress/wp-config.php
#
# END Configure wordpress
# Install wordpress
#
echo "Wordpress installing"
sudo -u vagrant -i -- wp core install --url="${HOST}" \
                --title="${BLOG_TITLE}" \
                --admin_user="${BLOG_ADMIN_LOGIN}" \
                --admin_password="${BLOG_ADMIN_PASSWORD}" \
                --admin_email="${BLOG_ADMIN_EMAIL}" \
                --path="/var/www/wordpress/" \
                --skip-email

sudo chown -R www-data:www-data /var/www/wordpress/
#
# END Install wordpress
# Configure theme
#
echo "Theme configuration"
ln -s /srv/theme /var/www/wordpress/wp-content/themes/$THEME_NAME
cp /var/www/wordpress/wp-content/themes/$THEME_NAME/.provision/style.template.css \
    /var/www/wordpress/wp-content/themes/$THEME_NAME//style.css

sed -i "s/#theme_nicename#/${THEME_NICENAME}/" /var/www/wordpress/wp-content/themes/$THEME_NAME/style.css
sed -i "s/#theme_name#/${THEME_NAME}/" /var/www/wordpress/wp-content/themes/$THEME_NAME/style.css

sudo -u vagrant -i -- wp theme activate ${THEME_NAME} \
                --path="/var/www/wordpress/" 
#
# END Configure theme
#
echo "Done."