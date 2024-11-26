FROM lab_base

# Metadata
LABEL name="p-web-01"
LABEL company="ACME Infinity Servers"

# Variables
ENV FLASK_ENV=development

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install software-properties-common -y
RUN add-apt-repository universe
RUN apt-get update -y
RUN apt-get install -y \
                    python3 \
                    python3-pip \
                    iptables \
                    gnupg \
                    python3-flask

# Copy Files to Lab
WORKDIR /app

COPY files/site/static static
COPY files/site/app.py .
COPY files/site/index.html .
COPY files/site/upload.html . 

# Post Actions
RUN mkdir files 
RUN mkdir uploads
COPY files/acme-hyper-branding-5.csv files/acme-hyper-branding-5.csv

# Generate PGP key
RUN gpg --batch --quick-generate-key --passphrase '' arodriguez@acme-infinity-servers.com

ENTRYPOINT [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=8081", "--debug"]