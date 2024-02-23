#!/bin/bash

if [[ ! -r "/etc/passwd" ]]; then
    echo "/etc/passwd must exist and be readable to be able to continue."
    exit 1
fi

while read -r line; do
  account=$(echo "${line}" | awk -F':' '{print $1}')
  home_dir=$(echo "${line}" | awk -F':' '{print $6}')
  
  # Only target home directories under /home
  if echo "${home_dir}" | grep -q "^/home"; then
    if [[ -r "${home_dir}" ]]; then
        echo "Home directory ${home_dir} of ${account} is accessible!"
    else
        echo "Home directory ${home_dir} of ${account} is NOT accessible!"
    fi
  fi
done < <(cat "/etc/passwd")
