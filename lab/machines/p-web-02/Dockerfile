FROM wordpress:latest

ENV WORDPRESS_DB_HOST="c-db-02"
ENV WORDPRESS_DB_USER="wordpress"
ENV WORDPRESS_DB_PASSWORD="wordpress"
ENV WORDPRESS_DB_NAME="wordpress"

# Copy Files to Lab
ADD files/site /var/www/html

RUN apt-get update -y
RUN apt-get install -y \ 
                    net-tools \
                    iputils-ping \
                    iproute2 \ 
                    cron \
                    gnupg

# Generate PGP key
RUN gpg --batch --quick-generate-key --passphrase '' arodriguez@acme-infinity-servers.com

