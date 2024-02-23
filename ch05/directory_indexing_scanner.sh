#!/bin/bash
FILE="${1}"
OUTPUT_FOLDER="${2}"

if [[ ! -s "${FILE}" ]]; then
  echo "You must provide a non-empty hosts file as an argument."
  exit 1
fi

if [[ -z "${OUTPUT_FOLDER}" ]]; then
  OUTPUT_FOLDER="data"
fi

while read -r line; do
  url=$(echo "${line}" | xargs)
  if [[ -n "${url}" ]]; then
    echo "Testing ${url} for Directory indexing..."
    if curl -L -s "${url}" | grep -q -e "Index of /" -e "[PARENTDIR]"; then
      echo -e "\t -!- Found Directory Indexing page at ${url}"
      echo -e "\t -!- Downloading to the \"${OUTPUT_FOLDER}\" folder..."
      mkdir -p "${OUTPUT_FOLDER}"
      wget -q -r -np -R "index.html*" "${url}" -P "${OUTPUT_FOLDER}"
    fi
  fi
done < <(cat "${FILE}")