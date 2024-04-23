FROM lab_base

# Metadata
LABEL name="c-backup-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install -y python3 

# Post Actions
COPY files/execute.sh /mnt/scripts/

RUN chmod u+x /mnt/scripts/execute.sh
RUN echo '*/1 * * * * bash /mnt/scripts/execute.sh' >> /tmp/root-crontab
RUN crontab /tmp/root-crontab && rm /tmp/root-crontab
RUN mkdir -p /var/www/site

ENTRYPOINT service cron restart && python3 -m http.server --directory /var/www/site 8080

