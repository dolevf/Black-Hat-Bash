#!/usr/bin/bash
#trying ls 
ls -l &> /dev/null

echo "exit code of the ls command was ${?}"

DontKnowWhatToWrite --really-dont-know &>/dev/null

echo "exit code of the DontKnowWhatToWrite command was ${?}"
