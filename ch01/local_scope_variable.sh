#!/bin/bash

publisher="No Starch Press"

print_name(){
  local name
  name="Black Hat Bash"
  echo "${name} by ${publisher}" 
}

print_name

echo "The variable ${name} will not be printed here because it is a local variable."