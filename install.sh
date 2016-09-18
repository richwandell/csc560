#!/usr/bin/env bash

cp /var/www/my.cnf /etc/mysql/my.cnf
service mysql restart
cp /var/www/mongod.conf /etc/mongod.conf
service mongod restart
mysql -proot -e "grant all privileges on *.* to 'root'@'%' with grant option;"
cp /var/www/scotchbox.local.conf /etc/apache2/sites-available/scotchbox.local.conf

apt-get update
apt-get install -y php5-xdebug
cp /var/www/xdebug.ini /etc/php5/mods-available/xdebug.ini
php5enmod xdebug
service apache2 restart

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

