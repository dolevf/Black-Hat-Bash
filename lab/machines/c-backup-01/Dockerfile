FROM lab_base

# Metadata
LABEL name="c-backup-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install cron -y
RUN apt-get install net-tools
RUN apt-get install python3 -y

CMD echo "Starting backup service..." && python3 -m http.server --directory /etc 8080