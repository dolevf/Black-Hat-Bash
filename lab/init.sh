#!/bin/bash

# Black Hat Bash - Automated Lab Build Script
 
# This script is intended to be executed within a Kali machine.
# What will this script do:
# - Installs & Configures Docker & Docker Compose
# - Clones the Black Hat Bash Repository
# - Builds, Tests and Runs all Lab Containers
# - Installs & Tests all Hacking Tools used in the Black Hat Bash book

# Script Checks system requirements
  # - Running Script as root
  # - Running Kali
  # - 8 GB of RAM
  # - 50 GB of Storage available
  # - Internet connectivity

check_prerequisite(){
  # Checks if script is running as root
  if [ "$EUID" -ne 0 ]; then
  	echo "Error: Please run as root."
    exit
  fi

  # Check if kali OS 
  if uname -a | grep -v -q kali; then
  	echo "Error: Operating system does not appear to be Kali."
  fi

  # Check internet connectivity (against Google)
  wget -q --spider http://google.com
  if [ $? -ne 0 ]; then
    echo "Error: No internet connectivity."
  fi

  # Check if RAM +8 GB
  total_ram=$(awk '/^MemTotal:/{print $2}' /proc/meminfo);
  if [ $total_ram -lt 8000000 ]; then
  	echo "Warning: System does not meet 8 GB RAM requirement."
  	echo "This may impact the performance of the lab"
  	read -p "Do you want to continue? [Y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Exiting..."
      exit
    fi
  fi

  # Check disk space
  FREE=`df -k --output=avail "$PWD" | tail -n1`   # df -k not df -h
  if [[ $FREE -lt 50000000 ]]; then               # 10G = 10*1024*1024k
    echo "Warning: System does not meet 50 GB disk space requirement."
  	echo "This may impact the performance of the lab"
  	read -p "Do you want to continue? [Y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Exiting..."
      exit
    fi
  fi;
}

install_docker(){
  # Check if Docker and Docker Compose are installed.
  docker compose version
  if [[ ! -x "$(command -v docker)" || $? -ne 0 ]]; then
  	echo "Installing docker..."
  	printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
  	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg
  	sudo apt update -y
  	sudo apt install docker-ce docker-ce-cli containerd.io -y
  	sudo systemctl enable docker –now
  	sudo usermod -aG docker $USER
  fi
}

clone_repo(){
	# Clones the Black Hat Bash git repository locally in the home directory
	if [ ! -d "/home/${SUDO_USER}/Black-Hat-Bash" ]; then
		git clone git@github.com:dolevf/Black-Hat-Bash.git /home/${SUDO_USER}/Black-Hat-Bash
	fi
}

deploy_containers(){
	/home/${SUDO_USER}/Black-Hat-Bash/lab/run.sh cleanup
	/home/${SUDO_USER}/Black-Hat-Bash/lab/run.sh deploy
	/home/${SUDO_USER}/Black-Hat-Bash/lab/run.sh status
}

install_wappalyzer(){
  echo ""
}

install_rustscan(){
  echo ""
}

install_nuclei(){
  echo ""
}

install_gobuster(){
  echo ""
}

install_xsstrike(){
  echo ""
}

install_linux_exploit_suggester_2(){
  echo ""	
}

install_gitjacker(){
  echo ""
}

install_linenum(){
  echo ""
}

install_mimipenguin(){
  echo ""
}

install_linuxprivchecker(){
  echo ""
}

echo "Initializing Black Hat Bash Automated Lab Build Script..."
echo
check_prerequisite

install_docker

clone_repo

deploy_containers


