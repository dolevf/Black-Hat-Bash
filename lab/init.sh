#!/bin/bash

# shellcheck disable=SC2164

# Black Hat Bash - Automated Lab Build Script

# Script Checks system requirements
  # - Running Kali
  # - Minimum of 4 GB of RAM
  # - Minimum of 40 GB disk space available
  # - Internet connectivity

USER_HOME_BASE="/home/${SUDO_USER}"
BHB_TOOLS_FOLDER="/home/${SUDO_USER}/tools"

BHB_BASE_FOLDER="$(pwd)"
BHB_LAB_FOLDER="${BHB_BASE_FOLDER}/lab"
BHB_INSTALL_LOG="/var/log/lab-install.log"

check_prerequisites(){
  # Checks if script is running as root
  if [[ "$EUID" -ne 0 ]]; then
    echo "Error: Please run with sudo permissions."
    exit 1
  fi

  if [[ ! -f "${BHB_INSTALL_LOG}" ]]; then
    touch "${BHB_INSTALL_LOG}"
    chown "${SUDO_USER}:${SUDO_USER}" "${BHB_INSTALL_LOG}"
  fi

  # Check if Kali OS 
  if ! grep -q "ID=kali" /etc/os-release; then
    echo "Error: Operating system does not appear to be Kali."
  fi

  # Check internet connectivity (against Google)
  if ! ping -c 1 -W 5 -w 5 "8.8.8.8" &> /dev/null; then
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
      printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable" | tee "${docker_apt_src}"
    fi
    
    if [[ ! -f "${docker_keyring}" ]]; then
      curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o "${docker_keyring}"
    fi
    apt update -y 
    apt install docker-ce docker-ce-cli containerd.io -y
    systemctl enable docker --now
    usermod -aG docker "${SUDO_USER}"
  fi
}

deploy_containers(){
  make deploy
}

install_tools(){
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
  apt install whatweb -y
}

install_rustscan(){
  docker pull --quiet rustscan/rustscan:2.1.1
  if ! grep -q rustscan "${USER_HOME_BASE}/.bashrc" ; then
    echo "alias rustscan='docker run --network=host -it --rm --name rustscan rustscan/rustscan:2.1.1'" >> "${USER_HOME_BASE}/.bashrc"
  fi
} 

install_nuclei(){
  apt install nuclei -y 
}

install_linux_exploit_suggester_2(){
  git clone https://github.com/jondonas/linux-exploit-suggester-2.git "${BHB_TOOLS_FOLDER}/linux-exploit-suggester-2"
}

install_gitjacker(){
  curl "https://raw.githubusercontent.com/liamg/gitjacker/master/scripts/install.sh" | bash
  if [[ -f "/usr/local/bin/gitjacker" ]]; then
    mv "/usr/local/bin/gitjacker" "${BHB_TOOLS_FOLDER}/gitjacker"
    rmdir bin
  fi 

  if ! grep -q gitjacker "${USER_HOME_BASE}/.bashrc"; then
    echo "alias gitjacker=\"${BHB_TOOLS_FOLDER}/gitjacker\"" >> "${USER_HOME_BASE}/.bashrc"
  fi
}

install_linenum(){
  wget -q https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -O "${BHB_TOOLS_FOLDER}/LinEnum.sh"
  chmod u+x "${BHB_TOOLS_FOLDER}/LinEnum.sh"
}

install_dirsearch(){
  apt install dirsearch -y
}

install_sysutilities(){
  apt install jq -y
  apt install ncat -y
  apt install sshpass -y
  pip3 install pwncat-cs
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

echo "[1/3] Installing Docker..."
install_docker &>> "${BHB_INSTALL_LOG}"

echo "[2/3] Deploying containers..."
deploy_containers

echo "[3/3] Installing third party tools..."
install_tools &>> "${BHB_INSTALL_LOG}"

chown -R "${SUDO_USER}:${SUDO_USER}" "${BHB_TOOLS_FOLDER}"

echo "Lab build completed." | tee -a "${BHB_INSTALL_LOG}"

echo "NOTE: Log out and log back in for shell changes to take effect"