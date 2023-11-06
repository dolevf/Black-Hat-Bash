FROM ubuntu:23.04

# Metadata
LABEL name="c-db-01"
LABEL company="ACME Infinity Servers"

# Variables
ENV DEBIAN_FRONTEND=noninteractive

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install -y \
    cron \
    mariadb-server \
    apache2 \
    php \
    php-mysql \
    lshw \
    at 

# Post Actions
COPY files/adminer-4.8.1.php /var/www/html/adminer.php
COPY files/database.sql /var/www/html/database.sql
COPY files/customers.sql /var/tmp/customers.sql

# Entry
ENTRYPOINT service mariadb restart \
    && \
    cat /var/www/html/database.sql | mysql -u root \
    && \
    cat /var/tmp/customers.sql | mysql -u root \
    && \ 
    rm /var/tmp/customers.sql \
    && \
    /usr/sbin/apache2ctl -D FOREGROUND