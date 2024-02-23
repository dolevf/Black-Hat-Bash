#!/bin/bash

PUBLISHER="No Starch Press"

print_name(){
  local name
  name="Black Hat Bash"
  echo "${name} by ${PUBLISHER}" 
}

print_name

echo "Variable ${name} will not be printed here because it is a local variable."