#!/bin/bash
IDENTITY=some_identity@email.local

while read -r passphrase; do
  echo "Brute forcing with ${passphrase}..."
  echo "${passphrase}" | gpg --batch \
                             --yes \
                             --pinentry-mode loopback \
                             --passphrase-fd 0 \
                             --output private.pgp \
                             --armor \
                             --export-secret-key "${IDENTITY}"

  if [[ $? -eq 0 ]]; then
    echo "Passphrase is: ${passphrase}"
    echo "Private key is located at private.pgp"
    exit 0
  fi

done < passphrases.txt
