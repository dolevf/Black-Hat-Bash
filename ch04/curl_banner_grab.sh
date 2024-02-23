#!/bin/bash
DEFAULT_PORT="80"

read -r -p "Type a target IP address: " ip
read -r -p "Type a target port (default: 80): " port

if [[ -z "${ip}" ]]; then
  echo "You must provide an IP address."
  exit 1
fi

if [[ -z "${port}" ]]; then
  echo "You did not provide a specific port, defaulting to ${DEFAULT_PORT}"
  port="${DEFAULT_PORT}"
fi

echo "Attempting to grab the Server header of ${ip}..."

result=$(curl -s --head "${ip}:${port}" | grep Server | awk -F':' '{print $2}') 

echo "Server header for ${ip} on port ${port} is: ${result}"
