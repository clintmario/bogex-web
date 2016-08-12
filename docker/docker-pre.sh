#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/../.env"

# Create and enable Virtual Host
if [ ! -f /etc/apache2/sites-available/$BGX_APP_NAME.conf ]; then
    cp $DIR/vhosts/$BGX_APP_NAME.tmpl /etc/apache2/sites-available/$BGX_APP_NAME.conf
    sed -i -e "s/BGX_SERVER_NAME/$BGX_SERVER_NAME/g" /etc/apache2/sites-available/$BGX_APP_NAME.conf
    sed -i -e "s/BGX_APP_NAME/$BGX_APP_NAME/g" /etc/apache2/sites-available/$BGX_APP_NAME.conf
    ln -s /etc/apache2/sites-available/$BGX_APP_NAME.conf /etc/apache2/sites-enabled
fi

# Make MySQL database bind address public
if grep -q "^bind-address\s*=\s*127.0.0.1" /etc/mysql/mariadb.conf.d/50-server.cnf; then
    sed -i -e "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
fi

# Setup /etc/hosts entry
#if ! grep -q "$BGX_SERVER_NAME" /etc/hosts; then
#    echo -e "127.0.0.1\t$BGX_SERVER_NAME" >> /etc/hosts
#fi
