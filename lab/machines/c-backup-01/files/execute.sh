#!/bin/bash

# This script is executed every minute on c-backup-01 to do maintenance work.

LOG="/tmp/job.log"

echo "$(date) - Starting cleanup script..." >> "$LOG"
if find /tmp -type f ! -name 'job.log' -exec rm -rf {} +; then
    echo "cleaned up files from the /tmp folder."  >> "$LOG"
fi

echo "$(date) - Cleanup script is finished." >> "$LOG"

