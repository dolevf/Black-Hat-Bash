#!/bin/bash 
TARGET_URL="http://172.16.10.12"
ROBOTS_FILE="robots.txt"

while read -r line; do
  path=$(echo "${line}" | awk -F'Disallow: ' '{print $2}')
  if [[ -n "${path}" ]]; then
    url="${TARGET_URL}${path}"
    status_code=$(curl -s -o /dev/null -w "%{http_code}" "${url}")
    echo "URL: ${url} returned a status code of: ${status_code}"
  fi

done < <(curl -s "${TARGET_URL}/${ROBOTS_FILE}")
