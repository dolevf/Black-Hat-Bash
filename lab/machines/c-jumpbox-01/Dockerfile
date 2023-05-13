FROM lab_base

# Metadata
LABEL name="c-jumpbox-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install -y \
                    cron \
                    openssh-server

# Copy Files to Lab
COPY --chown=jmartinez:jmartinez files/bash_history /home/jmartinez/.bash_history
COPY --chown=root:root files/read_program /home/jmartinez/read_program
COPY --chown=dbrown:dbrown files/profile /home/dbrown/.profile

# Post Actions
RUN chmod u+sx /home/jmartinez/read_program 

# Entry
ENTRYPOINT \
    service ssh restart \
    && \    
    tail -f /dev/null

