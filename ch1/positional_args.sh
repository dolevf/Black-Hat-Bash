#!/usr/bin/bash
Script_Name="${0}"
Tareget="${1}"
echo -e "Running ${Script_Name}...\nPinging ${Tareget}...\n"
ping -c5 "${Tareget}"
echo -e "Finished"
