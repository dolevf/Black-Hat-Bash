FROM lab_base

# Metadata
LABEL name="p-jumpbox-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install -y openssh-server elinks chkrootkit

# Enable backup user login
RUN echo 'backup:backup' | chpasswd
RUN chsh -s /bin/bash backup

# Configure SSH
COPY files/sshd_config /etc/ssh/sshd_config
RUN chown backup:backup /var/backups

# Set elinks with SetUID
RUN chmod u+s /usr/bin/elinks

# Grant sudo access to backup user
COPY files/backup-user-sudo-config /etc/sudoers.d/backup-user-sudo-config

# Grant sudo access to jmartinez user
COPY files/jmartinez-user-sudo-config /etc/sudoers.d/jmartinez-user-sudo-config

# Create the data and scripts directory
RUN mkdir scripts
RUN mkdir -p /data/backup
RUN chmod 757 /data

# Copy scripts
COPY files/backup_data.sh /scripts/backup_data.sh
RUN chmod u+x /scripts/backup_data.sh

# Install crontab script
RUN echo '*/5 * * * * root bash /scripts/backup_data.sh' >> /etc/crontab

# Entry
ENTRYPOINT service ssh restart \
    && \
    service cron restart \
    && \
    tail -f /dev/null

