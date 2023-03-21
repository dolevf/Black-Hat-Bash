#!/bin/bash 
RUST_SCAN_BIN="/home/kali/tools/RustScan/target/release/rustscan"
LOG_FILE="watchdog.log"
IP_ADDRESS="$1"
WATCHED_PORT="$2"

service_discovery(){
  local host
  local port
  host="${1}"
  port="${2}"

  nmap -sV -p "${port}" "${host}" >> ${LOG_FILE}
}

port_check=$("${RUST_SCAN_BIN}" -a "${IP_ADDRESS}" -g -p "${WATCHED_PORT}" && sleep 10)

until [[ -z "${port_check}" ]]; do
  echo "${IP_ADDRESS} has started responding on port ${WATCHED_PORT}!"
  echo "Performing a service discovery..."
  service_discovery "${IP_ADDRESS}" "${WATCHED_PORT}"
  break
done
