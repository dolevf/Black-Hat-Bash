#!/bin/bash
FILE="${1}"

while read -r host; do
  if ping -c 1 -W 1 -w 1 "${host}" &> /dev/null; then
    echo "${host} is up."
  fi
done < "${FILE}"