#!/bin/bash
IP_ADDRESS="${1}"

# Check if the argument is in a specific private network
case ${IP_ADDRESS} in
  192.168.*)
    echo "Network is 192.168.x.x"
  ;;
  10.0.*)
    echo "Network is 10.0.x.x"
  ;;
  *)
    echo "Could not identify the network"
  ;;
esac
