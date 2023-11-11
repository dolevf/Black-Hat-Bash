FROM ubuntu:23.04

# Metadata
LABEL name="c-db-01"
LABEL company="ACME Infinity Servers"

# Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DB_ADMINER_FILE="/var/www/html/database.sql"
ENV DB_CUSTOMERS_FILE="/var/tmp/customers.sql"

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

RUN mkdir /var/www/html/uploads 
RUN chmod 777 /var/www/html/uploads

# Entry
ENTRYPOINT service mariadb restart \
    && \
    if [[ -f "${DB_ADMINER_FILE}" ]]; then cat "${DB_ADMINER_FILE}" | mysql -u root; fi \
    && \
    if [[ -f "${DB_CUSTOMERS_FILE}" ]]; then cat "${DB_CUSTOMERS_FILE}" | mysql -u root; rm "${DB_CUSTOMERS_FILE}"; fi \
    && \
    /usr/sbin/apache2ctl -D FOREGROUND