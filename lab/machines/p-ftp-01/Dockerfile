FROM lab_base

# Metadata
LABEL name="p-ftp-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install -y \
                    vsftpd \ 
                    apache2 \
                    git

# Copy Files to Lab
RUN mkdir -p /var/www/html/backup/acme-hyper-branding
RUN mkdir -p /var/www/html/backup/acme-impact-alliance
COPY p-ftp-01/files/vsftpd.conf /etc/vsftpd.conf
COPY p-web-01/files/site/app.py /var/www/html/backup/acme-hyper-branding
COPY p-web-02/files/site/* /var/www/html/backup/acme-impact-alliance/

# Post Actions
RUN git config --global init.defaultBranch master
RUN git init /var/www/html/backup/acme-hyper-branding \
    && cd /var/www/html/backup/acme-hyper-branding \
    && git config --global user.email "mrogers@acme-hyper-branding.com" \
    && git config --global user.name "Melissa Rogers" \
    && git add -A \
    && git commit -m 'commit code'

RUN git init var/www/html/backup/acme-impact-alliance  \
    && cd /var/www/html/backup/acme-impact-alliance \
    && git config --global user.email "kpeterson@acme-impact-alliance.com" \
    && git config --global user.name "Kevin Peterson" \
    && git add -A \
    && git commit -m 'commit code'

RUN mkdir -p /var/run/vsftpd/empty

# Entry
ENTRYPOINT service cron restart \
    && \
    service apache2 restart \
    && \
    vsftpd /etc/vsftpd.conf