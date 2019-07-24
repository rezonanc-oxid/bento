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

# With varnish, java, elasticsearch, selenium and doxygen enabled
## - Install dependencies needed for selenium
apt-get install -y xfce4 xvfb x11vnc rng-tools;
## - Install firefox to get all dependencies
apt-get install -y firefox;
## - Install Varnish
apt-get install -y apt-transport-https;
wget -qO - https://packagecloud.io/varnishcache/varnish40/gpgkey | sudo apt-key add -;
add-apt-repository 'deb https://packagecloud.io/varnishcache/varnish40/ubuntu/ trusty main';
apt-get -y update;
apt-get install -y 'varnish=4.0.*';
## - install python-pip
apt-get install -y python-pip;
## - Install Doxygen and required packages
apt-get install -y doxygen flex bison make cmake graphviz build-essential;
## - Download fixed firefox version
wget -qO /tmp/firefox.tar.bz2 https://github.com/OXID-eSales/oxvm_assets/raw/master/firefox-31.6.0esr.tar.bz2;
## - Download fixed selenium version
mkdir -p /opt/selenium
wget -qO /opt/selenium/selenium.jar https://github.com/OXID-eSales/oxvm_assets/raw/master/selenium-server-standalone-2.47.1.jar;

# Remove non-used packages and clean package repository
apt-get -y autoremove;
apt-get -y clean;

# Remove docs
rm -rf /usr/share/doc/*;

# Remove caches
find /var/cache -type f -exec rm -rf {} \;

# delete any logs that have built up during the install
find /var/log/ -name *.log -exec rm -f {} \;
