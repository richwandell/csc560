#!/usr/bin/env bash

cp /var/www/my.cnf /etc/mysql/my.cnf
service mysql restart
cp /var/www/mongod.conf /etc/mongod.conf
service mongod restart
mysql -proot -e "grant all privileges on *.* to 'root'@'%' with grant option;"
cp /var/www/scotchbox.local.conf /etc/apache2/sites-available/scotchbox.local.conf
service apache2 restart