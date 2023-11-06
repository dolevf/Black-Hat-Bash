# Lab Diagram
<p>
  <img src="https://github.com/dolevf/Black-Hat-Bash/blob/master/lab/lab-network-diagram.png?raw=true" width="600px" alt="BHB"/>
</p>

# Lab Machine IP Addreses
| Machine  | Public IP | Private IP | Hostname
| -------- | ------- | ------- | ------- | 
| p-web-01  | 172.16.10.10  |  | p-web-01.acme-infinity-servers.com |
| p-ftp-01  | 172.16.10.11  | | p-ftp-01.acme-infinity-servers.com  |
| p-web-02  | 172.16.10.12  | 10.1.0.11 | p-web-02.acme-infinity-servers.com  |
| p-jumpbox-01 | 172.16.10.13 | 10.1.0.12 | p-jumpbox-01.acme-infinity-servers.com |
| c-backup-01 | | 10.1.0.13 | c-backup-01.acme-infinity-servers.com |
| c-redis-01 | | 10.1.0.14 | c-redis-01.acme-infinity-servers.com |
| c-db-01 | | 10.1.0.15 | c-db-01.acme-infinity-servers.com |
| c-db-02 | | 10.1.0.16 | c-db-02.acme-infinity-servers.com |


# Lab Installation

**Note**: These lab instructions were tested on Kali Linux only.

## Install Docker

**Add the docker apt source**

`printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list`

**Next, let's download and import the gpg key**

`curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg`

**Update the apt repository**

`sudo apt update -y`

**Install Docker and Docker Compose** 

`sudo apt install docker-ce docker-ce-cli containerd.io -y`

**Start the Docker Service** 

`sudo service docker start`

## Start the Lab
Go into the lab folder in this repository and run:

`chmod u+x run.sh && ./run.sh deploy`

## Stop the Lab
`./run.sh teardown`

## Rebuild the Lab
`./run.sh rebuild`

## Destroy the Lab
`./run.sh cleanup`

