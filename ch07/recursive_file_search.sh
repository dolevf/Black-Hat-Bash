#!/bin/bash
DIR_SEARCH="${1}"
DIR_BACKUP="${HOME}/backup"
COMPRESSED_FILE="${HOME}/files.tar.gz"

if [[ -z "${DIR_SEARCH}" ]]; then
    echo "You must specify an argument in the form of a file path."
    echo "For example: ./recursive_file_search.sh \"/var/log\""
    exit 1
else
    if [[ ! -d "${DIR_SEARCH}" ]]; then
        echo "${DIR_SEARCH} is not a directory."
        exit 1
    fi
fi

if [[ ! -d "${DIR_BACKUP}" ]]; then
    mkdir "${DIR_BACKUP}"
fi

while read -r file; do 
    echo "Copying ${file} into ${DIR_BACKUP}"
    cp -f "${file}" "${DIR_BACKUP}"
done < <(find "${DIR_SEARCH}" -type f -readable 2> /dev/null)

if [[ -n $(ls -A "${DIR_BACKUP}") ]]; then
    echo -e "\nCompressing collections into a tarball..."
    if tar czvfP "${COMPRESSED_FILE}" "${DIR_BACKUP}"; then
        echo "Success. Compressed folder with files is located at ${COMPRESSED_FILE}"
    else
        echo "Error occurred."
    fi
else
    echo "${DIR_BACKUP} seems empty, not taking any further actions."
fi

rm -rf "${DIR_BACKUP}"
