#!/bin/sh -eux
export DEBIAN_FRONTEND=noninteractive

# With default settings
## - Add ppa Repository
add-apt-repository ppa:ondrej/php -y;
apt-get -y update;
## - Install php 7.2
apt-get install -y php7.2;
## - Install PHP Packages
apt-get install -y php7.2-cli php7.2-intl php7.2-mysql php7.2-gd php7.2-curl php7.2-xml php7.2-sqlite3 php7.2-xdebug;
## - Install xDebug
apt-get install -y php7.2-xdebug;
## - Install Extra Packages
apt-get install -y git bash-completion;
## - Install MySQL Packages
apt-get install -y mysql-server mysql-client python-mysqldb;
## - Install Apache
apt-get install -y apache2;
## - Install unzip
apt-get install -y unzip;

# Remove non-used packages and clean package repository
apt-get -y autoremove;
apt-get -y clean;

# Remove docs
rm -rf /usr/share/doc/*;

# Remove caches
find /var/cache -type f -exec rm -rf {} \;

# delete any logs that have built up during the install
find /var/log/ -name *.log -exec rm -f {} \;
