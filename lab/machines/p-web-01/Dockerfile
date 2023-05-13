FROM lab_base

# Metadata
LABEL name="c-web-01"
LABEL company="ACME Infinity Servers"

# Install Required Packages
RUN apt-get update -y --fix-missing
RUN apt-get install software-properties-common -y
RUN add-apt-repository universe
RUN apt-get update -y
RUN apt-get install -y \
        python3 \
        python3-pip 
RUN pip3 install flask --break-system-packages

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