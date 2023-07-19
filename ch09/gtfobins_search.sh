#!/bin/bash
GTFOBINS_PATH="https://raw.githubusercontent.com/GTFOBins/GTFOBins.github.io/master/_gtfobins"

while read -r binary; do
  echo "Searching for ${binary}..."
  result=$(curl --fail -s -X GET "${GTFOBINS_PATH}/${binary}.md")
  
  if echo "${result}" | grep -q "functions:"; then
    echo "OK: Binary information was found for ${binary}:"
    echo "${result}"
  fi
done < <(find /usr/sbin /usr/bin -perm -4000  -printf "%f\n")
