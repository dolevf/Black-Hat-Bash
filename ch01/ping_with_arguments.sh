#!/bin/bash

# This script will ping any address provided as an argument.

script_name="${0}"
target="${1}"

echo "Running the script ${script_name}..."
echo "Pinging the target: ${target}..."
ping "${target}"
