#!/bin/bash

# shellcheck disable=SC2164

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
  # - 40 GB of Storage available
  # - Internet connectivity

USER_HOME_BASE="/home/${SUDO_USER}"
BHB_BASE_FOLDER="${USER_HOME_BASE}/Black-Hat-Bash"
BHB_LAB_FOLDER="${BHB_BASE_FOLDER}/lab"
BHB_TOOLS_FOLDER="${USER_HOME_BASE}/tools"
LOG="log.txt"

check_prerequisites(){
  # Checks if script is running as root
  if [[ "$EUID" -ne 0 ]]; then
    echo "Error: Please run with sudo permissions."
    exit
  fi

  # Check if Kali OS 
  if ! grep -q "ID=kali" /etc/os-release; then
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
    echo "This may impact the performance of the lab."
    read -p "Do you want to continue? [y/n] " -n 1 -r
    echo
    if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
      echo "Exiting..."
      exit
    fi
  fi

  # Check disk space
  local free
  free=$(df -k --output=size "${PWD}" | tail -n1)
  if [[ "${free}" -lt 41943040 ]]; then
    echo "Warning: System does not meet 40 GB disk space requirement."
    echo "This may impact the performance of the lab."
    read -p "Do you want to continue? [y/n] " -n 1 -r
    echo
    if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
      echo "Exiting..."
      exit
    fi
  fi

  if [[ ! -d "${BHB_TOOLS_FOLDER}" ]]; then
    mkdir "${BHB_TOOLS_FOLDER}"
  else
    rm -rf "${BHB_TOOLS_FOLDER:?}/"*
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

  if ! grep kali /etc/passwd | grep -q /bin/bash; then
    usermod --shell /bin/bash kali
  fi
}

install_docker(){
  local docker_apt_src
  local docker_keyring

  docker_apt_src="/etc/apt/sources.list.d/docker-ce.list"
  docker_keyring="/etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg"

  if ! docker compose version &> /dev/null; then 
    if [[ ! -f "${docker_apt_src}" ]]; then
      printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable" | sudo tee "${docker_apt_src}"
    fi
    
    if [[ ! -f "${docker_keyring}" ]]; then
      curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o "${docker_keyring}"
    fi
    sudo apt update -y 
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    sudo systemctl enable docker --now
    sudo usermod -aG docker "${USER}"
  fi
}

clone_repo(){  
  git clone --quiet https://github.com/dolevf/Black-Hat-Bash.git
}

deploy_containers(){
  cd "${BHB_LAB_FOLDER}"
  ./run.sh cleanup
  ./run.sh deploy
  echo
}

install_tools(){
  cd "${BHB_TOOLS_FOLDER}"
  install_whatweb
  install_rustscan
  install_nuclei
  install_linux_exploit_suggester_2
  install_gitjacker
  install_linenum
  install_dirsearch
  install_sysutilities
  install_unixprivesccheck
}

install_whatweb(){
  sudo apt install whatweb -y
  cd -
}

install_rustscan(){
  sudo apt install cargo -y
  git clone https://github.com/RustScan/RustScan.git && cd RustScan
  cargo build --release
  if ! grep -q rustscan "${USER_HOME_BASE}/.bashrc" ; then
    echo "alias rustscan=\"${BHB_TOOLS_FOLDER}/RustScan/target/release/rustscan\"" >> "${USER_HOME_BASE}/.bashrc"
  fi
  cd - 
}

install_nuclei(){
  sudo apt install nuclei -y 
}

install_linux_exploit_suggester_2(){
  git clone https://github.com/jondonas/linux-exploit-suggester-2.git "${BHB_TOOLS_FOLDER}/linux-exploit-suggester-2"
}

install_gitjacker(){
  sudo apt install jq -y
  curl "https://raw.githubusercontent.com/liamg/gitjacker/master/scripts/install.sh" | bash
  if ! grep -q gitjacker "${USER_HOME_BASE}/.bashrc"; then
    echo "alias gitjacker=\"/usr/local/bin/gitjacker\"" >> "${USER_HOME_BASE}/.bashrc"
  fi
}

install_linenum(){
  wget -q https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -O "${BHB_TOOLS_FOLDER}/LinEnum.sh"
  chmod u+x "${BHB_TOOLS_FOLDER}/LinEnum.sh"
}

install_dirsearch(){
  sudo apt install dirsearch -y
}

install_sysutilities(){
  sudo apt install jq -y
  sudo pip3 install pwncat-cs -y
}

install_unixprivesccheck(){
  if [[ ! -f "/usr/bin/unix-privesc-check" ]]; then
    apt install unix-privesc-check -y
  fi
  
  cp "/usr/bin/unix-privesc-check" "${BHB_TOOLS_FOLDER}/unix-privesc-check"
}

echo "This process may take a while, stay tuned..."

echo "Checking prerequisities..."
check_prerequisites 

sleep 2

echo "[1/4] Installing Docker..."
install_docker &>> "${LOG}"

echo "[2/4] Cloning the Black Hat Bash repository..."
clone_repo

echo "[3/4] Deploying containers..."
deploy_containers

echo "[4/4] Installing third party tools..."
install_tools &>> "${LOG}"

cd "${BHB_LAB_FOLDER}"

echo "Lab build completed." | tee -a "${LOG}"

echo "NOTE: Start a new terminal session for shell changes to take effect."
