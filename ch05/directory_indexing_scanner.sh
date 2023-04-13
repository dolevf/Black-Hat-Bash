#!/bin/bash
FILE="$1"

if [[ ! -f "${FILE}" ]] || [[ ! -s "${FILE}" ]]; then
  echo "You must provide a non-empty file as an argument."
  exit 1
fi

while read -r url; do
  echo "Testing ${url} for Directory indexing..."
  if curl -L -s "http://172.16.10.11/backup" | grep -q -e "Index of /" -e "[PARENTDIR]"; then
	echo -e "\t -!- Found Directory Indexing page at ${url}"
  fi
done < <(cat "${FILE}")
