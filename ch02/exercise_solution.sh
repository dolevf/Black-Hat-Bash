#!/bin/bash
NAME="${1}"
DOMAIN="${2}"
OUTPUT_FILE="results.csv"

# Check if the two expected arguments are set
if [[ -z "${NAME}" ]] || [[ -z "${DOMAIN}" ]]; then
  echo "You must provide two arguments to this script."
  echo "Example: ${0} mysite nostarch.com"
  exit 1
fi

# Write CSV header to the file
echo "status,name,domain,timestamp" > ${OUTPUT_FILE}

if ping -c 1 "${DOMAIN}" &> /dev/null; then
  echo "success,${NAME},${DOMAIN},$(date)" >> "${OUTPUT_FILE}"
else
  echo "failure,${NAME},${DOMAIN},$(date)" >> "${OUTPUT_FILE}"
fi
