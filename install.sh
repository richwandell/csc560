#!/usr/bin/env bash

cp /var/www/my.cnf /etc/mysql/my.cnf
service mysql restart
cp /var/www/mongod.conf /etc/mongod.conf
service mongod restart
mysql -proot -e "grant all privileges on *.* to 'root'@'%' with grant option;"
ln -s /var/www/scotchbox.local.conf /etc/apache2/sites-available/scotchbox.local.conf

add-apt-repository ppa:ondrej/php
apt-get update
apt-get -y remove php php-common
apt-get install -y php7.0
apt-get install -y php7.0-mysql php-redis php7.0-xml php7.0-mongo php-mbstring php-xdebug
apt-get install -y php7.0-mysql libapache2-mod-php7.0

rm /etc/php/7.0/mods-available/xdebug.ini
ln -s /var/www/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini

phpenmod xdebug
a2dismod php5
a2enmod php7.0
apachectl restart

EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
then
    php composer-setup.php --quiet
    RESULT=$?
    rm composer-setup.php
    exit $RESULT
else
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi


