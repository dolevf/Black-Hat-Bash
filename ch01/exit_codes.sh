#!/bin/bash

# Experimenting with status codes

command="$(ls -l > /dev/null)"
echo "The status code of the ls command was: $?"

command="$(lzl 2> /dev/null)"
echo "The status code of the non-existing lzl command was: $?"
