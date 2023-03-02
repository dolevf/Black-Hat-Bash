#!/bin/bash

# Assign argument one and two to variables
FIRST_NAME="${1}"
LAST_NAME="${2}"

# Create a file named output.txt
touch output.txt

# Write the current date using DD-MM-YYYY format
date +%M-%d-%Y >> output.txt

# Append first and last name to the file
echo "${FIRST_NAME} ${LAST_NAME}" >> output.txt

# Backup the output.txt file to a new backup.txt file
cp output.txt backup.txt

# Print the content of output.txt file
cat output.txt
