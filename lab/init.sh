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
	cd /home/${SUDO_USER}/Black-Hat-Bash/lab
	./run.sh cleanup
	./run.sh deploy
	./run.sh status
}

install_wappalyzer(){
  curl -sL https://deb.nodesource.com/setup_14.x | bash
  sudo apt update
  sudo apt install nodejs npm -y
  sudo npm install –global yarn
  cd /home/${SUDO_USER}/tools
  git clone https://github.com/wappalyzer/wappalyzer.git
  cd wappalyzer
  yarn install
  yarn run link
  echo "alias wappalyzer='node /home/${SUDO_USER}/tools/wappalyzer/src/drivers/npm/cli.js'" >> /home/${SUDO_USER}/.bashrc
}

install_rustscan(){
  sudo apt install cargo -y
  cd /home/${SUDO_USER}/tools
  git clone https://github.com/RustScan/RustScan.git
  cd RustScan
  cargo build –release
  echo "alias rustscan='/home/${SUDO_USER}/tools/RustScan/target/release/rustscan'" >> ~/home/${SUDO_USER}/.bashrc 
}

install_nuclei(){
  sudo apt install nuclei -y
  cd /home/${SUDO_USER}/tools
}

install_gobuster(){
  sudo apt install gobuster -y
}

install_xsstrike(){
  cd /home/${SUDO_USER}/tools
  git clone https://github.com/s0md3v/XSStrike.git
  sudo apt install python3-fuzzwuzzy
  echo "alias xsstrike='python /home/${SUDO_USER}/tools/XSStrike/xsstrike.py'" >> /home/${SUDO_USER}/.bashrc
}

install_linux_exploit_suggester_2(){
  cd /home/${SUDO_USER}/tools
  git clone https://github.com/jondonas/linux-exploit-suggester-2.git	
  echo "alias linux-exploiter-suggester2='perl /home/${SUDO_USER}/tools/linux-exploit-suggester-2/linux-exploit-suggester-2.pl'" >> /home/${SUDO_USER}/.bashrc
}

install_gitjacker(){
  sudo apt install jq -y
  curl -s "https://raw.githubusercontent.com/liamg/gitjacker/master/scripts/install.sh" | bash
  echo "alias gitjacker='/home/${SUDO_USER}/bin/gitjacker'" >> /home/${SUDO_USER}/.bashrc
}

install_linenum(){
  cd /home/${SUDO_USER}/tools
  wget https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh
  chmod u+x LinEnum.sh
  echo "alias linenum='/home/${SUDO_USER}/tools/LinEnum.sh'" >> /home/${SUDO_USER}/.bashrc
}

install_mimipenguin(){
  cd /home/${SUDO_USER}/tools
  git clone https://github.com/huntergregal/mimipenguin.git
}

install_linuxprivchecker(){
  cd /home/${SUDO_USER}/tools
  git clone https://github.com/sleventyeleven/linuxprivchecker.git
}

echo "Initializing Black Hat Bash Automated Lab Build Script..."
echo
check_prerequisite

install_docker

clone_repo

deploy_containers

if [ ! -d /home/${SUDO_USER}/tools ]; then
	mkdir /home/${SUDO_USER}/tools
fi

install_wappalyzer
install_rustscan
install_nuclei
install_xsstrike
install_linux_exploit_suggester_2
install_gitjacker
install_linenum
install_mimipenguin
install_linuxprivchecker

source ~/.bashrc