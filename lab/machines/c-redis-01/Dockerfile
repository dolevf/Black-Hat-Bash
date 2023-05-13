FROM lab_base

# Metadata
LABEL name="c-redis-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install -y \
                    cron \
                    redis-server 

# Copy Files to Lab
COPY --chown=root:root files/redis.conf /etc/redis/redis.conf

# Entry
ENTRYPOINT \
    echo "Starting redis service..." && \
    service redis-server start