FROM ubuntu:23.04

# Metadata
LABEL name="c-redis-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install cron -y
RUN apt-get install net-tools
RUN apt-get install redis-server -y

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
COPY --chown=root:root files/redis.conf /etc/redis/redis.conf

# Entry
ENTRYPOINT \
    echo "Starting redis service..." && \
    service redis-server start