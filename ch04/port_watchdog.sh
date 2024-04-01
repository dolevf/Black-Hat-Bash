#!/bin/bash 
LOG_FILE="watchdog.log"
IP_ADDRESS="${1}"
WATCHED_PORT="${2}"

service_discovery(){
  local host
  local port
  host="${1}"
  port="${2}"

  nmap -sV -p "${port}" "${host}" >> "${LOG_FILE}"
}

while true; do 
  port_scan=$(docker run --network=host -it --rm --name rustscan rustscan/rustscan:2.1.1 -a "${IP_ADDRESS}" -g -p "${WATCHED_PORT}")
  if [[ -n "${port_scan}" ]]; then
    echo "${IP_ADDRESS} has started responding on port ${WATCHED_PORT}!"
    echo "Performing a service discovery..."
    if service_discovery "${IP_ADDRESS}" "${WATCHED_PORT}"; then
      echo "Wrote port scan data to ${LOG_FILE}"
      break
    fi
  else
    echo "Port is not yet open, sleeping for 5 seconds..."
    sleep 5
  fi
done