FROM ubuntu:16.04
MAINTAINER Clint Mario Cleetus <clintmario@gmail.com>
LABEL Description="Cutting-edge LAMP stack, based on Ubuntu 16.04 LTS. Includes .htaccess support and popular PHP7 features, including composer and mail() function." \
License="Apache License 2.0" \
Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 -p [HOST DB PORT NUMBER]:3306 -v [HOST WWW DOCUMENT ROOT]:/var/www/html -v [HOST DB DOCUMENT ROOT]:/var/lib/mysql clintmario/ubuntu-lamp" \
Version="1.0"

RUN apt-get update
RUN apt-get upgrade -y

COPY docker/debconf.selections /tmp/
RUN debconf-set-selections /tmp/debconf.selections

RUN apt-get install -y \
php7.0 \
php7.0-bz2 \
php7.0-cgi \
php7.0-cli \
php7.0-common \
php7.0-curl \
#php7.0-dbg \
php7.0-dev \
php7.0-enchant \
php7.0-fpm \
php7.0-gd \
php7.0-gmp \
php7.0-imap \
php7.0-interbase \
php7.0-intl \
php7.0-json \
php7.0-ldap \
php7.0-mbstring \
php7.0-mcrypt \
php7.0-mysql \
php7.0-odbc \
php7.0-opcache \
php7.0-pgsql \
php7.0-phpdbg \
php7.0-pspell \
php7.0-readline \
php7.0-recode \
php7.0-snmp \
php7.0-sqlite3 \
php7.0-sybase \
php7.0-tidy \
php7.0-xmlrpc \
php7.0-xsl
RUN apt-get install apache2 libapache2-mod-php7.0 -y
RUN apt-get install mariadb-common mariadb-server mariadb-client -y
RUN apt-get install postfix -y
RUN apt-get install git nodejs npm composer nano tree vim curl ftp -y
RUN npm install -g bower grunt-cli gulp
# Added by CMC
RUN apt-get install snmp -y
RUN apt-get install ssh -y
RUN apt-get install zip unzip -y

ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC
ENV TERM dumb
ENV BGX_SERVER_NAME dev.bogex.com
ENV BGX_APP_NAME bogex-web

COPY docker/info.php /var/www/html/
COPY docker/run-lamp.sh /usr/sbin/
COPY ./ /var/www/html/$BGX_APP_NAME/

RUN chmod +x /var/www/html/$BGX_APP_NAME/docker/*.sh
RUN mkdir -p /var/www/html/$BGX_APP_NAME/vendor

RUN a2enmod rewrite
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN chmod +x /usr/sbin/run-lamp.sh
RUN chown -R www-data:www-data /var/www/html

VOLUME /var/www/html
VOLUME /var/log/httpd
VOLUME /var/lib/mysql
VOLUME /var/log/mysql

EXPOSE 80
EXPOSE 3306
EXPOSE 22

RUN /bin/bash /var/www/html/$BGX_APP_NAME/docker/docker-pre.sh

CMD ["/usr/sbin/run-lamp.sh"]
