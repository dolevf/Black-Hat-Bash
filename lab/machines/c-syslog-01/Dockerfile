FROM lab_base

# Metadata
LABEL name="c-syslog-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install -y openssh-server 

# Entry
ENTRYPOINT \
    service ssh restart \
    && \    
    tail -f /dev/null
