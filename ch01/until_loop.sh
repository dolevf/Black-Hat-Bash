#!/bin/bash

FILE="output.txt"

# Create an empty file
touch "${FILE}"

# Run until the file is no longer empty
until [[ -s "${FILE}" ]]; do
  echo "$FILE is empty..."
  echo "Checking again in 2 seconds..."
  sleep 2
done

echo "${FILE} appears to have some content in it!"
