#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/../.env"

# Create and enable Virtual Host
if [ ! -f /etc/apach2/sites-available/bogex-web.localhost.com.conf ]; then
cp $DIR/vhosts/bogex-web.localhost.com.conf /etc/apache2/sites-available
ln -s /etc/apache2/sites-available/bogex-web.localhost.com.conf /etc/apache2/sites-enabled
fi

# Make MySQL database bind address public
sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

# Setup /etc/hosts entry
cat $DIR/hosts/bogex-web.localhost.com >> /etc/hosts

#echo $DB_HOST
