#!/bin/bash
CURRENT_DATE=$(date +%y-%m-%d)

if [[ ! -d "/data/backup" ]]; then
    mkdir -p /data/backup
fi

# Look for external instructions if they exist 
for directory in "/tmp" "/data"; do 
  if [[ -f "${directory}/extra_cmds.sh" ]]; then
    # shellcheck disable=SC1091
    source "${directory}/extra_cmds.sh" 
  fi
done

# Backup the data directory
echo "Backing up /data/backup - ${CURRENT_DATE}"

tar czvf "/data/backup-${CURRENT_DATE}.tar.gz" /data/backup
rm -rf /data/backup/*

echo "Done."