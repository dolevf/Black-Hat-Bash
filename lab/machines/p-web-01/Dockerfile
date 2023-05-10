FROM ubuntu:23.04

# Metadata
LABEL name="c-web-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install software-properties-common -y
RUN add-apt-repository universe
RUN apt-get update -y
RUN apt-get install python3 -y
RUN apt-get install python3-pip -y
RUN apt-get install net-tools
RUN pip3 install flask --break-system-packages

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
WORKDIR /app

COPY files/site/static static
COPY files/site/app.py .
COPY files/site/index.html .
COPY files/site/upload.html . 

RUN mkdir files 
RUN mkdir uploads
COPY files/acme-hyper-branding-5.csv files/acme-hyper-branding-5.csv


ENTRYPOINT [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=8081"]