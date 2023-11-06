FROM redis:5.0.6

# Metadata
LABEL name="c-redis-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install -y openssh-server

# Copy Files to Lab
COPY --chown=root:root files/redis.conf /etc/redis/redis.conf

# Post Actions
RUN mkdir /root/.ssh/
RUN chmod 700 /root/.ssh

RUN touch /root/.ssh/authorized_keys
RUN chmod 644 /root/.ssh/authorized_keys

# Entry
ENTRYPOINT service ssh restart \
           && \
           redis-server /etc/redis/redis.conf
