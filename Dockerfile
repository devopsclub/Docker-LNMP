# Set the base image to Centos
FROM centos:centos6

# File Author / Maintainer

# Add the ngix and PHP dependent repository
ADD nginx.repo /etc/yum.repos.d/nginx.repo

#clean
RUN yum clean all

# Installing nginx 
RUN yum -y install nginx

# Installing MySQL
RUN yum -y install mysql-server mysql-client

# Repository for PHP5.5 
RUN rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
RUN yum -y install php56w php56w-opcache
RUN yum -y install php56w-common php56w-fpm

#Installing unzip and zip program
RUN yum install -y zip unzip 

#Installing Git
RUN yum install -y git

# Enviroment variable for setting the Username and Password of MySQL
ENV MYSQL_USER root
ENV MYSQL_PASS admin888

# Adding the configuration file of the nginx
ADD nginx.conf /etc/nginx/nginx.conf
ADD default.conf /etc/nginx/conf.d/default.conf
ADD my.cnf /etc/mysql/my.cnf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD run.sh /run.sh
RUN chmod 755 /run.sh

#Starting MySQL Service
RUN /etc/init.d/mysqld start

# Add volumes for MySQL 
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]

# Retrieve and Installing Pimcore
RUN rm -rf /var/www/
RUN mkdir /var/www/
RUN chown -R apache:apache /var/www/

#Add index.php
ADD index.php /var/www/index.php

# Set the port to 80 
EXPOSE 80 3306

# Executing supervisord
CMD ["/run.sh"]
