FROM mariadb:10.6.4-focal

ENV MYSQL_ROOT_PASSWORD="root"
ENV MYSQL_DATABASE="wordpress"
ENV MYSQL_USER="wordpress"
ENV MYSQL_PASSWORD="wordpress"


COPY files/robots.txt /var/www/html/robots.txt

CMD ["--default-authentication-plugin=mysql_native_password"]