FROM ubuntu:23.04

# Metadata
LABEL name="c-jumpbox-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y
RUN apt-get install -y openssh-server
RUN apt-get install cron -y
RUN apt-get install net-tools


# Provision Users
RUN useradd -m -s /bin/bash jmartinez
RUN useradd -m -s /bin/bash dbrown
RUN useradd -m -s /bin/bash ogarcia
RUN useradd -m -s /bin/bash arodriguez
RUN echo "jmartinez:password123" | chpasswd
RUN echo "dbrown:wAWSD@ASw2" | chpasswd
RUN echo "ogarcia:#T9aujf8h33" | chpasswd
RUN echo "arodriguez:asucj783E@#" | chpasswd

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

