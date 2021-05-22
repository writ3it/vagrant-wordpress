#!/bin/bash

apt-get -y install apache2

sudo a2enmod rewrite

systemctl restart apache2