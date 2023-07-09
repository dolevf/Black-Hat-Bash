#!/bin/bash
OS="$(uname)"

case $OS in
  "Linux")
    OS="Linux"
    ;;
  "FreeBSD")
    OS="FreeBSD"
    ;;
  "WindowsNT")
    OS="Windows"
    ;;
  "Darwin") 
    OS="Mac"
    ;;
  *) 
    OS="Unknown"
  ;;
esac

echo "The detected operating system is ${OS}"

if [[ "${OS}" == "Unknown" ]]; then
  exit 1
fi

exit 0