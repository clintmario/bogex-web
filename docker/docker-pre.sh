#!/bin/bash

# Note line ending.

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

# Setup Bogex Web User Account
useradd $BGX_USER_NAME
echo "$BGX_USER_NAME:$BGX_USER_PASSWORD" | chpasswd
mkdir /home/$BGX_USER_NAME
chmod 775 /home/$BGX_USER_NAME
chown -R $BGX_USER_NAME:$BGX_USER_NAME /home/$BGX_USER_NAME
usermod -a -G sudo $BGX_USER_NAME
usermod -a -G www-data $BGX_USER_NAME
chmod -R 775 $BGX_APP_ROOT_DIR
chown -R $BGX_USER_NAME:$BGX_USER_NAME $BGX_APP_ROOT_DIR
ln -s $BGX_APP_ROOT_DIR/.env /home/$BGX_USER_NAME
cp $BGX_APP_ROOT_DIR/$BGX_GITHUB_SSH_KEY_FILE_NAME /home/$BGX_USER_NAME
chown $BGX_USER_NAME:$BGX_USER_NAME /home/$BGX_USER_NAME/$BGX_GITHUB_SSH_KEY_FILE_NAME
chmod 400 /home/$BGX_USER_NAME/$BGX_GITHUB_SSH_KEY_FILE_NAME
