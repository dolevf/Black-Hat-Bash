FROM wordpress:latest

ENV WORDPRESS_DB_HOST="c-web-02-db"
ENV WORDPRESS_DB_USER="wordpress"
ENV WORDPRESS_DB_PASSWORD="wordpress"
ENV WORDPRESS_DB_NAME="wordpress"

# Copy Files to Lab
COPY files/donate.php /var/www/html/donate.php
COPY files/robots.txt /var/www/html/robots.txt
