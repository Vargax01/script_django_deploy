#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt install -y apache2
sudo -E apt-get -q -y install mysql-server
sudo apt install -y python3-pip
sudo apt-get install libapache2-mod-wsgi-py3
pip3 install virtualenv
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-apache
sudo apt-get install libmysqlclient-dev
sudo apt-get -y install python3-dev default-libmysqlclient-dev build-essential pkg-config
sudo apt install certbot python3-certbot-apache
sudo apt install wkhtmltopdf
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod lbmethod_byrequests


