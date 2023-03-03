# Lab Diagram
<p align="center">
  <img src="https://github.com/dolevf/Black-Hat-Bash/blob/master/lab/lab-network-diagram.png?raw=true" width="600px" alt="BHB"/>
</p>


# Lab Installation

## Install Docker

**Add the docker apt source**

`printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list`

**Next, let's download and import the gpg key**

`curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg`

**Update the apt repository**

`sudo apt update -y`

**Install Docker and Docker Compose** 

`sudo apt install docker-ce docker-ce-cli containerd.io -y`

## Start the Lab
Go into the lab folder in this repository and run:

`chmod u+x run.sh && ./run.sh deploy`

## Stop the Lab
`./run.sh teardown`

## Rebuild the Lab
`./run.sh rebuild`

## Destroy the Lab
`./run.sh cleanup`

