FROM wordpress:latest

ENV WORDPRESS_DB_HOST="c-web-db-02"
ENV WORDPRESS_DB_USER="wordpress"
ENV WORDPRESS_DB_PASSWORD="wordpress"
ENV WORDPRESS_DB_NAME="wordpress"

# Copy Files to Lab
COPY files/site/donate.php /var/www/html/donate.php
COPY files/site/robots.txt /var/www/html/robots.txt
