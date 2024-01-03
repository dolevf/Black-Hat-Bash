#!/bin/bash

# This function checks if the current user ID equals to zero
check_if_root(){
  if [[ "${EUID}" -eq "0" ]]; then
    return 0
  else
    return 1
  fi
}

is_root=$(check_if_root)
if [[ "${is_root}" -eq "0" ]]; then
  echo "User is root!"
else
  echo "User is not root!"
fi
