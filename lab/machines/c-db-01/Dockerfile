FROM ubuntu:23.04

# Metadata
LABEL name="c-db-01"
LABEL company="ACME Infinity Servers"

# Variables
ENV DEBIAN_FRONTEND=noninteractive

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install cron -y
RUN apt-get install net-tools -y
RUN apt-get install mariadb-server -y
RUN apt-get install apache2 -y
RUN apt-get install php -y
RUN apt-get install php-mysql -y

# Provision Users
RUN useradd -m -s /bin/bash jmartinez
RUN useradd -m -s /bin/bash dbrown
RUN useradd -m -s /bin/bash ogarcia
RUN useradd -m -s /bin/bash arodriguez
RUN echo "jmartinez:password123" | chpasswd
RUN echo "dbrown:wAWSD@ASw2" | chpasswd
RUN echo "ogarcia:#T9aujf8h33" | chpasswd
RUN echo "arodriguez:asucj783E@#" | chpasswd

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