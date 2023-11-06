#!/bin/bash
TARGETS=("$@")

print_help(){
  echo "Usage: ${0} <LIST OF IPS>"
  echo "${0} 10.1.0.1 10.1.0.2 10.1.0.3"
}

if [[ ${#TARGETS[@]} -eq 0 ]]; then
  echo "Must provide one or more IP addresses!"
  print_help
  exit 1
fi

for target in "${TARGETS[@]}"; do 
  while read -r port; do
    if timeout 1 nc -i 1 "${target}" -v "${port}" 2>&1 | grep -q "Connected to"; then
      echo "IP: ${target}"
      echo "Port: ${port}"
      echo "Service: $(grep -w "${port}/tcp" /etc/services | awk '{print $1}')" 
    fi
  done < <(grep "/tcp" /etc/services | awk '{print $2}' | tr -d '/tcp')
done