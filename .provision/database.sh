#!/bin/bash

DB_PASSWORD=`date +%s | sha256sum | base64 | head -c 32 ; echo`
echo $DB_PASSWORD > ~/.dbpassword

DB_NAME=$1
DB_USERNAME=$2

export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password password ${DB_PASSWORD}"
debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password_again password ${DB_PASSWORD}"

apt-get -y install mariadb-server

echo "${DB_NAME}"
mysql -e "DROP DATABASE IF EXISTS ${DB_NAME};"
mysql -e "CREATE DATABASE ${DB_NAME} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
mysql -e "DROP USER IF EXISTS ${DB_USERNAME};"
mysql -e "CREATE OR REPLACE USER '${DB_USERNAME}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USERNAME}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"