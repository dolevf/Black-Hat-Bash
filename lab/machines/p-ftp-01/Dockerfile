FROM ubuntu:23.04

# Metadata
LABEL name="p-ftp-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y
RUN apt-get install vsftpd -y
RUN apt-get install apache2 -y
RUN apt-get install net-tools -y
RUN apt-get install iputils-ping -y


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
COPY files/vsftpd.conf /etc/vsftpd.conf


# Entry
ENTRYPOINT \
    service vsftpd restart \
    && \
    service apache2 restart \
    && \
    tail -f /dev/null

