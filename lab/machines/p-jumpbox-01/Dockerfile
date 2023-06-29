FROM lab_base

# Metadata
LABEL name="p-jumpbox-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install -y openssh-server
RUN apt-get install -y elinks

# Copy Files to Lab
COPY --chown=jmartinez:jmartinez files/bash_history /home/jmartinez/.bash_history
COPY --chown=dbrown:dbrown files/profile /home/dbrown/.profile

# Enable backup user login
RUN echo 'backup:backup' | chpasswd
RUN chsh -s /bin/bash backup

# Configure SSH
COPY files/sshd_config /etc/ssh/sshd_config
RUN chown backup:backup /var/backups

# Set elinks with SetUID
RUN chmod u+s /usr/bin/elinks

# Entry
ENTRYPOINT \
    service ssh restart \
    && \    
    tail -f /dev/null

