#!/bin/bash

# Sets a variable containing the file name.
FILENAME="flow_control_with_if.txt"

# Test if a file exists, if not, create it.
if [[ -f "${FILENAME}" ]]; then
  echo "${FILENAME} already exists."
  exit 1
else
  touch "${FILENAME}"
fi
