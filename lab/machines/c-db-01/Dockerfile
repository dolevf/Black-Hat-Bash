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
    php-mysql 

# Post Actions
COPY files/adminer-4.8.1.php /var/www/html/adminer.php
COPY files/database.sql /var/www/html/database.sql

# Entry
ENTRYPOINT \
            service mariadb start \ 
            && \
            cat /var/www/html/database.sql | mysql -u root \
            && \
            /usr/sbin/apache2ctl -D FOREGROUND