#!/bin/bash
HOME="/var/www/wordpress/wp-content/themes/$1"
ROOT="/var/www/wordpress"

if [ -f "$HOME/install.sh" ];
then
    cd $ROOT
    source "$HOME/install.sh"
fi