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
  # - 4 GB of RAM
  # - 30 GB of Storage available
  # - Internet connectivity

USER_HOME_BASE="/home/${SUDO_USER}"
BHB_BASE_FOLDER="${USER_HOME_BASE}/Black-Hat-Bash"
BHB_LAB_FOLDER="${BHB_BASE_FOLDER}/lab"
BHB_TOOLS_FOLDER="${USER_HOME_BASE}/tools"

check_prerequisites(){
  # Checks if script is running as root
  if [[ "$EUID" -ne 0 ]]; then
    echo "Error: Please run with sudo permissions."
    exit
  fi

  # Check if Kali OS 
  if ! grep "ID=kali" /etc/os-release; then
    echo "Error: Operating system does not appear to be Kali."
  fi

  # Check internet connectivity (against Google)
  if ! ping -c 1 -W 1 -w 1 8.8.8.8 &> /dev/null; then
    echo "Error: No internet connectivity."
  fi

  # Check if RAM +4 GB
  local total_ram
  total_ram=$(awk '/^MemTotal:/{print $2}' /proc/meminfo);
  if [ "${total_ram}" -lt 4194304 ]; then
    echo "Warning: System does not meet 4 GB RAM requirement."
    echo "This may impact the performance of the lab"
    read -p "Do you want to continue? [y/n] " -n 1 -r
    echo
    if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
      echo "Exiting..."
      exit
    fi
  fi

  # Check disk space
  local free
  free=$(df -k --output=size "$PWD" | tail -n1)
  if [[ "${free}" -lt 31457280 ]]; then
    echo "Warning: System does not meet 30 GB disk space requirement."
    echo "This may impact the performance of the lab"
    read -p "Do you want to continue? [y/n] " -n 1 -r
    echo
    if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
      echo "Exiting..."
      exit
    fi
  fi

  if [[ ! -d "${BHB_TOOLS_FOLDER}" ]]; then
    mkdir "${BHB_TOOLS_FOLDER}"
  fi

  if [[ ! -d "${BHB_BASE_FOLDER}" ]]; then
    mkdir "${BHB_BASE_FOLDER}"
  fi

  local nr_config
  nr_config="/etc/needrestart/needrestart.conf"
  if [[ -f "${nr_config}" ]]; then
    if grep -q "#\$nrconf{restart}" "${nr_config}"; then
      sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/g" "${nr_config}"
    fi
  fi
}

install_docker(){
  # Check if Docker and Docker Compose are installed.
  if ! docker compose version &> /dev/null; then 
    echo "Installing docker..."
    if [[ ! -f "/etc/apt/sources.list.d/docker-ce.list" ]]; then
      printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
    fi
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg
    sudo apt update -y
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    sudo systemctl enable docker --now
    sudo usermod -aG docker "${USER}"
  fi
}

clone_repo(){  
  git clone git@github.com:dolevf/Black-Hat-Bash.git "${BHB_BASE_FOLDER}"
}

deploy_containers(){
  cd "${BHB_LAB_FOLDER}"
  ./run.sh cleanup
  ./run.sh deploy
  ./run.sh status
}

install_tools(){
  cd "${BHB_TOOLS_FOLDER}"
  install_wappalyzer
  install_rustscan
  install_nuclei
  install_linux_exploit_suggester_2
  install_gitjacker
  install_linenum
  install_mimipenguin
  install_linuxprivchecker
}

install_wappalyzer(){
  curl -sL https://deb.nodesource.com/setup_14.x | bash
  sudo apt update -y
  sudo apt install nodejs npm -y
  sudo npm install --global yarn
  git clone https://github.com/wappalyzer/wappalyzer.git
  cd wappalyzer
  yarn install
  yarn run link
  if ! grep -q wappalyzer "${USER_HOME_BASE}/.bashrc"; then
    echo "alias wappalyzer='node ${BHB_TOOLS_FOLDER}/wappalyzer/src/drivers/npm/cli.js'" >> "${USER_HOME_BASE}/.bashrc"
  fi
}

install_rustscan(){
  sudo apt install cargo -y
  git clone https://github.com/RustScan/RustScan.git
  cd RustScan
  cargo build --release
  if ! grep -q rustscan "${USER_HOME_BASE}/.bashrc" ; then
    echo "alias rustscan='${BHB_TOOLS_FOLDER}/RustScan/target/release/rustscan'" >> "${USER_HOME_BASE}/.bashrc"
  fi
}

install_nuclei(){
  sudo apt install nuclei -y
}

install_gobuster(){
  sudo apt install gobuster -y
}

install_linux_exploit_suggester_2(){
  git clone https://github.com/jondonas/linux-exploit-suggester-2.git
}

install_gitjacker(){
  sudo apt install jq -y
  curl -s "https://raw.githubusercontent.com/liamg/gitjacker/master/scripts/install.sh" | bash
  if ! grep -q gitjacker "${USER_HOME_BASE}/.bashrc"; then
    echo "alias gitjacker='${USER_HOME_BASE}/bin/gitjacker'" >> "${USER_HOME_BASE}/.bashrc"
  fi
}

install_linenum(){
  wget https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh
  chmod u+x LinEnum.sh
}

install_mimipenguin(){
  git clone https://github.com/huntergregal/mimipenguin.git
}

install_linuxprivchecker(){
  git clone https://github.com/sleventyeleven/linuxprivchecker.git
}

export DEBIAN_FRONTEND=noninteractive # don't prompt user with TUI consoles

echo "Initializing Black Hat Bash Automated Lab Build Script..."
echo

# Run steps
check_prerequisites
install_docker
clone_repo
deploy_containers
install_tools

source ~/.bashrc
