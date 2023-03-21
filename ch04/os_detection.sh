#!/bin/bash 
HOSTS="$*"

if [[ "${EUID}" -ne 0 ]]; then
  echo "The Nmap Scan Type -O requires root privileges."
  exit 1
fi

if [[ "$#" -eq 0 ]]; then
  echo "You must pass an IP or an IP range"
  exit 1
fi

echo "Running an OS Detection Scan against ${HOSTS}..."

nmap_scan=$(nmap -O ${HOSTS} -oG -)
while read -r line; do
  ip=$(echo "${line}" | awk '{print $2}')
  os=$(echo "${line}" | grep OS | awk -F'OS: ' '{print $2}' | sed 's/Seq.*//g')

  if [[ -n "${ip}" ]] && [[ -n "${os}" ]]; then
    echo "IP: $ip OS: $os"
  fi
done <<< "${nmap_scan}
