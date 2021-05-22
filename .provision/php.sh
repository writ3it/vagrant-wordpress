#!/bin/bash

VERSION="7.4"

apt-get -y install php${VERSION} \
                php${VERSION}-common \
                php${VERSION}-mysqli \
                php${VERSION}-pdo \
                php${VERSION}-xml \
                php${VERSION}-cli \
                libapache2-mod-php