#!/bin/bash
FILE="${1}"
PORT="${2}"

if [[ "$#" -ne 2 ]]; then
  echo "Usage: ${0} <file> <port>"
  exit 1
fi

if [[ ! -f "${FILE}" ]]; then
  echo "File: ${FILE} was not found."
  exit 1
fi

if [[ ! "${PORT}" =~ ^[0-9]+$ ]]; then 
  echo "${PORT} must be a number."
  exit 1
fi

while read -r ip; do
  echo "Running netcat on ${ip}:${PORT}"
  result=$(echo -e "\n" | nc -v "${ip}" -w 1 "${PORT}" 2> /dev/null)
  if [[ -n "${result}" ]]; then
    echo "==================="
    echo "+ IP Address: ${ip}"
    echo "+ Banner: ${result}"
    echo "==================="
  fi
done < "${FILE}"
