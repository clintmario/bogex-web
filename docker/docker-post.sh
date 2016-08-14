#!/bin/bash

# Note line ending.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/../.env"

# Create MySQL database and user
MYSQL=`which mysql`
Q1="CREATE DATABASE IF NOT EXISTS $DB_DATABASE;"
Q2="GRANT USAGE ON *.* TO '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_PASSWORD';"
Q3="GRANT ALL PRIVILEGES ON $DB_DATABASE.* TO '$DB_USERNAME'@'%';"
Q4="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}${Q4}"
    
$MYSQL -uroot -e "$SQL"
