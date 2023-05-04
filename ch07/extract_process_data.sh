#!/bin/bash

for pid in $(ls -1 /proc/ | grep -E '^[0-9]+$'); do
  cmdline=$(cat "/proc/${pid}/cmdline" | tr '\000' ' ')
  state=$(grep State "/proc/${pid}/status" | awk -F'State:' '{print $2}'| xargs)
  name=$(grep Name "/proc/${pid}/status"  | awk -F'Name:'  '{print $2}' | xargs)

  if [[ ! -d "${pid}" ]]; then
    mkdir "${pid}"
  fi

  echo "${cmdline}" > "${pid}/cmdline.txt"
  echo "${state}" > "${pid}/state.txt"
  echo "${name}" > "${pid}/name.txt"
done